#compdef update.sh

configs=( 'vimrc' 'zshrc' 'keyboard_layout' )

_arguments \
	'1:action:((diff\:"display differences" local\:"update local files" repository\:"copy files to this folder"))' \
	"2:specific config:($configs)"
