#!/bin/sh

_install_go() {
	brew install golangci-lint
	go install github.com/rakyll/gotest@latest
}

_install_terraform() {
	brew install terraform tflint
}

if ! [ -d .git ]; then
	echo "Must run in a git repository!"
	exit 1
fi

brew install \
	hadolint \
	lefthook \
	prettier \
	shellcheck \
	yamllint
go install mvdan.cc/sh/v3/cmd/shfmt@v3.7.0

BUNDLE_NAME="${1:-lefthook}"

case "$BUNDLE_NAME" in
"lefthook")
	_install_go
	_install_terraform
	;;
"go")
	_install_go
	;;
"terraform")
	_install_terraform
	;;
*)
	_fail "Unknown bundle name, must be one of \"go\", \"terraform\"."
	exit 1
	;;
esac

cat <<EOF >lefthook.yml
---
remote:
  git_url: https://github.com/carhartl/lefthook-config
  config: $BUNDLE_NAME.yml
EOF
echo lefthook.yml >>.git/info/exclude

cat <<EOF >.commitlint.config.js
module.exports = {
  rules: {
    "body-case": [2, "always", "sentence-case"],
    "body-leading-blank": [2, "always"],
    "header-case": [2, "always", "sentence-case"],
    "header-full-stop": [2, "never", "."],
    "header-max-length": [2, "always", 50],
  },
};
EOF
echo .commitlint.config.js >>.git/info/exclude

lefthook install
