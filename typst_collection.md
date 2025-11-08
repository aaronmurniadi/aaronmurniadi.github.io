---
layout: post
title: 'Typst Collection'
---

# Typst Collection

{% comment %}
Define a mapping between filenames and their titles
{% endcomment %}
{% assign pdf_title_map = "cv_aaron_murniadi.pdf:My CV" | split: "," %}
{% assign pdf_title_map = pdf_title_map | push: "edward_packard_nine_things.pdf:Edward Packard's 'Nine Things I Learned In Ninety Years'" %}
{% assign pdf_title_map = pdf_title_map | push: "philosophical_review.pdf:The Philosophical Review" %}
{% assign pdf_title_map = pdf_title_map | push: "two_column_article.pdf:Simple Two Column Article" %}

{% assign files = site.static_files | where_exp:"file","file.path contains 'media/files/'" %}
{% assign pdfs = files | where_exp:"file", "file.extname == '.pdf'" %}

{% for pdf in pdfs %}
{% assign typ_name = pdf.name | replace: '.pdf', '.typ' %}
{% assign typ_file = files | where: 'name', typ_name | first %}

{% assign custom_title = nil %}
{% for mapping in pdf_title_map %}
{% assign map_parts = mapping | strip | split: ":" %}
{% if map_parts[0] == pdf.name %}
{% assign custom_title = map_parts[1] %}
{% break %}
{% endif %}
{% endfor %}

{%- capture title -%}
{%- if custom_title -%}
{{ custom_title }}
{%- elsif site.data.pdf_titles and site.data.pdf_titles[pdf.name] -%}
{{ site.data.pdf_titles[pdf.name] }}
{%- else -%}
{{ pdf.name | replace: '.pdf','' | replace: '_',' ' | capitalize }}
{%- endif -%}
{%- endcapture -%}

### {{ title | strip }}

<p style="text-align:right">
  <a href="{{ site.url }}/{{ pdf.path }}">Download PDF</a>
  {% if typ_file %}
    | <a href="{{ typ_file.path }}">Download Source</a>
  {% endif %}
</p>

<embed src="{{ site.url }}/{{ pdf.path }}" type="application/pdf" width="100%" height="720px" toolbar="0" />

{% endfor %}
