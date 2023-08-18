# Linting YAML Files

## `ansible-lint`

```
pip3 install ansible-lint

ansible-lint main.yml
```

## `yamllint`

Install and use:

```
# Install:
pip3 install yamllint

# to run on yaml files:
yamllint .
```

### Truthy

Create a `.yamllint` file in your repo with:

```yaml
---
extends: default

rules:
  truthy:
    allowed-values:
      - 'true'
      - 'false'
      - 'yes'
      - 'no'
```
