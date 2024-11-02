FROM kasmweb/core-ubuntu-focal:1.16.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install required packages
RUN apt-get update && apt-get install -y wget unzip gnupg2 software-properties-common apt-utils

# Download and install IntelliJ IDEA Ultimate Edition
RUN wget -O /tmp/intellij.tar.gz https://download-cdn.jetbrains.com/idea/ideaIU-2024.2.4.tar.gz \
    && mkdir -p /opt/intellij \
    && tar -xzf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij \
    && rm /tmp/intellij.tar.gz

# Download and install PyCharm Professional
RUN wget -O /tmp/pycharm.tar.gz https://download-cdn.jetbrains.com/python/pycharm-professional-2024.2.4.tar.gz \
    && mkdir -p /opt/pycharm \
    && tar -xzf /tmp/pycharm.tar.gz --strip-components=1 -C /opt/pycharm \
    && rm /tmp/pycharm.tar.gz

# Download and install PHPStorm
RUN wget -O /tmp/phpstorm.tar.gz https://download-cdn.jetbrains.com/webide/PhpStorm-2024.2.4.tar.gz \
    && mkdir -p /opt/phpstorm \
    && tar -xzf /tmp/phpstorm.tar.gz --strip-components=1 -C /opt/phpstorm \
    && rm /tmp/phpstorm.tar.gz

# Install Firefox
RUN apt-get update && apt-get install -y firefox

# Install Git
RUN apt-get update && apt-get install -y git

# Install Remmina and its plugins
RUN apt-get update && apt-get install -y remmina remmina-plugin-rdp remmina-plugin-vnc

# Install Discord
RUN wget -O /tmp/discord.deb "https://discordapp.com/api/download/stable?platform=linux&format=deb" \
    && apt-get update \
    && apt-get install -y /tmp/discord.deb \
    && rm /tmp/discord.deb

# Install OnlyOffice from the latest link
RUN wget -O /tmp/onlyoffice.deb "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" \
    && apt-get update \
    && apt-get install -y /tmp/onlyoffice.deb \
    && rm /tmp/onlyoffice.deb

# Install Thunderbird
RUN apt-get update && apt-get install -y thunderbird

# Install Telegram Desktop
RUN wget -O /tmp/telegram.deb "https://telegram.org/dl/desktop/linux" \
    && dpkg -i /tmp/telegram.deb; apt-get install -f -y \
    && rm /tmp/telegram.deb

# Install Visual Studio Code
RUN wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
    && apt-get update \
    && apt-get install -y /tmp/vscode.deb \
    && rm /tmp/vscode.deb

# Set Firefox as the default browser system-wide
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 200 \
    && update-alternatives --set x-www-browser /usr/bin/firefox \
    && update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 200 \
    && update-alternatives --set gnome-www-browser /usr/bin/firefox

# Create a desktop shortcut for IntelliJ
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=IntelliJ IDEA\nExec=/opt/intellij/bin/idea\nIcon=/opt/intellij/bin/idea.png\nTerminal=false\nCategories=Development;IDE;" > /usr/share/applications/intellij.desktop \
    && chmod +x /usr/share/applications/intellij.desktop

# Create a desktop shortcut for PyCharm
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PyCharm\nExec=/opt/pycharm/bin/pycharm.sh\nIcon=/opt/pycharm/bin/pycharm.png\nTerminal=false\nCategories=Development;IDE;" > /usr/share/applications/pycharm.desktop \
    && chmod +x /usr/share/applications/pycharm.desktop

# Create a desktop shortcut for PHPStorm
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PHPStorm\nExec=/opt/phpstorm/bin/phpstorm.sh\nIcon=/opt/phpstorm/bin/phpstorm.png\nTerminal=false\nCategories=Development;IDE;" > /usr/share/applications/phpstorm.desktop \
    && chmod +x /usr/share/applications/phpstorm.desktop

# Create a desktop shortcut for Firefox
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox\nExec=firefox\nIcon=firefox\nTerminal=false\nCategories=Network;WebBrowser;" > /usr/share/applications/firefox.desktop \
    && chmod +x /usr/share/applications/firefox.desktop

# Create a desktop shortcut for Remmina
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Remmina\nExec=remmina\nIcon=org.remmina.Remmina\nTerminal=false\nCategories=Network;RemoteAccess;" > /usr/share/applications/remmina.desktop \
    && chmod +x /usr/share/applications/remmina.desktop

# Create a desktop shortcut for Discord with the --no-sandbox argument
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Discord\nExec=/usr/bin/discord --no-sandbox\nIcon=discord\nTerminal=false\nCategories=Network;Chat;" > /usr/share/applications/discord.desktop \
    && chmod +x /usr/share/applications/discord.desktop

# Create a desktop shortcut for OnlyOffice
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=OnlyOffice\nExec=/usr/bin/onlyoffice-desktopeditors\nIcon=onlyoffice\nTerminal=false\nCategories=Office;" > /usr/share/applications/onlyoffice.desktop \
    && chmod +x /usr/share/applications/onlyoffice.desktop

# Create a desktop shortcut for Thunderbird
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Thunderbird\nExec=thunderbird\nIcon=thunderbird\nTerminal=false\nCategories=Network;Mail;" > /usr/share/applications/thunderbird.desktop \
    && chmod +x /usr/share/applications/thunderbird.desktop

# Create a desktop shortcut for Telegram
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Telegram\nExec=/usr/bin/telegram-desktop\nIcon=telegram-desktop\nTerminal=false\nCategories=Network;Chat;" > /usr/share/applications/telegram.desktop \
    && chmod +x /usr/share/applications/telegram.desktop

# Create a desktop shortcut for Visual Studio Code
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Visual Studio Code\nExec=/usr/bin/code\nIcon=code\nTerminal=false\nCategories=Development;IDE;" > /usr/share/applications/vscode.desktop \
    && chmod +x /usr/share/applications/vscode.desktop

# Create a desktop shortcut for WhatsApp Web
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=WhatsApp Web\nExec=firefox https://web.whatsapp.com\nIcon=firefox\nTerminal=false\nCategories=Network;Chat;" > /usr/share/applications/whatsapp-web.desktop \
    && chmod +x /usr/share/applications/whatsapp-web.desktop

# Create user-specific shortcuts on the desktop
RUN mkdir -p $HOME/Desktop \
    && cp /usr/share/applications/intellij.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/pycharm.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/phpstorm.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/firefox.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/remmina.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/discord.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/onlyoffice.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/thunderbird.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/telegram.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/vscode.desktop $HOME/Desktop/ \
    && cp /usr/share/applications/whatsapp-web.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/intellij.desktop \
    && chmod +x $HOME/Desktop/pycharm.desktop \
    && chmod +x $HOME/Desktop/phpstorm.desktop \
    && chmod +x $HOME/Desktop/firefox.desktop \
    && chmod +x $HOME/Desktop/remmina.desktop \
    && chmod +x $HOME/Desktop/discord.desktop \
    && chmod +x $HOME/Desktop/onlyoffice.desktop \
    && chmod +x $HOME/Desktop/thunderbird.desktop \
    && chmod +x $HOME/Desktop/telegram.desktop \
    && chmod +x $HOME/Desktop/vscode.desktop \
    && chmod +x $HOME/Desktop/whatsapp-web.desktop

######### End Customizations ###########

RUN chown -R 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
