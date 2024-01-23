# Credit: https://github.com/Area69Lab
# setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Enable Screen Sharing
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setvnclegacy -vnclegacy yes


# disable spotlight indexing
sudo mdutil -i off -a

# Create new account
sudo dscl . -create /Users/alone
sudo dscl . -create /Users/alone UserShell /bin/bash
sudo dscl . -create /Users/alone RealName "Alone"
sudo dscl . -create /Users/alone UniqueID 1001
sudo dscl . -create /Users/alone PrimaryGroupID 80
sudo dscl . -create /Users/alone NFSHomeDirectory /Users/vncuser
sudo dscl . -passwd /Users/alone $1
sudo dscl . -passwd /Users/alone $1
sudo createhomedir -c -u alone > /dev/null

# Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

# VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

# Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate



# Install Xcode
xcode-select --install

# Install ngrok
brew install --cask ngrok

# Install TeamViewer
brew install --cask teamviewer

# Check if TeamViewer is installed successfully
if [ -d "/Applications/TeamViewer.app" ]; then
    echo "TeamViewer installed successfully."
else
    echo "TeamViewer installation failed. Trying alternative method..."
    
    # Download and install TeamViewer using official installer
    curl -O https://download.teamviewer.com/download/TeamViewerQS.dmg
    hdiutil mount TeamViewer.dmg
    sudo installer -pkg /Volumes/TeamViewer/Install\ TeamViewer.pkg -target /
    hdiutil unmount /Volumes/TeamViewer
    rm TeamViewer.dmg
    
    # Check again if TeamViewer is installed
    if [ -d "/Applications/TeamViewer.app" ]; then
        echo "TeamViewer installed successfully using alternative method."
    else
        echo "TeamViewer installation failed. Please install it manually."
    fi
fi

# Configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 --region=in &
