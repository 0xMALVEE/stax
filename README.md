# Stax

Stax is a tool that will help you to stack your PRs. 

The primary purpose is to make it easier to create smaller PRs. And reduce the amount of energy other people need to review them.

## Installation

### MacOS/Linux/WSL on Windows/ChromeOS

Homebrew is a package manager that works on MacOS and Linux systems.

#### Install brew

##### MacOS

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

##### Linux/WSL on Windows/ChromeOS

See https://docs.brew.sh/Homebrew-on-Linux

#### Install stax

```
brew install TarasMazepa/stax/stax
```

### Windows

Clone this repo and put the path to the repo into your PATH variable.

Let me know if you need some help. Create a ticket on the repo.

## stax doctor

Will help you to set up everything that stax needs to start working

```
stax doctor
```

```
[V] git config --get user.name # TarasMazepa
[V] git config --get user.email # 6552358+TarasMazepa@users.noreply.github.com
[V] git config --get push.autoSetupRemote # true
```

Stax will give you advice on how to configure everything.

```
stax doctor
```

```
[X] git config --get user.name # null
    X Set your git user name using:
      git config --global user.name "<your preferred name>"
[X] git config --get user.email # null
    X Set your git user email using:
      git config --global user.email "<your preferred email>"
[X] git config --get push.autoSetupRemote # false
    X Set git push.autoSetupRemote using:
      git config --global push.autoSetupRemote true
```

## v1 Roadmap

| Feature                                            | Status |
|----------------------------------------------------|--------|
| [commit](#stax-commit)                             | ✅      |
| [amend](#stax-amend)                               | ✅      |
| [delete-gone-branches](#stax-delete-gone-branches) | ✅      |
| [pull](#stax-pull)                                 | ✅      |
| [log](#stax-log)                                   | ✅      |
| [rebase](#stax-rebase)                             | ✅     |
| [move](#stax-move)                               | ✅     |

## v2 Roadmap

It would be a UI tool that will implement all features from v1.

## What is stax-like git workflow?

It is a way to reduce the burden of creating commits, branches, and PRs, so it doesn't consume much
of your time. As a result, you can start creating more PRs with smaller changes and have
them reviewed easier and faster while catching more bugs.

## Commands

To see full list of commands, run:

```
stax help
```

Here is the list of commands currently available:

### stax commit

Creates branch, commits current changes with the same name as a branch, and pushes.

![stax commit diagram](https://github.com/TarasMazepa/stax/assets/6552358/013c5848-1697-49b2-a1b2-17f17eeea9cb)

```
stax commit "two-in-one-commit-name-and-branch-name"
```

Result:

```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name

```

You can see that a branch with `two-in-one-commit-name-and-branch-name` name was created as well as
a commit with the same name `two-in-one-commit-name-and-branch-name`.

#### -a flag

Adds all the files to the staging area

#### --pr flag

Redirects you to a create PR page

### stax amend

Amends to the current commit and force pushes the branch

![stax amend diagram](https://github.com/TarasMazepa/stax/assets/6552358/c3025256-2e4f-4c8f-95c1-095ab9b8b514)

```
stax amend
```

### stax delete-gone-branches

Deletes local branches with gone remotes. It is useful when you are using `stax-commit`, which pushes all
the branches. So once they are merged and deleted from the remote, you can clean up local branches.

![stax delete-gone-branches diagram](https://github.com/TarasMazepa/stax/assets/6552358/55be3cf5-3667-4568-a8b0-785f623ec680)

### stax pull

Switching to the main branch, pulling all the changes, deleting gone branches, and switching to the original
branch.

![stax pull diagram](https://github.com/TarasMazepa/stax/assets/6552358/581b2384-2cce-4e78-9be2-76241e0f6c8e)

### stax log

Outputs tree structure of your branches.

```
> stax log
  x Updates-stax-log-example-in-readme
  o Adds-stax-log-example-to-readme
o-┘ origin/main, origin/HEAD, main
| o Promotes-version-command-to-be-not-hidden-command
o-┘
```

### stax rebase

Rebase tree of nodes on top of the <remote>/head or reference provided as first positional argument.

### stax move

Move has five directions:
* `up` — one node up. You can optionally specify the index of the child node (as represented in the log command); the default is 0.
* `down` — one node up
* `top` — to the topmost node, but stop on the first node with more than one child. Optionally you can specify an index of the child node (as represented in log command), default is 0.
* `bottom` — to the bottommost node, but stop on the first node that has more than one child, or stop before the node that had <remote>/head as a child.
* `head` — moves to the <remote>/head

# Videos

[Why stack pull request?](https://youtu.be/gJu0oseqaqs)

[Checking out stacking workflow](https://www.youtube.com/watch?v=zoqbYxW3saY)

## Alternatives

* https://sapling-scm.com/
* https://graphite.dev/
* https://stacked-git.github.io/
* https://github.com/ezyang/ghstack
* https://www.git-town.com/
* https://ejoffe.github.io/spr/
* https://stacked-git.github.io/
* https://github.com/modularml/stack-pr
