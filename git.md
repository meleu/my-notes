# git
[✏️](https://github.com/meleu/my-notes/edit/master/git.md)

## copy of the remote repository

You cloned a repo, changed some stuff and then regretted. The only thing you want is an exact copy of the remote repo.

Don't 'rm -rf' and clone the repo again!

here's the command you want:

```sh
git reset --hard origin/master
# git reset --hard <repo>/<branch>
```

