# Stax

Stax is a tool that will help you a bit with day to day stax-like git workflow.

Currently tool is still in early incubation period.

## What is stax-like git workflow?

It is a way to reduce burden of creating commits, branches and PRs, so it doesn't consume much of your time. As a result you can start creating more PRs with smaller changes in them and have them reviewed easier and faster in the same time catching more bugs.

## Commands

Here is the list of command currently awailable:

### stax-commit
Creates branch, commits current changes with the same name as a branch and pushes.
```
stax-commit "two-in-one-commit-name-and-branch-name"
```
Result:
```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name

```
You can see that branch with `two-in-one-commit-name-and-branch-name` name was created as well as commit with the same name `two-in-one-commit-name-and-branch-name`. 

### stax-amend
Amends to the current commit and force pushes
```
stax-amend
```

### stax-delete-local-only-branches
Deletes all local-only branches. Useful when you are using `stax-commit` which pushes all the branches. So once they are merged and deleted from the remote you can clean up local branches.