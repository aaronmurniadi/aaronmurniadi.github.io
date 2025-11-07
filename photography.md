---
layout: post
title: 'Photography'
---

# Photography

Welcome to my little photography corner! Here you'll find a selection of images I’ve taken.
I enjoy capturing moments from daily life and unique scenes that catch my attention.

---

{% assign image_title_map = "beach_fujifilm_c200_fujifilm_crystal_archive_typeii.jpg:Sunset at the beach" | split: "," %}
{% assign image_title_map = image_title_map | push: "chair_fujifilm_c200_kodak_2383.jpg:Inaccessible chair at National Library" %}

{% assign files = site.static_files | where_exp:"file","file.path contains 'assets/files/images'" %}
{% assign images = files | where_exp:"file", "file.extname == '.jpg'" %}

{% for image in images %}
{% assign typ_name = image.name | replace: '.image', '.typ' %}
{% assign typ_file = files | where: 'name', typ_name | first %}

{% assign custom_title = nil %}
{% for mapping in image_title_map %}
{% assign map_parts = mapping | strip | split: ":" %}
{% if map_parts[0] == image.name %}
{% assign custom_title = map_parts[1] %}
{% break %}
{% endif %}
{% endfor %}

{%- capture title -%}
{%- if custom_title -%}
{{ custom_title }}
{%- elsif site.data.image_titles and site.data.image_titles[image.name] -%}
{{ site.data.image_titles[image.name] }}
{%- else -%}
{{ image.name | replace: '.image','' | replace: '_',' ' | capitalize }}
{%- endif -%}
{%- endcapture -%}

<img src="{{ site.url }}/{{ image.path }}" alt="{{ title | strip }}" style="display:block; max-width:100%; height:auto; margin: 0 auto -.5em auto;" />
<p style="text-align:center; margin-top:0.5em; margin-bottom:2em; font-style:italic;">{{ title | strip }}</p>
{% endfor %}
