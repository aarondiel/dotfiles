#compdef update.sh

describe_configs() {
	_values -s \
		"," \
		"configs" \
		"nvim" \
		"zsh" \
		"keyboard_layout" \
		"lf" \
		"scripts" \
		"awesome"
}

_arguments \
	"-h[show help message]" \
	"--help[show help message]" \
	"--configs[list available configs]" \
	"-o[only install certain configs]:configs:describe_configs" \
	"--only[only install certain configs]:configs:describe_configs"
