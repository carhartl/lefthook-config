# Lefthook config

[Lefthook](https://github.com/evilmartians/lefthook)

## Installation

```bash
./install.sh
```

## Setup in a project

```bash
cat << EOF > lefthook.yml
---
remote:
  git_url: https://github.com/carhartl/lefthook-config
EOF
lefthook install
echo lefthook.yml >> .git/info/exclude
```
