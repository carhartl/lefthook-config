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

cat <<EOF >.lefthook.yaml
---
remotes:
  - git_url: https://github.com/carhartl/lefthook-config
    configs:
      - base.yaml
EOF

BUNDLE_NAME="${1:-all}"
case "$BUNDLE_NAME" in
"all")
	_install_go_deps
	_install_terraform_deps
	cat <<EOF >>.lefthook.yaml
      - go.yaml
      - terraform.yaml
EOF
	;;
"go")
	_install_go_deps
	cat <<EOF >>.lefthook.yaml
      - go.yaml
EOF
	;;
"terraform")
	_install_terraform_deps
	cat <<EOF >>.lefthook.yaml
      - terraform.yaml
EOF
	;;
*)
	_fail "Unknown bundle name, must be one of: \"all\",  \"go\", \"terraform\"."
	exit 1
	;;
esac

echo .lefthook.yaml >>.git/info/exclude

lefthook install

_success "Git hooks installed successfully!"
