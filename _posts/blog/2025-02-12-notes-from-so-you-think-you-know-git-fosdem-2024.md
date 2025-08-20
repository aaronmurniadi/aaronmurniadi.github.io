---
title: 'Notes from "So You Think You Know Git - FOSDEM 2024"'
description: "Notes and takeaways from a FOSDEM 2024 presentation on advanced Git techniques, covering language-aware function tracking and background maintenance tasks for improved repository performance."
author: aaron
date: 2025-02-12
categories: [Technology, Version Control]
tags: [git, version control, FOSDEM, software development, code history, repository maintenance]
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
