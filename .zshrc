##Init
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export PATH="$PATH:$HOME/.local/bin"
export EDITOR=vim
export LESS="-R --mouse --wheel-lines 3"
bindkey -e

if [[ $(ps -o args= $PPID | awk "{print $1}") =~ "alacritty|konsole" ]]; then
    ZSH_TMUX_AUTOSTART=true
#    ZSH_TMUX_AUTOQUIT=false
fi

if [[ -f $HOME/.p10k.zsh ]]; then
    source $HOME/.p10k.zsh && ZSH_THEME=powerlevel10k/powerlevel10k
elif [[ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/share/powerline/bindings/zsh/powerline.zsh
elif [[ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    ZSH_THEME=agnoster
else
    autoload -Uz promptinit && promptinit && prompt adam2
fi

##Alias & Function & Variable
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rg='rg -p'
alias vim='vim -p'
alias xx=exit
alias aurfind="yay -Slq | fzf --multi --preview 'yay -Si {1}' --reverse | xargs -ro yay -S"
alias pkgfind="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' --reverse | xargs -ro sudo pacman -S"
alias tetris="autoload -Uz tetriscurses && tetriscurses"

archman() xdg-open "https://man.archlinux.org/search?q=$*&go=Go"
aw()      xdg-open "https://wiki.archlinux.org/index.php?search=$*"
aur()     xdg-open "https://aur.archlinux.org/packages/?K=$*"
pkg()     xdg-open "https://www.archlinux.org/packages/?q=$*"
pkgcmp()  xdg-open "https://pkgstats.archlinux.de/compare/packages#packages=$(echo $* | tr ' ' ',')"

zudo() { sudo zsh -c $functions[$1] $@ }
rename-i3ws() { i3-msg "rename workspace '$1' to '$2'" }
show-pacdiff() { rg --files / -g '*.pac{new,save}' --no-messages }
load-obsvc() { modprobe v4l2loopback card_label="OBS Virtual Camera" }
fd() {
    loc="${2:-$HOME}"; pattern="${1}[^/]*$"
    rg --hidden --files --no-messages $loc --null | xargs -0 dirname | sort -u | rg --no-line-number --smart-case $pattern
}
fdcd() {
    loc="${2:-$HOME}"; pattern="${1}[^/]*$"
    cd "$(\rg --hidden --files --no-messages $loc --null | xargs -0 dirname | sort -u | \rg --no-line-number --smart-case $pattern | fzf --tac)"
}
ff() {
    loc="${2:-$HOME}"; pattern="${1}[^/]*$"
    rg --hidden --files --no-messages $loc | sort |rg --no-line-number --smart-case $pattern
}
ffcd() {
    loc="${2:-$HOME}"; pattern="${1}[^/]*$"
    cd "$(\rg --hidden --files --no-messages $loc | sort | \rg --no-line-number --smart-case $pattern | fzf --tac | xargs dirname)"
}
ffedit() {
    loc="${2:-$HOME}"; pattern="${1}[^/]*$"
    $EDITOR "$(\rg --hidden --files --no-messages $loc | sort | \rg --no-line-number --smart-case $pattern | fzf --tac)"
}
install-deps() {
    if [[ ! $* ]]; then
        echo "No package provided"
    else
        pacman -S --asdeps --needed $(pacman -Si $* | sed -n '/^Opt/,/^Conf/p' | sed '$d' | sed '0,/^[^:]*:/s///' | sed 's/:.*$//' | tr -s " " | tr '\n' ' ')
    fi
}
update-mirrors() {
    reflector --save /etc/pacman.d/mirrorlist --protocol https --latest 20 --sort rate --download-timeout 30
    pacman -Syyu
}
update-grub() {
    grub-mkconfig -o /boot/grub/grub.cfg
    sed -i "s/echo/#echo/g" /boot/grub/grub.cfg
}

PYGLOBALPATH=$(python -c "import site; print(site.getsitepackages()[0])")
PYUSERPATH=$(python -m site --user-site)
export PYGLOBALPATH PYUSERPATH #SC2155

##Zsh settings
HYPHEN_INSENSITIVE=true
ZSH_COLORIZE_STYLE=friendly
HISTFILE=$HOME/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey \^U backward-kill-line
autoload -Uz compinit && compinit
autoload -Uz run-help && unalias run-help && alias help=run-help
autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn
zmodload zsh/terminfo
setopt aliases autocd beep cdablevars complete_aliases correct extendedglob notify

##3rd party settings
plugins=(
    alias-finder
    autojump
    catimg
    colored-man-pages
    colorize
    command-not-found
    copypath
    copyfile
    dircycle
    extract
    fzf
    git
    #globalias
    history-substring-search
    jsontools
    per-directory-history
    sudo
    tmux
    vscode
    zsh-interactive-cd
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
