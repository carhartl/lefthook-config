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
cp commitlint.config.js "$HOME/.commitlint.config.js"
