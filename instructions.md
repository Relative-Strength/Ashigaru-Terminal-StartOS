**Ashigaru Terminal User Guide**
=====================================

**Introduction**
---------------

Ashigaru Terminal is a terminal-based application that enables users to participate in Whirlpool CoinJoin cycles with the goal of strengthening privacy in Bitcoin transactions.

**Key Features**
----------------

*   **Self-Custody**: Users retain complete control over their wallets and keys throughout the entire process.
*   **Privacy-Preserving**: Sensitive information such as master public keys or wallet structures remain private.
*   **Anonymity**: Connections are routed through Tor by default, preventing observers from linking activity to a particular IP address.

**Using Ashigaru Terminal**
---------------------------

### Pasting Content

To paste content into the web terminal:

*   On Windows or Linux, use `Ctrl+Shift+V`.
*   On macOS, use `Cmd+Shift+V`.

Note: In LibreWolf or Tor Browser, it may be necessary to disable 'resistFingerprinting' for the web terminal to function properly. Alternatively, you can use a Chromium-based browser such as Brave (even over tor).

### Connecting to a Electrum Server over Tor

To connect to a Electrum server over Tor within Ashigaru Terminal:

*   Enter the server's `.onion` address.
*   Enter the correct port.
*   Enable the proxy with the address `embassy` and port `9050`.
*   Connect

### Connecting to a local Electrum Server

To connect to a local Electrum server (like electrs on start9) within Ashigaru Terminal:

*   Enter the server's local address, if you run electrs it's "electrs.embassy".
*   Enter the correct port.
*   Connect.

### Important Notes

*   **Updates**: Updates may not retain existing wallets. **Always back up your seed phrase securely**, especially before upgrading or migrating.
*   **Combination with Ashigaru Mobile App**: Ashigaru Terminal is designed to be used in combination with the Ashigaru Mobile App.
*   You will not be able to copy a deposit address from Ashigaru Terminal into your clipboard unfortunately. It is reccomended to display a QR instead or copy over the address manually (Triple check you have the right address before depositing)
*   If you hit Quit by mistake, you will be shown a terminal screen. To return to the wallet simply paste this command and press enter:
```
/opt/ashigaru-terminal/bin/Ashigaru-terminal
```
*   The proper way to Stop or restart the Application is using the Start9 User Interface

### Using Testnet
*   If you Hit restart in testnet4, you will be shown a terminal interface. To open in testnet, simply past in this command and press enter:
```
/opt/ashigaru-terminal/bin/Ashigaru-terminal -n testnet4
```
*   To go back to mainnet just run the same command without -n testnet4 to enter mainnet again. Here is the full mainnet command:
```
/opt/ashigaru-terminal/bin/Ashigaru-terminal
```

**Learning Resources**
----------------------

### Learning Materials

For learning resources on the Ashigaru stack, you may find the following helpful:

*   [Ashigaru Terminal Overview](https://ashigaru.rs/docs/ashigaru-terminal-overview)
*   [Whirlpool and Ashigaru](https://k3tan.com/ashigaru-whirlpool)
*   [Ashigaru Terminal Tutorial (Video)](https://www.youtube.com/watch?v=aykJ4eP-Veo)
*   [Using Ashigaru with Electrum (Video)](https://www.youtube.com/watch?v=ULZoPMCYPfk)

**Disclaimer**
--------------

The developers do not assume any responsibility for your actions. Do your own research and make informed decisions.

### Official Website

The only official website is `ashigaru.rs`. Any other sites are fraudulent, as are individuals claiming to represent Ashigaru on social media – Ashigaru has no social media presence. Always act responsibly and in compliance with the law.

## Good Luck!

Enjoy your Ashigaru Terminal experience and happy experimenting with enhanced privacy features!
