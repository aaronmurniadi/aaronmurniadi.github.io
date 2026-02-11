#set page(width: 6in, height: 9.5in, margin: (top: 0.75in, bottom: 1in))
#set text(size: 11pt, number-type: "lining", kerning: true, ligatures: true)
#set par(
  justify: true,
  justification-limits: (
    tracking: (max: 0.025em, min: -0.01em),
  ),
)
#let journal-prefix = [The]
#let journal-name = [Philosophical Review]
#let journal-title = [The Philosophical Review]
#let journal-date = [October 1954]
#let journal-location = [Cornell University Press, Ithaca, New York]
#let journal-price = [\$6.00 A YEAR, SINGLE COPIES \$1.50]
#let subtitle = [A Quarterly Journal]
#let volume = [LXIII]
#let number = [4]
#let whole-number = [368]

//Manual hyphenations
#let words = (
  "emer-i-tus",
)

#show: body => words.fold(body, (body, word) => {
  show word.replace("-", ""): word.replace("-", [-?].text)
  body
})

// Front Page Title
#align(center)[
  #v(1fr)
  #text(size: 24pt, weight: "bold")[#upper[#journal-prefix]]
  #v(0.25fr)
  #text(size: 55pt, tracking: -2pt, style: "italic", font: "Libre Caslon Text")[#journal-name]
  #v(1fr)
  #text(size: 12pt, weight: "bold", spacing: 5pt)[#upper[#subtitle]]
  #v(3fr)
  #align(center)[
    #stack(
      line(length: 2.5cm),
      v(0.5em),
      text(weight: "bold")[#upper[#journal-date]],
      v(0.5em),
      line(length: 2.5cm),
    )
  ]
  #v(1fr)
  #text(size: 12pt, spacing: 5pt, weight: "bold")[#upper[#journal-location]]
  #v(0.5fr)
  #text(style: "italic", size: 11pt)[#upper[#journal-price]]
  #v(1fr)
]

#pagebreak()

#set page(margin: (inside: 0.75in, outside: 1in))

#v(1fr)

#align(center)[
  #text(size: 14pt, weight: "bold")[#upper[#journal-prefix]]
  #v(-1.8em)
  #text(size: 28pt, style: "italic", weight: "medium", tracking: -1pt, font: "EB Garamond")[#journal-name]
  #v(-1em)
]

#align(center)[
  #box(width: 77%)[
    #align(left)[
      #text(size: 10pt)[
        #upper[Edited by] the Faculty of the Sage School of Philosophy in Cornell University:
        Rogers Albritton, Max Black, Stuart M. Brown, Jr., E. A. Burtt, G. Watts Cunningham (Emeritus),
        Norman Malcolm, John Rawls, George H. Sabine (Emeritus), Irving Singer, Harold R. Smart, Gregory Vlastos.

        #v(1em)

        #align(center)[
          EDITORIAL BOARD

          Max Black, Stuart M. Brown, Jr., Gregory Vlastos \
          _Managing Editor:_ Stuart M. Brown, Jr.
        ]

        #v(1em)

        Articles intended for publication, books for review, and subscriptions should be sent to
        #upper[#journal-title], 231 Goldwin Smith Hall, Cornell University, Ithaca, New York.
        The articles in this REVIEW are indexed in the INTERNATIONAL INDEX TO PERIODICALS, New York, New York.
      ]
    ]
  ]
]

#v(2fr)

#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[#upper[#journal-prefix]]
  #v(-2em)

  #text(size: 28pt, style: "italic", weight: "bold", tracking: -0.5pt, font: "Libre Caslon Text")[#journal-name]

  #v(-1.5em)

  #text(spacing: 8pt)[
    #upper[VOLUME] #volume #h(1fr)\*#h(1fr) #upper[NUMBER] #number #h(1fr)\*#h(1fr) #upper[WHOLE NUMBER] #whole-number
  ]

  #v(0.35em)

  #stack(
    line(length: 2.5cm),
    v(0.5em),
    text(weight: "bold", spacing: 6pt)[October 1954],
    v(0.5em),
    line(length: 2.5cm),
  )

  #v(0.35em)
]

#v(0.5em)

#let section(title, supplement: none) = heading(
  level: 1,
  title,
  supplement: supplement,
)

#let article(title, author, tracking: 0pt) = heading(
  level: 2,
  text(tracking: tracking)[#title],
  supplement: text(smallcaps(author), size: 0.8em),
)

#let book-review(book_author, book_title, review_author) = heading(
  level: 2,
  supplement: "book-review",
  [#text(size: 9pt)[#text(style: "italic")[#book_author], #book_title\; by #review_author]],
)

#show outline.entry: it => {
  if it.element.level == 1 {
    if it.element.supplement == [dotted] {
      grid(
        columns: (auto, 1fr, auto),
        column-gutter: 0.5em,
        align: bottom,
        it.element.body,
        box(width: 1fr, repeat(".", gap: 0.1em)),
        stack(
          dir: ltr,
          spacing: 0.5em,
          "",
          it.page(),
        ),
      )
    } else if it.element.supplement == [dotted-end] {
      // Don't show dotted-end headings in this outline
    } else {
      // Default level 1 heading without dots
      grid(
        columns: (auto, 1fr, auto),
        column-gutter: 0.5em,
        align: bottom,
        it.element.body, none, none,
      )
    }
  } else if it.element.level == 2 {
    if it.element.supplement == [book-review] {} else {
      // Default level 2 heading without dots
      layout(size => {
        let right_content = stack(
          dir: ltr,
          spacing: 1em,
          smallcaps(it.element.supplement),
          it.page(),
        )
        let right_width = measure(right_content).width
        let gutter_width = 2 * 0.5em
        let content_width = size.width - right_width - gutter_width

        let body = it.element.body
        let actual_height = measure(block(width: content_width, body)).height
        let single_line_height = measure(block(width: content_width, "A")).height
        let is_broken = actual_height > single_line_height * 1.01

        if is_broken {
          body
          grid(
            columns: (1fr, auto),
            column-gutter: 0em,
            align: bottom,
            box(width: 1fr), right_content,
          )
        } else {
          grid(
            columns: (auto, 1fr, auto),
            column-gutter: 0em,
            align: bottom,
            body, box(width: 1fr, repeat(".", gap: 0.1em)), right_content,
          )
        }
      })
    }
  }
}

#set text(size: 10pt, number-width: "tabular", number-type: "old-style")

#outline(title: none)

#v(-0.7em)

#set par(leading: 0.3em)
#context (
  block(
    width: 100% - 2.5em,
    query(heading.where(level: 2, supplement: [book-review])).map(review => review.body).join([—]),
  )
)

#v(0.2em)

#show outline.entry: it => {
  grid(
    columns: (auto, 1fr, auto),
    column-gutter: 0.5em,
    align: bottom,
    it.element.body,
    box(width: 1fr, repeat(".", gap: 0.1em)),
    stack(
      dir: ltr,
      spacing: 0.5em,
      "",
      it.page(),
    ),
  )
}

#outline(title: none, target: heading.where(supplement: [dotted-end]))

#v(1em)

#align(center)[
  #block(width: 95%)[
    #smallcaps[#text(size: 9pt, hyphenate: false)[
        #lower[edited by the faculty of the sage college of philosophy in cornell
          #text(spacing: 0.5em)[university. published by cornell university press, ithaca, new york]]
      ]
    ]
  ]
]

#align(center)[
  #block(width: 55%)[
    #text(size: 0.8em, hyphenate: false)[
      Entered as second-class matter at the post office at
      #text(spacing: 0.4em)[Ithaca, New York, under the act of March 3, 1879.]
    ]
  ]
]

#pagebreak()

#set text(size: 11pt)

#counter(page).update(479)
#article(
  upper("Causal Necessities: An Alternative to Hume"),
  "Charles Hartshorne",
  tracking: 0.2pt,
)

#counter(page).update(500)
#article(
  upper("Four Types of Ethical Relativism"),
  "Paul W. Taylor",
  tracking: 0.2pt,
)

#counter(page).update(517)
#article(
  upper("Disputes About Synonymy"),
  "Richard Taylor",
  tracking: 0.2pt,
)

#pagebreak()
#section("DISCUSSION")

#counter(page).update(530)
#article(
  [Wittgenstein's #text(style: "italic")[Philosophical Investigations]],
  "Norman Malcolm",
)

#counter(page).update(560)
#article(
  "Some Remarks on the Ontology of Ockham",
  "Gustav Bergmann",
)

#pagebreak()
#counter(page).update(572)
#article(
  "Comment",
  "Ernest A. Moopy",
)

#counter(page).update(577)
#article(
  "The Categorical Imperative",
  "Marcus G. Singer",
)

#counter(page).update(592)
#article(
  "Kant, Bayle, and Indifferentism",
  "D. A. Rees",
)

#pagebreak()
#counter(page).update(596)
#section("REVIEW OF BOOKS", supplement: "dotted")


#book-review("John Wild", "Plato's Modern Enemies and the Theory of Natural Law", "Richard Robinson")
#book-review("N. R. Murphy", "The Interpretation of Plato's Republic", "Helen North")
#book-review("L. M. De Rijk", "The Place of the Categories of Being in Aristotle's Philosophy", "Kurt von Fritz")
#book-review("F. M. Cornford", "Principium Sapientiae: The Origins of Greek Philosophical Thought", "F. E. Sparshott")
#book-review(
  "Herbert Dingle",
  "The Scientific Adventure. Essays in the History and Philosophy of Science",
  "Philip P. Wiener—D. S. Mackay, G. P. Adams, W. R. Dennes (eds.)",
)
#book-review("Thompson M. Clarke—A. G. N. Flew (ed.)", "Logic and Language", "A. I. Melden—James C. O'Flaherty")
#book-review(
  "A. I. Melden—James C. O'Flaherty",
  "Unity and Language: A Study in the Philosophy of Johann Georg Hamann",
  "Paul L. Holmer",
)
#book-review("Meinong-Gedenkschrift", "Meinong-Gedenkschrift", "Roderick M. Chisholm—Karl Jaspers")
#book-review("Karl Jaspers", "The Origin and Goal of History", "Maurice Mandelbaum—Baker Brownell")
#book-review("Baker Brownell", "The College and the Community", "Harold Taylor")
#book-review("André-Louis Leroy", "David Hume", "Bernard Wand—R. P. Anschutz")
#book-review("R. P. Anschutz", "The Philosophy of J. S. Mill", "Frederick C. Dommeyer")
#book-review(
  "John A. Hutchison and James Alfred Martin, Jr.",
  "Ways of Faith: An Introduction to Religion",
  "John B. Noss—Louis O. Kattsoff",
)
#book-review("Louis O. Kattsoff", "Elements of Philosophy", "Martin A. Greenman—R. A. F. Hoernlé")
#book-review("R. A. F. Hoernlé", "Studies in Philosophy", "A. C. Ewing")
#book-review("Lewis Mumford", "Art and Technics", "Lucius Garvin")


#pagebreak()
#counter(page).update(638)
#section("BOOKS RECEIVED", supplement: "dotted-end")

#pagebreak()
#counter(page).update(638)
#section("NOTES", supplement: "dotted-end")
