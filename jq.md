# jq
[✏️](https://github.com/meleu/my-notes/edit/master/jq.md)

## minify JSON with jq

```
# --compact-output | -c
$ date -c input.json
```

## if with no else

Else is mandatory, but you can use `empty` to make it do nothing.

```
jq 'if CONDITION then SOMETHING else empty end' input.json
```

