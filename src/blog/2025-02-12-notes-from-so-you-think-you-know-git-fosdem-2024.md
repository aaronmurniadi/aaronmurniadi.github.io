---
title: Notes from "So You Think You Know Git - FOSDEM 2024"
slug: notes-from-so-you-think-you-know-git-fosdem-2024
date: 2025-02-12
tags:
  - status
published: true
---
See historical changes to a particular method/function in a given file using language-aware heuristics (especially for C, Java, Python, etc.) to detect function/method boundaries:

```
$ git log -L :MethodName:path/to/file
```

Enable background maintenance tasks for a Git repository. This configures Git to run periodic maintenance processes in the background to improve repository performance. These tasks include optimizing data storage, pruning unnecessary objects, and keeping the repository efficient over time:

```
$ git maintenance start
```

[Source](https://www.youtube.com/watch?v=aolI_Rz0ZqY)
