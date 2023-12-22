#!/bin/sh

readonly DEBUG="${DEBUG:-unset}"
if [ "${DEBUG}" != unset ]; then
	set -x
fi

_fail() {
	printf "\033[0;31m==> %s\033[0m\n\n" "$1"
}

_success() {
	printf "\033[0;32m==> %s\033[0m\n\n" "$1"
}

_install_go_deps() {
	brew install golangci-lint
	go install github.com/rakyll/gotest@latest
}

_install_terraform_deps() {
	brew install terraform tflint
}

if ! [ -d .git ]; then
	_fail "Must run in a git repository!"
	exit 1
fi

brew install \
	actionlint \
	hadolint \
	lefthook \
	prettier \
	shellcheck \
	shfmt \
	yamllint

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

cat <<EOF >.lefthook.yaml
---
remote:
  git_url: https://github.com/carhartl/lefthook-config
  config: $BUNDLE_NAME.yaml
EOF
echo .lefthook.yaml >>.git/info/exclude

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

_success "Git hooks installed successfully!"
