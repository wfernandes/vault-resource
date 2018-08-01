# vault-resource
Concourse Vault Resource

## Source Configuration

- `url`: *Required* URL of Vault
- `role_id`: *Required* AppRole Id
   The role_id can be obtained by running `vault read auth/approle/<my-role>/role-id`
- `secret_id`: *Required* Secret Id of the app role.
   The secret_id can be obtained by running `vault write -f
auth/approle/role/<my-role>/secret-id`
- `path`: *Required* The path of the secret in vault
- `tarball`: *Optional*

## Example

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
    path: /secret/ci/datadog-api-key
```

## Behavior

- *check*:
- *in*
- *out*
