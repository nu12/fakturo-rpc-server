# fakturo-rpc-server

## Test

```
rake test
```

## Relese

```
git tag $(rake version | tr -d '"') && git push --tags
```