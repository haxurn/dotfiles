# nvim — advanced workflow, end to end

Companion to `CHEATSHEET.md` (which lists keys). This file teaches the *flow*.

---

## 1. The mental model — vim is a language

Speak **verb + noun**:

```
verb (operator)   noun (motion / text-object)
d delete          w word        iw inner word
c change          $ end-line    i" inside quotes
y yank (copy)     } paragraph   ap a paragraph
v select          gg / G top/bottom   i( inside parens
> indent          f<c> to char  it inside tag
```

`dw` delete word · `ci"` change inside quotes · `yap` yank paragraph.
**Counts** multiply: `3dd`, `d2w`. Learn nouns once — every verb gets them.

## 2. Text objects (the real level-up)

Cursor *inside* the thing. `i` = inner, `a` = around (incl. delimiter).

| Do | Result |
|---|---|
| `ciw` | change word |
| `ci"` `ci'` `ci(` `ci{` `ci[` | change inside quotes/brackets |
| `ca(` | change parens **and** the parens |
| `cit` | change inside HTML/XML tag |
| `dap` | delete a paragraph |
| `vi{` / `yi(` | select / yank inside braces / parens |

`clipboard=unnamedplus` is on → yanks go to the **system clipboard** automatically.

## 3. Surround (nvim-surround)

Pairs perfectly with text objects:

```
ysiw"     surround word with "..."
yss)      surround whole line with (...)
cs"'      change "double" -> 'single'
cs(<q>    change (parens) -> <q>tag</q>
ds(       delete the surrounding parens
visual S  surround the selection (e.g. vi{ then S })
```

## 4. The repeat trio

- `.` repeat last change — edit once, move, `.` to redo. Most powerful key.
- `u` / `Ctrl-r` undo / redo.
- **cgn** repeatable replace (better than `:%s` for scattered edits):
  ```
  *              search word under cursor
  cgn new  Esc   change next match
  .  .  .        replay on each following match (n to skip)
  ```

## 5. Jump anywhere — flash.nvim

```
s<chars>   type a couple chars of where you want to be -> press the label
S          select an expanding treesitter node (function, block, arg...)
```
`s` replaces builtin substitute (use `cl` for that). Works as a motion too:
`ds` in operator-pending via `r` (remote) — e.g. `yr` then label to yank far text without moving.

## 6. Read code with LSP — and get back

The trap: `gd` jumps you away. The fix: the **jumplist**.

```
gd       definition        Ctrl-o   jump BACK   Ctrl-i   forward
gr       references (fzf)   K        hover docs (K again to scroll in)
gy       type definition   gi       implementation
```
`<leader>g` grep the whole project · `<leader>f` open any file by fuzzy name.

## 7. The fix loop (red → green)

```
<leader>T    Trouble: every error/warning in the project
]d / [d      next / prev problem (shows the message)
K            read what the checker wants
<leader>ca   code action: auto-fix, add import, organize
<leader>e    full diagnostic for the line
<leader>cf   format the file
```
Errors show **inline** next to the line (error-lens). Usual loop: see red → `<leader>ca` → pick fix → `]d` next.

## 8. Autocomplete (blink.cmp)

`Tab` accept / next · `Shift-Tab` prev · `Ctrl-Space` open · `Ctrl-e` dismiss.
Ghost text previews the top suggestion. In a snippet, `Tab` jumps placeholders.

## 9. Multi-file

Files are **buffers** on the top bar (not tabs):
```
<leader>f      open file (fuzzy)      Shift-l / h   cycle buffers
Alt-1..9       jump direct            <leader>q     close buffer
<leader>vs     vsplit + next buffer   Ctrl-h/j/k/l  move between splits
```
Compare: open A, `<leader>vs`, `<leader>f` B into the new split.

## 10. Project-wide refactor

**Rename a symbol everywhere** (LSP, safe):
```
cursor on name -> <leader>rn -> new name -> Enter
```

**Grep -> quickfix -> mass edit** (plain text):
```
<leader>g  pattern         grep
Ctrl-q     (in fzf)         send matches to quickfix
:cdo s/old/new/g | update   run on every match + save
```

## 11. Editing at speed

```
A / I    append end / insert start of line
o / O    new line below / above
J        join line below
>> <<    indent / dedent   (visual > <  stays selected)
Alt-j/k  move line(s) up/down (also visual)
gv       reselect last visual
* / #    search word under cursor fwd / back
Esc      clear search highlight
```
**Visual block** (column edit): `Ctrl-v` select column → `Shift-i` type → `Esc` → applied to every line.

## 12. Git in-editor (gitsigns)

```
]h / [h      next / prev hunk      <leader>hp  preview hunk
<leader>hs   stage hunk            <leader>hr  discard hunk
<leader>hb   blame line            <leader>hd  diff file
```
Commit: `<leader>hg` lazygit (or `<leader>z` terminal → `git commit`) → `Alt-z` / `q` to close.

## 13. Macros (record once, replay N)

```
qa  ...edits...  q     record into register a
@a    replay      50@a  replay 50x      @@  repeat last
```

---

## Drill order

1. **Week 1:** `ciw` `ci"` `ci(`, `.` repeat, `s` (flash), `<leader>f` / `<leader>g`.
2. **Week 2:** `gd`+`Ctrl-o`, `K`, `<leader>ca`, `]d`/`[d`, `<leader>rn`.
3. **Week 3:** buffers/splits, git hunks, surround (`ys`/`cs`/`ds`), `cgn`, visual-block.
4. **Later:** macros, `:cdo`, marks.

---

## Full narrated run — rename + fix + commit

*Rename `getUser` → `fetchUser`, fix fallout, commit.*

```
nvim .
<leader>g  getUser <CR>     grep, jump to the definition
<leader>rn fetchUser <CR>    LSP renames every usage
<leader>T                    Trouble — leftover errors?
]d                           jump to first (e.g. name in a string/comment LSP won't touch)
ciw fetchUser Esc            fix by hand
<leader>cf                   format
<leader>hp                   eyeball each hunk's diff
:w                           save
<leader>z                    terminal
  git add -p && git commit -m "refactor: rename getUser -> fetchUser"
Esc                          close terminal, keep session
```

Loop: **find → change → LSP fixes refs → Trouble shows leftovers → format → stage → commit.**
