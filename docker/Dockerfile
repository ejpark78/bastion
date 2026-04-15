FROM kasmweb/core-ubuntu-noble:1.18.0
USER root

# 1. Environment variables
ENV UV_INSTALL_DIR=/usr/local/bin \
    DEBIAN_FRONTEND=noninteractive \
    PASSWORD_STORE=basic \
    XMODIFIERS=@im=fcitx \
    GTK_IM_MODULE=fcitx \
    QT_IM_MODULE=fcitx

# 2. Package & Repository Setup
# Consolidating all apt-get operations into a single layer to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    gnupg2 \
    software-properties-common \
    lsb-release \
    wget \
    git \
    zsh \
    locales \
    fonts-nanum \
    fcitx \
    fcitx-hangul \
    fcitx-frontend-gtk2 \
    fcitx-frontend-gtk3 \
    fcitx-frontend-qt5 \
    fcitx-bin \
    im-config \
    python3 \
    python3-pip \
    sudo \
    tilix \
    alacritty nautilus \
    # GUI & Electron Dependencies for VS Code/Chrome
    libgbm1 \
    libasound2t64 \
    libnss3 \
    libxshmfence1 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libsecret-1-0 \
    dbus-x11 \
    # 2.1 Add External Repositories
    && install -m 0755 -d /etc/apt/keyrings \
    # VS Code
    && curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
    # Docker CLI
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    # Antigravity
    && curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list \
    # DBeaver
    && add-apt-repository ppa:serge-rider/dbeaver-ce -y \
    # 2.2 Install Applications
    && apt-get update && apt-get install -y --no-install-recommends \
    firefox \
    code \
    docker-ce-cli \
    docker-compose-plugin \
    dbeaver-ce \
    antigravity \
    # 2.3 Google Chrome (via .deb)
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    # 2.4 Setup Korean Locale
    && locale-gen ko_KR.UTF-8 \
    && update-locale LANG=ko_KR.UTF-8 \
    # 2.5 Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# 3. Oh My Zsh & Korean Input configurations
USER kasm-user
WORKDIR /home/kasm-user

# 3.1 Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 3.2 Fcitx Setup & Autostart
RUN im-config -n fcitx \
    && mkdir -p /home/kasm-user/.config/autostart /home/kasm-user/.config/fcitx \
    && echo '[Desktop Entry]\nType=Application\nExec=fcitx -dr\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[ko_KR]=fcitx\nName=fcitx' > /home/kasm-user/.config/autostart/fcitx.desktop \
    && echo "[Profile]\nIMName=fcitx-hangul" > /home/kasm-user/.config/fcitx/profile

USER root

# 4. VS Code & Chrome Sandbox/Keyring Fix
# In containerized environments, Electron apps often need --no-sandbox and --password-store=basic
RUN echo '#!/usr/bin/env bash\n/usr/bin/code --no-sandbox --password-store=basic "$@"' > /usr/local/bin/code \
    && echo '#!/usr/bin/env bash\n/usr/bin/google-chrome-stable --no-sandbox --password-store=basic "$@"' > /usr/local/bin/google-chrome \
    && chmod +x /usr/local/bin/code /usr/local/bin/google-chrome

# 4. Project Directory Structure
RUN mkdir -p /home/kasm-user/project/docs/history /home/kasm-user/project/docs/plans \
    && chown -R kasm-user:kasm-user /home/kasm-user

# 5. User Permissions (DooD support & Sudo)
RUN for gid in 999 998 989; do \
        if getent group $gid; then \
            GROUP_NAME=$(getent group $gid | cut -d: -f1); \
        else \
            GROUP_NAME="docker_host_${gid}"; \
            groupadd -g $gid $GROUP_NAME; \
        fi; \
        usermod -aG $GROUP_NAME kasm-user; \
    done \
    && echo "kasm-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 6. Final Configuration
RUN usermod -s /bin/zsh kasm-user
USER kasm-user
WORKDIR /home/kasm-user

