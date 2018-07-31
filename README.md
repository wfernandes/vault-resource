# vault-resource
Concourse Vault Resource


## Installing

```
resource_types:
- name: vault
  type: docker-image
  source:
    repository: wfernandes/vault-resource
    tag: latest

resources:
- name: team-vault
  type: vault
  source:
    url: ((vault.url))
    role_id: ((vault.role_id))
    secret_id: ((vault.secret_id))
    path: path/to/data
```

## Source Configuration
