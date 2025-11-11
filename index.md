---
title: 'Home'
layout: home
---

## Hi, my name is Aaron Purnomo Murniadi

A Software Engineer with a passion for technology, coding, and open-source software. My background includes four years of studying philosophy (though I didn't finish the degree), which has profoundly shaped my thinking and continues to influence my work and writing.

This blog serves as a platform for me to share my ideas, projects, and reflections—covering everything from technical insights to philosophical musings.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      {% if post.date %}
        <span>{{ post.date | date: "%b %d, %Y" }} — </span>
      {% endif %}
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

## Summaries

<ul>
  {% for summary in site.summaries %}
    <li>
      {% if summary.date %}
        <span>{{ summary.date | date: "%b %d, %Y" }} — </span>
      {% endif %}
      <a href="{{ summary.url | relative_url }}">{{ summary.title }}</a>
    </li>
  {% endfor %}
</ul>

## Articles

This collection consists of articles and lengthy texts, mainly centered on philosophy—traces of my unfinished journey in Philosophy, if you will. Almost all of the content is in Bahasa Indonesia.

### Published Articles (external links)

- ["Ranting Mencari Jalan ke Akar", Mardiatmadja, SJ, B.S. and Whisnu Bintoro, CICM, Dhaniel (2020)
  "EKLESIOLOGI Langkah demi Langkah. Sudut-Sudut Hening Ziarah Gereja". PT Kanisius, Yogyakarta. ISBN 978-979-21-6665-1](http://repo.driyarkara.ac.id/321)

- [Murniadi, Aaron Purnomo (2022) "Waktu intuitif (durasi) sebagai dasar adanya kehendak bebas manusia menurut Henri Bergson." _Driyarkara Jurnal Filsafat_, 42 (2): 5. pp. 81–91. ISSN 2809-9516](https://karya.brin.go.id/id/eprint/25247/1/2809-9516_42_2_2022-5.pdf)

### Unpublished Articles

<ul>
  {% for article in site.articles %}
    <li>
      {% if article.date %}
        <span>{{ article.date | date: "%b %d, %Y" }} — </span>
      {% endif %}
      <a href="{{ article.url | relative_url }}">{{ article.title }}</a>
    </li>
  {% endfor %}
</ul>
