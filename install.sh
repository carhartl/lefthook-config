#!/bin/sh

_install_go_deps() {
	brew install golangci-lint
	go install github.com/rakyll/gotest@latest
}

_install_terraform_deps() {
	brew install terraform tflint
}

if ! [ -d .git ]; then
	echo "Must run in a git repository!"
	exit 1
fi

brew install \
	actionlint \
	hadolint \
	lefthook \
	prettier \
	shellcheck \
	yamllint
go install mvdan.cc/sh/v3/cmd/shfmt@v3.7.0

BUNDLE_NAME="${1:-lefthook}"

case "$BUNDLE_NAME" in
"lefthook")
	_install_go_deps
	_install_terraform_deps
	;;
"go")
	_install_go_deps
	;;
"terraform")
	_install_terraform_deps
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
