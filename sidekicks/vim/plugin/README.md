### macOS accents and normal mode maps

My day job requires me to write content in Portuguese, a language full of accents and digraphs.
Since I work mainly on macOS, I insert accents using a combination of the `⌥(Option)` key and
a letter. For example, to insert `é`, I type `⌥+e e`.

In [iTerm][iterm], I use set my `⌥` to behave as `Normal` instead of `Meta` or `Esc+`. This
way, I can insert accented characters in my terminal (and, of course, vim) the same way I do in
other apps. But that creates a new problem. I can't use the `⌥` key in normal mode with the `<M>`
mapping.

### Workaround

So, how do I get the `⌥` to work as intended in normal mode? You can see at the
[mappings.vim][mappings] that there's a special if for when vim is on `macunix`. Basically, I map
the shortcut to use the correspondent digraph instead of the '<M-d>' combination.


### Limitation
Some keys can't be used with the `⌥` as a modifier (any key that you press to generate a digraph/accent, like `e i \` n u`).
Since I don't usually map stuff to `⌥+<key>` (you will find only one shortcut mapped in my
settings), that's something it's good to have in mind if you plan to use terminal this way.

