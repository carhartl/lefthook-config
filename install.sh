#!/bin/sh

if ! [ -d .git ]; then
	echo "Must run in a git repository!"
	exit 1
fi

brew install \
	golangci-lint \
	hadolint \
	lefthook \
	prettier \
	shellcheck \
	terraform \
	tflint \
	yamllint
go install mvdan.cc/sh/v3/cmd/shfmt@v3.7.0

cat <<EOF >lefthook.yml
---
remote:
  git_url: https://github.com/carhartl/lefthook-config
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
