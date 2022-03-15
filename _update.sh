#compdef update.sh

local state

_arguments \
	'(-h --help)'{-h,--help}'[display usage information]' \
	'--only[list of dotfiles to target]:configs:->configs' \
	'1:action:->action'

case "$state" in
	configs)
		_values -s ',' 'actions' \
			'vimrc' 'zshrc' 'keyboard_layout' 'awesome' 'lf'
		;;

	action)
		local -a actions
		actions=(
			'diff:print difference'
			'local:target local dotfiles'
			'repository:target dotfiles inside repository'
		)

		_describe 'actions' actions
		;;
esac
