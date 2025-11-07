---
layout: post
title: 'Typst Collection'
---

# Typst Collection

{% assign files = site.static_files | where_exp:"file","file.path contains 'assets/files/'" %}
{% assign pdfs = files | where_exp:"file", "file.extname == '.pdf'" %}

{% for pdf in pdfs %}
{% assign typ_name = pdf.name | replace: '.pdf', '.typ' %}
{% assign typ_file = files | where: 'name', typ_name | first %}

{%- capture title -%}
{%- if pdf.name == "cv_aaron_murniadi.pdf" -%}
My CV
{%- elsif pdf.name == "edward_packard_nine_things.pdf" -%}
Edward Packard's "Nine Things I Learned In Ninety Years"
{%- elsif pdf.name == "example_thesis.pdf" -%}
Example Thesis
{%- elsif site.data.pdf_titles and site.data.pdf_titles[pdf.name] -%}
{{ site.data.pdf_titles[pdf.name] }}
{%- else -%}
{{ pdf.name | replace: '.pdf','' | replace: '_',' ' | capitalize }}
{%- endif -%}
{%- endcapture -%}

## {{ title | strip }}

<embed src="{{ site.url }}/{{ pdf.path }}" type="application/pdf" width="100%" height="720px" toolbar="0" />

[Download PDF]({{ site.url }}/{{ pdf.path }}) \| [Download Source]({{ typ_file.path }})

{% endfor %}
