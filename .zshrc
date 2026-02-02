##Init
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim
export LESS="-R --mouse --wheel-lines 3"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
bindkey -e

if [[ $(ps -o args= $PPID | awk "{print $1}") =~ "alacritty|konsole" ]]; then
    ZSH_TMUX_AUTOSTART=true
#    ZSH_TMUX_AUTOQUIT=false
fi

if [[ -f /usr/bin/oh-my-posh ]]; then
    eval "$(oh-my-posh init zsh --config $HOME/.local/share/oh-my-posh/themes/powerlevel10k_rainbow.omp.json)"
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
alias vim='vim -p'
alias ncdu='ncdu --color dark'
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
show-pacdiff() { rg --files / -g '*.pac{new,save}' --no-messages }
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
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zmodload zsh/terminfo
setopt aliases autocd beep cdablevars complete_aliases correct extendedglob notify

##3rd party settings
plugins=(
    autojump
    colored-man-pages
    colorize
    command-not-found
    copyfile
    copypath
    dircycle
    extract
    fzf
    #globalias
    jsontools
    per-directory-history
    sudo
    tmux
    zsh-interactive-cd
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
