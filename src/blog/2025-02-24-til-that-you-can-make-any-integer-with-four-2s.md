---
title: "TIL that you can make any integer with four 2s!"
slug: til-that-you-can-make-any-integer-with-four-2s
date: 2025-02-24
tags:
  - TIL
  - status
published: true
---
TIL that you can make any integer with four 2s! The formula is:

$$
n = -log_{\sqrt{2+2}}\left(log_{2}\left(\sqrt{\sqrt{\cdots n \cdots\sqrt{2}}}\right)\right)
$$

To create the integer 7, you do this:

$$
7=-log_{\sqrt{2+2}}\left(log_{2}\left( \sqrt{\sqrt{\sqrt{\sqrt{\sqrt{\sqrt{\sqrt{2}}}}}}}\right)\right)
$$

Source:
- [Eli Bendersky's "Making any integer with four 2s"](https://eli.thegreenplace.net/2025/making-any-integer-with-four-2s/) 

P.S.: This has absolutely nothing to do with my burning desire to fill this blog with equations. (Okay, maybe a little.)