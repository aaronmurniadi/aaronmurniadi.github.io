---
title: About the "Translate this Article" button
slug: about-the-translate-this-page-button
date: 2025-02-12
tags:
  - blog
published: true
---
Before migrating to Bearblog, most of my legacy content was written in Bahasa Indonesia. I wanted a quick and easy way to translate my posts for readers. One solution I found was Google Translate, which allows you to view a webpage inside a container with its contents automatically translated—a pretty handy feature.

After some trial and error, I discovered that you can add a custom `<a>` element in the navigation section like this:

```markdown
[Home](/) 
[Status](/status/) 
[Posts](/posts/) 
[Articles](/articles/) 
[Contact](/contact/) 
[CV](https://github.com/aaronmurniadi/cv/releases/latest/download/aaron_murniadi_cv.pdf)
<a href="https://translate.google.com/translate?sl=auto&amp;tl=en&amp;u={{ post_link }}" target="_blank">Translate this Article</a>
```

And yes—it works! 🎉

Clicking the "Translate this Article" button will open a new tab of the Google Translated version of your post. Keep in mind that this only works for _Posts_, as it relies on `{{ post_link }}`.

What about pages that aren’t `Posts`, like the `Home` page? With the current setup, the translation link breaks, generating a URL like this:
```
https://translate.google.com/translate?sl=auto&tl=en&u={{%20post_link%20}}
```
To fix this, I decided to show the translation button only on specific pages, such as my `Articles` page. Initially, I thought this would require JavaScript, but surprisingly, it can be done purely with CSS!

First, add the `class="translate"` attribute to the link element:
```html
<a class="translate" href="https://translate.google.com/translate?sl=auto&amp;tl=en&amp;u={{ post_link }}" target="_blank">Translate this Article</a>
```
Then, use this clever CSS trick:
```css
html:not(:has(meta[property="og:type"][content="article"])) .translate {
    display: none;
}
```
Now, the translation button only appears on pages that include the `<meta property="og:type" content="article">` tag.

Pretty neat, right? 🚀