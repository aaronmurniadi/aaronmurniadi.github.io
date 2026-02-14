#let sidenote(content) = {
  place(dx: 29em, block(
    // fill: yellow,
    breakable: false,
    width: 14em,
    content,
  ))
}


#let template(
  title: none,
  abstract: none,
  authors: (),
  date: "©2025",
  doc,
) = {
  set page(
    paper: "a4",
    margin: (y: 9em, left: 6em, right: 22em),
    header: context {
      if (here().page() != 1) {
        set text(
          font: "ETBembo",
          weight: "semibold",
          size: 8pt,
          tracking: 1.1pt,
          number-type: "old-style",
          number-width: "tabular",
        )
        place(right, dy: 6em, dx: 24em)[
          #upper(authors.join())'S \ "#upper(title)" #h(1em) #text(size: 16pt, counter(page).display())
        ]
      } else {
        set text(font: "ETBembo", size: 8pt, tracking: 1.1pt, number-type: "old-style", number-width: "tabular")
        place(right, dy: 6em, dx: 24em)[
          #link("https://edwardpackard.com/")[Source: https://edwardpackard.com/]
        ]
      }
    },
  )

  // Paper identification (title, author, date)
  block(
    // fill: luma(230),
    width: 100% + 23em - 5em,
    inset: 0pt,
    radius: 4pt,
    text(font: "TeX Gyre Heros", size: 10pt, tracking: 2pt)[
      // title

      #text(size: 13pt, upper(title))

      // authors
      #set par(justify: true)
      #upper(authors.join(", ", last: " and "))

      // date
      #upper(" © 2025")

      // abstract
      #pad(x: 5em, block(
        // fill: yellow,
        text(tracking: 0pt, abstract),
      ))
    ],
  )
  // Configure headings.
  set heading(numbering: none)
  show heading: it => context {
    // Find out the final number of the heading counter.
    let levels = counter(heading).get()
    set text(16pt, weight: 400)
    if it.level == 1 [
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([Acknowledgment], [Acknowledgement])
      // #set align(center)
      #set text(if is-ack { 10pt } else { 13pt })
      #set text(style: "italic", weight: "bold", size: 12pt)
      #v(18pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering(heading-numbering, ..levels)
        [.]
        h(7pt, weak: true)
      }
      #it.body
      #v(16pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set par(first-line-indent: -pt)
      #set text(style: "italic", size: 13pt)
      #v(14pt, weak: true)
      #if it.numbering != none {
        numbering(heading-numbering, ..levels)
        [.]
        h(7pt, weak: true)
      }
      #it.body
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering(heading-numbering, ..levels)
        [. ]
      }
      _#(it.body):_
    ]
  }


  set par(
    justify: true,
    justification-limits: (
      tracking: (max: 0.025em, min: -0.01em),
    ),
  )

  set text(
    font: "ETBembo",
    weight: "regular",
    size: 11pt,
    tracking: 0pt,
    number-type: "old-style",
    number-width: "tabular",
  )
  doc
}

#import "@preview/tablex:0.0.9": colspanx, hlinex, rowspanx, tablex

#set quote(block: true)

#show: doc => template(
  title: [Nine Things I Learned in Ninety Years],
  authors: ([Edward Packard],),
  abstract: [
    Looking back over my life from when I was about ninety, I ruefully reflected on how often I went off the rails. That I'd survived thus far, scathed but in happy circumstances, was thanks neither to grit, determination, nor wise counsel, but mostly luck. Considering my most memorable lapses, the consequences of which ranged from unfortunate to catastrophic, I suspect that they all would have been avoided if it hadn't taken me most of a lifetime to get a grip on a few basic principles. I'm laying them out here for readers who might want to be aware of them.
  ],
  doc,
)

#block()

Nine Things I Learned:


#show outline.entry: it => link(
  it.element.location(),
  pad(left: 1em, it.indented(it.prefix(), it.body())),
)

#outline(title: none, depth: 2)

#v(1em)

= 1) to be self-constituted;

In her book _Self-Constitution: Agency, Identity, and Integrity_ (2009) Harvard philosopher Christine Korsgaard draws on Kant's and Aristotle's philosophy to make a case for self-constitution—being "consistent, unified, and whole"— having "integrity." Korsgaard says that to be good at being a person, you need to be committed to acting in accord with what Kant called "a universal law," for which I would substitute "a virtuous moral framework." How is that constructed? A strand of thought in philosophy asserts that moral precepts can't be scientifically established—they are indicia of the ways of thinking of particular cultures or religions. Arrayed against this dismal take on our need for guidance are propositions in the "we hold these truths to be self-evident" category, basic principles like, what causes or tends to cause misery and suffering is bad; what causes or tends to cause joy and happiness is good. Anger, hatred, envy, jealousy, dishonesty, meanness, vengefulness, cruelty, resentment, and despair are bad; joy, cheerfulness, kindliness, fairness, compassion, and honesty are good. That's my moral framework as far as I've developed it.

I think of life as like being on a raft drifting downstream on a river of time, other people getting on and off; meanwhile, you're poling, trying to steer the best course, sometimes hanging up on a shoal, maybe falling asleep and awakening almost on the opposite bank, where the wind took you, which is not where you meant to be, getting back mid-stream somehow and carried along with the current through sometimes wildly unexpected weather until you reach the sea. Maybe that's why I admire Huckleberry Finn's moral framework: "What you want, above all things, on a raft, is for everybody to be satisfied, and feel right and kind towards the others."

Professor Korsgaard says, "Your movements have to come from your constitutional rule over yourself. Otherwise, you'll be ruled by a heap of impulses." That permeated my consciousness. If you aren't self-constituted, if you aren't unified, if you don't have integrity, you'll be a mess.

But what if you are a self-constituted, self-aggrandizing narcissist who is "consistent, unified, and whole" in your life project of gaining ever more money, power, and dominance without regard to how it affects anyone else? That's not in accord with my moral framework, or Huck Finn's, or with Kant's and Korsgaard's universal law. You need moral strands woven into your self-constituted character to be a good person.

Once you've achieved that—once you are virtuously self constituted—you will be self-assured and have reason to be so. You will be emotionally invulnerable to being pushed around. You will not entertain feckless impulses, much less yield to them. It will be in your nature to do the right thing.


= 2) to keep awake and aware;

If you're not awake and aware, you're sleepwalking. I spent much of my life in this state, and I know all about it. When you're sleepwalking, you fail to consider what the purpose is of what you're doing and how what you do or don't do will affect you and how it will affect others. Sleepwalkers can go off the rails and stay there unless they luckily stumble back on track.

Sleepwalking doesn't necessarily diminish mental acuity, though I think it invariably affects judgment. Many sleepwalkers hold positions of power. Coming upon Christopher Clark's _The Sleepwalkers: How Europe Went to War in 1914_ (2014), I knew at once why he had chosen that title. In each of the primarily responsible countries, men of imperious bent and puffed-up notions of honor prevailed over wiser and more thoughtful ones in formulating and implementing national policy. Almost without exception, those responsible for making fateful decisions proved incapable of weighing the risk of a staggering continent-wide catastrophe such as was about to unfold. Referring to Austria-Hungary, whose leaders were determined to act forcefully after the assassination of Archduke Ferdinand, Clark says that the decision-makers had no basis for their preconceived notions of how events would play out. Charles Swann, a principal character in Proust's novel _In Search of Lost Time_, gives us a close-up look at how a sleepwalking state is initiated. Swann is intelligent, cultivated, and socially adept, but whenever he must confront an unpleasant fact if he is to make a rational decision, "a mental lethargy, which was, with him, congenital, intermittent, and providential, happened at that moment to extinguish every particle of light in his brain."

Sleepwalking is an all too accessible alternative to confronting inconvenient facts. If you are sleepwalking, and it becomes habitual, a day will come when you act, or fail to act, in a way such that, were you in an awakened state, it would be obvious to you that if you continue your present course of action, or inaction, a catastrophe will ensue. One can stop sleepwalking and keep awake and aware by becoming a buddha. This might seem impossible, outlandish, outré, and out of the question to you, but I have it on the authority of the revered Buddhist monk Thich Nhat Hanh and my own experience that it's doable. In Hanh's book _The Art of Living_ (2017), he says that being a buddha doesn't require any particular belief or practice. Simply "being fully present, understanding, compassionate, and loving" is enough. "It's not so difficult to be a buddha," says Thich Nhat Hanh. "Just keep your awakening alive all day long."

= 3) to consider what others may be thinking and feeling;

For most of my life, whenever I spoke or acted, I first considered what seemed to be in my best interest, or, more often, gave no thought to the matter at all. Only rarely did I consider how anyone affected by what I said, or did, or failed to say or do, would react.

Fixed in my mind and occasionally emerging in my consciousness is a conversation I had during college years. It was with a man a generation older than me, whom I wanted to impress. At a pivotal point, I thought of a witty remark I could make regarding his boat. I imagined that I would be displaying a high degree of sophistication in making it. That was the extent of my thinking before I blurted it out. If I had taken a few seconds to consider it further, I would have realized that, although there was a possibility that this gentleman would find my remark to be clever, it was certain that he would find it to be crude and offensive, so much so that I'm reluctant to repeat it here, half a century later.

Despite this memorable lesson, it took me a long time to learn to give thought to what may be going on in the minds of people I'm interacting with, both empathetically—sensing how others are feeling, and cognitively—conjecturing how they are thinking. The latter is called "theory of mind," it being one's theory as to what's going on in another's mind.

Littered among my memories like pieces of trash along a trail are occasions when I said something that worked to my disadvantage even though I had supposed that it would impress, or persuade, or engender respect for me on the part of the person I addressed it to. Belatedly, I became aware that decisions involving interactions with others should be informed by reflecting on what whomever you're interacting with may think and feel in response to what you say and do.

= 4) to make happiness my default state of mind;

For some years, I scrolled down Facebook posts every day and once in a while came across one by the Dalai Lama. One day, I read:


#quote()[
  As long as we observe love for others and respect for their
  rights and dignity in our daily lives, then whether we are
  learned or unlearned, whether we believe in the Buddha
  or God, follow some religion or none at all, as long as we
  have compassion for others and conduct ourselves with
  restraint out of a sense of responsibility, there is no doubt
  we will be happy.
]


That got me out of my normal slouch and sitting up straight. Can happiness be assured if you just follow a few simple precepts? No need for mastering meditation techniques, observing elaborate religious practices, or divining the wisdom to be found in ancient texts?

I'm sure that the Dalai Lama, a practical man who respects science, would agree that one can't be happy when being subjected to extreme emotional or physical pain. But for most of us who are fortunate enough to rarely or never experience vicious assaults, I came to believe that, if we feel and behave the way the Dalai Lama recommends, happiness can become our usual state of being—our default state of mind. Later, I came upon another post by the Dalai Lama:

#quote()[
  Even more important than the warmth and affection
  we receive, is the warmth and affection we give… .
  More important than being loved, therefore, is to love.
]

I've come to think that understanding this, too, is required for happiness to become one's default state of mind.


= 5) to seek an eternal perspective;

I said that the third thing I learned in ninety years was to consider what other people may be thinking and feeling. The 17th century philosopher Benedict Spinoza expanded his view from that of his own ego to include the view of other people, and beyond the view of other people to the view of what he called "God," or "Nature,"—meaning the entire cosmos. He believed that, through knowledge and understanding, one could find joy and equanimity in the natural order of things. It's a perspective akin to that of Buddhism, whose central thought, the 20th century mythologist Joseph Campbell wrote, is "compassion without attachment," a condition in which "you can stay alive, in action, but be disengaged from desire for, and fear of, the fruits of your action." Achieving a similarly expansive embrace of life and the world—an eternal perspective—led Spinoza to conclude that, "A man strong in character hates no one, is angry with no one, envies no one, is indignant with no one, scorns no one, and is not at all proud."

Can you feel fully alive if you are trying to achieve a challenging goal, but, because you are disengaged from desire or fear (have an eternal perspective), you don't have an emotional investment in what's going on about you? Isn't life colorless if you are never thrilled when you succeed and dismayed when you fail? Achieving extraordinary equanimity has obvious merit, but if you are emotionally disengaged, doesn't it drain the excitement out of life? Aren't you less likely to be satisfied?

Not necessarily. In Peter Matthiessen's book _The Snow Leopard,_ (1978) he describes his trek with the zoologist George Schaller, in the Himalayas, in search of a reclusive snow leopard. They found scat, but never caught a glimpse of the exotic animal they were stalking. When they returned to base camp, a Buddhist monk asked Matthiessen if they had seen the snow leopard. When Matthiessen replied that they had not, the monk said, "No\! Isn't that wonderful?"

It would have been very unBuddhist if the monk had said, "How unfortunate." Was saying "Isn't that wonderful?" a stretch? I don't think so, the point being that it was a release from attachment, the expedition itself was wonderful, their thinking and talking about it was wonderful, that they were "alive, in action," was wonderful; and that there was a majestic animal nearby that was not to be seen was wonderful. Some philosophers find seeking an eternal perspective to be at odds with pursuing one's legitimate self-interest. In his book _The View from Nowhere_ (1986), Thomas Nagel seems to see it as a balancing act. He says, "The hope is to develop a detached perspective that can coexist with and comprehend the individual one." I think Spinoza would say that an eternal perspective needn't be qualified to accommodate a self-fulfilling life; it's a necessary condition of having one, bringing with it equanimity and joy.

= 6) to guard against self-deception;

#quote(attribution: "Oliver Wendell Holmes, Jr. (1841–1935)")[
  Certitude is not the test of certainty.
]

Self-deception occurs when one's decisions and conclusions are driven or influenced by skewed beliefs, unbalanced emotional states, wishful thinking, and so forth. It doesn't take much for us to be subconsciously ingenious at justifying insupportable conclusions. A common example of the process is confirmation bias—giving greater credence and weight to data supporting one's entrenched beliefs and ignoring or minimizing what would undermine them. People who are brilliant and highly educated can be as vulnerable to self-deception as anyone. They employ their superior intellectual capability to display a virtuosity of sophistry most of us could never attain.

In his book _Things That Bother Me_ (2018), the British  philosopher Galen Strawson quotes two notable thinkers who lived four centuries apart, but cast lights of similar wave-lengths on how self deception becomes entrenched in one's mind:

#quote(attribution: "Francis Bacon (1561–1626)")[
  Once the human mind has favored certain views, it pulls
  everything else into agreement with and support for them.
  Should they be outweighed by more powerful countervailing
  considerations, it either fails to notice these, or scorns them, or makes fine distinctions in order to neutralize or reject them ... thereby leaving untouched the authority of its previous position.
]

#quote(attribution: "Daniel Kahneman (1934–2024)")[
  We know that people can maintain an unshakeable faith in
  any propositions, however absurd, when they are sustained
  by a community of likeminded believers.
]


In his book _The Disordered Mind_ (2018), Nobel laureate
neuroscientist Eric Kandel notes, "All conscious perception depends on unconscious processes." Unconscious processes wreaked havoc on my decision making.

I had planned, as the heading of this section, to claim that I had learned to avoid self-deception, but after reading more about it, I decided that I had learned only to _guard_ against self-deception. At that moment, a cloud of uncertainty threatened to envelop me. Recalling Yeats's foreboding poem, "The Second Coming" (1919), I had to tell myself: Don't let it be that "The best lack all conviction" is true.

= 7) how to confront mortality;

#quote(attribution: "Epictetus (d. 135 C.E. )")[Keep death and exile before your eyes each day ...]

#quote(attribution: "Benedict Spinoza (1632–1677)")[
  The free man thinks of death, least of all things.
]


The ancient Greek and Roman Stoics believed that it's wise to
contemplate death well ahead of the event. I suppose their idea was that it's desirable to contemplate death's inevitability so as not to be shocked when it's staring you in the face. If you have cultivated Stoicism, you might be better able to bear unexpected news that you have little time to live. Stoicism is a noble stance, but I prefer Spinoza's, which is that the path to equanimity, self-control, and disinterest in one's mortality is to be found in gaining an eternal perspective through knowledge and understanding.

Spinoza rejected all supernatural claims of the world's religions, including anthropomorphic conceptions of God and of rewards and punishments administered by a deity to living persons or in an afterlife. He lived simply, but disdained asceticism. He considered doctrinal and myth-based religions to be superstitions; yet he was pragmatic. Knowing that his landlady found comfort in her religious beliefs, he took care not to undermine her faith.

#quote(attribution: "George Eliot (1819–1880)")[
  I try to delight in the sunshine that will be when I shall never see it any more. And I think it is possible for this sort of impersonal life to attain greater intensity—possible for us to gain much more independence—than is usually believed, of the small bundle of facts that make our own personality.]

Eliot translated Spinoza's treatise, _Ethics,_ into English. The passage quoted above, from one of her letters, is a snapshot of an eternal perspective in the making.

#quote(attribution: "Bertrand Russell (1872-1970)")[
  The best way to overcome the fear of death—so at least it seems to me—is to make your interests gradually wider and more impersonal, until bit by bit the walls of the ego recede, and your life becomes increasingly merged in the universal life. ]


In Russel's essay "A Philosophy for Our Time" he observed that Spinoza's philosophy generated an impersonal feeling that overrode anxiety, and that, even as Spinoza's death was approaching, "he remained completely calm at all times, and in the last day of his life, showed the same friendly interest in others as he did in days of health."

#quote(attribution: "Katharine Hepburn (1907-2003)")[
  I look forward to oblivion.]

Katharine Hepburn was one of the most high-spirited and goodhearted public figures of her time. Her sentiment, quoted above, which she expressed when she was aged, helpless and futureless, exemplifies the fearlessness and bravura that marked her character throughout her illustrious life.

#quote(attribution: "Michel de Montaigne (1533-1592) ")[
  I want death to find me planting my cabbages, neither
  worrying about it, nor about the unfinished gardening.
]

The great essayist was probably as sensible a person as anyone who ever lived.

= 8) what an outsized role is played by luck;

In his book, _Night Thoughts_ (2009), the actor, playwright, and essayist Wallace Shawn says that he was born lucky (that is—to well-heeled, sophisticated, highly intelligent, generally enlightened parents). But unlike most people who were born lucky and take their unusual circumstances for granted, Shawn began to notice the differences between lucky and unlucky people at an early age. "Lucky people tend to expand, to fill the space their luck has given them," he writes. We've become familiar with the very very lucky—billionaires who buy penthouses in incongruously tall towers and fund politicians who express their gratitude by revising the Internal Revenue Code so it favors to an even greater degree the rich and especially the superrich, who then rest their bulky elbows even more heavily on the scales of what happens in our governing bodies, perpetuating for them what they think of as a virtuous circle. But even many rungs farther down the wealth ladder are many who are luckier than most people who ever lived. Shawn notes that if you've lived a relatively peaceful life and not been bombed or harassed or had to live in fear and you've been able to get two or three decent meals a day, you're lucky. And if you've accomplished a lot in life, it's at least in large part because you were lucky in the opportunities you had, in how your path was smoothed, and in how someone helped you along at a critical time.

So much depends on luck: your genetic makeup, the circumstances in which you grew up, the mix of events and influences that formed your disposition and your predispositions, the random happenings that swiveled you in directions not of your choosing. It follows, I think, that the luckier you've been, the more humility and generous spiritedness you need, and the unluckier you've been, the more compassion for yourself you need, and unfair as it may seem, the more you need irrepressible resolve.

= 9) to consider what you have at the moment.

As a general principle, be dynamic, take initiatives, don't be a stick in the mud, and so forth, for sure, but there are times when it's all important to first think for a moment, lest later you reflect that it would have only taken a moment—

#pagebreak()

#v(1fr)

#quote(attribution: [_Much Ado About Nothing_ \
  William Shakespeare])[
  For it falls out \
  #h(3em) That what we have we prize not to the worth \
  #h(3em) Whiles we enjoy it, but being lacked and lost, \
  #h(3em) Why, then we rack the value, then we find \
  #h(3em) The virtue that possession would not show us \
  #h(3em) While it was ours.
]

#v(6fr)

#pagebreak()

#text(size: 16pt, style: "italic")[Sources]

#set par(justify: false)

- Bakewell, Sarah. _How to Live: A Life of Montaigne in One Question and Twenty Attempts at an Answer_. Other Press, 2010.

- Campbell, Joseph. _Reflections on the Art of Living: A Joseph Campbell Companion._ Edited by Diane K. Osbon, HarperCollins, 1995.

- Clark, Christopher. _The Sleepwalkers: How Europe Went to War in 1914_. Harper, 2014.

- Dalai Lama. _Beyond Religion: Ethics for a Whole World_. Houghton Mifflin Harcourt, 2011.

- Eliot, George. _The Journals of George Eliot_. Edited by Margaret Harris and Judith Johnston, Cambridge University Press, 2011.

- Epictetus. _Discourses, Fragments, Handbook_ ("_Encheiridion_"), §21. Translated and edited by Robin Hard, Oxford University Press, 2014.

- Hampshire, Stuart. Spinoza and Spinozism. Oxford University Press, 1951. Reprint, 2005. Hanh, Thich Nhat. _The Art of Living: Peace and Freedom in the Here and Now_. HarperCollins, 2017. Hepburn, Katharine. Quoted in _The Washington Post_, Nov. 10, 1990, p. A23.

- Holmes, Oliver Wendell, Jr. "_Natural Law_." _Harvard Law Review_, vol. 32, no. 1, Nov. 1918. Kandel, Eric. _The Disordered Mind: What Unusual Brains Tell Us About Ourselves_. Farrar, Straus and Giroux, 2018. Korsgaard, Christine M. _Self-Constitution: Agency, Identity, and Integrity_. Oxford University Press, 2009. Matthiessen, Peter. _The Snow Leopard_. Viking Press, 1978.

- Montaigne, Michel de. _The Complete Essays of Montaigne_. Translated by M. A. Screech, Penguin Classics, 1991. Nadler, Steven. _Think Least of Death: Spinoza on How to Live and How to Die_. Princeton University Press, 2021. Nagel, Thomas. _The View From Nowhere._ Oxford University Press, 1986.

- Proust, Marcel. _In Search of Lost Time._ Vol. 1,  translated by C. K. Scott Moncrieff and Terence Kilmartin, revised by D. J. Enright, Modern Library, 1998.

- Russell, Bertrand. _Portraits from Memory and Other Essays_. Routledge, 2021.

- Shakespeare, William. _Much Ado About Nothing_. Edited by Claire McEachern, Bloomsbury Arden Shakespeare, 2016.

- Shawn, Wallace. _Night Thoughts_. Haymarket Books, 2009.

- Strawson, Galen. _Things That Bother Me: Death, Freedom, the Self, Etc._ New York Review Books, 2018. Twain, Mark. _The Adventures of Huckleberry Finn_. Bantam Classic Edition, 2012.

- Yeats, W. B. "The Second Coming." (1919). In _The Collected Poems of W. B. Yeats_, edited by Richard J. Finneran, rev. 2nd ed., Scribner, 1996.
