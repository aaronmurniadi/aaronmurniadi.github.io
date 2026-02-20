#import "@preview/droplet:0.3.1": dropcap
#import "@preview/typearea:0.2.0": typearea

#let template(body) = {
  // Page
  show: typearea.with(
    two-sided: true,
    paper: "a5",
    div: 13,
    binding-correction: 8mm,
    footer-include: true,
    header-include: true,
    footer-height: 0em,
    header-height: 0em,
  )

  // Font and Paragraph
  set text(font: "TeX Gyre Schola", size: 11pt, lang: "en")
  set par(
    justify: true,
    justification-limits: (
      tracking: (max: 0.02em, min: -0.015em),
    ),
    first-line-indent: (amount: 1em, all: false),
    spacing: 0.7em,
    leading: 0.7em,
  )

  // Chapter
  show heading.where(level: 1): it => {
    set align(left)
    set block(spacing: 3em)
    set text(size: 18pt, weight: "regular", style: "italic")
    pagebreak() + v(4em) + it
  }

  // Use symbols for footnotes instead of numbers
  set footnote(numbering: "*")
  set footnote.entry(indent: 0em)
  // Reset footnote counter per page
  set page(header: counter(footnote).update(0))

  // Body
  body
}

// Image
#let framed-image(img-path, cap) = {
  figure(
    rect(
      stroke: 1pt + black,
      inset: 1pt,
      image(img-path, height: 95%, scaling: "smooth"),
    ),
    caption: text(size: 10pt, style: "italic", cap),
  )
}

#let dropped(first, rest) = {
  dropcap(height: 3, gap: 0.5em)[#smallcaps(first)#rest]
}
