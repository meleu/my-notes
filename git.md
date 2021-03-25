# git
[✏️](https://github.com/meleu/my-notes/edit/master/git.md)

## links

- <https://github.com/eficode-academy/git-katas> - deliberate git practice

### egghead.io

- <https://egghead.io/q/git>

### gitflow

- Interesting video (portuguese): <https://www.youtube.com/watch?v=wzxBR4pOTTs>
- Good doc: <https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow>
- cheatsheet: <https://danielkummer.github.io/git-flow-cheatsheet/index.html>


## copy of the remote repository

You cloned a repo, changed some stuff and then regretted. The only thing you want is an exact copy of the remote repo.

Don't 'rm -rf' and clone the repo again!

here's the command you want:

```sh
git reset --hard origin/master
# git reset --hard <repo>/<branch>
```

## testing a pull request

```sh
git fetch origin pull/1234/head:pr-1234
git checkout pr-1234

# git fetch <repo> pull/<pr-id>/head:<local-branchname>
# git checkout <local-branchname>
```

## getting the latest commit hash

```sh
git log origin/master --max-count=1 --no-merges --format='format:%h'

# git log <repo>/<branch> --max-count=1 --no-merges --format='format:%h'
```

For more info about formatting see `man git log`.

