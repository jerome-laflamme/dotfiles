if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ls='ls -al --color=auto'
	alias reload='hyprctl reload'
    alias grep='grep --color=auto'
    alias ff='fetch'
    alias r='hyprctl reload'
    alias c='clear'
    alias v='nvim'

	# Config aliases
    alias hc='nvim ~/.config/hypr/hyprland.lua'
    alias nc='nvim ~/.config/nvim/init.lua'
    alias vc='nvim ~/.config/nvim/init.lua'
    alias fc='nvim ~/.config/fish/config.fish'
    alias bc='nvim .bashrc'
    alias kc='nvim ~/.config/kitty/kitty.conf'

	# Git aliases
	alias gs="git status"
	alias ga="git add -A"
    alias gc="git commit -m"
	alias go="git push"


    set PS1 '[\u@\h \W]\$ '
    export MANPAGER='nvim +Man!'
    export TLDRPAGER='nvim +tld!'
    set fish_greeting ''
end
