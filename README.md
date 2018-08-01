# vault-resource
Concourse Vault Resource

**Important:** Currently, the vault-resource operates on the KV Secret Engine v1 **ONLY**.


## Source Configuration

- `url`: *Required*

   URL of Vault
- `role_id`: *Required*

   This is the approle id.
   The role_id can be obtained by running `vault read auth/approle/<my-role>/role-id`
- `secret_id`: *Required*

   This is the secret id of the approle.
   The secret_id can be obtained by running `vault write -f auth/approle/role/<my-role>/secret-id`
- `path`: *Required*

   The path of the secret in vault. For example, `/secret/ci/my-secret`
- `tarball`: *Optional*

   This is a boolean value and defaults to `false`. See the behavior for more details.

## Example

```
resource_types:
- name: vault
  type: docker-image
  source:
    repository: wfernandes/vault-resource
    tag: latest

resources:
- name: vault-datadog-api-key
  type: vault
  source:
    url: ((vault.url))
    role_id: ((vault.role_id))
    secret_id: ((vault.secret_id))
    path: /secret/ci/datadog-api-key
```

Fetch a secret,

```
plan:
- get: team-datadog-api-key
  trigger: true
```

Push a secret,

```
- put: vault-datadog-api-key
  params:
    data: vault-test-output
```

See `tests/pipeline.yml` for a full example.

## Behavior

- *check*:

  Reports the sha256 hash of the contents of the secret as the version. That
is, for the secret `/secret/ci/my-secret` there is a key/value pair `foo=bar`,
the version will be the `sha256sum` hash of the json payload `{"foo":"bar}`.
This is done because currently, this resource only supports version 1 of the
KV secret engine.

- *in*:

  If `tarball: false`,

  It puts the value of each key in a separate file within the destination
directory. So if the secret had the following contents in json format,
  ```json
  {
	"foo": "bar",
    "some/path/key": "some-value"
  }
  ```
  The destination directory would contain a file called `foo` with the
contents of `bar` and another file at the path of `some/path/key` containing
the value of `some-value`.

  If `tarball: true`,

  It expects a key called `tarball` and it extracts the contents of the
tarball within the destination directory.
- *out*:

  If `tarball: false`,

  It converts each file and its contents into key/value pair respectively. For
example, if the `path: secret/ci/my-secret` and the source directory contains
the following structure,

  ```
  .
  ├── foo
  └── some
    └── path
        └── to
            └── secret
                └── ca.crt
  ```
  Then the keys put under `secret/ci/my-secret` would be `foo` and
`some/path/to/secret/ca.crt` with the contents of the file as the values.

  If `tarball: true`,

  It `tar`'s up all the contents of the source directory and puts it under the
key `tarball`.
