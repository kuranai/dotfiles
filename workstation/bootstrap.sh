#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

UPGRADE_PACKAGES=${1:-none}

if [ "${UPGRADE_PACKAGES}" != "none" ]; then
  echo "==> Updating and upgrading packages ..."
  sudo apt-get update
  sudo apt-get upgrade -y
fi

echo "==> Installing apt packages ..."
sudo apt-get install -qq \
  apache2-utils \
  apt-transport-https \
  build-essential \
  bzr \
  ca-certificates \
  clang \
  cmake \
  curl \
  direnv \
  dnsutils \
  docker.io \
  fakeroot-ng \
  gdb \
  git \
  git-crypt \
  gnupg \
  gnupg2 \
  htop \
  hugo \
  ipcalc \
  jq \
  less \
  libclang-dev \
  liblzma-dev \
  libpq-dev \
  libprotoc-dev \
  libsqlite3-dev \
  libssl-dev \
  libvirt-clients \
  libvirt-daemon-system \
  lldb \
  locales \
  man \
  mosh \
  mtr-tiny \
  musl-tools \
  ncdu \
  netcat-openbsd \
  openssh-server \
  pkg-config \
  protobuf-compiler \
  pwgen \
  python \
  python3 \
  python3-flake8 \
  python3-pip \
  python3-setuptools \
  python3-venv \
  python3-wheel \
  qemu-kvm \
  qrencode \
  quilt \
  ripgrep \
  shellcheck \
  silversearcher-ag \
  socat \
  software-properties-common \
  sqlite3 \
  stow \
  sudo \
  tig \
  tmate \
  tmux \
  tree \
  unzip \
  wget \
  zgen \
  zip \
  zlib1g-dev \
  vim-gtk3 \
  zsh \
  postgresql \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  python3-dev \
  default-jre \
  default-jdk \
  --no-install-recommends \

rm -rf /var/lib/apt/lists/*

# install Go
if ! [ -x "$(command -v go)" ]; then
  export GO_VERSION="1.16"
  wget "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" 
  tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz" 
  rm -f "go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH="/usr/local/go/bin:$PATH"
fi

# install nvim
if ! [ -x "$(command -v nvim)" ]; then
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
	tar zxf nvim-linux64.tar.gz
	mv nvim-linux64/bin/nvim /usr/local/bin
	mv nvim-linux64/share/nvim /usr/local/share
	rm nvim-linux64.tar.gz
	rm -rf nvim-linux64
fi

if ! [ -x "$(command -v starship)" ]; then
  curl -fsSL https://starship.rs/install.sh | bash -s -- -y
fi
# install nodejs
if ! [ -x "$(command -v node)" ]; then
  curl -sL install-node.now.sh | bash -s -- -f
fi

# install bitwarden-cli
if ! [ -x "$(command -v bw)" ]; then
  sudo curl -s https://api.github.com/repos/bitwarden/cli/releases/latest | grep -o "http.*bw-linux.*zip" | wget -qi -
  unzip bw-linux*.zip
  sudo mv bw /usr/local/bin
  sudo chmod a+x /usr/local/bin/bw
  rm bw-linux*.zip
fi

#Install pipx
if ! [ -x "$(command -v pipx)" ]; then
python3 -m pip install --user pipx
python3 -m pipx ensurepath
#Install some python packages with pipx
/root/.local/bin/pipx install howdoi
/root/.local/bin/pipx install black
/root/.local/bin/pipx install mypy
/root/.local/bin/pipx install pgcli
fi

# install kubectl
if ! [ -x "$(command -v kubectl)" ]; then
  curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod 755 /usr/local/bin/kubectl
fi

# install tools
if ! [ -x "$(command -v jump)" ]; then
  echo " ==> Installing jump .."
  export JUMP_VERSION="0.40.0"
  wget https://github.com/gsamokovarov/jump/releases/download/v${JUMP_VERSION}/jump_${JUMP_VERSION}_amd64.deb
  sudo dpkg -i jump_${JUMP_VERSION}_amd64.deb
  rm -f jump_${JUMP_VERSION}_amd64.deb
fi

if ! [ -x "$(command -v hub)" ]; then
  echo " ==> Installing hub .."
  export HUB_VERSION="2.14.2"
  wget https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz
  tar xf hub-linux-amd64-${HUB_VERSION}.tgz
  chmod +x hub-linux-amd64-${HUB_VERSION}/bin/hub
  cp hub-linux-amd64-${HUB_VERSION}/bin/hub /usr/local/bin
  rm -rf hub-linux-amd64-${HUB_VERSION}
  rm -f hub-linux-amd64-${HUB_VERSION}.tgz*
fi

VIM_PLUG_FILE="${HOME}/.vim/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "${HOME}/.vim/plugged"
  pushd "${HOME}/.vim/plugged"
  git clone "https://github.com/AndrewRadev/splitjoin.vim"
  git clone "https://github.com/ConradIrwin/vim-bracketed-paste"
  git clone "https://github.com/Raimondi/delimitMate"
  git clone "https://github.com/SirVer/ultisnips"
  git clone "https://github.com/cespare/vim-toml"
  git clone "https://github.com/corylanou/vim-present"
  git clone "https://github.com/ekalinin/Dockerfile.vim"
  git clone "https://github.com/elzr/vim-json"
  git clone "https://github.com/fatih/vim-hclfmt"
  git clone "https://github.com/fatih/vim-nginx"
  git clone "https://github.com/fatih/vim-go"
  git clone "https://github.com/hashivim/vim-hashicorp-tools"
  git clone "https://github.com/junegunn/fzf.vim"
  git clone "https://github.com/mileszs/ack.vim"
  git clone "https://github.com/roxma/vim-tmux-clipboard"
  git clone "https://github.com/plasticboy/vim-markdown"
  git clone "https://github.com/scrooloose/nerdtree"
  git clone "https://github.com/t9md/vim-choosewin"
  git clone "https://github.com/tmux-plugins/vim-tmux"
  git clone "https://github.com/tmux-plugins/vim-tmux-focus-events"
  git clone "https://github.com/fatih/molokai"
  git clone "https://github.com/tpope/vim-commentary"
  git clone "https://github.com/tpope/vim-eunuch"
  git clone "https://github.com/tpope/vim-fugitive"
  git clone "https://github.com/tpope/vim-repeat"
  git clone "https://github.com/tpope/vim-scriptease"
  git clone "https://github.com/ervandew/supertab"
  popd
fi

if [ ! -d "$(go env GOPATH)" ]; then
  echo " ==> Installing Go tools"
  # vim-go tooling
  go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
  go get -u -v github.com/mdempsky/gocode
  go get -u -v github.com/rogpeppe/godef
  go get -u -v github.com/zmb3/gogetdoc
  go get -u -v golang.org/x/tools/cmd/goimports
  go get -u -v golang.org/x/tools/cmd/gorename
  go get -u -v golang.org/x/tools/cmd/guru
  GO111MODULE=on go get golang.org/x/tools/gopls@latest
  go get -u -v golang.org/x/lint/golint

  cp -r $(go env GOPATH)/bin/* /usr/local/bin/
fi

if [ ! -d "${HOME}/.fzf" ]; then
  echo " ==> Installing fzf"
  git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
  pushd "${HOME}/.fzf"
  git remote set-url origin git@github.com:junegunn/fzf.git 
  ${HOME}/.fzf/install --bin --no-bash --no-zsh --no-fish
  popd
fi

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
fi

if [ ! -d "${HOME}/.tmux/plugins" ]; then
  echo " ==> Installing tmux plugins"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  git clone https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
  git clone https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
  git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo "==> Setting shell to zsh..."
chsh -s /usr/bin/zsh

echo "==> Creating dev directories"
mkdir -p /root/code

echo "==> create nvim config directory"
mkdir -p /root/.config/nvim

if [ ! -d /root/code/dotfiles ]; then
  echo "==> Setting up dotfiles"
  # the reason we dont't copy the files individually is, to easily push changes
  # if needed
  cd "/root/code"
  git clone --recursive https://github.com/kuranai/dotfiles.git

  cd "/root/code/dotfiles"
  git remote set-url origin git@github.com:kuranai/dotfiles.git

  ln -sfn $(pwd)/vimrc "${HOME}/.vimrc"
  ln -sfn $(pwd)/zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/tmuxconf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/tigrc "${HOME}/.tigrc"
  ln -sfn $(pwd)/git-prompt.sh "${HOME}/.git-prompt.sh"
  ln -sfn $(pwd)/gitconfig "${HOME}/.gitconfig"
  ln -sfn $(pwd)/agignore "${HOME}/.agignore"
  ln -sfn $(pwd)/sshconfig "${HOME}/.ssh/config"
  ln -sfn $(pwd)/init.vim "${HOME}/.config/nvim/init.vim"
  ln -sfn $(pwd)/starship.toml "${HOME}/.config/starship.toml"
  ln -sfn $(pwd)/bash_profile "${HOME}/.bash_profile" 
fi


if [ ! -f "/root/secrets/pull-secrets.sh" ]; then
  echo "==> Creating pull-secret.sh script"

cat > pull-secrets.sh <<'EOF'
#!/bin/bash

set -eu

echo "Authenticating with bitwarden"
export BW_SESSION=$(bw login --raw)

echo "Pulling secrets"

bw get attachment github_rsa --itemid 96d4043b-16ea-42f5-8e7c-ab5400ef906a

rm -f ~/.ssh/github_rsa
ln -sfn $(pwd)/github_rsa ~/.ssh/github_rsa
chmod 0600 ~/.ssh/github_rsa

echo "Done!"
EOF

  mkdir -p /root/secrets
  chmod +x pull-secrets.sh
  mv pull-secrets.sh ~/secrets
fi

#install plugin that nvim needs
pip3 install pynvim

# Set correct timezone
timedatectl set-timezone Europe/Berlin

# Setup postgresql for dev
sed -i 's/md5/trust/g' /etc/postgresql/12/main/pg_hba.conf
sed -i 's/peer/trust/g' /etc/postgresql/12/main/pg_hba.conf
service postgresql restart
sudo -u postgres psql -c "CREATE ROLE root WITH SUPERUSER LOGIN"
sudo -u postgres psql -c "CREATE DATABASE dev"

echo ""
echo "==> Done!"
