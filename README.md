# SmartMarketBuddy

![SmartMarketBuddy Logo](images/SMB_logo_transparent.ico)


Welcome to SmartMarketBuddy - Your Intelligent Trading Assistant! Setting up SmartMarketBuddy is quick and easy, typically taking between 5 - 10 minutes. Whether you're tech-savvy or new to computers, our streamlined installation process ensures you'll be up and running in no time.

## Quick Installation Guide

### Step 1: Set Up MetaTrader 5 (MT5)

1. Download MT5:
   - Visit [MetaTrader 5](https://www.metatrader5.com/en/download) official website
   - Click "Download MetaTrader 5" for Windows
   - Run the installer and follow the simple installation steps

2. Connect to Your Broker:
   - Open MT5
   - Click "File" → "Login to Trade Account"
   - Enter your broker credentials
   - If you don't have a broker account yet, you can open one through MT5's built-in broker directory

3. Enable Automated Trading:
   - In MT5, go to "Tools" → "Options"
   - Select "Expert Advisors" tab
   - Enable "Allow automated trading"
   - Enable "Allow WebRequest for listed URL"
   - Add "localhost" to the WebRequest URLs list
   - Click "OK" to save changes

### Step 2: Install SmartMarketBuddy

1. Download the Installer:
   - Download the SmartMarketBuddy installer from our [releases page](https://github.com/smartmarketbuddy/smartmarketbuddy/releases)
   - Download "Installer.zip"
   - Extract the downloaded zip file to any location on your computer

2. Run the Installation:
   - Open the extracted folder
   - Double-click "SMB_setup_agent.bat"
   - The installer will automatically:
     * Set up the required environment
     * Install necessary components
     * Create desktop and start menu shortcuts

### Step 3: Start Using SmartMarketBuddy

- Find SmartMarketBuddy in your Start Menu or use the desktop shortcut
- Launch the application and log in
- You're ready to start trading with SmartMarketBuddy!

## Frequently Asked Questions (FAQ)

**Q: Do I need to install Python separately?**
A: No! Our installer includes everything you need.

**Q: Can I use SmartMarketBuddy with any broker?**
A: Yes, as long as they support MetaTrader 5.

**Q: Is my trading account information secure?**
A: Absolutely. We only store your SmartMarketBuddy username and password for authentication. We never store or have access to your MT5 or broker credentials.

**Q: What if I need to uninstall SmartMarketBuddy?**
A: Simply use the uninstaller in the installation folder or Windows' Add/Remove Programs.

**Q: Does SmartMarketBuddy work on macOS or Linux?**
A: Currently, SmartMarketBuddy is only available for Windows due to MT5 platform requirements.

## Legal Information

### Disclaimer
SmartMarketBuddy is provided "as is" without any warranties. Trading forex and other financial instruments carries significant risks. By using SmartMarketBuddy, you acknowledge that:

- We are not responsible for any financial losses incurred while using our software
- Past performance is not indicative of future results
- You are solely responsible for your trading decisions
- We only store user authentication data (username/password) for app access

### Privacy
We respect your privacy. The only personal information we collect and store is your SmartMarketBuddy username and password, which are used solely for authenticating your access to the application.

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

### Technologies
- [Python](https://www.python.org/)
- [Flask](https://flask.palletsprojects.com/)
- [AWS](https://aws.amazon.com/)
- [SQLite Cloud](https://sqlitecloud.io/)
- [Paystack](https://paystack.com/)

### Assets
Stock market icons created by [Andy Horvath - Flaticon](https://www.flaticon.com/free-icons/stock-market)

---
© 2025 SmartMarketBuddy. All rights reserved.
