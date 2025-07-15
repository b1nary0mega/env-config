#!/usr/bin/env bash

# OG by Lee Baird (@discoverscripts)
# Mod by Jimmi Aylesworth (@b1nary0mega)

# Variables
BLUE='\033[1;34m'
NC='\033[0m'
YELLOW='\033[1;33m'

###############################################################################################################################

echo
echo "-> ${BLUE}Updating the operating system.${NC}"
apt update ; apt -y upgrade ; apt -y dist-upgrade ; apt -y autoremove ; apt -y autoclean ; updatedb
echo

if ! command -v colorize &> /dev/null; then
    echo "--> ${YELLOW}Installing colorize.${NC}"
    sudo apt install -y colorize
fi

if [ ! -f /opt/ohmyzsh.sh ]; then
    echo "--> ${YELLOW}Installing Oh My ZSH for root and $SUDO_USER .${NC}"
    wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O /opt/ohmyzsh.sh
    chmod 755 /opt/ohmyzsh.sh
    sh /opt/ohmyzsh.sh --unattended
    # Path to the zshrc file
    ZSHRC="$HOME/.zshrc"
    # Check if the file exists
    if [[ ! -f "$ZSHRC" ]]; then
      echo "Error: $ZSHRC not found!"
    fi
    # Backup current .zshrc
    cp "$ZSHRC" "$ZSHRC.bak"
    echo ".. ${BLUE}Updating Plugins and Theme.${NC}"
    sed -i '' 's/^plugins=(git)$/plugins=(git debian ansible colorize)/' "$ZSHRC"
    sed -i '' 's/^ZSH_THEME="robbyrussell"$/ZSH_THEME="aussiegeek"/' "$ZSHRC"
    if [ -n "$SUDO_USER" ]; then
        sudo -u "$SUDO_USER" sh /opt/ohmyzsh.sh --unattended
        cp "$ZSHRC" "$ZSHRC.bak"
        echo ".. ${BLUE}Updating Plugins and Theme.${NC}"
        sed -i '' 's/^plugins=(git)$/plugins=(git debian ansible colorize)/' "$ZSHRC"
        sed -i '' 's/^ZSH_THEME="robbyrussell"$/ZSH_THEME="aussiegeek"/' "$ZSHRC"
    fi
fi

if ! command -v ansible &> /dev/null; then
    echo "--> ${YELLOW}Installing Ansible.${NC}"
    apt install -y ansible-core
    echo
fi

if ! command -v aws &> /dev/null; then
    echo "--> ${YELLOW}Installing AWS.${NC}"
    apt install -y awscli
    echo
fi

if ! command -v go &> /dev/null; then
    echo "--> ${YELLOW}Installing Go.${NC}"
    apt install -y golang-go
    # shellcheck disable=SC2129
    echo "" >> ~/.zshrc
    echo "export GOPATH=/opt/go" >> ~/.zshrc
    echo "export GOROOT=/usr/lib/go" >> ~/.zshrc
    echo "export PATH=\$PATH:/usr/lib/go/bin:/opt/go/bin" >> ~/.zshrc
    mkdir -p /opt/go/{bin,src,pkg}
    # shellcheck disable=SC1090
    source ~/.zshrc
    echo
fi

if ! command -v jq &> /dev/null; then
    echo "--> ${YELLOW}Installing jq.${NC}"
    apt install -y jq
    echo
fi

if ! command -v raven &> /dev/null; then
    echo "--> ${YELLOW}Installing Raven.${NC}"
    apt install -y raven
    echo
fi

if ! command -v sublist3r &> /dev/null; then
    echo " --> ${YELLOW}Installing Sublist3r.${NC}"
    apt install -y sublist3r
    echo
fi

###############################################################################################################################

if ! command -v dnstwist &> /dev/null; then
    echo "--> ${YELLOW}Installing dnstwist.${NC}"
    apt install -y dnstwist
    echo
fi

if [ -d /opt/Domain-Hunter/.git ]; then
    echo ".. ${BLUE}Updating Domain Hunter.${NC}"
    cd /opt/Domain-Hunter/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing Domain Hunter.${NC}"
    git clone https://github.com/threatexpress/domainhunter /opt/Domain-Hunter
    echo
    echo "--> ${YELLOW}Setting up Domain Hunter virtual environment.${NC}"
    python3 -m venv /opt/Domain-Hunter-venv
    /opt/Domain-Hunter-venv/bin/python -m pip install pytesseract
#    /opt/Domain-Hunter-venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pytesseract
    chmod 755 /opt/Domain-Hunter/domainhunter.py
    echo
fi

if [ -d /opt/DomainPasswordSpray/.git ]; then
    echo ".. ${BLUE}Updating DomainPasswordSpray.${NC}"
    cd /opt/DomainPasswordSpray/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing DomainPasswordSpray.${NC}"
    git clone https://github.com/dafthack/DomainPasswordSpray /opt/DomainPasswordSpray
    echo
fi

# shellcheck disable=SC2166
if [ -d /opt/Egress-Assess/.git -a -d /opt/Egress-Assess-venv ]; then
    echo ".. ${BLUE}Updating Egress-Assess.${NC}"
    cd /opt/Egress-Assess/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing Egress-Assess.${NC}"
    git clone https://github.com/RedSiege/Egress-Assess /opt/Egress-Assess
    echo
    echo "--> ${YELLOW}Setting up Egress-Assess virtualenv.${NC}"
    python3 -m venv /opt/Egress-Assess-venv
    /opt/Egress-Assess-venv/bin/python -m pip install -r /opt/Egress-Assess/requirements.txt
    # If you are in a corp env that is doing MITM with SSL, use the following line instead. Do the same for all Python repos.
#    pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt --upgrade | grep -v 'already satisfied'
    echo
fi

if [ -d /opt/egressbuster/.git ]; then
    echo ".. ${BLUE}Updating egressbuster.${NC}"
    cd /opt/egressbuster/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing egressbuster.${NC}"
    git clone https://github.com/trustedsec/egressbuster /opt/egressbuster
    echo
fi

if ! command -v feroxbuster &> /dev/null; then
    echo "--> ${YELLOW}Installing feroxbuster.${NC}"
    apt install -y feroxbuster
    echo
fi

if ! command -v gobuster &> /dev/null; then
    echo "--> ${YELLOW}Installing gobuster.${NC}"
    apt install -y gobuster
    echo
fi

if [ -d /opt/krbrelayx/.git ]; then
    echo ".. ${BLUE}Updating krbrelayx.${NC}"
    cd /opt/krbrelayx/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing krbrelayx.${NC}"
    git clone https://github.com/dirkjanm/krbrelayx /opt/krbrelayx
    echo
fi

if [ -d /opt/manspider/.git ]; then
    echo ".. ${BLUE}Updating MAN-SPIDER.${NC}"
    cd /opt/manspider/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing MAN-SPIDER.${NC}"
    git clone https://github.com/blacklanternsecurity/MANSPIDER /opt/manspider
    apt install -y antiword tesseract-ocr
    echo
fi

if ! command -v nishang &> /dev/null; then
    echo "--> ${YELLOW}Installing nishang.${NC}"
    apt install -y nishang
    echo
fi

echo ".. ${BLUE}Updating Nmap scripts.${NC}"
nmap --script-updatedb | grep -Eiv '(starting|seconds)' | sed 's/NSE: //'
echo

if [ -d /opt/PowerSharpPack/.git ]; then
    echo ".. ${BLUE}Updating PowerSharpPack.${NC}"
    cd /opt/PowerSharpPack/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing PowerSharpPack.${NC}"
    git clone https://github.com/S3cur3Th1sSh1t/PowerSharpPack /opt/PowerSharpPack
    echo
fi

if [ -d /opt/PowerSploit/.git ]; then
    echo ".. ${BLUE}Updating PowerSploit.${NC}"
    cd /opt/PowerSploit/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing PowerSploit.${NC}"
    git clone https://github.com/0xe7/PowerSploit /opt/PowerSploit
    echo
fi

if [ -d /opt/PowerUpSQL/.git ]; then
    echo ".. ${BLUE}Updating PowerUpSQL.${NC}"
    cd /opt/PowerUpSQL/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing PowerUpSQL.${NC}"
    git clone https://github.com/NetSPI/PowerUpSQL /opt/PowerUpSQL
    echo
fi

if [ -d /opt/PrivescCheck/.git ]; then
    echo ".. ${BLUE}Updating PrivescCheck.${NC}"
    cd /opt/PrivescCheck/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing PrivescCheck.${NC}"
    git clone https://github.com/itm4n/PrivescCheck /opt/PrivescCheck
    echo
fi

if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then
    echo "--> ${YELLOW}Expanding Rockyou list.${NC}"
    zcat /usr/share/wordlists/rockyou.txt.gz > /usr/share/wordlists/rockyou.txt
    rm /usr/share/wordlists/rockyou.txt.gz
    echo
fi

if ! command -v rustc &> /dev/null; then
    echo "--> ${YELLOW}Installing Rust.${NC}"
    apt install -y rustc
    echo
fi

if [ -d /opt/SharpCollection/.git ]; then
    echo "--> ${BLUE}Updating SharpCollection.${NC}"
    cd /opt/SharpCollection/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing SharpCollection.${NC}"
    git clone https://github.com/Flangvik/SharpCollection /opt/SharpCollection
    echo
fi

if [ -d /opt/subfinder/.git ]; then
    echo ".. ${BLUE}Updating subfinder.${NC}"
    cd /opt/subfinder/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing subfinder.${NC}"
    git clone https://github.com/projectdiscovery/subfinder /opt/subfinder
    cd /opt/subfinder/v2/cmd/subfinder || exit
    go build
    echo
fi

# shellcheck disable=SC2166
if [ -d /opt/theHarvester/.git -a -d /opt/theHarvester-venv ]; then
    echo ".. ${BLUE}Updating theHarvester.${NC}"
    cd /opt/theHarvester/ || exit ; git pull
    /opt/theHarvester-venv/bin/python -m pip install -r /opt/theHarvester/requirements.txt --upgrade | grep -v 'already satisfied'
#    /opt/theHarvester-venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt --upgrade | grep -v 'already satisfied'
    echo
else
    echo "--> ${YELLOW}Installing theHarvester.${NC}"
    git clone https://github.com/laramies/theHarvester /opt/theHarvester
    echo
    echo "--> ${YELLOW}Setting up theHarvester virtualenv.${NC}"
    python3 -m venv /opt/theHarvester-venv
    /opt/theHarvester-venv/bin/python -m pip install -r /opt/theHarvester/requirements.txt
#    /opt/theHarvester-venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
    echo
fi

if [ -d /opt/Windows-Exploit-Suggester-NG/.git ]; then
    echo ".. ${BLUE}Updating Windows Exploit Suggester NG.${NC}"
    cd /opt/Windows-Exploit-Suggester-NG/ || exit ; git pull
    echo
else
    echo "--> ${YELLOW}Installing Windows Exploit Suggester NG.${NC}"
    git clone https://github.com/bitsadmin/wesng /opt/Windows-Exploit-Suggester-NG
    echo
fi

if ! command -v xlsx2csv &> /dev/null; then
    echo "--> ${YELLOW}Installing xlsx2csv.${NC}"
    apt install -y xlsx2csv
    echo
fi

if ! command -v xml_grep &> /dev/null; then
    echo "--> ${YELLOW}Installing xml_grep.${NC}"
    apt install -y xml-twig-tools
    echo
fi

if ! command -v xspy &> /dev/null; then
    echo "--> ${YELLOW}Installing xspy.${NC}"
    apt install -y xspy
    echo
fi

if [ ! -f /opt/xwatchwin/xwatchwin ]; then
    echo "--> ${YELLOW}Installing xwatchwin.${NC}"
    apt install -y imagemagick libxext-dev xutils-dev
    wget http://www.ibiblio.org/pub/X11/contrib/utilities/xwatchwin.tar.gz -O /tmp/xwatchwin.tar.gz
    tar zxvf /tmp/xwatchwin.tar.gz -C /tmp/
    rm /tmp/xwatchwin.tar.gz
    mv /tmp/xwatchwin/ /opt/
    cd /opt/xwatchwin/ || exit

    # Patch source code
    sed -i 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' /opt/xwatchwin/xwatchwin.c
    sed -i 's/_SVID_SOURCE/_DEFAULT_SOURCE/g' /opt/xwatchwin/xwatchwin.c
    sed -i 's/^WinNamesEqual(/int WinNamesEqual(/g' /opt/xwatchwin/xwatchwin.c

    xmkmf && make && make install
    rm /usr/bin/xwatchwin
    echo
fi

###############################################################################################################################

if ! command -v xrdp &> /dev/null; then
    echo "--> ${YELLOW}Installing xrdp.${NC}"
    apt install -y xrdp
    systemctl start xrdp
    systemctl enable xrdp
    echo
fi

if ! command -v gimp &> /dev/null; then
    echo "--> ${YELLOW}Installing gimp.${NC}"
    apt install -y gimp
    echo
fi

if ! command -v libreoffice &> /dev/null; then
    echo "--> ${YELLOW}Installing Libre Office.${NC}"
    apt install -y libreoffice
    echo
fi

if ! command -v flameshot &> /dev/null; then
    echo "--> ${YELLOW}Installing flameshot.${NC}"
    apt install -y flameshot
    if [ "$XDG_CURRENT_DESKTOP" == "XFCE" ]; then
    	echo "..... ${BLUE}binding PRINT SCREEN button.${NC}"
         if [ -n "$SUDO_USER" ]; then
            sudo -u "$SUDO_USER" xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/Print" --type string --set "flameshot gui"
        else
            xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/Print" --type string --set "flameshot gui"
        fi
    else
        echo "..... ${BLUE}Remember to update keyboard bind.${NC}"
    fi
fi

if ! command -v "brave-browser" &> /dev/null; then
    echo "--> ${YELLOW}Installing Brave Browser.${NC}"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    echo
fi

###############################################################################################################################

echo "..${BLUE}Updating locate database.${NC}"
updatedb

echo "...enjoy the shinies..."

exit
