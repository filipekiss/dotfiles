# Captain - Git Hook System


Captain is a simple shell binary that acts as a "hub" for all my git hooks. I just basically make
a symlink from `captain` to the hook name (`ln -s captain post-commit`, for example). There's
a `core.hooksPath` config in git that will run the "global" hooks, which are actually all pointing
to `captain`.

The hooks I wish to run are organized into folders, following the pattern `hook-name.d`
(`post-commit.d/`, for example, will contain all hooks that should be run on post-commit).

I also have a `utils` folder where I put all my binaries and the things in the hook folders are just
symlinks to those.
