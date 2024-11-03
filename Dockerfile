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

# Create desktop entries for all applications in one layer
COPY <<EOF /usr/share/applications/
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA
Exec=/opt/intellij/bin/idea
Icon=/opt/intellij/bin/idea.png
Terminal=false
Categories=Development;IDE;

[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Exec=/opt/pycharm/bin/pycharm.sh
Icon=/opt/pycharm/bin/pycharm.png
Terminal=false
Categories=Development;IDE;

[Desktop Entry]
Version=1.0
Type=Application
Name=PHPStorm
Exec=/opt/phpstorm/bin/phpstorm.sh
Icon=/opt/phpstorm/bin/phpstorm.png
Terminal=false
Categories=Development;IDE;

[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox
Exec=firefox
Icon=firefox
Terminal=false
Categories=Network;WebBrowser;

[Desktop Entry]
Version=1.0
Type=Application
Name=Remmina
Exec=remmina
Icon=org.remmina.Remmina
Terminal=false
Categories=Network;RemoteAccess;

[Desktop Entry]
Version=1.0
Type=Application
Name=Discord
Exec=/usr/bin/discord --no-sandbox
Icon=discord
Terminal=false
Categories=Network;Chat;

[Desktop Entry]
Version=1.0
Type=Application
Name=OnlyOffice
Exec=/usr/bin/onlyoffice-desktopeditors
Icon=onlyoffice-desktopeditors
Terminal=false
Categories=Office;

[Desktop Entry]
Version=1.0
Type=Application
Name=Thunderbird
Exec=thunderbird
Icon=thunderbird
Terminal=false
Categories=Network;Mail;

[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Exec=/usr/bin/code --no-sandbox
Icon=code
Terminal=false
Categories=Development;IDE;
EOF

# Copy VSCode icon and make desktop entries executable
RUN cp /usr/share/code/resources/app/resources/linux/code.png /usr/share/pixmaps/code.png || true && \
    chmod +x /usr/share/applications/*.desktop

# Create Desktop shortcuts and set permissions in one layer
RUN mkdir -p $HOME/Desktop && \
    cp /usr/share/applications/*.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/*.desktop && \
    chown -R 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

# Set up final user environment
ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
