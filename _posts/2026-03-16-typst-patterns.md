---
title: "How I Found My Typst Patterns (and Why the Community Needs More)"
date: 2026-03-16
layout: post
---

# How I Found My Typst Patterns (and Why the Community Needs More)

> [Check out my Typst templates here](/typesettings)!

I had one of those moments while working on [Harvard Law Review journal template](/typesettings#journal-template) recently, where you're staring at your code and suddenly something clicks into place. I'd been struggling with how to organize this academic journal layout, trying different approaches, when I just decided to define all the metadata first.

```typst
#let meta = (
  journal: "Typst Type Review",
  year: "1958", 
  month: "February",
  volume: "71",
  number: "4",
  title: "The Foundations of Visual Language: The Law of Typography",
  author: "Aaron P. Murniadi",
  abstract: [...],
  body: [...],
)
```

Then I put all the styling rules at the bottom. Suddenly everything was clean. The content was up top where I could see it upon opening the file, the styling was tucked away, and I could actually read what my document was about without scrolling past pages of setup code.

That's when it hit me: Typst gives us almost too much freedom.

## The Problem with Too Much Freedom

Here's the thing I've noticed in the Typst community: we're all figuring this out on our own. I often ask "how should I structure my document?" and gets five different answers on top of my mind. There's no official guidance, no community-approved patterns, no real consensus.

Don't get me wrong, though. The official Typst documentation is fantastic. When I need to understand how `show` rules work or the exact syntax for page setup, [the docs](https://typst.app/docs/) are my go-to. They cover the technical details beautifully. But they're focused on the "how" not the "why." They'll teach you every function in Typst, but they won't tell you how to organize a 50-page report or when to split your styles into separate files.

That's the gap I'm talking about. We have excellent technical documentation, but we're missing the higher-level guidance about document architecture and patterns.

## What I Actually Use Day to Day

### The "Get It Done" Approach

For quick stuff—like [my CV](/typesettings#cv) or simple documents—I still use the traditional top-down approach:
```typst
#import "@preview/droplet:0.3.1": dropcap

#set document(title: "Aaron P. Murniadi's CV")

#let section-block(title, content) = [
  #text(size: 1.25em, style: "italic", title)
  #block(inset: (left: 2em))[#content]
  #v(0.5em)
]

// ... more function definitions ...

#header(name: [Aaron P. Murniadi], contact: [...])
```

**Why it works:** It's fast, it's obvious, and for one-off documents, you don't need anything fancy. I can whip this up in 10 minutes and it just works.

**When it breaks:** The moment you need to maintain it or create variations. I tried making different CV versions this way and ended up copying codes around. Not great.

### The "Split It Up" Method

Then there's my book project approach. I learned this the hard way after my first attempt at typesetting ["The Maid of Orleans"](/typesettings#maid-of-orleans) turned into a messy document.
```
maid_of_orleans/
├── maid_of_orleans.typ       # Main content
├── maid_of_orleans_style.typ # Style definitions
└── main.typ                  # Alternative layout
```

Now I keep styles completely separate:
```typst
#import "@preview/droplet:0.3.1": dropcap
#import "@preview/typearea:0.2.0": typearea

#let template(body) = {
  // Page setup and styling
  show: typearea.with(...)
  set text(...)
  set par(...)
  // Custom styling rules
  body
}

#let framed-image(img-path, cap) = { ... }
#let dropped(first, rest) = { ... }
```

And the main file stays clean:
```typst
#import "maid_of_orleans_style.typ": dropped, framed-image, template, typearea
#show: template

// Cover and content
```

**Why this clicked:** I can update the style everywhere by changing one file. I can reuse this style for different book in the future. Most importantly, when I'm writing content, I'm not distracted by style related code.

**The downside:** Back and forth between the files, and you have to remember what's actually something does. But honestly? Worth it for anything book-length.

## The "Template Everything" Phase

I went through a phase where I tried to template everything. Academic papers, reports, you name it.
```typst
#let template(
  title: none,
  abstract: none,
  authors: (),
  date: "©2025",
  doc,
) = {
  set page(...)
  set text(...)
  set par(...)
  // All styling rules
  doc
}

#show: doc => template(
  title: [Nine Things I Learned in Ninety Years],
  authors: ([Edward Packard],),
  abstract: [...],
  doc,
)
```

**The reality:** This is powerful but can get over-engineered fast. I spent more time tweaking the template than writing content sometimes. Now I only use this for documents that really need strict formatting-like conference papers where every margin matters.

## Pattern 4: Configuration-Driven Design

For highly configurable documents, especially those that might need different layouts or formats, a configuration object approach works well.

### Example: Two-Column Article

See example output [here](/typesettings#two-column-article).
```typst
#let config(
  column: 2,
  size: 10pt,
  font: "Libertinus Serif",
  paper: "a4",
  title: none,
  authors: (),
  abstract: [],
  doc,
) = {
  // Apply configuration
  set page(paper: paper, ...)
  set text(font: font, size: size, ...)
  // ... rest of styling
}

#show: document => config(
  column: 2,
  title: [Article Title],
  authors: (...),
  abstract: [...],
  document,
)
```

**Characteristics:**
- Highly parameterized
- Easy to switch configurations
- Suitable for template libraries
- Great for documents with multiple format requirements

**When to use:** Template systems, documents needing multiple output formats, or when building reusable document classes.

### The "Meta First" Breakthrough

This brings me back to that HLA journal moment. The metadata-first approach changed how I think about document structure.
```typst
#let meta = (
  institution: "Typst University",
  journal: "Typst Type Review", 
  year: "1958",
  title: "The Foundations of Visual Language",
  author: "Aaron P. Murniadi",
  abstract: [...],
  body: [...]
)

// Styling and setup using meta object
#set text(...)
#set page(...)

// Document content
#meta.body
```

Instead of starting with styling, I start with data. All the document information lives in one object. Then I apply styles to that data.

**Why this feels right:** The document structure is visible immediately. I can see what the paper is about without scrolling. When I need to update the journal name or volume, it's one place. The styling becomes a separate concern that I can tweak without touching the content.

### Sometimes You Just Need It Simple

Not every document needs architecture. For quick drafts or simple letters, I go straight to the point:
```typst
#set page(...)
#set text(...)
#set par(...)

#align(center)[SUPREME COURT OF THE UNITED STATES]

// Direct content without complex structure
```

No templates, no metadata objects, just get it done. Sometimes this is exactly what you need.

## So What Should We Do?

Look, I don't have the perfect answer. But I think the Typst community needs to start talking about this more openly. We need to share what works, what doesn't, and stop pretending there's one "right" way.

Here's what I've learned works for me:

* **Start with the problem, not the pattern**. Don't force a template approach on a simple letter.
* **Think about who will maintain this**. Future you? A team? That changes everything.
* **Consider the document's lifecycle**. One-off vs. living document needs different structures.
* **Don't be afraid to refactor**. I've rewritten documents multiple times as I understood them better.

# Let's Build Some Community Wisdom

I've shared my patterns. Now I want to hear yours. What organizational approaches have you discovered? What worked brilliantly? What failed spectacularly?