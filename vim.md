# vim
[✏️](https://github.com/meleu/my-notes/edit/master/vim.md)

## links

- <https://thoughtbot.com/upcase/onramp-to-vim>

## install vim-plug

The [vim-plug](https://github.com/junegunn/vim-plug) is useful to install/update vim plugins.

Here's a way to install it at startup:
- add this to your `.vimrc`
```
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
```

## video: Mastering the Vim Language

- <https://www.youtube.com/watch?v=wlR5gYd6um0>

- 4:35 the language (basics)
- 5:36 repeatable & undoable
- 6:48 verbs/operators in vim
- 8:21 nouns in vim - motions
- 9:05 nouns in vim - text objects
- 12:18 nouns in vim - parameterized text objects (find/search)
- 16:33 where to learn/read
- 18:35 tips for mastering the language
- 20:35 relative number
- 22:45 visual mode is a smell
- 24:18 custom operators (from plugins)
    - 24:42 tpope/vim-surround
    - 26:02 tpope/vim-commentary
    - 26:48 vim-scripts/ReplaceWithRegister
    - 27:41 christoomey/vim-titlecase
    - 28:21 christoomey/sort-motion
    - 28:57 christommey/system-copy
- 29:52 custom nouns (objects)
    - 30:03 michaeljsmith/vim-indent-object
    - 31:08 kana/vim-textobj-entire
    - 30:30 kana/vim-textobj-line
        - both requires kana/vim-textobj-user
    - 32:15 ruby block
- 33:30 Finding more custom text objects

Syntax of the language: Verb + Noun

Example:

- **d** for delete
- **w** for word
- combine to be "**d**elete **w**ord"

Some verbs:

- `d`: delete
- `c`: change (delete and enter insert mode)
- `>`: indent
- `v`: visually select
- `y`: yank (copy)

Some nouns related to motions:

- `w`: word
- `b`: back
- `2j`: down 2 lines

Some nouns related to text objects:

- `iw`: inner word (works from anywhere in a word)
- `it`: inner tag (the contents of an HTML tag)
- `i"`: inner quotes
- `ip`: inner paragraph
- `as`: a sentence

Some nouns related to parameterized text objects

- `f`, `F`: find the next character, including it.
- `t`, `T`: find the next character, excluding it.
- `/`, `?`: search the string, not including the string.

### Tips:

- use `:set relativenumber`
- "visual mode is a smell"

### plugin suggestions

- Surround. e.g.:
  - `ds"`: delete surrounding quotes
  - `cs("`: change surrounding parens to quotes
  - `ysiw"`: add double quotes around the word
  - `cst<h2>`: change surrounding tag to `<h2>`
- Commentary
- ReplaceWithRegister
- Titlecase
- Sort-motion
- System-copy





