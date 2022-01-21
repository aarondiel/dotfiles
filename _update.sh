#compdef update.sh

args=(
	'local:copy files from this folder to your local files'
	'repository:copy files from your local files to this folder'
	'diff:display differences between your local files and this folder'
)

_describe 'update.sh' args
