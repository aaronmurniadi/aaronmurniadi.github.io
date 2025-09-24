#set document(
  title: "The Maid of Orleans",
  author: "Frederick Henning",
)
#set page(
  width: 125mm,
  height: 176mm,
  margin: (
    top: 20mm,
    bottom: 20mm,
    left: 17mm,
    right: 15mm,
  ),
)
#set text(
  size: 10pt,
  lang: "en",
  font: "Baskerville",
)

#set heading(numbering: "I")
#show heading: it => {
  if it.level == 1 {
    v(36pt, weak: true)
    align(center)[
      #text(1.5em, it.body)
    ]
    v(24pt, weak: true)
  } else {
    it
  }
}

#let drop(it) = {
  lettrine(it.text.at(0), lines: 2)
  it.text.slice(1)
}

#let frontmatter(body) = {
  counter(page).update(1)
  set page(numbering: "i")
  body
}

#let mainmatter(body) = {
  counter(page).update(1)
  set page(numbering: "1")
  body
}

#let backmatter(body) = {
  body
}

#let preface(body) = {
  heading(level: 1, numbering: none, smallcaps[Preface])
  body
}

#set par(
  justify: true,
  leading: 0.52em,
)

#frontmatter[
  #include "00_cover.typ" 
  #pagebreak()
  #include "00_desc.typ"
  #pagebreak()
  #outline()
  #pagebreak()
  #include "00_preface.md"
  #figure(
    image("images/p00.jpg", width: 80%),
    caption: [
      _“Oh, were I only a man!” she sighed._
    ]
  )
]

#mainmatter[  
  #figure(
    image("images/p00b.jpg", width: 80%),
    caption: [
      _“Dear uncle, see these beautiful violets,” she cried._
    ]
  )

  #include "03b.md"
  #include "04.md"
  #include "05a.md"
  
  #figure(
    image("images/p01.jpg", width: 80%),
    caption: [
      _The last act in the ceremony was Charles’s coronation_
    ]
  )

  #include "05b.md"
  #include "06a.md"

  #figure(
    image("images/p02.jpg", width: 80%),
    caption: [
      _The flames mounted higher, and the people saw, not a devil’s witch, but a praying angel with eyes fixed upon heaven._
    ]
  )
  
  #include "06b.md"
  #include "07.md"
  #include "08_appendix.typ"
]

#backmatter[
  #include "LICENSE.typ"
]
