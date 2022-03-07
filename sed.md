# sed
[✏️](https://github.com/meleu/my-notes/edit/master/sed.md)

## sed like grep

```sh
sed -n '/regexp/p'  # method 1
sed '/regexp/!d'    # method 2
```

## print file contents from X to Y

X and Y can be the number of the line or a regex:

```sh
sed '1,/regex/!d'         # from line 1 to line with regex
sed '/regex1/,/regex2/!d' # from line with regex1 to line with regex2
```
