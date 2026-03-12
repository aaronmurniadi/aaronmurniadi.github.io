#import "@preview/droplet:0.3.1": dropcap
#import "@preview/typearea:0.2.0": typearea

// ── Metadata ────────────────────────────────────────────────────

#let meta = (
  journal: "Typst Type Review",
  year: "1958",
  month: "February",
  volume: "71",
  number: "4",
  title: "The Foundations of Visual Language: The Law of Typography",
  short-title: "The Law of Typography",
  author: "Aaron P. Murniadi",
  abstract: [Typography is often described as the clothes that words wear. While the content of a text provides the soul, typography provides the physical presence, the tone of voice, and the first impression. To the untrained eye, it might seem like a simple choice between fonts, but to the designer and the reader, it is governed by a set of psychological and structural principles often referred to as the "laws" of typography. These laws ensure that written communication is not just seen, but understood and felt.],
  keywords: "Typography, Legibility, Readability, Visual Hierarchy, Kerning, Serif, Sans-Serif, White Space, Document Design.",
  body: [
    // ── BODY ────────────────────────────────────────────────────

    == The Law of Legibility and Readability

    #dropcap(height: 2, gap: 2pt)[
      Typography serves as the physical manifestation of the written word, acting as the essential bridge between abstract thought and visual communication. To the skilled designer, this medium is governed by a rigorous set of structural principles often referred to as the laws of typography, which function as the invisible scaffolding of every document. These laws are not merely aesthetic suggestions or artistic preferences but are instead essential functional requirements that ensure communication is not just seen by the eye, but deeply understood and internalized by the mind. By adhering to these guidelines, a designer can transform a chaotic collection of letters into a cohesive narrative that speaks with clarity and intent.#footnote[
        If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.
      ]
    ]

    The most fundamental law in this discipline is the nuanced distinction between legibility and readability, two terms that are frequently conflated but represent distinct stages of the visual and cognitive process. _Legibility_ refers specifically to the design of the typeface itself and the ease with which one individual letterform can be distinguished from another under various conditions. This is an inherent property of the font's anatomy, where factors such as a generous x-height, distinct character shapes that avoid ambiguity, and open counter spaces play a critical role in preventing visual confusion. A highly legible typeface ensures that a "c" is not mistaken for an "o" and that an "I" is clearly distinct from an "l," providing the basic building blocks for any successful typographic system.

    In contrast, _Readability_ concerns the macro-level arrangement and orchestration of those typefaces within a specific layout or composition. It is a holistic measure of how easily a reader can process long passages of text without experiencing ocular fatigue or losing interest. Even a perfectly legible font can become entirely unreadable if the surrounding layout is poor, neglected, or overly cramped. To achieve high readability, a designer must carefully consider how the human eye moves across a page, ensuring that the visual path is clear and that the cognitive load remains low. Key factors that dictate this experience include:

    1. _Line Length (Measure):_ The horizontal width of a text block determines the rhythm of the reader's eye movements. The ideal length is generally considered to be between 45 to 75 characters, as anything longer causes the reader to struggle to find the start of the next line, while anything shorter breaks the flow of thought unnecessarily.
    2. _Leading:_ This is the vertical space between lines of type, a crucial element that prevents the "ghosting" effect where lines appear to vibrate or merge into one another. Proper leading provides the necessary white space for the eye to track smoothly from the end of one sentence to the beginning of the next without distraction.
    3. _Kerning and Tracking:_ These represent the microscopic and macroscopic adjustments of horizontal spacing between characters. While tracking affects the overall density of a block of text, kerning ensures that specific pairs of letters do not create awkward gaps or overlaps, resulting in a consistent and harmonious visual texture that feels balanced to the viewer.

    == The Law of Hierarchy and Emphasis

    The law of hierarchy dictates that a designer must actively guide the reader's eye through the content in a logical, tiered order using the strategic power of contrast and positioning. Without a clear visual map, a page becomes an impenetrable and exhausting wall of text, making it nearly impossible for the reader to scan for vital information or grasp the primary message quickly. This structural guidance is achieved through several primary levers that signal the importance of different content blocks:

    1. _Size:_ This is the most immediate and visceral tool for establishing importance. Headlines should be significantly larger than subheadings to signal the start of new sections and grab attention from a distance, establishing a clear entry point for the reader.
    2. _Weight:_ By utilizing the varying weights within a font family, such as light or medium versions, a designer can create a sense of urgency, strength, or delicacy. These shifts in density provide a visual anchor for the most important keywords, allowing the eye to jump to essential terms.
    3. _Style:_ Mixing different classifications, such as serif and sans-serif fonts, allows for the creation of structural divides that distinguish between types of information. Using a serif for body text and a sans-serif for headers can create a sophisticated tension that clarifies the document's organization and enhances navigation.

    == The Law of Serif vs. Sans-Serif

    Historically, serif fonts have been associated with authority, tradition, and the long academic heritage of the printed press. Their small "feet" or strokes at the ends of character limbs are often thought to help the eye navigate through printed lines by creating a horizontal flow that connects letters. On the other hand, sans-serif fonts are viewed as modern, clean, and minimalist, often preferred for their high performance on digital screens where lower resolutions might blur delicate serifs. The law here is not about the inherent superiority of one style over the other, but rather about the appropriateness of the choice for the specific context and medium. A formal legal document or a classic novel may require the gravitas and historical weight of a serif, while a fast-paced digital interface or a mobile application often demands the clinical clarity and scalability of a sans-serif to remain accessible.

    == The Law of Proximity and White Space

    White space, or negative space, is perhaps the most powerful yet misunderstood tool in the designer's kit, acting as the silence between musical notes that gives the melody its form. It is not "empty" space but rather a functional element that defines the relationships between objects and provides the eye with a place to rest. The law of proximity states that related elements should be grouped closely together to signal their connection, while unrelated elements should be separated by clear margins. This strategic use of space provides the necessary breathing room to prevent cognitive overload, allowing the human brain to process information in manageable, logical chunks rather than being overwhelmed by a cluttered and disorganized interface.

    == Conclusion

    Typography remains the silent partner of language, working tirelessly behind the scenes to shape our perception and emotional response to every word we read. By adhering to these fundamental laws, we ensure that messages are delivered with both precision and intent, respecting the reader's time and cognitive resources. Whether it is a dense scientific paper requiring absolute clarity or a minimalist digital interface focused on speed, the way we set our type ultimately determines if our words are ignored as noise or if they are remembered as meaningful communication.


  ],
)// ── BODY ────────────────────────────────────────────────────


// ── Typography ──────────────────────────────────────────────────

#set text(
  size: 11pt,
  number-type: "old-style",
  lang: "en",
)

#set par(
  first-line-indent: 1.5em,
  leading: 0.65em,
  spacing: 0.65em,
  justify: true,
  justification-limits: (
    tracking: (max: 0.1em, min: -0.01em),
  ),
)


// ── Page geometry ───────────────────────────────────────────────

#show: typearea.with(
  two-sided: false,
  paper: "a5",
  div: 15,
  binding-correction: 0mm,
  header-include: true,
  footer-include: false,
  header-ascent: 20%,
  footer-descent: 1pt,
)

// ── Header ──────────────────────────────────────────────────
#set page(
  header: context {
    let pg = counter(page).get().first()
    let is-odd = calc.odd(pg)
    let rule = line(length: 100%, stroke: 0.4pt)
    set text(size: 11pt)

    if pg == 1 {
      stack(
        spacing: 6pt,
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left + horizon, center + horizon, right + horizon),
          text(tracking: 0.18em)[NUMBER #meta.number],
          text(tracking: 0.18em)[#upper(meta.month) #meta.year],
          text(tracking: 0.18em)[VOLUME #meta.volume],
        ),
        rule,
      )
    } else if is-odd {
      stack(
        spacing: 6pt,
        grid(
          columns: (1fr, 6fr, 1fr),
          align: (left + horizon, center + horizon, right + horizon),
          [#meta.year\]],
          [
            #set par(justify: false)
            #smallcaps(lower(meta.short-title))
          ],
          [#pg],
        ),
        rule,
      )
    } else {
      stack(
        spacing: 6pt,
        grid(
          columns: (1fr, 6fr, 1fr),
          align: (left + horizon, center + horizon, right + horizon),
          [#pg], smallcaps(lower(meta.author)), [\[Vol.~#meta.volume],
        ),
        rule,
      )
    }
  },

  // ── Footer ──────────────────────────────────────────────────
  // Only the title page carries a footer (outside page number).
  footer: context {
    set text(size: 11pt)
    let pg = counter(page).get().first()
    if pg == 1 { align(right)[#pg] }
  },
)


// ── Footnotes ───────────────────────────────────────────────────
#set footnote.entry(
  separator: line(length: 100%, stroke: 0.4pt),
  indent: 0pt,
  gap: 0.45em,
)


// ── Headings ────────────────────────────────────────────────────

#set heading(numbering: none)

#show heading.where(level: 1): it => {
  block(above: 1em, below: 0.25em, context {
    let n = counter(heading).get().first()
    align(center, strong[
      #text(number-type: "lining")[#numbering("I.", n)]#h(0.4em)#it.body
    ])
  })
}

#show heading.where(level: 2): it => {
  block(above: 1em, below: 1em, align(center, emph(it.body)))
}

#show heading.where(level: 3): it => {
  block(above: 0.5em, below: 0.25em, it.body)
}

// Run-in headings
#show heading.where(level: 4): it => {
  v(0.5em, weak: false)
  strong(it.body)
  h(1em)
}

#show heading.where(level: 5): it => {
  v(0.5em, weak: false)
  it.body
  h(1em)
}

// ── Utility shorthand ───────────────────────────────────────────

#let lining(content) = text(number-type: "lining")[#content]


// ================================================================
//  DOCUMENT
// ================================================================

// ── Title page  (mirrors \thispagestyle{plain}) ──────────────────

// Footnotes use superscript symbols (†, ‡ …) on the title page,
// matching \renewcommand*{\thefootnote}{\fnsymbol{footnote}}.
#set footnote(numbering: n => {
  ("†", "‡", "§", "¶", "‖", "_", "††").at(
    calc.rem(n - 1, 7),
  )
})

// Journal nameplate  (\begin{tcolorbox}[…])
#rect(
  width: 100%,
  stroke: 0.8pt + black,
  inset: (x: 8pt, y: 8pt),
  align(center, text(size: 21pt, tracking: 0.3em, font: "Baskervaldx")[
    #smallcaps(upper(meta.journal))
  ]),
)

#v(2em)

// Full title
#pad(right: 3em, align(left, text(size: 14pt)[
  #upper(meta.title)#footnote[
    Submission for r\/Typst subreddit.
    Compiled: #datetime.today().display().
  ]
]))

#v(0.5em)

// Author
#pad(left: 1em, text(size: 14pt)[
  _#meta.author _#footnote[A person who loves Typst.]
])

#v(0.5em)

// Abstract + keywords
#pad(left: 2em, right: 2em)[
  #set text(size: 11pt)
  #set par(first-line-indent: 0pt)

  #meta.abstract

  #v(0.5em)

  _Keywords:~#meta.keywords _
]

#v(1em)


// ── Body  (mirrors) ──────────────────────

// Reset footnotes to arabic numerals, counter to zero.
#set footnote(numbering: "1")
#counter(footnote).update(0)


#meta.body

