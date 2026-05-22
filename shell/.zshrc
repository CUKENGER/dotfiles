export QT_FONT_DPI=96
export MOZ_ENABLE_WAYLAND=1
export YAZI_IMAGE_BACKEND=kitty

export ZSH="$HOME/.oh-my-zsh"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

ZSH_THEME="robbyrussell"

plugins=(git z fzf zsh-autosuggestions)

# faster completion
autoload -Uz compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
compinit -C

source $ZSH/oh-my-zsh.sh

# aliases
alias lz="eza --tree --level=1 --icons --no-time --no-user --no-permissions"
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias la="eza -a --icons"

alias cat="bat --style=auto --line-range :500"
alias tt='tmux'

alias nvim-chad="NVIM_APPNAME=nvchad nvim"
alias nvim-astro="NVIM_APPNAME=astronvim nvim"
alias nvim-my="NVIM_APPNAME=mynvim nvim"
alias nvim-lazy="NVIM_APPNAME=lazyvim nvim"
alias nvim-mylazyvim="NVIM_APPNAME=mylazyvim nvim"

alias zapret="~/zapret-discord-youtube-linux/main_script.sh -nointeractive > ~/zapret-discord-youtube-linux/zapret.log 2>&1 &"

# fzf
eval "$(fzf --zsh)"

# yazi cd
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"

	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi

	rm -f -- "$tmp"
}

# neovim picker
function nvims() {
	local items=("lazyvim" "mynvim" "astronvim" "nvchad" "default" "mylazyvim")

	local config=$(printf "%s\n" "${items[@]}" | fzf \
		--prompt=" Neovim Config  " \
		--height=50% \
		--layout=reverse \
		--border \
		--exit-0)

	if [[ -z $config ]]; then
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi

	NVIM_APPNAME=$config nvim "$@"
}

# custom fpath
# fpath+=${ZDOTDIR:-~}/.zsh_functions

# disable ctrl+z
stty susp undef

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# nvm (NORMAL, NO WRAPPERS)
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/share/nvm/init-nvm.sh" ] && source /usr/share/nvm/init-nvm.sh
