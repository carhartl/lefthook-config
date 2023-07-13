#!/bin/sh

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

cat << EOF > lefthook.yml
---
remote:
  git_url: https://github.com/carhartl/lefthook-config
EOF
cp commitlint.config.js .commitlint.config.js

echo lefthook.yml >> .git/info/exclude
echo .commitlint.config.js >> .git/info/exclude

lefthook install