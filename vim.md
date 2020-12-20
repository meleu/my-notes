# vim
[✏️](https://github.com/meleu/my-notes/edit/master/vim.md)

## vimwiki

Questions to be answered:

- How to add a trailing `.md` extension when creating a new wiki page with `<Enter>`?
- How to git commit & push after saving with `:w`?
- How to open a specific wiki from command line? (I want to open my-notes with an alias like `mynotes`)
- How to sort an unordered list alphabetically?
    - Answer: <https://github.com/christoomey/vim-sort-motion>

## cool videos

- [Vim: tutorial on customization and configuration - by Leeren](https://www.youtube.com/watch?v=JFr28K65-5E) - advanced, very well reviewed
- [Vim as an IDE - by Leeren](https://www.youtube.com/watch?v=Gs1VDYnS-Ac) - VimConf talk
- <https://thoughtbot.com/upcase/the-art-of-vim> - some useful vim tips


## video series: Onramp to Vim

This is the best video series I found on the internet to get started with vim

- link: <https://thoughtbot.com/upcase/onramp-to-vim>


### sensible.vim

Avoid too much configurations, but take a look at this one (which claims to be "defaults everyone can agree on"):
<https://github.com/tpope/vim-sensible>

It enables things like `<C-L>` to clear `hlsearch`, `<C-W>` to delete previous word when in INSERT mode, etc.


### motions and moving

Taking notes of the ones that are new to me.

mapping  | summary
---------|--------
`f<char>`| (f)ind a char forward in a line and move to it (`F` goes backward)
`t<char>`| find a char forward in a line and move un(t)il it (`T` goes backward)
`;`      | repeat last `f`, `F`, `t` or `T` command
`,`      | repeat last `f`, `F`, `t` or `T` command, but in opposite direction
`H`, `M`, `L` | move (H)igh, (M)iddle, or (L)ow within the viewport
`C-u`, `C-d`  | move (u)p or (d)own

See `:h motion` for more info.


### command language

The commands are usually composed of a verb and a noun. Example: `dw`, stands for delete a word.

**Tip**: usually the same key used two times in a row applies the verb in the whole line. Examples: `dd` deletes the whole line, `cc` change the whole line.

"Text Objects"

  mapping  | operation
-----------|----------
`iw`, `aw` | "inner word", "a word" (a word includes the space)
`is`, `as` | "inner sentece", "a sentece"
`ip`, `ap` | "inner paragraph", "a paragraph"
`i)`, `a)` | "inner parenthesis", "a parenthesis"
`i'`, `a'` | "inner single quote", "a single quote"
`it`, `at` | "inner tag", "a tag" (HTML tag)

See `:h text-objects` for more options.

**Tip**: prefer using text-objects rather than motions in order to increase repeatability.
