---
title: "Building legacy electron app in Docker"
slug: building-legacy-electron-app-in-docker
date: 2025-01-21
tags:
  - status
published: true
---
So we have this old electron app that still in use in production, yet it refused to be build using modern environment. Something about deprecated old packages or something.

I have an idea to build it inside a Docker container that's setup to mimic the old environment.