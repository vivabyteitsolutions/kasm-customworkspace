FROM kasmweb/core-ubuntu-focal:1.16.0
USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/dockerstartup/install

WORKDIR $HOME

# Combine all apt-get commands and cleanup in one layer
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg2 \
    software-properties-common \
    apt-utils \
    firefox \
    git \
    remmina \
    remmina-plugin-rdp \
    remmina-plugin-vnc \
    thunderbird \
    && rm -rf /var/lib/apt/lists/*

# Download and install all JetBrains IDEs in one layer
RUN mkdir -p /opt/intellij /opt/pycharm /opt/phpstorm && \
    wget -q -O - https://download-cdn.jetbrains.com/idea/ideaIU-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/intellij && \
    wget -q -O - https://download-cdn.jetbrains.com/python/pycharm-professional-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/pycharm && \
    wget -q -O - https://download-cdn.jetbrains.com/webide/PhpStorm-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/phpstorm

# Install Discord, OnlyOffice, and VSCode in one layer
RUN wget -q -O discord.deb "https://discordapp.com/api/download/stable?platform=linux&format=deb" && \
    wget -q -O onlyoffice.deb "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" && \
    wget -q -O vscode.deb "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/code_1.95.1-1730355339_amd64.deb" && \
    apt-get update && \
    apt-get install -y ./discord.deb ./onlyoffice.deb ./vscode.deb && \
    rm *.deb && \
    rm -rf /var/lib/apt/lists/*

# Set Firefox as default browser
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 200 && \
    update-alternatives --set x-www-browser /usr/bin/firefox && \
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 200 && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox

# Create Desktop directory
RUN mkdir -p $HOME/Desktop

# Create desktop shortcuts directly in the Desktop folder for our specific apps
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=IntelliJ IDEA\nExec=/opt/intellij/bin/idea\nIcon=/opt/intellij/bin/idea.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/intellij.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PyCharm\nExec=/opt/pycharm/bin/pycharm.sh\nIcon=/opt/pycharm/bin/pycharm.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/pycharm.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PHPStorm\nExec=/opt/phpstorm/bin/phpstorm.sh\nIcon=/opt/phpstorm/bin/phpstorm.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/phpstorm.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox\nExec=firefox\nIcon=firefox\nTerminal=false\nCategories=Network;WebBrowser;" > $HOME/Desktop/firefox.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Remmina\nExec=remmina\nIcon=org.remmina.Remmina\nTerminal=false\nCategories=Network;RemoteAccess;" > $HOME/Desktop/remmina.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Discord\nExec=/usr/bin/discord --no-sandbox\nIcon=discord\nTerminal=false\nCategories=Network;Chat;" > $HOME/Desktop/discord.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=OnlyOffice\nExec=/usr/bin/onlyoffice-desktopeditors\nIcon=onlyoffice-desktopeditors\nTerminal=false\nCategories=Office;" > $HOME/Desktop/onlyoffice.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Thunderbird\nExec=thunderbird\nIcon=thunderbird\nTerminal=false\nCategories=Network;Mail;" > $HOME/Desktop/thunderbird.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Visual Studio Code\nExec=/usr/bin/code --no-sandbox\nIcon=code\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/vscode.desktop

# Copy VSCode icon and make shortcuts executable
RUN cp /usr/share/code/resources/app/resources/linux/code.png /usr/share/pixmaps/code.png || true && \
    chmod +x $HOME/Desktop/*.desktop

# Set permissions
RUN chown -R 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

# Set up final user environment
ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000FROM kasmweb/core-ubuntu-focal:1.16.0
USER root

ENV HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/dockerstartup/install

WORKDIR $HOME

# Combine all apt-get commands and cleanup in one layer
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg2 \
    software-properties-common \
    apt-utils \
    firefox \
    git \
    remmina \
    remmina-plugin-rdp \
    remmina-plugin-vnc \
    thunderbird \
    && rm -rf /var/lib/apt/lists/*

# Download and install all JetBrains IDEs in one layer
RUN mkdir -p /opt/intellij /opt/pycharm /opt/phpstorm && \
    wget -q -O - https://download-cdn.jetbrains.com/idea/ideaIU-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/intellij && \
    wget -q -O - https://download-cdn.jetbrains.com/python/pycharm-professional-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/pycharm && \
    wget -q -O - https://download-cdn.jetbrains.com/webide/PhpStorm-2024.2.4.tar.gz | tar xz --strip-components=1 -C /opt/phpstorm

# Install Discord, OnlyOffice, and VSCode in one layer
RUN wget -q -O discord.deb "https://discordapp.com/api/download/stable?platform=linux&format=deb" && \
    wget -q -O onlyoffice.deb "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" && \
    wget -q -O vscode.deb "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/code_1.95.1-1730355339_amd64.deb" && \
    apt-get update && \
    apt-get install -y ./discord.deb ./onlyoffice.deb ./vscode.deb && \
    rm *.deb && \
    rm -rf /var/lib/apt/lists/*

# Set Firefox as default browser
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 200 && \
    update-alternatives --set x-www-browser /usr/bin/firefox && \
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 200 && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox

# Create Desktop directory
RUN mkdir -p $HOME/Desktop

# Create desktop shortcuts directly in the Desktop folder for our specific apps
RUN echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=IntelliJ IDEA\nExec=/opt/intellij/bin/idea\nIcon=/opt/intellij/bin/idea.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/intellij.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PyCharm\nExec=/opt/pycharm/bin/pycharm.sh\nIcon=/opt/pycharm/bin/pycharm.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/pycharm.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=PHPStorm\nExec=/opt/phpstorm/bin/phpstorm.sh\nIcon=/opt/phpstorm/bin/phpstorm.png\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/phpstorm.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox\nExec=firefox\nIcon=firefox\nTerminal=false\nCategories=Network;WebBrowser;" > $HOME/Desktop/firefox.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Remmina\nExec=remmina\nIcon=org.remmina.Remmina\nTerminal=false\nCategories=Network;RemoteAccess;" > $HOME/Desktop/remmina.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Discord\nExec=/usr/bin/discord --no-sandbox\nIcon=discord\nTerminal=false\nCategories=Network;Chat;" > $HOME/Desktop/discord.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=OnlyOffice\nExec=/usr/bin/onlyoffice-desktopeditors\nIcon=onlyoffice-desktopeditors\nTerminal=false\nCategories=Office;" > $HOME/Desktop/onlyoffice.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Thunderbird\nExec=thunderbird\nIcon=thunderbird\nTerminal=false\nCategories=Network;Mail;" > $HOME/Desktop/thunderbird.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Visual Studio Code\nExec=/usr/bin/code --no-sandbox\nIcon=code\nTerminal=false\nCategories=Development;IDE;" > $HOME/Desktop/vscode.desktop

# Copy VSCode icon and make shortcuts executable
RUN cp /usr/share/code/resources/app/resources/linux/code.png /usr/share/pixmaps/code.png || true && \
    chmod +x $HOME/Desktop/*.desktop

# Set permissions
RUN chown -R 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

# Set up final user environment
ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
