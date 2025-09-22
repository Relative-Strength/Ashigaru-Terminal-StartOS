#!/usr/bin/env bash
set -euo pipefail

# tmux/ttyd runtime
TMUX_SESSION="${TMUX_SESSION:-ashigaru}"
PORT="${PORT:-7682}"
ASHIGARU_CMD="${ASHIGARU_CMD:-/opt/ashigaru-terminal/bin/Ashigaru-terminal}"

# Tor runtime
TOR_SOCKS_LISTEN="${TOR_SOCKS_LISTEN:-127.0.0.1}"
TOR_SOCKS_PORT="${TOR_SOCKS_PORT:-9050}"
TOR_CONTROL_ENABLE="${TOR_CONTROL_ENABLE:-0}"
TOR_CONTROL_LISTEN="${TOR_CONTROL_LISTEN:-127.0.0.1}"
TOR_CONTROL_PORT="${TOR_CONTROL_PORT:-9051}"
TOR_DATADIR="${TOR_DATADIR:-/home/ashigaru/.tor}"

mkdir -p "${TOR_DATADIR}"

# Generate a minimal torrc each start
TORRC="${TOR_DATADIR}/torrc"
{
  echo "DataDirectory ${TOR_DATADIR}"
  echo "SocksPort ${TOR_SOCKS_LISTEN}:${TOR_SOCKS_PORT}"
  echo "AvoidDiskWrites 1"
  echo "ClientOnly 1"
  echo "Log notice stdout"
  if [ "${TOR_CONTROL_ENABLE}" = "1" ]; then
    echo "ControlPort ${TOR_CONTROL_LISTEN}:${TOR_CONTROL_PORT}"
    echo "CookieAuthentication 1"
  fi
} > "${TORRC}"

# Start Tor (as current non-root user)
tor -f "${TORRC}" &

# Wait briefly for Tor SOCKS (non-fatal)
for i in $(seq 1 20); do
  if bash -c ">/dev/tcp/127.0.0.1/${TOR_SOCKS_PORT}" 2>/dev/null; then
    break
  fi
  sleep 1
done

# Start tmux session if missing
if ! tmux has-session -t "${TMUX_SESSION}" 2>/dev/null; then
  tmux new-session -d -s "${TMUX_SESSION}" "${ASHIGARU_CMD}"
fi

# Build ttyd args
TTYD_ARGS=(-p "${PORT}")
if [ -n "${TTYD_CREDENTIALS:-}" ]; then
  TTYD_ARGS+=(-c "${TTYD_CREDENTIALS}")
fi

# Exec ttyd to attach to the tmux session
exec ttyd "${TTYD_ARGS[@]}" tmux attach-session -t "${TMUX_SESSION}"
