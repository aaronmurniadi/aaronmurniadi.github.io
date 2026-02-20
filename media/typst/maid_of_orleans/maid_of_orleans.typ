#import "maid_of_orleans_style.typ": dropped, framed-image, template, typearea
#show: template

#set page(footer: none)

// Cover
#align(center)[
  #v(1fr)

  #text(size: 18pt, weight: "semibold", tracking: 0.05em)[#upper()[The]]

  #text(size: 22pt, weight: "semibold", tracking: 0.1em)[#upper()[Maid of
    Orleans]]

  #v(1fr)

  #text(size: 12pt, style: "italic")[Translated from the German of\ Frederick
    Henning]

  #v(1fr)

  #text(size: 11pt)[#smallcaps[by]]

  #text(size: 16pt, tracking: 0.025em)[#smallcaps[george p. upton]]\
  #text(size: 9pt, style: "italic")[Translator of "Memories," etc.]

  #v(2fr)

  #image("images/p00a.jpg", scaling: "smooth", height: 5em)

  #v(3fr)

  #text(size: 12pt, tracking: 0.1em)[#smallcaps[chicago]]

  #text(size: 12pt)[#smallcaps[A. C. McClurg & Co.]]


  #text(size: 12pt)[#smallcaps[1904]]
]

#pagebreak()

// Frontmatters
#align(center)[
  #v(1fr)
  The Project Gutenberg eBook of The Maid of Orleans, by Frederick Henning

  #v(1fr)

  This eBook is for the use of anyone anywhere in the United States and most
  other parts of the world at no cost and with almost no restrictions
  whatsoever. You may copy it, give it away or re-use it under the terms of the
  Project Gutenberg License included with this eBook or online at #link(
    "www.gutenberg.org",
  )[www.gutenberg.org].

  #v(1fr)

  Release Date: May 23, 2021 [eBook \#65431]

  #v(4fr)

  Typst typesetting by Aaron Purnomo Murniadi

  #text(size: 10pt, style: "italic")[#link(
    "aaronmurniadi@gmail.com",
  )[aaronmurniadi\@gmail.com]]

  #v(1fr)

  Compiled: #datetime.today().display()

]

// Table of contents
#set heading(numbering: none)
#set outline.entry(fill: none)
#show outline.entry.where(
  level: 1,
): it => {
  v(1.5em, weak: true)
  it
}


#set page(
  footer: context {
    let page_number = counter(page).at(here()).first()
    let alignment = if calc.odd(page_number) { right } else { left }
    align(alignment, numbering("i", page_number))
  },
)

#counter(page).update(1)
#outline(title: "Table of Contents", indent: auto)

// List of Figures
#set figure(
  numbering: none,
  placement: auto,
  kind: "custom-image",
  supplement: [],
)
#outline(
  title: "List of Figures",
  target: figure.where(kind: "custom-image"),
)

// Body

#set page(
  footer: context {
    let page_number = counter(page).at(here()).first()
    let alignment = if calc.odd(page_number) { right } else { left }
    // Convert the numeric page value to Roman numerals for the display
    align(alignment, numbering("1", page_number))
  },
)

#counter(page).update(1)
= Preface

#dropped[The life story of Joan of Arc,][
  as told in this volume, closely follows the historical facts as well as the
  official records bearing upon her trial and burning for "heresy, relapse,
  apostasy, and idolatry." It naturally divides into two parts. First, the
  simple pastoral life of the shepherd maiden of Domremy, which is charmingly
  portrayed; the visions of her favorite saints; the heavenly voices which
  commissioned her to raise the English siege of Orleans and crown the Dauphin;
  her touching farewell to her home; and, secondly, the part she played as the
  Maid of Orleans in the stirring events of the field; the victories which she
  achieved over the English and their Burgundian allies; the raising of the
  siege; the coronation of the ungrateful Dauphin at Rheims; her fatal mistake
  in remaining in his service after her mission was accomplished; her capture at
  Compiègne; her infamous sale to the English by Burgundy; her more infamous
  trial by the corrupt and execrable Cauchon; and her cruel martyrdom at the
  stake. Another story, the abduction of Marie of Chafleur, her rescue by Jean
  Renault, and their final happiness, is closely interwoven with the movement of
  the main story, and serves to lighten up the closing chapters. This episode is
  pure romance of an exciting nature; but the life of the Maid of Orleans is a
  remarkably faithful historical picture, which is all the more vivid because
  the characters are real. In this respect it resembles nearly all the volumes
  in the numerous German "libraries for youth." They are stories of real lives,
  concisely, charmingly, and honestly told, and adhere so closely to fact that
  the reader forms something like an intimate personal acquaintance with the
  characters they introduce.]

\ #align(right)[G. P. U.]

= I --- The Fairy Tree


#dropped[As the traveller,][
  descending the valley from Neuf-?châ-?teau, approaches the village of
  Domremy,#footnote[Neuf-?châ-?teau and Domremy are both in the department of
    Vosges, France. The former is a town with about 4000 population; the latter,
    a village, famous as the birthplace of Joan of Arc.] he will observe at his
  right upon an eminence of the nearest range of hills a stately chestnut-tree,
  its lower branches hung with wreaths of flowers, some fresh, some fading. If
  he does not mind a little fatigue and climbs to this spot, he will be richly
  rewarded for his exertions. The tree in itself is a sufficient compensation
  for his efforts, for who does not contemplate with admiration such a work of
  nature? Who does not listen with rapture to the gentle rustle of its leaves
  and find rest in its cool shade? But this tree has a still stronger attraction
  for those who believe its story. Ofttimes in the twilight they see happy
  sprites dancing round it with joyous faces, and the soft rustling of its
  leaves they declare is celestial whispers, for it is given to them to
  understand heavenly speech.]


This tree is the "Fairy Tree."#footnote[One of the witnesses at the trial of
  Joan of Arc said: "There is a tree called by us the 'Fairy Tree.' Every year
  the young girls and youths of Domremy come to walk there on the Lætare Sunday.
  Jeanne the Maid went there like all the other girls, and did as they did.
  Though she hung garlands on the boughs of the 'Fairy Tree,' she liked better
  to take them into the parish church and lay them on the altars of Saint
  Margaret and Saint Catherine."]

The outlook from this spot will still further repay the traveller. A beautiful
valley spreads out before him, bounded on either side by the forest-crowned
heights of Argonne and Ardennes, between which the Meuse#footnote[The river
  Meuse flows through France, Belgium, and the Netherlands, a distance of 500
  miles, and empties into the North Sea.] winds its silvery way. Numerous
villages dot these heights and are sprinkled here and there along the lower
pasture-land. North and south gleam the towers of Neuf-?châ-?teau and
Vaucouleurs.#footnote[Vaucouleurs is a town of about 3000 population. It was
  from there Joan of Arc started on her expedition to save France.] The nearest,
and at the same time most pleasant of these villages, is Domremy, whose
cottages, embowered in greenery, cluster about the little church of Saint
Margaret. Many herds of cattle and sheep are feeding in the pastures between
fields luxuriant with growing crops. Looking back, the eye catches the dusky
summits of the Bois de Chêne,#footnote[Bois de Chêne, or Wood of Oaks, is the
  name of the forest upon the edge of which is Domremy, Joan of Arc's native
  village.] and at the crossroad leading thither stands the chapel of Saint
Catherine.

Between the chapel and the Fairy Tree, and somewhat nearer the latter, sparkles
a bubbling spring whose curative powers were believed in by those of pious faith
in the olden times.

Thus the scene appears under pleasant skies. But when the temperature suddenly
changes, and the cold air rushes down into the valley, its mists are driven and
scattered among the mountainous defiles. At such times superstitious villagers
believe they see the fairies dancing round the tree, and even the saints of
heaven in the wavering shapes of the mist.

Among the mysterious spots which have invested the neighborhood of Domremy with
such fame and sacredness Bois de Chêne is not the least famous. One cannot enter
its dark recesses without that peculiar feeling of awe which inspires a solitary
wanderer in the presence of nature's grandeurs,---a feeling which inevitably
fills the mind of a superstitious person with a bewildering array of
supernatural fancies. It was from this very forest that Merlin the wizard
predicted the deliverer of France would come.

Think of a child of susceptible and fanciful nature, fed upon nursery tales full
of superstitions, a child passionately fond of solitary reveries and fervent
appeals to the saints, growing up in such an environment! Is it remarkable that
such a child should see marvels on the earth and in the air, and the saints
themselves in bodily image, and that she should hear their voices and listen
devoutly to angelic music in the celestial regions?

Just such a child as this sat under the Fairy Tree on a beautiful spring morning
in the year 1424.#footnote[Joan of Arc (Jeanne d'Arc or Darc) was born at
  Domremy, Jan.~6, 1412, and died May 30, 1431. Her father was Jacques d'Arc,
  and her mother Isabelle Romée, illiterate laborers, but of good repute. She
  had three brothers,---Jacques, Pierre, and Jean,---and a sister Catharine.]
She was a maiden of twelve years, and was tending a little flock of sheep
grazing on the hillside. Even the casual observer would have noticed her
striking appearance, for while the other girls were frolicking in the meadow
below her, she sat leaning against the tree, gazing fixedly into space, and
evidently thinking of other things than dance, and sport, and herds. Looking
more closely into her lovely oval face and observing its transparent tints and
delicate features, the question would at once suggest itself---How did such a
slight, ethereal creature happen among the children of peasants? Those wonderful
eyes did not merely reveal the self-unconsciousness of the visionary and the
rapture of supernatural contemplation. They were clear mirrors of the heart,
reflecting its inmost recesses and depths. That heart was the heart of an angel,
the heart of a child so innocent it was impossible not to love her and
sympathize with her.

As she sat there, a flock of little birds flew to the tree, filling the air with
the music of their songs. Apparently she did not notice them, for she neither
moved nor changed the expression of her face. They fluttered down from the tree
and hopped about the dreamer, approaching her more and more nearly, until at
last some of them lit on her head and shoulder. Now for the first time she was
conscious of her little guests.

"Ah!" she exclaimed in a soft melodious voice. "You are here and I did not know
it." She quickly opened a little basket standing near her, sprinkled some crumbs
upon the ground, and watched with childish delight the liveliness of her tiny
companions. Her pleasure, however, was soon marred by a saucy and envious fellow
in the little crowd, who pecked his neighbor. Chirping sorrowfully, the victim
flew to the maiden's feet.

"Alas! alas! poor little bird!" she exclaimed, the tears coming into her eyes.
She took the little fellow in her lap and caressed him. "Wait, now, thou envious
'wolf,'" she said, addressing the offender. "Did I not scatter crumbs enough for
you all? And did you not know I would have doubled the amount if that had not
been sufficient? You deserve to be punished for your greediness. Now you shall
see how finely this poor little fellow will fare at his own table." Thereupon
she filled her lap from the basket, and the little one ate with a relish, while
the "wolf" was not allowed to come near the table, much as he wished to.
Suddenly the flock rose and flew into the branches of the tree in manifest
alarm. Her sheep, which had been feeding below her, rushed up the hill as fast
as they could, and closely huddled together.

"What is the matter?" cried the maiden, as she cast a hasty glance at the flying
herd. "What has driven you away from the meadow in such fright? Holy Catherine!
the cruel wolf must be lurking on the edge of the wood."

She quickly sprang up, seized her crook, and flew to the Bois de Chêne, where a
wolf was really lying in wait. One who had seen her then would hardly have
recognized the gentle maiden, the dreamer of a moment before, in this resolute
heroine, her eyes flashing with courage. Wonderful to relate, the beast fled
from her. For an instant it crouched, ready to spring upon her, and then slunk
away into the forest. Thereupon the little heroine went to the neighboring
chapel, knelt before the image of Saint Catherine, and poured out the
thankfulness of her heart in long and fervent prayers. It was her childish
belief that her patron saint had performed a miracle. She did not know that the
beasts of the wood can be intimidated by the firmness and courage of a fearless
person's glance, and that even the lion himself will not attack such a person
unless he is in a frenzy of rage.

As the little one left the chapel the spiritual illumination which irradiated
her face when she sat dreaming under the Fairy Tree again shone in her beautiful
eyes. Her route led her to the miraculous spring.#footnote[This spring, in the
  depositions of the witnesses at Joan's trial, is always called the "Well of
  the Thorn."] The fresh green of the bushes and turf allured her. She threw
herself down, and soon was lulled by the gentle plashing of the water into sweet
fancies. For a long time she failed to observe that she had companions who had
come there to drink,---a doe and fawns, who fearlessly approached and drank the
clear water undisturbed. After they had quenched their thirst, the fawns stood
watching the dreamer with their intelligent little eyes as if they were awaiting
friendly recognition from an old acquaintance. Not receiving it, they sported
frolicsomely around her. Suddenly the charming scene was interrupted. The
animals tossed up their heads, listened intently, and then, as if at a word of
command, galloped away to the forest. A bevy of simple, joyous, sun-browned
shepherdesses came running toward her from the meadow.

"Joan, Joan," cried one, "where are you?"

The maiden rose.

"Aha!" said the one just speaking, "she has been listening again to the murmurs
of the spring. Just see how wondrously her eyes glisten!"

At this all of them came up and gazed with a kind of awe at the strange maiden.

"Well, what do you wish?" said Joan, gently.

"We have made a wager," replied the former speaker. "See this beautiful wreath,
Joan. After we had woven it we decided it should go to the winner in a race to
the Fairy Tree. Agnes boasted it would be hers. Margot was just as sure that she
would win it. 'Ah!' said I; 'if Joan were only here you would not talk this
way!' 'And why not?' said Agnes. 'Because,' said I, 'Saint Catherine always
helps her.' 'Oh,' interposed Margot, 'I will find Joan and she also shall race.'
Then I said, 'We will all search for Joan.' 'Yes,' all shouted, 'let us find
Joan!' And here we are. Here is the wreath, and there is the Fairy Tree. Will
you run?"

Joan made no reply. She stood absorbed in devotion, and prayed: "Holy Catherine,
give me the victory, not for my sake, but for thy honor."

"Joan, do you not hear us?"

"Yes, I am ready."

Gleefully the maidens formed a line. "One, two, three," a clear voice counted,
and all ran up the hillside. In a few seconds the line was zig-zag, with Agnes,
Margot, and Joan in the lead. Most of the others gave up the race and followed
slowly on, watching the three in eager suspense. Soon, however, they noticed
there was one in the lead, for the other two had perceptibly fallen back.

"Did I not tell you Joan would win?" said the one who had first spoken.

"But there is some witchcraft about it," said her neighbor. "Look at her, look!
Holy Margaret! Her feet do not touch the ground."

"That is so," all said, as they crossed themselves. "She is flying through the
air."

It really seemed as if Joan were flying. The mist, the fast-gathering twilight,
and the distance created such an ocular illusion that any superstitious
spectator would have sworn she was flying. All hurried to the tree, under whose
branches the victor was not standing, but devoutly kneeling. The joyous crowd
surrounded her, and no feeling of envy clouded their joy as they placed the
wreath upon her fair head. As the night was now fast coming on, the girls went
homewards with the flocks. They were all from the village of Domremy.

Joan found Jacques, her father, Pierre, her brother, and Duram Laxart, her
uncle, engaged in earnest conversation with a stranger in the square in front of
the church. A few words which she overheard aroused her curiosity, and she
approached the group and listened.

"I bid you repent," said the stranger, "lest the wrath of Heaven be visited upon
you, for all the misfortunes of this land are divine punishments for the sins of
the Court and the King's kindred."

"Oh, oh, holy father," said one, "that would be very sad."

"What do you mean by that, my son?"

"I mean it would be very sad for Heaven to punish poor people who have done no
wrong, for the wrongdoings of the Court."

"Go home, thou son of Belial who doubtest that which the Spirit reveals to thee
through my lips. Shut thyself up in thy chamber, and three times repeat seven
paternosters, that thy soul may be released from the bonds of doubt, for doubt
is the work of the devil, who is already stretching out his claws to seize
thee."

"But, holy father---"

"Be quiet, Gamoche," interposed another villager. "Do not interrupt the holy
father. He will explain it all to us."

"Yes, yes," cried the others, "he will explain everything."

"Well, then, listen to me, children," resumed the stranger. "But, holy Mother of
God, where shall I begin? The list of the sins of this Court is so long that if
I should go back a century, even then it would not be the beginning. I will
confine myself to the recent ones, which must be more or less familiar to you
all. Have you heard about the last King, Charles the Sixth?"#footnote[Charles
  the Sixth was born at Paris in 1368, and died in 1422. He reigned forty-two
  years, but became deranged in 1392, and the Duke of Orleans, his brother,
  gained the ascendancy. It was his Queen, Isabella, who prepared the way for
  the treaty of Troyes, which was to make Henry the Fifth of England King of
  France on Charles's death.]

"Why should we not have heard? He died insane only two years ago."

"Yes, insane. He had a few lucid moments after 1392, in which he recognized in
some measure the profligacy of the administration. The whole royal family, with
but few exceptions, acted as if they were insane. First of all, there was the
Queen, the notorious Isabella of Bavaria, who was as much a stranger to the
nobility of human nature as she was to the divine. Her every purpose and act had
no higher motive than the gratification of her own desires and the discovery how
to accomplish them. It would have mattered nothing to her if a sea of blood had
been shed, if only her interests were advanced. There was the Duke Louis of
Orleans,#footnote[After the derangement of his brother, Louis assumed the
  regency in opposition to the Duke of Burgundy. He was assassinated by the
  latter in 1407.] brother of the insane King, who pandered to Isabella's
profligacy and lust of power, finally seized the reins of sovereignty, and
plunged the state into direst confusion. There were the King's uncles, the dukes
of Bourbon, Berry, Burgundy, and Anjou, all alike avaricious and ambitious for
power, who lashed the Duke of Orleans and the King with the scourge of war,
murdered their subjects, and ravaged the country. Then came numerous factions
which contended with one another, one for this, and one for that, and finally
almost countless great and little lords, robber barons, who, pretending to
espouse the cause of one party, harried the districts of others, leaving a trail
of pillage and blood. To complete the burden of wretchedness, King Henry the
Fifth sent his Englishmen, those hereditary enemies of France, across the
Channel. In alliance with the turbulent dukes, particularly those of Burgundy
and Brittany, they advanced victorious, captured one place after another, and at
last even Rouen and Paris, so that few provinces were left to the unfortunate
King. Frightful confusion followed when this King died in 1422. Henry the Fifth,
to be sure, died in the same year, but his field marshal, the Duke of Bedford,
guardian of young Henry the Sixth,#footnote[Henry the Sixth was crowned King of
  France in 1430, but lost all his French possessions except Calais, owing to
  the successes of Joan of Arc. The Duke of Bedford was his uncle.] did not
abandon the field. The infamous treaty of Troyes gave him the semblance of
right."

"How so, holy father?" interposed one of the villagers.

"Be quiet," replied another. "You ought to have known that Queen Isabella, out
of hate and revenge against her youngest son Charles, who, after the death of
his brother the Dauphin, was crown prince, concluded that treaty with England
whereby the French royal family was barred from the succession and the King of
England was declared successor of Charles the Sixth."

"Oh, the disgrace! Oh, the shame!" several exclaimed.

"And this poor Dauphin," continued the former speak-er, "spent a joyless youth,
in which his unnatural mother often forced him as well as his father to suffer
the pangs of hunger; and yet, poor, weak, and throneless as he is, he is still
ready to struggle for that throne which is his birthright as Charles the
Seventh. Is this not so, holy father?"

"Certainly, certainly, God's pity," replied the stranger. "He should rule by his
own and by divine right. The treaty of Troyes cannot prevent it. But where is
the hero who will lead him to coronation at Rheims? Alas, only miraculous
interposition can save him from ruin."

"Saint Catherine," sighed a gentle voice.

"Joan!" exclaimed Jacques, as he recognized his daughter, "what are you doing
here? Go home."

"Not yet, father Jacques," said the stranger. "Let her stay. Do you not know
that the prayers from a pure child's heart are heard by the dear saints? And,"
he added, "I have never seen eyes so full of innocence and piety as hers."

"Ah!" replied Jacques, "of what use are the prayers of a child when the whole
country lies helpless?"

"Are you also an unbeliever?" replied the stranger. "Know you not that the great
God can manifest Himself in a little child?"

These were the last words of the conversation which Joan heard. She suddenly
disappeared, but she did not go home. She wended her way to the church, which
was always open. Never had her heart been so troubled and full of strange
longings, never had she been so powerfully moved to hold communion with her
saint. It was not so much the desire to make a votive offering of her wreath as
it was the unspeakable sorrow of the fatherland and the wretched plight of the
poor Dauphin that urged her to this sacred spot. And was this strange? If her
sympathetic nature made her shed tears over the slight suffering of a bird, how
much more would it force her to weep over the story of universal misfortune
which she had just heard! Why should not the courage with which she had defended
her sheep from the wolf display itself now even more decidedly? And why should
she not believe in her very soul that her favorite saint would perform a miracle
of rescue?

"Oh, were I only a man!" she sighed from the depth of her heart. "Oh that I
could clothe my limbs in armor and wield the sword for the right! I would ask
for nothing better in life. No sacrifice would be too great to accomplish it.
Then, surely, the beloved saints would not refuse to help me."

#framed-image("images/p00.jpg", ["Oh, were I only a man!" she sighed.])

In such a spirit she entered the sacred house. It was empty. The shadows of
evening, mingling with the clouds of incense smoke which still lingered in the
church, were intensified by the feeble light of a small lamp. She thrilled with
sacred awe as she advanced through the mysterious gloom. In her exalted mood it
seemed to her that Saint Catherine smiled, as with trembling hand she placed the
wreath upon her altar. In transports of sorrow and gratitude, of divine trust,
and of overwhelming desire for action, she knelt at the altar, and her soul
ascended to the celestial abodes. She knew no prayers except the Lord's Prayer,
the Credo, and the Ave Maria, but the more she repeated them the more completely
was she spiritually absorbed.

Thus little by little she sank into that species of ecstasy in which the
ordinary spiritual functions are suspended and there remain only the sacred
feeling of heavenly contemplation and the free play of the fancy. It is a
condition which differs from actual dreaming only in its danger, for there is
danger that this ecstatic feeling once aroused may become real, and its
possessor may behold illusive pictures of the fancy. The enthusiast may believe
he sees real objects and hears actual voices. He may believe them to be messages
from heaven, never asking himself whether such fancies will stand the test of
reason. Because of ecstasies like these, deeds have been committed which have
darkened the page of history with everlasting shame. But when these ecstasies
arise from exalted moral ideas they may achieve results which are far beyond
mere human strength and secure imperishable fame for the enthusiast.

Thus it was with this simple child praying at the altar. In her ecstatic fancy
she saw the roof of the church open, and her favorite Saints Catherine and
Margaret floating down through the clouds of incense. She heard them saying,
"Keep thy heart unsullied, Joan, for Heaven has chosen thee as the champion of
France."

The vision disappeared. The dream was over. But in that instant the career of
this child was determined. She was the subsequent Maid of Orleans.


= II --- The Dauphin and La Hire

By the storm of an April day in the year 1428, four years after the events
related in the preceding chapter, a man was detained at home in the castle of
Chinon.#footnote[Chinon, a town in the department of Indre-et-Loire, France, was
  a royal residence from the twelfth century to the reign of Henry the Fourth.
  In its great hall Charles the Seventh first saw Joan of Arc.] His costume
showed that he was of the highest rank, and the apartment also was furnished in
a style of princely luxury. As it was apparent, however, that these luxurious
surroundings were the survivals of an older period, evidently the present
occupant of the castle either did not care to improve them or could not afford
to do it. As a matter of fact the shabbiness of his own costume favored the
latter inference. The morose expression of his face, which had but little that
was attractive in it, deepened this impression. Nothing about it indicated any
higher ambition than the gratification of his physical desires. His appearance
gave the impression that he was at least thirty-five years of age, but in
reality he was only twenty-six. This man was the Dauphin of France, afterwards
King Charles the Seventh.

Before him stood a young and beautiful woman, whose face was in striking
contrast with his. A dignified royal presence, eyes flashing with spirit and
resolution, womanly gentleness and kindness,---such were the characteristics
portrayed in her beautiful countenance. Some of its lines indicated troubles of
the heart, but her present trouble was of another kind.

This lady was Marie of Anjou, the proud consort of the Dauphin. They were both
standing, for in the excitement of their conversation they had evidently risen
from their seats.

"Oh, this wretchedness!" she moaned. "Beautiful France desolate! The luxurious
fields of the Loire laid waste! The poor people killed or fugitives in the
forests! Townsmen in servitude or in continual fear of a victorious enemy! And
you! What are you doing?"

"How, I? Who laments all this more than I? Who has to suffer from it more than
I? Am I not growing poorer every day because of it? I am afraid I shall not have
even an ordinary dinner to-day."

He hastily rang a silver bell, and a servant entered. "Jacques, go to the cook
and ask him what he has for dinner."

Contempt and deep sorrow were pictured on Marie's face, but she quickly mastered
her anger. "Certainly, my husband, you have to suffer," said she, "but what kind
of a king would he be who did not feel the sufferings of his people a
thousand-fold?"

"Pah! I feel my poverty above everything else."

"But what necessity is there for your poverty? Do you not know that your poverty
will disappear on the day when you overcome the enemy?"

"I overcome the enemy! God help me! I need what few mercenaries I have to forage
for the kitchen. Raise fresh troops! How can I do it? What little gold there is
in my treasury is already pledged. I overcome the enemy! Ha, ha, ha! they
already hold nearly all of France. La Hire#footnote[La Hire, one of Charles the
  Seventh's most distinguished generals, was born about 1390, and died at
  Montauban in 1443.] told me to-day that Count Salisbury is before Orleans, and
is besieging the city. When Orleans falls, I must fly from here. Then what? I
shall end by being a beggar."

"You will not if you pluck up courage and remember that when the necessity is
the greatest, divine aid is nearest, and that it is more glorious and more
worthy of a king to be vanquished in battle than to be ruined by inglorious
indolence."

"Pah! I will do neither the one nor the other. I will live and enjoy myself.
That will compensate me for what I lacked in the hungry days of my youth. I will
make terms with the English. They may have everything else if they will only
leave me Languedoc.#footnote[One of the ancient governments in Southern France.
  Toulouse was its capital.] I can live there in a manner that suits my income."

"Shame! shame! what is this I hear?" exclaimed Marie. "Are you a Valois? Does
royal blood flow in your veins? Do you not blush to utter such words? Oh, my
husband, do whatever else you wish, but save France and me from such shame."

"Well, well, all is not over yet at Orleans."

"But even if it fall, and if all seem lost, even then do not make such a
shameful agreement."

With these words the noble lady retired. The moral indignation of her manner and
her words appeared to make some impression upon the Dauphin. He buried his face
in his hands, and was absorbed in thought---as far as he was capable of
thinking.

While thus engaged, an arras door opened behind him, revealing the charming
little curly head of a girl of eighteen or nineteen years. No one could have
seen that exquisite figure moving along with such easy and consummate grace
without confessing he had never before seen such exquisite beauty and
fascinating manner. Her charm appeared not only in her beautiful figure, but
also in the gracious expression which characterized her personality and radiated
from her countenance.

This maiden was the famous Agnes Sorel,#footnote[Agnes Sorel was born in
  Touraine about 1409, and died in 1450.] the favorite of Charles the Seventh,
who, as history relates, was conspicuous for her womanly tenderness, and who
always used her influence over the King for noble purposes and never for
personal ends.

The Dauphin was not aware of her presence until he felt the light touch of her
hand upon his shoulder. The sight of her was magical in its effect. His face
lightened up, and all traces of dejection disappeared.

"Is it you, Agnes? Now everything is all right."

"What has been wrong?" she asked most tenderly.

"Marie has been here. She has made my head ache and has nearly ruined my
appetite. But---"

"I know all about it," interrupted Agnes.

"How? You know all about it? Who could have told you?"

"No one told me."

"Oh, you have been eavesdropping. Ah, ha!"

"I had to. I could not go back, and of course I was not permitted to enter."

"Hm! Never mind. It is all right, just the same."

"Oh, no, Your Majesty."

"How? What do you mean?"

"I share the anxiety and trouble of your proud consort."

"Nonsense! You ought not to be troubled."

"By all the saints, Your Majesty, I shall be inconsolable and unhappy if you do
not abandon your decision. I should be ashamed to serve a prince who can so
easily renounce his rights and his dignities."

"Well, well, I will consider the matter. Will that satisfy you?"

"Oh, no, sire. You must promise me that you will not think again of that hateful
scheme. Will you not for my sake?" Thereupon she triumphantly and gracefully
pirouetted about the apartment.

"Agnes, I take back my word," cried the Dauphin.

This made her all the happier, and she continued her dance, singing this
accompaniment:---

"Eio, eio, eio, no, He cannot be a King Who does not keep his word! Eio, eio,
eio, O, This one here---he is not such, No, no, no, oh, no."

With the last word she suddenly disappeared, for the heavy tramp of men's feet
was heard in the antechamber. The interruption displeased the Dauphin, and he
was about to leave the room, but before he could do so the new-comers stood at
the door. It only increased his displeasure that he was forced to remain. The
two men, whom he regarded with a sinister expression, were rough and sturdy, men
of the class who stand fast in battle and look death fearlessly in the eye,
knights in the truest sense of the word.

"So quickly back, my brave La Hire?" said Charles to one of them.

"By Our Lady, Your Majesty, never was there greater need for quick and decisive
action than now," was his reply. "I have just heard that Count Salisbury has
completely invested the city of Orleans. Not even a cat can get out of it, and
in a few weeks it will be in the clutches of famine. If we do not help them you
can easily see---"

"Help them!" interrupted the Dauphin, despondently. "My good knight, how much
money do you suppose there is in my treasury? Ha! ha!"

"The people will see to it that the treasury of their legitimate King is filled
if in turn they have the assurance that he will make a stand for the right, for
his honor, and for the fatherland."

"And until then I suppose I can keep on with my fasting cure to which my mother
accustomed me. You will not believe it, my good La Hire, but it is the sad truth
that my cook has notified me he has nothing to serve to-day but a pair of fowls
and a hind-quarter of mutton. And you are to be invited as guests to such a
banquet as that!"

"Well, sire, that is all right. To-day we will eat the fowls and the mutton;
to-morrow we will drive the English out of their kitchens, and seat ourselves at
their tables."

"But how are we going to drive them out? It is impossible. Can I summon troops
out of the ground?"

"Yes, sire, you can!"

The Dauphin looked at him with astonishment.

"Do you take me for a wizard? Or, do you mean I am in partnership with the
devil?"

"Resolution and courage, sire, have often worked wonders. Inscribe them on your
banner to-day, and to-morrow it will not flutter deserted. It will rally those
around it who have fallen away discouraged as well as those who follow the
profession of arms, and would gladly enlist under such a royal banner for the
sake of the rich reward. There are men yet who are ready to stand by you with
their good swords. See, here is my stanch friend Saintrailles," pointing to his
companion, "and he is not the only one who is ready."

"You are welcome, brave knight," said Charles. "It is a shame I can only invite
you to sit down to two fowls and a leg of mutton."

"Sire," replied Saintrailles, who could hardly restrain his indignation, "I was
not thinking of your table when I followed my friend here. I was thinking of
your wretched plight and of the bleeding fatherland."

"And do you believe it can be helped?"

"Certainly, sire, but he who would win must venture."

"Yes, and in the meantime he may also lose. But, by my faith, I have not much
more to lose."

"But all the more to win. The brave soul thinks only of winning."

"Oh, yes, you talk like La Hire, and La Hire talks like Marie, and Marie talks
like---but if the English would let me have Languedoc as an independent dukedom,
then---"

He did not finish the sentence, for through the side-door, which was partly
open, he saw the warning finger of Agnes Sorel. Then he resumed:

"I am glad you have come, noble knights. We will meet at table and further
consider this matter. But, alas! two fowls and a leg of mutton!"

On the evening of the same day, when La Hire reached his lodgings and was laying
off his armor, a young man of about eighteen years entered. His strong, supple
frame, handsome, noble face, piercing black eyes, lofty forehead beneath
raven-black hair, as well as his resolute, self-confident bearing, impressed
themselves upon the knight.

"Who are you, and what do you wish?" he said, at the same time regarding the
young man with evident satisfaction.

"My name, noble knight, is probably unknown to you," was his reply. "My father
of blessed memory, however, left it to me unstained. I have come to honor that
name under your banner in the service of the distressed King and the unhappy
fatherland."

"Well said, young man, and, by Our Lady, you look to me like one who can use his
sword as well as his tongue. We will consider the matter."

"Will you not accept my service, noble sir?"

"Gently, young man. Do you suppose that I confide the honor of my banner to
every nameless fellow? Out with your name."

"I am called Jean Renault."

"Renault? Was your father that Thomas Renault who fell in the service of the
Duke of Orleans, fighting against the English?"

"The same, noble sir."

"Then a thousand times welcome. Your father was a brave knight and a noble
gentleman. From to-day you shall serve under my banner, and you will have ample
opportunities to earn your knightly spurs." Thereupon he shook the young man's
hand heartily.

"I thank you for your confidence, noble sir," replied the new adherent, with
beaming eyes. "I will do my utmost to justify this confidence, but what I can do
to earn my knightly spurs I do not yet know, partly because of my youth, and
also, though it is no disgrace, partly because of my poverty."

"Poverty! Your father had property."

"Yes; but it was at Rouen, and it has fallen into the hands of the English."

"Well, we will see that it is returned to you. But now tell me where you
acquired your training."

"Under my father, to whose retinue I was last attached."

"Then you have also fought against the English?"

"Yes, I was in the battle in which my father fell and the Duke of Orleans was
captured."

"Then you are doubly welcome, my young friend," warmly exclaimed the knight. "I
well know I cannot take your father's place, but I will do for you all that a
man can."

Overcome by such generosity, Jean pressed the knight's proffered hand to his
lips. His heart was too full for words. La Hire understood his silence, and
admired him all the more. "You are from the neighborhood of Rouen, and are
acquainted there?" he resumed.

"I know every village thereabouts, noble sir. Alas! they are nearly all ruined."

"Yes! God and the saints pity them. But, further, do you know the Bishop of
Beauvais?"

"Certainly I know him. It is his diocese."

"That is fortunate. I have a message for the bishop, but no messenger who is
acquainted with that region, or cunning enough to evade the English. I can trust
you for both?"

"I am ready, noble sir, provided you do not wish me to act as a spy."

"Do you suppose, my young friend, that I would choose you if I needed a spy? No,
the mission you are to undertake has nothing to do with the war. However, I
cannot conceal from you the danger involved in the undertaking. The Bishop of
Beauvais has the reputation of loving money and leaning to both sides. Do you
understand me?"

"Perfectly, noble sir. He is devoted, now to the Burgundians, now to the
Lotharingians, now to the English, and now to the Duke of Orleans."

"Listen. The English might easily regard a messenger to him as a spy, which, by
Our Lady, would grieve me. But then again, even if they should hold you as a
prisoner it would be uncomfortable, for money is so scarce in our treasury that
you might have to wait a long time for your release."

"I do not think, noble sir, that the English will catch me."

"Then you will undertake the mission?"

"I await your commands."

"Rest to-day and to-morrow. The day after to-morrow you shall have the letter
for the Bishop."

As the road to Rouen led directly through the English district it was
practically impossible for a messenger to make the journey on horseback. Jean
therefore decided to go on foot, disguised as a peasant. As the cities around
Orleans were in possession of the English, he was continually forced to take
divergent routes. He made a wide circuit around Paris, and at last approached
Rouen from the east. While on this part of his journey he stopped in a forest
one noon to rest and enjoy his simple meal. While thus engaged, he suddenly
heard a female voice crying for help. He sprang up, and ran to the road whence
the cry had come. Concealing himself behind some bushes, he watched and
listened. He heard the distant rattle of a carriage and the clatter of armor
toward the east. A heavy travelling carriage soon came lumbering along the rough
road, accompanied by half a dozen men at arms.

"Has a shameful crime been committed, and did the cry come from that carriage?"
said Jean to himself. "What! I think I know the arms on the carriage door. Why,
certainly. They are the Duke of Luxemburg's. But I must be sure of it." With
this he rushed from his hiding-place. "Halt!" he shouted, brandishing his
knobbed stick.

The coachman and attendants were astonished. It seemed incredible that a single
man, armed with such a weapon, should dare to order them to halt. While they
prepared for resistance they watched, not so much the young man as the thickets,
for they were suspicious that other peasants might make their appearance. During
this brief waiting Jean discovered what he had feared, and what he was so
anxious to ascertain. Scarcely had his "halt" died away when a girl's face
appeared at the carriage door.

"Help! help!" she cried, in terror. "Help! They are dragging me to a convent---"

A smothered exclamation of pain followed the last word. Some one inside the
carriage had pulled her back and stifled her cries. Instead of the girl's face
there now appeared at the door the wrathful face of a knight.

"Seize the dog," he shouted. "Do not kill him. I must have him alive."

The men at arms prepared for action at once, but Jean did not stir. He stood
immovable as a statue, staring at the door. The distress which he was powerless
to relieve threatened his own undoing, but he remained as if glued to the spot,
trying to identify the personality of the victim. He had only caught a fleeting
glance of her, but that glance left an impression that could not be effaced. She
was a girl of fifteen or sixteen years, and so radiantly beautiful that even her
expression of poignant suffering and fear could not diminish her charm.

Meanwhile the men at arms were arranging their plan. They evidently intended to
surround and overpower him, but their movements were too slow to suit the knight
in the carriage. "Well," he roared, "what are you waiting for? Seize him!"

The command brought Jean to his senses, and the first glance revealed his
danger. With a quick rush he broke through the circle of his assailants and ran
back into the thicket.

"Follow him, ride him down," furiously cried the knight.

The men at arms rode after him, but before they could overtake him he had
disappeared in the woods, where they could not follow him on horseback. To
dismount and pursue him on foot would have been a rash undertaking, so they
turned about only to receive violent reproaches and curses from their master,
who was forced to resume his journey without his wished-for victim.

Jean did not go far, for he well knew they would not dare to follow him into the
forest. Leaning against a tree, he watched the carriage, which took the road to
Rouen. His first impulse was to follow it and keep it in sight, but, upon second
thought, he remembered he was not at that moment his own master, but was in the
service of another, and that under such circumstances he had no right to risk
his liberty or his life. Accordingly he let the carriage go on several hours
before he resumed his journey.

Making allowance for the precautions he must take, it would be three or four
days before he could reach Rouen. On the way he made several inquiries as to the
whereabouts of the carriage, so that when he entered that city on the evening of
the fourth day, he knew it was there. At the inn where he put up he passed
himself off as a fugitive peasant who desired an interview with the bishop, that
he might tell him of the sufferings of himself and his fellow villagers. As his
story was a probable one, he hoped there would be no opposition to his remaining
there. He was told that the bishop arrived two days before in the company of the
Duke of Luxemburg, and had brought a young novice to the convent of Saint
Ursula. He had gone away again with the Duke, but only for a short time.

Whenever Jean ventured out of the inn, he took his way to the convent. He could
see only its outer walls, and yet he was drawn to it over and over again. Near
the convent stands the church of Saint Ursula. As its doors were always open
there was nothing to prevent him from entering and praying fervently for the
unhappy girl he had seen in the forest. One day he as usual selected a spot
close to the wall between the church and the convent for his devotions. This
wall must have been in frequent use, for there was a door in it opening upon a
passage-way to the other buildings. While Jean was praying the church was empty,
and in the gathering shades of evening the sacred room was quiet and restful. In
the profound silence it seemed to him that he heard human sobs in the distance.
He listened intently. There could be no doubt of it. He was not deceived. The
sound seemed to come out of the wall. He placed his ear against the stone, and
distinctly heard a woman's painful ejaculations between alternate groans and
gentle sobs. A cold sweat stood on his brow. He felt rooted to the spot. The
longer he listened the fiercer grew the storm in his breast. At last he could
endure it no longer. He rushed out into the air. His heart was almost bursting.
"The captive lady!" he cried, "can it be she?"

His despair drew him again to the spot, and again he listened. His pulse beat so
feverishly, and he was under such excitement, that it was impossible for him to
judge calmly, but he fancied he recognized the voice.

During the remainder of his stay in Rouen Jean spent his time almost exclusively
in trying to discover the fate of this unfortunate one, but it was in vain. He
only found that he was drawing attention to himself, and this attention at last
became so apparent that after delivering the letter to the Bishop he was forced
to leave Rouen abruptly and make his way back.


= III --- The Conspiracy

Four leagues distant from Cambray#footnote[A town in the department of Nord,
  France, famous for the manufacture of cambrics, which take their name from
  it.] the towers of Beaurevoir Castle rise from forest-crowned heights. In
selecting this spot the builders combined the useful and the beautiful, for the
castle was famous both for its strength and for its attractive situation. The
view from the upper windows and from the towers repaid the appreciative observer
at any season of the year, but he would have lingered longest in admiration when
park and gardens, wood and meadow, field and grove were decked in the beauty of
early spring, when the thickly clustered villages, east, west, and north, smiled
amid their luxuriant crops, or when on the southern heights the Argonne forest
was clad in its most gorgeous greenery. How much more attractive the beauties of
this spot must have been to a child whose greatest delight was to be among the
flowers of the garden and meadow, the birds in the parks, and the varied
scenery! How closely such a child must have been attached to such a spot! How
strong its temptation to pass all its time with nature!

Just such a child as this had been allured to the park and gardens by the
sunshine of an early April day in the year last named,---a girl blooming with
color, vigorous with health. At a distance she appeared to be about eighteen
years of age, but closer observation showed she could not have been much over
fifteen. Of all the beautiful things in this beautiful scene she was the most
attractive, as she frolicked and skipped about like a fawn, bounding over the
flowery meadows for the first time. As she ran about in the sunshine she gave
expression to her childish joy at each fresh manifestation of the marvellous
work of spring, and broke out in most exultant exclamations when she discovered
the first violets in the grass.

Two ladies slowly following her, and engaged in earnest conversation, were
attracted by her outcries. "There now," said one of them, a somewhat slender
person with angular features and sharp eyes, "you see what an undisciplined
creature she is. Is it proper for her to behave in such a manner? This comes of
letting her have her own way. How often have I protested! But of what use is it?
When you see that your talking is of no avail it is best to hold your tongue. If
you do not, then they say, 'Oh, yes, that's the way envious old spinsters always
talk.'"

The other lady, whose handsome face, beaming with good nature, was in striking
contrast with that of her companion, cast an appealing glance at her. "Oh, dear
Rosette, are you not mistaken? Who would dare to insult my husband's sister by
making such a remark?"

"Oh, well, you know people often think many things they do not say."

"That is true. But even if they do, why should you conclude they are thinking
things about you they do not venture to say?"

"I cannot give you any precise reason."

"Then I must tell you it is not kind to think evil of others, especially of your
own friends, unless you have sufficient cause to do so. But never mind. You were
speaking of Marie. You are offended with the behavior of the poor child."

"Child! A fine child she is,---ha! ha! You ought to have known some time ago
that she is no longer a child. She is a grown-up girl."

"Let us hope she may not discover it for a long time yet. How happy she would be
if she could always preserve her childlike nature! Look at her, dear Rosette! Is
it not a beautiful sight---such an innocent child, sporting in pure delight?"

The sister-in-law turned up her nose.

"But why is not her behavior proper?" continued the other. "Proper! What is
proper? Are not many things proper which are called highly improper? Marie is in
her own world here. She has grown up in it, is attached to it, and enjoys
herself in it. You cannot imagine how delighted I am to see her thus. Poor
little one! Orphaned at an early age, she has never known the comfort of a
father's or mother's embraces, and shall I begrudge her her harmless pleasures?"

"It would be much better if she were to begin leading a more quiet and serious
life right away, in preparation for her future."

"What has the future in store for her?"

"Is she not intended for the convent?"

"Who says so? She is sole heir of Louis of Chafleur, who has left her a rich
property. Why should she take the veil?"

"She will not take it voluntarily. I think it is the wish of your husband."

"I think you are mistaken. At least, I do not know of any such plan. John simply
said that a convent would be the safest retreat for Marie in case the tumult of
war should invade the Argonne forest. To seek the shelter of a convent and to
take the veil are two different things."

Rosette's eyes glistened with malicious triumph as she looked at Marie, who at
that instant came bounding forward with a bunch of violets and put an end to the
conversation; her look seemed to say, "I know some things better than you."

While this was going on in the park, two men were standing at an upper window of
the castle. They were considerably beyond middle age, and resembled one another
in a certain cold, crafty, calculating expression of countenance. One of them
wore the usual costume of a knight, the other the conventional dress of a high
church dignitary. One was John of Luxemburg, lord of the castle; the other,
Pierre Cauchon, Bishop of Beauvais.

"The girl is really a handsome child," said the Bishop, as he looked at Marie.

"Oh, yes," slowly assented the lord of the castle. "But," he added with a
peculiar twinkle of the eye, "I know something that is more beautiful."

The prelate understood. "Hm! I won't dispute that. These are fine possessions.
It would be a pity to have them pass into the hands of strangers."

"You have echoed my very thought, your reverence. So I think we are agreed on
the general point."

"You mean that in these times of disturbance there is no place where Marie will
be so secure as in the cell of a convent."

"Exactly, and unless I am mistaken that is also what you mean."

"In a general sense, yes; but we have not yet considered the most important
point."

"Let us come to it."

"The question arises, How is the girl to be secured for the convent? and next,
How is she to be taken there?"

"I will see that she is taken there. As to the rest of the business, I appeal to
the experience of your reverence."

"Hm! a difficult task when, as in this case, the novice has the utmost aversion
to a convent."

"It is not so difficult as appears at first sight. I know of similar cases where
the task has been successfully accomplished."

"Yes, but under peculiar circumstances."

"The circumstances in our case are similar."

The Bishop's face wore a crafty expression. "That is truly quite another thing.
Let us hear about it."

"Of course Marie's property remains in possession of her guardian until she
reaches legal age, when it is at her disposal."

"That is clear. But what will the Church get?"

"Patience, your reverence. If she should not reach that age---and that is not
impossible---"

"Well?"

"I understand that in such a case the property is legally mine."

"That is also clear. But what will the Church get?"

"In that case we can make an agreement as to how much the Church shall have."

"We understand each other, noble knight. But supposing she reaches legal age?"

"Then the Church must see to it that the legal requirements are not binding. I
say 'legal requirements.' You understand me, holy father?"

"Perfectly, my noble friend. Sometimes we have had to grant exemptions from
requirements which afterwards were shown to have been void because of
irregularities."

"I am glad we understand each other so well."

"Yes, but what will the Church get?"

"The same as in the other case, namely, a share of the property, only the Church
will not come into actual possession until after the death of the testatrix."

"Hm! It seems to me, my noble friend, that you not only propose to take the
lion's share, but the entire prize. The Church would have the first claim in
case of death."

"You haven't let me finish, your reverence. Until the death of the heir I will
secure you, as the representative of the Church, a yearly income of three
hundred pounds."

The Bishop's eyes glistened. "And the security?" he said, stretching out his
hand.

"My word, the word of a nobleman;" and they shook hands.

A pause ensued. Each of the men, in the stillness, seemed to be studying whether
he might not find eventually that he had been overreached and had not received
his proper share. The Bishop was the first to come to a decision, and asked,
"When shall we begin our work, noble friend?"

"At once, if you are ready." Thereupon he rang a bell, and ordered the servant
who answered it to call Mademoiselle de Chafleur.

It was not long before Marie came running into the room, full of joyous
exultation. "Dear uncle, see these beautiful violets," she cried. "Oh, what
delicious perfume!"

#framed-image("images/p00b.jpg", ["Dear uncle, see these beautiful violets," she
  cried.])

"Very beautiful indeed. They are messengers sent by Spring to the other
flowers."

"It must be so. Oh, you cannot imagine how beautiful the park is already! Tell
me quickly what I am to do, so that I can return soon."

"So you find it very pleasant in the park?"

"Oh, I could stay there always."

"I am all the more sorry, then, that you will have to leave it soon."

"What! Leave! Uncle, I do not understand you."

"Yes, child. The tumult of war approaches nearer and nearer."

"What of that? Is not the castle safe? Let the Englishmen come. We will send
those long-nosed gentlemen home again. Yes, 'we,' I say, for you know I am a
Chafleur."

"I have the highest respect for your courage, my little Amazon, but the English
will not be greatly scared by it. No, child, I must find a safer place for you."

"And my aunts?"

"Oh, that is a different matter. My wife and sister must submit to the
inevitable."

"And I can also."

"No, child. Your father sacredly intrusted you to me. I should not be keeping my
word if I exposed you to the dangers of war."

"But I say again, uncle, and you have said yourself, that the castle is safe
enough."

"Still it can be taken; but no enemy will dare to attack the sacred walls of a
convent."

"A convent! What do you mean? Do you intend to make me a nun? Me! A nun! Ha! ha!
ha! I shall die a-laughing."

"It is not always nuns who find shelter in a convent."

"Nevertheless, uncle, and once for all, I say I will have nothing to do with a
convent."

"Then tell me what you will do, for you cannot stay here."

"Are you in earnest, uncle?"

"Absolutely so."

The tears came to the girl's eyes. Sobbing, and throwing her arms around his
neck, she exclaimed: "Uncle, you cannot send me away from you."

"It is for your safety, my child."

"But I do not wish any special safety. Where my aunts can stay, I can stay."

"It is of no use. No use. My decision is final."

The girl stood erect. She wiped the tears from her eyes and looked at the knight
with a strange and distressed expression. Gradually her look became colder and
more fixed, and at last he realized her undaunted determination.

"My decision is made too, uncle. I will not go to a convent. I would rather fall
into the hands of the English. But the situation is not so desperate as that. I
will let my kinsman La Hire know. He will protect me. Let me have a messenger,
uncle. In an hour I will have a letter ready." Thereupon she left the room.

"Well, what do you think now, noble knight?" began the Bishop.

"Pah!" he replied, "I will send her a messenger who will throw her letter into
the first forest brook he comes to, and return without seeing La Hire."

On the morning of the fourteenth day after this scene, a heavy travelling
carriage stood in the castle yard with an escort of six armed men. Marie lay
sobbing in the arms of Madame de Luxemburg. Still sobbing, she at last followed
the impatient lord of the castle to the carriage. Nothing had been heard from La
Hire, and when, as John of Luxemburg had said, an attack upon the castle was
likely to be made, he told Marie he would accompany her to her kinsman. At the
first inn they met the Bishop of Beauvais, apparently by accident. As he was
journeying in the same direction he accepted the knight's invitation to take a
seat in the carriage.

Overcome with grief, and not expecting any trickery, Marie at first did not
notice the road they were taking. After passing three or four inns, however, she
saw that they were going west instead of south. Not even then did she suspect
treachery. They easily satisfied her inquiries by pretending they must take a
circuitous route to avoid encountering the English. When, however, they kept on
in the same direction the next day, her suspicions were fully aroused.

"Uncle," she said, "you cannot deceive me any longer; you are not taking me to
Chinon. What are you going to do with me?"

"I will not deceive you, child," replied the knight, for pretense was useless
any longer. "I cannot carry out my plan to take you to Chinon. The whole
district of the Loire is in the hands of the English. I cannot even get back to
Beaurevoir, so nothing remains but---"

"But what?" she piteously exclaimed.

"The convent."

She uttered a scream of terror.

"Be quiet," said the knight, harshly. "If you scream again I will silence you in
a way that may not be agreeable."

They were in a forest where fugitive peasants might be in hiding. Even at a
distance from it, he had been fearful lest the girl might attract some one's
attention. He wished to reach his destination without being observed, and was
particularly anxious no one should even suspect where he was or what he was
doing.

Marie was not frightened by his threat, but a quick glance showed her they were
in a forest where no help of any kind could be expected. In despair she sank
back into a corner of the carriage. Anger, desperation, and scorn raged by turns
in her breast, until at last, overcome by exhaustion, she buried her face in her
hands and wept.

The vigorous "halt" of a manly voice aroused her from her wretched condition. In
an instant she was at the carriage door. Her first glance fell upon a handsome
youth who was advancing courageously toward the carriage. The reader knows who
he was.

"Help! help!" she involuntarily cried. "They are taking me to a convent."

Her guardian pulled her back, and silenced her cries by holding his handkerchief
over her mouth. She tried desperately to release herself,---but what availed her
weakness against the strength of a trained knight? In her anguish the image of
the brave youth rose before her, and her anxiety about his fate made her forget
her own. She listened intently to all that was going on outside. She trembled
when it seemed impossible for her to escape, but at last she exulted when she
knew that he was safe.

It was late at night when the carriage came to a stop. Marie knew by the call of
a watchman that they were either before a city or a castle. The Bishop gave his
name, and the creaking gate opened. The carriage passed through several dark
streets, and stopped at last before a large, gloomy building. Here also the
Bishop's name was an Open Sesame; the heavy bolts were pushed back, the carriage
rolled over a paved yard, and with a hollow, fateful sound the gate was closed
and locked.

Marie shook as in an ague fit. She realized that she was a prisoner, and perhaps
was cut off from all the pleasures of life; but not a sound escaped her lips.
Her mute sorrow alone reproached her persecutors. She did not know she was in
the Ursuline Convent at Rouen, but she had no doubt it was some convent in the
Bishop's diocese. Evidently they were ready to receive an exalted guest, whom
they had expected, in a manner befitting her station. The abbess, a lady of
middle age, who, judging by her speech and manners, might have been of high
rank, was awaiting her in the parlor. After the Bishop had exchanged a few words
with her, the abbess turned to Marie and said: "May your entrance among us be
blest, Mademoiselle de Chafleur. I hope these sacred walls will furnish you both
the outward security which you need, and your heart that peace which the world
cannot give."

There was something so cordial, and withal so winning, in the tone with which
she spoke these words, that Marie pressed her extended hand to her lips with the
utmost sincerity, and covered it with kisses. She longed to throw herself into
the arms of this gracious lady, and weep away her sorrow as she would on a
mother's breast. Her longing was so overpowering that she sank upon her knees
and moistened the abbess's hand with her tears.

"Save me, gracious lady, save me," she implored. "I am the victim of a
conspiracy. They have deceived me, brought me here by force, and torn me from
all that is dear and sacred to me."

The astonished abbess cast an inquiring glance at the Bishop. "The novice," he
said in reply to it, "is here because it is the wish of her guardian, a lord of
Luxemburg, who alone has authority to act for her. Therefore it is idle to talk
of force. To your---"

"I am not a novice," cried Marie, rising. "I am Marie of Chafleur. My guardian
has control of my property, but he has no right arbitrarily to dispose of my
person."

"I trust your ability," resumed the Bishop, "to remove these worldly ideas,
which are unbecoming within these sacred walls, and to implant in this perverse
soul the spirit of quiet resignation and Christian humility. I authorize you to
employ all the means which are at your command to produce this result, and I
have no doubt of their efficacy."

The last words were spoken with a peculiar intonation which was in the nature of
a command to the abbess, but of the significance of which the poor child had not
the most remote idea. The abbess, who understood well enough what was expected
from her, made a quiet sign of assent, and the two men took their leave, firmly
convinced that their work was completed successfully.

Marie was assigned to the usual cell and left alone. She first went to the
grated window. It looked out only upon the yard. With a pitiful sob she threw
herself upon the hard couch. Her tears flowed, and she gave vent to her anguish
in melancholy ejaculations. At last she knelt before the crucifix and poured out
her aching heart in long and fervent prayer. Again she quietly sought her couch.
She was now able to think calmly over recent events. As she was ignorant of what
was in store for her, she was still buoyant with the hopefulness of youth. She
thought of La Hire, whom she had known as an honorable knight. The image of the
young man also mingled pleasantly in her thoughts of the future. She decided she
would write again to La Hire. He could not have deserted her. Thus consoling
herself, she sank into kindly slumber. Poor child! Little she knew that her
letters could not find their way into the outside world without first being read
by the superior.

One day two nuns, commissioned to acquaint her with the rules of the Ursuline
order, visited her. Her declaration that she did not wish to know them made no
impression upon the sisters. They performed their duty, and then withdrew to
make their report. Shortly afterwards another sister entered, and summoned the
novice to prepare herself by prayer and fasting for the vow which she was
shortly to take.

"What means this farce?" said Marie. "I am not a novice. I will not join your
order. I will not take a vow."

"Our wishes are useless within these walls," replied the sister. "We must do
what the superior, the abbess, and the rules of the order command."

"What is that to me? I am not one of you."

"You will do well, sister, to submit to the inevitable."

"And what if I do not?"

"Then they will force you to submit."

"Force me, Marie of Chafleur! I should like to hear how they propose to do it."

"I can tell you, sister. They will lock you in your cell and let you go half
starved."

"Well, I would rather wholly starve than take the vow."

"They will thrust you into a gloomy prison."

"Go on."

"They will come daily to your prison and punish you without mercy."

Marie shrieked aloud. She clenched her fists. Her lips quivered. "Woman," she at
last exclaimed, "the devil has sent you to tempt me! Leave me. Go and report
that I will suffer death rather than consent."

"I must first do what I have been ordered, sister." Thereupon the nun knelt
before the crucifix and repeated aloud the prayers which were prescribed as a
preparation for the vow. When she had finished she withdrew. What she had said
came to pass. Marie first was locked in her cell and given only a scanty bit of
bread. When that proved of no avail she was put into the prison. It was her loud
laments which Jean had heard while praying in the church of Saint Ursula, for
the prison was only separated from the church by a single wall.

= IV --- In Camp and Court

News of the siege of the City of Orleans by the English at last reached the
village of Domremy. No one was more deeply affected by it than Joan, for she
believed from what her confessor had told the villagers that with the fall of
Orleans the King's cause would be lost, that there was no hope for the raising
of the siege, and that the wretchedness of the fatherland would then be
complete.

Scarcely had Joan heard the news before she left the village to meditate upon
this new situation in some one of her favorite solitudes. She was at this time
about seventeen years of age, blooming and beautiful in person, but unchanged in
nature and habits. She longed to abandon herself to her thoughts and impressions
in solitude as she used to do when tending her father's flocks. Deep down in her
heart she felt the sorrows of others now as she did then, and was moved by the
same irresistible desire to help them. She longed to prostrate herself before
her saints, to look into the clouds with supernatural vision and see their
figures and hear their voices as she used to do. Her communion with the
spiritual world at this time had become so intimate that she could question her
saints and hear their instant replies. The Fairy Tree, under which she fed the
birds, the miraculous spring where the fawns frisked about her, and the chapel
at the cross-road near the oak forest, in which she had most of her visions,
were her favorite resorts. In this chapel she knelt before the image of Saint
Catherine, unconscious of the outside world. The burden of her fervent prayer
was the necessities of the country, the rescue of the City of Orleans, and the
coronation of the King.

"O that I were a man! O that I were a commander!" she sighed. "I would rush to
the rescue. Perhaps it is not impossible. Does not the wolf fly from me when my
saints are near? Can I not hide my maiden's figure in the garb of the soldier?
Are not these limbs strong enough to wear armor? What if the dear saints should
commission me to rescue the fatherland!"

Absorbed in such thoughts and longings, she lost herself in communion with the
celestial world, and in a vision she saw her favorite saints in the glowing
clouds.

"Why do you tarry, Joan?" said the voices. "Cities and villages are being
destroyed every day. Daily the blood of the people is being shed. Arise! Execute
the decree of Heaven."

"But," said Joan, "how may I know it is Heaven which sends me?"

"The signs of your mission will not fail."

"And what is my mission?"

"To raise the siege of the city of Orleans, and conduct the King to his
coronation at Rheims."

"How shall I begin?"

"Go to the King and offer yourself to him as commander of the army."

"To whom shall I apply so that I may reach the King?"

"Go to the knight, Robert of Baudricourt.#footnote[Robert of Baudricourt was the
  governor of Vaucouleurs.] He will help you."

Joan returned home, and remained several days deeply absorbed in contemplating
the mission to which she had been assigned. She would often steal away to her
little chamber and weep bitterly; for although she felt exalted by the heavenly
decree, still, it seemed impossible for her secretly to leave all the dear ones
at home,---father, mother, brothers, and sister. And yet she must go secretly,
for her father never would approve of her purpose or consent to her going, and
no other way suggested itself. They had grown so accustomed to seeing her
absorbed in silent and solitary meditations that they kept aloof from her at
such times. It had been village gossip for years that she communicated with
spirits and practised magic. In what other way indeed could her mastery of the
wild beasts be explained? Her brother Pierre, however, who was devotedly
attached to her, was an exception. He never pained her by suspicions. She had no
secrets from him, and she came to him now in perfect confidence and wept upon
his breast.

"It is not true, Pierre," she said, looking up at him with her beautiful tearful
eyes, "that you mock at me as the others do?"

"How can you think such a thing of me, little sister?"

"Oh, I do not think it, my brother."

"And yet your question seems to imply that you do."

"Not at all, Pierre. I know very well that you love me, but you must tell me so
over and over again. I know very well you do not mock me, but even that does not
satisfy me. I must have the assurance from your own lips."

"I know very well, Joan, that you are a favorite with your saints, that they
manifest themselves to you in the clouds, and that you talk with them as you
talk with us."

"Yes; you believe me when I tell you these things. But when I tell the
others---"

"Oh, my sister, they do not know you as I do. I know that you never speak an
untruth."

"And yet my actions now must be deceitful. Alas! Pierre, that is what distresses
me."

"But remember, little sister, that you are obeying the celestial ones, that it
is the fatherland which calls you."

"And still it grieves me, my brother. I go about here just as usual. Father,
mother, and all the others think that I shall always go on this way, and I let
them think so, and purposely strengthen this belief while I am preparing to
leave them secretly. Oh, Pierre, they will never forgive me."

"Why should you distress yourself with such thoughts, my sister? You know that
you must undertake this mission. And it is right you should, for the will of
Heaven is superior to the human will. When father and mother and the others hear
what Heaven has accomplished through you, do you not think they will forgive
you?"

"Your words have done me good, my brother," cried Joan, her clear, brilliant
eyes shining with happiness. "Would that I could always have you by my side and
hear your voice! If you were near I would fear no one whom I may encounter."

"I will go with you, my sister."

"No, Pierre, you cannot."

"And why not?"

"Is it not enough for me to bring sorrow to our parents? Would you add to that
sorrow by secretly going away also?"

"You are right. I ought not to go. You are obeying the decree of Heaven, but I
cannot offer that plea. But I know of some one who might go with you."

"Who?"

"Uncle Laxart. He also loves you, and he will not have to ask permission of any
one."

"But will he go?"

"I will speak to him about it."

The next day (in the year 1429)---it was the day of the Three Holy Kings---Joan
crossed the snow-covered valley to the Fairy Tree, sprinkled crumbs for the
birds as usual, and listened to their grateful songs. Soon afterwards she was
lost in deep reverie in the chapel at the cross-roads, and while in this state
her enraptured eyes beheld her saints, Catherine and Margaret, in the clouds.

"The hour has come, Joan," she heard them say. "Arise! the Queen of Heaven will
be with you."

"But I must go all alone," she replied. "They will call me an adventuress."

"Not so! Your protector is already at the door."

As Joan arose she saw a man approaching the chapel. With joyous surprise she
recognized her uncle, Duram Laxart.

"I know all, Joan," he exclaimed. "I am ready to escort you as soon as you need
my protection. I have already been to Vaucouleurs and have seen the knight
Baudricourt. Start as soon as you can get ready. We will lodge with Wagner, whom
you know."

Before the astonished maiden could reply her uncle was off in the direction of
Vaucouleurs.

The time for departure had come at last. Deeply agitated, she stood at the door
of the chapel, and looked once more with tearful eyes out over the valley. Once
more her gaze lingered upon the miraculous spring, the Fairy Tree, and her home
at Domremy, and her soul was filled with tender and sacred associations.

"Farewell, O Wonder Tree, where I have spent so many happy hours," she said
between her sobs. "And you, little birds, farewell! Alas! Joan can never feed
you again. In vain will you wait for her. Farewell, dear spring, whose music I
have heard so often in my happy dreams. Tell the deer I cannot play with them
again. Farewell, loved valleys and fields! How happy I was when I played here
with the companions of my childhood! Alas! I shall never see you again!
Farewell, my father! My beloved mother, farewell! And you, my Pierre, my good,
dear brother. Oh, how hard it is to leave you! Alas! never again shall I look
into your true eyes, never again hear words of love and sympathy from your lips.
Farewell all, all farewell! Grieve not that I leave you. Be not angry. It cannot
be otherwise. No! it must be so, for Heaven has decreed it, and the fatherland
has called me. Away, Joan, away! The struggle is at hand."

No one could have seen the simple peasant maiden at that moment, her eyes
shining as the tears glistened on their lashes, no one could have realized her
strength of will in giving up all that had filled her soul with sorrow as she
thought of leaving it, no one could have watched her passing down the valley
like a soldier defiant of danger, without the conviction that it was an event
fraught with the highest significance for France.

Joan found her uncle at Wagner's house in Vaucouleurs. He had already called
upon Baudricourt, but was sent away with instructions to reprove his silly niece
and take her back to her parents. Though not in the least discouraged, Joan
spent the night in prayer, and in the morning went to see Baudricourt. She found
him in the company of Jean de Nouillemport de Metz. Both laughed when they
learned the nature of her errand, but she spoke with such sincere conviction of
her celestial visions that Baudricourt at last dismissed her with a promise to
give the matter serious consideration. Subsequently, when Joan prayed in the
church, and the people came in crowds to see "the saint," a priest approached
her with a crucifix to see if she was possessed of the devil. Joan fell upon her
knees and kissed the holy symbol, and the priest declared, "She may be mad but
she is not possessed." On her way out of the church she met the knight
Nouillemport de Metz, to whom she thus appealed: "Alas! No one will believe me,
and yet France can be saved only by me." The words reminded him of the prophecy
of Merlin. After observing her more closely, and recognizing her spiritual
purity and her resolute determination of purpose, he expressed his willingness
to take her to the Dauphin, and he had little difficulty in persuading
Baudricourt to join him. A few days afterwards Joan was delighted to find
herself on the way to Chinon with the knights and their men at arms. In her
costume she looked like a slim, handsome page rather than a trooper. Chinon was
more than one hundred and fifty leagues away, and for half that distance the
country was occupied by the English. Hence they were obliged to make wide
circuits, and frequently halt in the forests and ford rivers. After a fourteen
days' march they reached the city of Gien#footnote[Gien is in the department of
  Loiret, and thirty-eight miles in a direct line from Orleans. Its principal
  industry is the manufacture of faience.] on the Loire. The news spread like
wildfire that the Maiden who, according to Merlin's prophecy, was to rescue
France, had come, and all hastened to extend her an enthusiastic welcome.

After leaving Gien there was little danger, and at last they safely reached
Chinon and put up at an inn. Here, as at Gien, the news of Joan's arrival spread
rapidly, and attracted a great crowd. To satisfy the universal curiosity, she
appeared on the balcony and was welcomed with enthusiastic shouts. Her knightly
companions promptly waited upon the Dauphin; but they found him greatly
discouraged and in a despondent mood because of the news that the Englishman,
John Falstaff, had repulsed the French, who tried to prevent him from taking
supplies of herring to his countrymen before Orleans. The Dauphin's
disappointment over the "herrings day" defeat, however, would have been
short-lived had he not at the same time been overtaken by a calamity which
seemed to him even worse, namely, his utter lack of money and the consequent
emptiness of his kitchen and cellar. In such a mood Joan's companions found him.
At first he listened to them with indifference and a contemptuous smile, but
when they told him the people had recognized the Maiden as a saint, and welcomed
her as the rescuer of France, it occurred to him she might be instrumental in
relieving his necessitous condition. At last he ordered that she should be
admitted. To test the prophetic gift ascribed to her, he received her standing
among the nobles of his court, while another person sat on the throne.

Joan recognized him at once, however, and advancing to him, knelt, and greeted
him with these words: "God grant you a long and happy life,
Dauphin."#footnote[Joan called him "Dauphin" because she did not consider him a
  king until he was crowned.]

"You are mistaken," he replied. "Yonder is the King," pointing to the person on
the throne.

"Noble prince," she answered, "you cannot deceive me. You are the Dauphin." A
murmur of astonishment ran through the hall.

"Sire," she continued, "if we can be alone I will tell you something that will
remove all doubt as to my mission."#footnote[The doubt which was thrown upon the
  King's legitimacy greatly weighed upon his spirits. This doubt Joan removed.
  Her words to him are thus reported: "On the part of my Lord, I tell thee thou
  art true heir of France and son of the King, and he sends me to lead thee to
  Rheims to the end thou may'st receive thy crown and thy coronation if thou
  wilt."]

The Dauphin conducted her to the adjacent oratory, and there, according to the
tradition, she revealed things to him which he was certain none could know but
God and himself. He was so sure of this that at the close of the interview he
exclaimed: "I am convinced of your divine commission, but my councillors must
also be convinced."

"Very well, sire," she replied. "Summon the three most learned and experienced
to meet me in the morning, and I will give them a sign." Her wish was gratified.
The three selected were the Archbishop of Rheims, Charles of Bourbon, and De la
Tremouille, the King's minister. They first required her to give her history,
and then they asked for the sign. Joan went back to the oratory. Then, according
to tradition, the heavenly ones appeared, and with them an angel in long white
raiment. The latter carried a brilliant crown and slowly advanced into the
audience-room.

"Sire," said the angel, "trust this maiden whom Heaven sends to you. Give her at
once as many soldiers as you can raise. As a sign that you shall be crowned at
Rheims, Heaven sends you this token." Thereupon the angel handed the crown to
the Archbishop, went out as he had entered, and disappeared through the ceiling
of the oratory. So says the tradition.

The three councillors were not yet fully satisfied, however. They suggested that
Joan should be examined by the learned theologians of the University of
Poitiers.#footnote[Poitiers is the capital of the department of Vienne, and is
  famous not alone for its university, but for its cathedral and the Temple de
  St.~Jean, the oldest Christian structure in France.] When they also asked her
for a sign, she replied: "Give me soldiers and you shall have signs enough."
They finally reported that she was trustworthy, and that the King ought to
accept her service. The Dauphin's council promptly decided to raise as many
troops as possible, place the Maiden in command of them, and send her with a
convoy of supplies to Orleans. In these few days popular sentiment had changed
rapidly, cheerful self-sacrifice and enthusiastic eagerness for action took the
place of discouragement and dissension. Knights and their men at arms offered
their services, and wealthy burghers sacrificed their treasures for the cause of
the country. The Dauphin at last was also in a cheerful frame of mind, for his
treasury was filling up and he could once more take some pleasure in living. He
was also in a position now to be of service to the Maiden. He presented her with
a general's outfit,---a master of horse, two pages, two heralds, and a chaplain.

About this time the Duc d'Alençon#footnote[The Duke d'Alençon was a relative of
  the King, and had been held prisoner by the English for three years. He was
  released upon the promise of a heavy ransom.] returned from English captivity.
He noticed with great delight that every one was eager to follow the Maiden into
battle. He immediately mortgaged his property, purchased war equipment, and
accepted the duty of preparing the convoy of supplies. Joan met with an
affectionate welcome from his wife, who had come to Blois, where the
preparations were going on.

The twenty-sixth of April, 1429, was fixed as the day of departure. Joan had
previously sent her herald Guienne with a letter to the Duke of
Bedford#footnote[The Duke of Bedford, an English general and statesman, was John
  Plantagenet, third son of Henry IV, and at this time regent of France. He was
  conspicuous in the prosecution of Joan of Arc.], which she had dictated to her
chaplain. It ran thus:

This letter, however, never was answered. The herald did not come back.

On the day appointed the expedition set out from Blois. At its head was a
procession of priests singing hymns, Joan's chaplain leading them with his
banner. Next followed the leaders, Duc d'Alençon, Marshal de Retz, Admiral de
Coulent, De la Maison, Laval, Potou de Saintrailles, Count Dunois and La Hire,
in whose retinue was Jean Renault. Then came two hundred horsemen, and a long
train of wagons loaded with supplies brought up the rear. Joan in full armor,
wearing a shining helmet which covered her closely cropped locks, and carrying a
sword whose hilt and scabbard were ornamented with lilies, rode among the
leaders. Upon one side of her banner, which was thickly sprinkled with lilies,
was a picture of the Saviour with the orb in His hand and an angel on either
side of Him; on the other, the inscription, "Jesus, Maria."#footnote[Joan of
  Arc, testifying at her trial, said: "I had a banner of which the field was
  sprinkled with lilies; the world was painted there, with an angel at each
  side; it was white, of the white cloth called bocasine; there was written
  above, I believe, ''; it was fringed with silk. Because the Voices had said to
  me, 'Take the standard in the name of the King of Heaven,' I had this figure
  of God and of two angels done. I did all by their command."] Her demeanor was
serious and dignified, serene confidence shone in her beaming eyes. Her only
regrets were the profanity of the soldiers and La Hire's loud prayer every
morning and evening: "Dear God! do for La Hire as he would do for Thee if he
were the dear God and Thou wert La Hire."

On the third day they were before Orleans, but the city was on the other side of
the Loire, and there was no bridge. They occupied a redoubt on their side of the
river, which the English had abandoned because it was of no use to them. At this
juncture the Bastard of Orleans,#footnote[Count Jean Dunois, called the "Bastard
  of Orleans," was born in 1402, and died in 1468. He was the natural son of
  Louis, Duke of Orleans, and Mariette d'Enghien, and at this time was in
  command at Orleans.] commander of the city, came in a barge to meet them. By
his advice they went two leagues farther up the river and made a halt near
Castle Chécy, where they found a French garrison. Count Dunois agreed to send a
fleet for the transportation of the supplies, but at three in the afternoon it
had not come. The sky was overcast, thunder growled in the distance, and the
waves of the Loire were lashed by fierce winds. The courage of the soldiers
began to waver.

"When this storm subsides," said the Duc d'Alençon, "the English vessels will be
here instead of ours, and then all will be lost."

"Ah, you forget," said the Maiden, "that I promised you in the name of God we
should enter Orleans successfully."

"H'm! it does not look as if you could keep your promise," replied the Duke.

"Have a little patience," said Joan, as she closely scanned the sky. "Before a
quarter of an hour passes the wind will change." She retired a little distance
to pray, but hardly had she knelt before a favoring wind sprung up and the
vessels which had been detained by the storm arrived.

"Now what do you think of that, Jean?" said La Hire, as they began loading the
supplies.

"I think, noble sir," replied the youth, "that the Maiden in her pastoral life
has had ample opportunity to observe the wind and weather, and is therefore able
to predict changes like these."

"Oho! Then she is an impostor!"

"Why so, noble sir?"

"Do you not understand? Does she not make people believe that the winds change
in answer to her prayers?"

"Oh no, certainly not. She does not pray on account of the wind. She prays
because prayer is a necessity to her, because of the impelling forces of her
nature, and because she feels happy in communing with Heaven. Her special prayer
is for strength and help from on high for her great work, which is beginning
this very hour."

"H'm! But she deceives the multitude by it, just the same."

"She does only what she must do. Does the sun lave itself every evening in the
sea just because the people believe it does?"

"I am not criticising you, my young friend, but one minute you deny the
supernatural in the manifestations of the Maiden, and in the next you extol her
to the very skies."

"What are wonders anyway, noble sir? What the blind multitude regards as a
wonder easily resolves itself into harmony with nature to the reflective person,
and what the multitude passes by without observing at all is a wonder to the
intelligent thinker."

"Explain yourself more clearly."

"As to the first point, the Maiden herself is a sufficient illustration. Do not
these people recognize a wonder in this change of wind, while you see nothing at
all extraordinary in it? As to the other point there are a thousand
illustrations. The sky with its stars, the flowers of the field, the worm in the
dust,---all these are wonders of creation which the multitude scarcely notices,
but which are marvellous to the observant thinker."

"And this Maiden?"

"She is a wonder in both ways, and therein lies her extraordinary power. She is
believed to be a prophetess who has direct communication with Heaven. The people
regard her as an actually divine wonder, because of her purity of heart, her
celestial confidence, her unsullied patriotism, and her spiritual illumination.
Indeed, noble sir, the Maiden is a wonderful gift of Heaven to stricken France."

"Then you also believe in her success apart from her divine commission?"

"I do not dispute her divine commission. She is executing it because the divine
voice in her own heart has charged her with that duty. Do I believe in her
success? Look at these people! How their eyes are fixed upon this Maiden! At her
command of 'forward' they would plunge into the Loire and follow her, believing
that its waters would bear them up. Will you not yourself, noble sir, although
you do not believe in her divine commission, gladly draw your sword when the
lily banner waves before you? If the spirit which Joan has roused in our little
band is animating all France, how can we do otherwise than expect success?"

"You are right, my young friend," said La Hire, extending his hand. "I thank
your gallant father in his grave for the training he gave you. Yes, yes, it must
be so,---when religious or political enthusiasms fire a people, great results
always follow. In this case it is a joint enthusiasm. The victory will be ours,
and we shall thank the Maiden for it. I will not again grieve her with my
prayers. When it is prayer time I will go so far off that she cannot hear me.
But one thing more, Jean. Have you heard anything about Marie?"

"Alas! noble sir, I have not. As you well know, I have not ceased making
inquiries, but as in your case, the turmoil of war has prevented me from
obtaining personal information."

"Yes, yes, I know. I cannot tell you how that poor child's situation troubles
me. I have waited from week to week for an opportunity to speak a few words to
this lord of Luxemburg and his bishop"---and his grip of his sword indicated
what kind of words he had in mind. "But let us hope," he resumed, "that the
Maiden whom we serve may open the way to Marie's release. First, we must send
the English to the devil. After that nothing shall prevent me from finding
Marie, and"---casting a significant glance at Jean---"I know who will stand by
me."

"To the end of the world, noble sir," cried the youth, his flashing eyes showing
that the words came from his heart.

"Good, good, I am sure of it; but it is time that we were off." He pointed to
the last of the vessels, which was held for the troops. Soon they came to the
line of the English intrenchments, which stretched around the city.

"Well," growled La Hire, "these English gentlemen do not like to show
themselves, and yet it would be an easy matter to break these nutshells. I
wonder if they have run away."

"They are there, and can see us," said Jean. "They are lying behind the walls,
but they have no ordnance to use against us."

It turned out as Jean said. The English made no assault, and the little flotilla
reached the city unharmed. There was unbounded enthusiasm when the Maiden
appeared with her banner at the gates. The people would have carried her in
their arms had not the commander of the city forestalled them by having a horse
in readiness for her. She mounted and rode in triumph to the cathedral, where a
#emph[Te Deum] was sung, the first which had been heard for a long time within
its walls. Then she was escorted to the house of Jacques Boucher, treasurer of
the Duke of Orleans, where she was to lodge. Now for the first time she put off
her armor, drank a cup of wine diluted with water, and then withdrew with the
wife and daughters of her host to her chamber. There was lively commotion in the
streets until far into the night. All anxiety disappeared on that 29th of
April, 1429. An old chronicle relates that the people and the soldiers believed
an angel had come down from heaven to them. To the same extent that their
despair had vanished and given place to joyous enthusiasm, courage waned in the
English camp. Most of those brave soldiers, particularly the spearsmen and
archers, believed the Maiden was either a messenger from heaven or from hell,
either a saint or a mighty magician. Their leaders inveighed bitterly against
the Dauphin because he employed unknightly weapons, weapons of hell.

On the next day Joan urged an immediate attack, but at a council of the most
experienced leaders it was decided to wait at least for the arrival of the next
contingent of troops from Blois. They did not altogether believe in Joan's
divine commission, but they thought it best to take advantage of the popular
enthusiasm which she had aroused. Count Dunois returned to Blois to hasten
reinforcements forward, and on the fourth day his banner was seen on the left
bank of the Loire. His route led directly past the English encampment. Joan
could no longer remain inactive. "We must go out and meet them and fetch them
in," she cried, at the same time mounting her steed, seizing her little
battle-axe and banner, and riding to the gate. The knights shook their heads. No
one was eager to rush directly into the jaws of the lion, for it did not seem
possible that any one would come back if the English came out and attacked them.

"Now," shouted La Hire, "no one shall say that La Hire has been outdone in
courage by a woman. Forward," he commanded, galloping after the Maiden, and
followed by his little band. Count Dunois had halted some distance away,
evidently awaiting help from the city. As soon as he saw the banners of the
Maiden and La Hire he moved forward along the first line of intrenchments. The
two forces soon met and advanced towards the city along the very front of the
English camp, but such was the Englishmen's fear of the Maiden that not one of
them ventured out. No one even hurled a missile. They looked on quietly, as the
little band passed their lines and safely reached the city. As further
reinforcements were on their way, it was decided on the following day to attack
Fort Saint Loup.

Early in the morning, while Joan, wearied by her exertions on the day before,
was still sleeping, some of the captains sallied out with their troops and made
a furious assault upon the fort. The English, seeing only their customary
assailants, fell upon them, and after a hard struggle beat them back. At that
instant the Maiden, bearing her lily banner, rode to the Burgundian gate.
"Halt!" she shouted to the fugitives. "Look you, the Maiden whom God sent to you
is here. Follow me to victory." At once she plunged into the thick of battle.
Her presence acted like magic on both sides. The French impetuously followed
her, Daulon, Master of horse, La Hire, and two other knights, leading the first
charge. The English wavered.

"Why do you hesitate?" cried Guerard, their leader. "Shame and confusion to any
one who fears this country girl! Drive her back to her village and her father's
cows."

His appeal was unheeded. The soldiers stood for a moment staring at the banner
in the hand of "the witch," and then, as if at the word of command, rushed in a
panic for the protecting walls of the fort. "On, my brave ones, forward to the
battle and victory," cried Joan, as she furiously galloped after the fugitives.

"Now, soldiers of France!" said La Hire, "she is doing more than her share. On,
my children! Shall we let this brave one do all the work alone?" He spurred his
steed, but his heavy battle horse could not overtake the Maiden's light courser.
The next instant a single knight of La Hire's troop flew after her, and in a few
seconds his sword was waving at her side. It was Jean Renault. Enthusiasm such
as he had never felt before had seized him. He was oblivious to all sense of
danger. Scarcely was the last Englishman through the fortress gate before the
Maiden and Jean rushed through also. The astonished English soldiers saw the
lily banner in their very midst. Before they had recovered from the deadly fear
it inspired, it was flying on the wall. The French poured through the gate, and
victory was soon complete. Those who resisted were cut down, and the rest were
taken prisoners. Some of the fugitives had fled to the tower of the church
within the walls, but these unfortunates were either killed upon the steps, or
hurled themselves from the windows. A more fortunate remnant came out of the
sacristy, where they had arrayed themselves in the robes of the priests. These
were greeted with jibes and laughter as they begged of the Maiden to be made
prisoners. Amid the peals of bells and the triumphal shouts of the people, the
Maiden entered the city at the head of her soldiers.

Three days after this---a festival day intervening---the leaders decided to make
a feint upon the right bank, covering an attack upon the left. As Orleans lies
upon the right bank of the Loire, the commander of the city kept a large number
of boats for crossing. In the midst of the stream, but somewhat nearer the left
bank, is an island which the English had not occupied. The French landed upon
this island, Joan and La Hire, with his troop, in the lead. The boats were
fastened together and thus made a bridge to the left bank, over which they
advanced for an attack upon the first fort, Le Blanc. It would have been easy
for the English to stop the passage, but they did not attempt it. After setting
Fort Le Blanc on fire they fell back upon Fort Saint Augustine.

Joan followed them, and planted her banner half an arrowshot's distance from the
wall. Suddenly there was a shout, "The English are coming from Fort St.~Rivi."
The little band retreated to the Loire, all save fifteen, La Hire and Jean among
the latter. These fell back a little distance, so as not to expose themselves
needlessly to the enemy's assault, seeing which the English plucked up courage
and attacked them, shouting loudly.

"Follow me," cried Joan, waving her banner and advancing upon the English. The
fifteen did not hesitate, rash as the undertaking seemed. They pressed forward,
cutting their way through. When those who had retreated to the river saw this
they came to their assistance, and in a few minutes the English were driven back
into the fort. Joan rushed on until she reached the palisades, dashed through a
breach which Daulon had made, and planted her banner on the wall. The French
rapidly came up, captured the fort, and burned it. It may well be imagined this
fresh victory was hailed with delight in the city. The bells again pealed as the
soldiers entered, but their reception was a quiet one as compared with the
enthusiastic homage which the Maiden received on her way to her lodgings.

Though Joan was wounded in the foot during the battle and passed a restless
night, she was again on horseback early in the morning. She rode to the
Burgundian Gate with a little band, and ordered it to be opened. The keeper
would not obey, saying that the leaders had decided not to give battle that day,
and had ordered the gate to be kept closed. When Joan insisted a tumult arose.
The people demanded it should be opened, and at last opened it by force. With
joyful acclamations the crowd followed their inspired leader to the river. The
boats which had been used the day before were lying there, and served this time
to carry her across. Joan held her horse by the bridle and let it swim after
her, and thus the left bank was reached. A shout of joy from the French who had
garrisoned the captured fort welcomed the lily banner. They came out to meet
her, and Joan placed herself at their head. "Forward, my brave ones," she cried.
"The victory to-day also will be ours." An enthusiastic shout was the reply as
they impetuously rushed on to assault Fort Tournelles.

This fort, the strongest bulwark of the English, was close to the river, a
drawbridge furnishing the only approach to it. On the land side it was
surrounded by a high wall, which had to be passed before reaching the fort
itself. Its garrison was the very flower of the English warriors, led by the
experienced Glasdale. An assault by a mere handful of troops without ordnance or
storming appliances seemed to the English the height of madness.

In the meantime the number of the assailants continually increased, for when the
leaders in Orleans witnessed the courageous dash of the Maiden they realized
that they must support her. One after another La Hire, Dunois the Bastard of
Orleans, De Retz, Gaucourt, Gamache, Graville, Tintey, Villars, Chailly,
Couraze, D'Illiers, Thermes, Gontaut, Eulant, Saintrailles, and others appeared
upon the scene. By ten o'clock the assault was general. The French hurled long
spears. The English brandished leaden maces and iron battle-axes and hurled
beams, stones, boiling oil, and molten lead upon the heads of the assailants.
After three hours of furious fighting the French fell back.

"Courage," cried Joan, whose banner was always in the front. "Courage in God's
name. The victory is ours." She rushed to a ladder and ascended. "Surrender!"
she shouted to the English, "or you will be massacred." The reply was an arrow,
which pierced her shoulder so that it protruded five inches out of her back. She
gave a cry of pain and came down to the trenches. The English rushed upon her
furiously, but a hand was stretched out to her at once. A heavy battle-axe
struck her protector down. It was the brave Gamache who had come to her rescue.
In a trice other heroes were on the spot, and the English fell back. They bore
the maiden tenderly away and took off her armor. She looked up with tearful
eyes, but they were fixed upon heaven, as was her wont.

"How is it going, Count Dunois?" she asked.

"We have ordered a retreat," he replied, whereupon she partly sprang up, seized
the arrow with both hands, and pulled it out. "Let there be no retreating," she
urged. "Quick, my armor." In a few minutes she mounted her steed and galloped
through the flying ranks. "Halt!" she pleaded. "Have courage, in God's name. In
half an hour the English will be in our hands."

The effect of her heroic resolution was wonderful. The soldiers turned back with
cheers. Daulon grasped the lily banner and carried it to the wall. Joan hastened
forward and again led the assault. The terror of the English at the reappearance
of the Maiden cannot be described. They had believed her dead. They were certain
now that she was in league with Satan. They dropped their weapons and fled, and
fear lent wings to their flight. Loud cries of horror from the water side
completed the disasters of the day. An attack had been made upon the drawbridge.
Glasdale had hastened there to protect the weak point. A shot fired by Daulon
shattered the pier, and the bridge with all its defenders fell with a crash into
the Loire. Glasdale, weighed down by his heavy armor, was drowned. It was this
disaster which had caused the outcries. The day ended in a tragedy for the
English. "Save yourselves as you can," was the signal for flight. The fort was
taken.

In Orleans the bells rang welcome to the troops. They rang the whole night long
in celebration of the victory. The churches were thronged, and from thousands of
grateful hearts rose the #emph[Te Deum laudamus] to heaven. The next morning
dense smoke ascended from the English camp. Suffolk and Talbot had abandoned the
siege, set fire to their camp, and retreated with the remnant of their army.

Thus in nine days Joan accomplished the first part of her mission.

= V --- The Coronation and the Capture

On the left bank of the Loire, a few miles above Orleans, is the little city of
Jargeau. At the time of which we write it was surrounded by massive walls, and
was considered a strong fortress. After the raising of the siege of Orleans the
weakness of their position was so apparent that the Duke of Suffolk, with his
brothers, Alexander and John de la Pole, fell back to Jargeau. Within a few
weeks the Maid of Orleans, as Joan was now generally called, was before its
walls with her principal commanders. Her only desire now was to conduct the King
to Rheims for his coronation. Notwithstanding her wounds were not yet healed,
she left Orleans with La Hire, Dunois, the Duc d'Alençon, and other officers,
went to Tours, where the Dauphin was then stopping, and requested him to follow
her at once to Rheims. He was not disposed, however, to grant her request. His
kitchen, cellar, and money-chest were once more replenished, and as life was now
very enjoyable, he decided that it would be rash to hazard such an undertaking
until the way was cleared; for notwithstanding the deliverance of Orleans, the
enemy was still holding the district. The leaders also declared that it would be
in violation of all the rules of war. They must first open the way, and above
all, Jargeau must be captured. Joan was obliged to submit to their decision, and
join them.

On the 20th of June---the day was Friday---the army arrived before Jargeau.
Learning that Falstaff was on his way from Paris with help for Suffolk, no time
was wasted. Preparations for the assault were instantly begun, and on Saturday
evening a breach had been made in the wall. Early on Sunday morning Joan, in
full armor, entered the tent of d'Alençon, he being in chief command.

"Come, noble Duke," she cried, "let us make the attack."

"What," he replied, "to-day? On Sunday?"

"Why not, noble sir? Obedience is the best service to God."

"But, Joan, is the breach passable?"

"Undoubtedly. God has given the enemy into our hands."

"But, in the meantime---"

"There is no meantime, noble sir. What fear you? Have you forgotten that I
promised to take you back safe to your wife?"

"Well, let the attack begin."

"Forward, attack!" cried Joan, as she left the tent, waving her banner. The
troops advanced, but the apprehensions of the Duke proved to be well founded.
The breach was too high. A ladder must be raised. In the meantime, among the
daring ones who had rushed forward, was Jean. "Halt, boy," shouted La Hire, at
the same time pulling him back. "I don't think your skull is tough enough to
resist that fellow's club." He pointed to the breach. Jean looked up and saw a
giant standing in the opening, wielding a massive club, and laughing with
fiendish glee as he dashed everything about him to pieces. "Wait a bit," said La
Hire. "I think your namesake, the gunner, can stop that fellow's laughing." He
was right. The catapult hurled a rock through the air, the giant flung up his
arms, and fell backward from the wall, a great shout accompanying his fall.

Joan rushed up the ladder shouting "Forward, forward, my brave ones," but a
stone felled her to the earth.

"Hurrah!" shouted the English, "the witch is dead." Their joy was short-lived,
however. Fear again seized them, as they not only heard her assuring words to
those about her, but saw her prepare to ascend the ladder again.

"All right now, boy," said La Hire, as Jean again rushed forward. "I am with you
this time." They quickly climbed the ladder, but when Jean reached the top some
of the English had been thrown down, and others were flying into the city. Among
those who had been hurled down was Alexander de la Pole. When the Duke of
Suffolk saw his brother fallen, and the French pouring in, he gave up the fight,
and, like the others, turned toward the city.

"Halt! halt! surrender!" a strong voice shouted. Suffolk stopped and looked at
his pursuer. He could have vanquished him with little effort, but he did not
consider it chivalrous to take advantage of an enemy. "Who are you?" he asked.

"Jean Renault," was the answer.

"Nobleman?"

"Yes."

"Knight?"

"No."

"Kneel down."

Jean obeyed. The Duke raised his sword, and with the words, "In the name of God
and Saint George I dub thee knight," he dealt him three blows upon the shoulder
with the flat of the blade, and then offered him his sword.

Jean arose, pressed the Duke's hand to his lips, and took his sword, saying, "I
do not deserve this honor, my Lord Duke, but I am very proud to receive the
sword of the first of England's heroes."

"You are right," said a deep voice behind him; and, as if in benediction, La
Hire laid his mailed hand upon his head. "You are right, say I. All the
knighthood of France would begrudge you this sword. By Saint George, I am just
as happy as if I had seen that sword in the hand of my own son."

"The noble La Hire's word," said the Duke, "is sufficient warrant that my sword
will be worthily carried, Sir Jean Renault; there is no stain upon it, guard its
purity." Jean's feelings overcame him, and he could make no reply.

After the capture of Jargeau, Joan rested for a time, meanwhile forwarding
reinforcements to Orleans, for more victories must yet be achieved in the
district of the Loire. While her fame attracted recruits every day to her
banner, the fear of her very name was so overpowering that Meung, Beaugency,
Guetin, and other cities surrendered without offering resistance. The English
force which came from Paris under Talbot and Falstaff was defeated at Patay, and
two of its generals were taken prisoners. The evacuation of Paris was the result
of this battle.#footnote[It was after the victory at Patay that Joan of Arc
  declared that the English power in France would not recover from the blow in a
  thousand years.]

Joan returned with the Duc d'Alençon to Orleans, and thence repaired to Gien to
see the Dauphin. "Sire," she said, "the district of the Loire is now clear. Go
with me to your coronation at Rheims."

The Dauphin still hesitated. "The way is even yet dangerous," he said. "Many
castles and cities in Champagne are still in the hands of the enemy. How easy it
would be for them to fall upon our rear from Normandy." His councillors in
attendance decided that his fears were well grounded.

"Oh, you saints of heaven," cried the Maiden, her eyes shining with enthusiasm,
"help me to inspire the noble Dauphin with a little of that courage you have
given me!" Her prayer was answered at once. The King was moved by her soulful
eyes, her steadfast faith, and her lofty inspiration. "Yes, Joan, we will trust
you," he exclaimed. "On to Rheims."

Orders were sent in all directions. The leaders and their troops quickly
assembled, and the march began. Joan led the vanguard. At the mere announcement
of her coming the cities of Auxerre, St.~Florentin, Chalons, and Sept-Sceaux
capitulated. Troyes did not surrender until preparations for assault were made.
At Sept-Sceaux, four leagues from Rheims, they rested. Charles then sent three
of his principal councillors to San Remy to fetch the holy oil which was kept
there.#footnote[Tradition says that Clovis and all his successors for nine
  centuries were anointed with this oil.] They returned, escorted by a grand
procession headed by the Abbot of San Remy, who walked under a canopy, carrying
the phial.

From all the towers of Rheims the bells announced the memorable ceremony of July
17, 1429, which completed Joan's mission. The pealing organ and a majestic hymn
of praise welcomed the long coronation procession as it entered the Cathedral of
St.~Denis. Joan accompanied the King to the vestibule, where the Archbishop of
Rheims met him and conducted him to the high altar. The choir was occupied on
each side by the commanders and leading dignitaries, knights and lords, squires
and attendants, while a vast multitude of people crowded the cathedral to its
utmost capacity. Joan stood next to the King, her eyes shining with sacred joy,
holding her banner in her left hand and her sword in her right.#footnote[Joan's
  enemies subsequently reproached her for this, saying it was pride that moved
  her to take her banner to the ceremony. She only replied that it had shared
  the pain; it was right it should share the honor.] It was a position which
ordinarily only the first marshals of the kingdom were entitled to occupy; but
no one questioned her right to it or envied her.

#framed-image("images/p01.jpg", [The last act in the ceremony was Charles's
  coronation.])

The sacred function began at nine o'clock in the morning and lasted until two
o'clock in the afternoon. The opening ceremony was the administering of the oath
by the Archbishop, during which Joan, following the old custom, held her sword
over the King's head. Then followed the knighting, for Charles had not yet
received this honor, without which he could not ascend the throne. He knelt and
the Duc d'Alençon knighted him. The third ceremony was the consecration and
anointing with the holy oil, and was performed by the Archbishop. The last act
was his coronation by the same prelate. As soon as the royal symbol glittered
upon his head the cathedral resounded with the enthusiastic acclamations of the
great multitude: "Hail, hail, King Charles the Seventh!" accompanied by a
fanfare of trumpets, the roll of drums, and majestic chorales.

Joan was the first to proclaim allegiance to the Crown. She threw herself at the
King's feet, and after kissing his knee, said: "Sire, the will of God is
accomplished. You are now the true King of France. My mission is ended. Permit
me to return to my home and resume the humble life of the shepherdess."

"No, Joan," replied the King, "I cannot spare you. All that I now am is due to
you. You must accompany me on the return."

Joan rose sadly. She felt that in remaining longer she would be disobeying the
divine voices which had commissioned her to perform only the two tasks now
successfully accomplished. The King rewarded her by granting a patent of
nobility to her whole family, whence it is that she is called "Jeanne d'Arc."
Her coat of arms was a blue shield with two gold lilies and a silver sword
bearing a golden crown on its point. These distinctions, however, were of little
interest to Joan. She grew sadder and sadder, and ardently longed for her home
fields and her loved Fairy Tree. This feeling became all the more intense when
her brother Pierre arrived; but she rushed joyously into his arms and was
somewhat consoled when the King appointed him her page, and she knew that he
would never leave her. She took part in many more military operations; but
although she entered many cities whose gates opened at the sound of her name,
though she was everywhere greeted as a saint and welcomed with enthusiastic
acclamations and songs of praise, she no longer felt the early unquestioning
faith and the sacred inspiration. An ill-starred movement against Paris, in
which she was wounded afresh, confirmed her in the belief that she had exceeded
her duty, and that she was no longer under the protection of her saints. She was
haunted with gloomy presentiments of death. They pursued her in dreams, and at
last she again implored the King to let her go.

"What do you fear, Joan?" said the King. "If you are wounded it shall be my care
to heal you. If you are captured by the English I will release you, if it costs
half my kingdom. You are the guardian angel of France. I cannot let you go." He
placed her in command of his own corps and sent her once more into the tumult of
battle.

On the 27th of May Joan appeared with her army before
Compiègne,#footnote[Compiègne, a town in the department of Oise, forty-five
  miles northeast of Paris, and famous as a royal residence. Its palace was
  rebuilt by Louis XV., and fitted up sumptuously by Napoleon I.] which was
occupied by the French but was closely invested by the Duke of Burgundy, who was
in alliance with the English. She successfully entered the city, and of course
was received with the greatest enthusiasm. Early on the next day she made a
sally at the head of six hundred troopers. She wore her usual armor, with a
short silver-gilt cape over it, and carried her small battle-axe, sword, and
banner.

Philip of Burgundy's army was composed of experienced troops, and its various
divisions were led by Noyelles, John of Luxemburg, and John of Montgomery. Joan
swept among them like a whirlwind, carrying everything before her, and for the
time throwing them into utter confusion. A cry of terror---"The Maiden, the
Maiden"---was raised in the camp, but when Philip of Burgundy appeared with
reinforcements the English, recovering from their first surprise and confusion,
began to hold their ground. Finding herself confronted by a tenfold increased
force, she ordered a retreat. She was the last in the line, and was closely
pressed by the enemy, but when the boldest of them came too close she turned
upon them and drove them back. In this manner she forced her way successfully to
the gate. As there was much crowding and disorder there, she turned once more at
the head of her rear guard against her pursuers, and beat them back, thus
gaining time for her troopers to get into the city; but when she herself made a
dash for the gate she found an English troop barring the way. She slashed right
and left and hewed her way through; but, alas! the gate was shut. No one heard
her call, no one opened the gate, for it was feared that the English might rush
through. Joan turned her horse, hoping to reach open country or find another
gate. The enemy, seeing that she rode alone, plucked up courage. She was quickly
surrounded, and a desperate fight ensued. An archer stole under her horse,
seized her by her velvet cape, and pulled her down. She gathered all her
strength for a last effort, but, overcome by superior numbers, sank exhausted
upon her knee, and still fought on with her little remaining strength. Longingly
she watched the city, but no one came to her rescue. At last she surrendered her
sword to Lionel, one of the leaders in the Duke of Luxemburg's corps.

"The Maiden is captured," shouted the soldiers. The news flew from place to
place and from troop to troop. The English celebrated the event with as much
enthusiasm as if they had won a pitched battle. Well might they rejoice, for
Joan's prowess had cost them two-thirds of their French possessions.

The Duke of Bedford, the Earl of Warwick, and the Bishop of Winchester
instructed Brother Martin, Vicar General of the Inquisition, to demand the
delivery of "the witch" into the hands of the Church. Martin wrote to the Duke
of Burgundy as follows:---

"Both of us know," said the Duke of Burgundy to John of Luxemburg, "that Joan is
not a witch but a noble maiden, and that we are bound to deliver all noble
prisoners to our English allies for a consideration of ten thousand pounds. But
we also know that the Maiden is an exception, as it is altogether probable that
Charles VII will ransom her, for he has promised to do so." John of Luxemburg
was satisfied, as he hoped to get more from the King than from the English. In
the meantime he sent Joan to his castle Beaurevoir, where she was affectionately
greeted by his wife.

Month after month passed, but nothing was heard from Charles VII. In the
luxurious life he was leading he had not time to think of his rescuer, whom he
had promised to ransom even if it cost him half his kingdom. For this reason the
English were anxious to expedite matters. They instructed Cauchon, Bishop of
Beauvais, in whose diocese Joan had been captured, to request her delivery to
him and to conduct her examination. They offered ten thousand pounds to the Duke
of Luxemburg, the ransom price of a general, and an annuity of three hundred
pounds to Duke Lionel. In the middle of September the Duke of Luxemburg sent
word to his wife he could wait no longer, but by her earnest pleading and by her
excuse that the Duke of Bedford had not yet sent the money, she secured a
further respite for Joan.

Joan burst into tears as she now for the first time realized the actual
character of the situation. "Oh, I knew it would be so!" she exclaimed. "They
have sold me, but I would rather die than be given into the hands of the
English."

One stormy November evening the castle guards heard a scream which was audible
even above the howling of the gale. They rushed to the spot and found Joan in
the moat. She had thrown herself from her window, but she had failed in her
purpose. She was not dead. The event made the avaricious master of the castle
fearful that he might lose his reward entirely, for how could he give security
that this desperate maiden, in spite of the utmost watchfulness, might not carry
out her purpose yet?

A few weeks later the rabble of Rouen stood before an iron cage suspended from a
tower. Derisive epithets and cruel insults passed from lip to lip and were
greeted with indecent laughter. In a corner of the cage sat a cowering figure
bound with fetters. Her face could not be seen, for her head was bowed in
anguish. One of the mob thrust his lance toward her to make her look up. He was
successful. She slowly raised her head, and the crowd looked upon eyes full of
sorrow, eyes full of purity and beauty,---the eyes of Joan. The Duke of
Luxemburg had completed his infamous bargain. He had delivered her to the
English.

= VI --- The Martyrdom

Jean Renault sat in a tavern at Chinon, abstractedly gazing out over the flowery
fields which were visible from his windows. It was a day in May, 1431, and the
time and the scene painfully reminded him this was the third spring since the
incidents in the forest and the Ursuline church. He was not a dreamer, however,
but a man of quick and resolute action. It was the thought that he had been
prevented from accomplishing the purpose upon which his heart was set that made
him gloomy and abstracted. A heavy step interrupted his reverie.

"Ha! the villain," exclaimed La Hire, as he entered, almost beside himself with
rage. "The sordid, venal wretch! The dishonorable scoundrel, who would sell that
noble one for contemptible gold! But just let him wait! I am searching for him
and I am on his track!"

"Noble sir," interrupted Jean, "of whom speak you?"

"Of whom am I speaking? Of whom else than Luxemburg? That---"

"Ah! of him! I too was thinking of him."

"I can well believe it, my boy," for although Jean was now a knight, La Hire
continued to call him "my boy." "I cannot sleep because of it. Shame and
disgrace upon him."

"I wish we had been at Compiègne. Then we should have had a chance to meet him."

"Yes, yes, to meet him---but the poor Maiden!"

"Yes, the poor Maiden! I was also thinking of her."

"She languishes in a gloomy prison."

"Yes, in a gloomy prison."

"Her delicate limbs are loaded with fetters."

"Yes, loaded with fetters!"

"Condemned to bread and water, like a felon."

"Condemned to bread and water!"

"She, the rescuer of France!"

"Of whom speak you, noble sir?"

"Of whom do I speak? Saint George, of whom else than Joan?"

"Of Joan? I thought it was of---"

"Ah, you were thinking of Marie! The poor child! May God's vengeance overtake
Luxemburg!"

"And what about Joan?"

"Do you not know? Why, of course you do not, for I have not told you. He has
given her up, sold her to the English, the villain!"

"Who has?" cried the astonished Jean.

"The Duke of Luxemburg."

"God help her! And the King?"

"Pah! the King! He doesn't care."

"Oh, the shame!"

"Oh, the disgrace!"

"But by what legal authority have they put Joan in prison?"

"By what legal authority? Ask the priests who have condemned her."

"The priests!"

"The vengeful English have given her to the Holy Inquisition. The Bishop of
Beauvais conducted the proceedings, and she has been sentenced to life
imprisonment for heresy."

"To life imprisonment! But how could they convict her of heresy?"

"They did not convict her. That simple child refuted every charge made against
her by her sensible and devout replies to the questions they asked her. They
condemned her upon the charge of having intercourse with evil spirits."

"Shameful, it is shameful!" cried Jean, springing up in a rage.

"Yes, horrible!"

"Farewell, noble sir."

"What? Whither go you?"

"To Rouen. You must let me go. I shall not ask the King."

"But what will you do in Rouen?"

"Summon help if it be possible. Rescue Joan even if it should cost my life."

"Would that I could go with you! But I could be of no service. You will not
accomplish your purpose, my boy. They have not only selected a special tower for
her prison, but they have securely bound her with chains fastened to a post that
cannot be reached by you. And there are two guards constantly on the watch
outside and three inside the prison."

"But even that, noble sir, does not discourage me. It only makes me the more
eager to be off; and there is something else that urges me on to Rouen."

"Well, God go with you, my boy. But I warn you to be careful. I wish I could go
also. I would ask you to wait until I can be there, but it would not be right.
You have waited too long already."

On the next day Jean rode to Rouen in the disguise of a peasant. While going
through the recovered districts he rode as fast as the strength of his horse
would permit, following the same circuitous route which he took on his first
journey. On the last stretch he made a still wider detour, which brought him
into his own neighborhood, where he met peasants of his acquaintance, as he had
expected. He left his horse with them and pursued his way on foot to Rouen. That
city, as well as its vicinity, was in the hands of the enemy, and was so
strongly garrisoned that little but English was heard on the streets,---a fact
which caused Jean much misgiving. His appearance, however, did not excite
attention, for intercourse between city and country had gradually been restored,
and the peasants were freely bringing in their products for the market.

Jean's first move was to the church of Saint Ursula. There, at the place by the
wall which was so familiar to him, he fell upon his knees, but he could not
pray. He could hear his heart beating as he listened; but when he found that he
was listening in vain and that there was no sign of life on the other side of
the wall, he became more composed, and prayed fervently to Heaven for help. Upon
his return to his lodgings he passed himself off for one of the curious crowd
which was pouring in from near and far to see "the witch."

"You have come here to little purpose, good friend," said his host, "and yet
there are some sights which will repay you. You can see the cage in which the
prisoner was fastened, and the tower in which she is still confined."

"Is no one allowed to enter the tower? I would be satisfied if I could see her
even from a distance."

"Why, what are you thinking of? No one should be allowed to see her, for she has
intercourse with evil spirits! How easy it would be for one of those spirits to
assume the appearance of a peasant and join a crowd of curious people, just as
if it were one of them! Now the prison door opens! Hush! the spirit gets in
there! and ps-t---they are gone. Do you see? That is the way with witches."

"Is that so?"

"Oh, yes! My grandmother, blessed---"

At this instant the loquacious host was called out. When he returned he had
forgotten his story in his eagerness to make an announcement to his guest.

"You are a very lucky man," he said, beaming with delight.

"How so?" replied Jean.

"Why, look you! I thought I was too when I heard the news. I am perfectly
delighted that you did not lodge with that pitiful fellow, Loup. Between
ourselves, I can't endure that man. He has recently---but I will tell you about
that another time. What was I saying? Oh, yes! Look, there comes my cousin, the
dear, good woman! You cannot imagine how pious she is. His reverence, the
Bishop, could tell you. Why, he has even taken her confessions many a time
himself!"

"Yes, but what does all this mean?"

"Why, it means good news. I have stolen away to tell you, for it is still a
secret, and my cousin has promised his reverence not to breathe a word of it to
any one, and she first told Charlotte---"

"But what is this secret?"

"Well, what do you think? The witch has actually had intercourse with evil
spirits in the prison!"

"Ah! How do you know that?"

"How? My cousin could tell you exactly. Let me see, how was it? Oh, yes; I have
it. The witch had promised to renounce all her hellish practices and wear
women's clothes. So they were brought into the prison; but notwithstanding that
she was found the next morning with men's clothes on again. There you have it."

"But why do you conclude from that that she has intercourse with evil spirits?"

"Why? Do you still doubt? Holy Ursula! his reverence says so. My cousin, the
good woman, she could tell you all about it; but she has gone just now to mass."

"But you were going to tell me some good news."

"Oh, yes; I had nearly forgotten it. It is this. As the witch has resumed her
intercourse with the evil spirits, she will have to be tried again."

"Well, of what interest is that to me?"

"Of what interest is it to you? Holy Ursula! Is it not of the greatest interest
to you that you have not come here in vain? When they sentence the witch again,
she will stand upon a high platform, as she did the first time, and you will see
her just as easily as you see me now."

"So! That is nice. But when will it be?"

"I do not know, little friend. But, ps-t, my cousin will find out all about it
from his reverence."

"Is the Bishop here?"

"Not yet; but if he does not come to-day, he will be here in the morning."

"Well, surely, I arrived here at just the right time."

"Did I not tell you so? I am so glad you are not stopping with that disagreeable
Loup, for he could not have told you a word about this matter."

"Of course not. He has not such a pious cousin who confesses to his reverence
himself. But can I go now and see the tower and the cage?"

"Certainly, little friend; but listen. If you should meet that Loup, do not
greet him, do not even look at him, for they say he has an evil eye---he might
bewitch you."

"I will keep it in mind."

To his great disappointment Jean found the tower so well guarded that he could
not be of the slightest assistance to Joan. He decided to withdraw and await
events before forming any plans, and in the meantime make inquiries about Marie.
While on his way back he heard from passers-by that the Bishop was momentarily
expected, and that he would pass that way. As he did not wish unnecessarily to
expose himself to the prelate's gaze, he entered the Ursuline church. It was
empty. He went to the usual spot, and scarcely had he placed his ear to the wall
before he clearly heard a sob, which seemed to come through the stone. Trembling
with excitement, he listened all the more intently, but in vain. All was silent.
Had he or had he not been deceived? All at once it seemed to him as if it were
the voice of the girl in the carriage which he met in the forest, and that she
could be no other than Marie of Chafleur. He quickly made his plans. As he stood
leaning against a door, near which he had been kneeling apparently engaged in
devotion, he pressed a piece of wax against the lock, went at once to a
locksmith's in an out of the way street, and said his master wished a key made
from the impression.

The next evening, when all Rouen was out to see the young King Henry of England
make his entrance, Jean again found the church empty. He tried his key and it
opened the door. He emerged into a long, dark passage-way which skirted the
wall. If he was right in his calculations, he would find the prison between this
passage and the church. He felt along the wall, for he could see nothing. He was
right. There was a door near the corner. It must lead to the prison out of which
had come the sound of sobbing. With trembling hand he took another impression,
groped his way back, closed the door in the church wall, and departed. The next
day he obtained the second key. He now forsook the church for a time and devoted
his attention exclusively to the fate of Joan. The strangest reports were
circulated about her; but they were so incredible and withal so dreadful, that
he paid little attention to them. What pained him the most was the certainty
that he could do nothing to help her.

Thus matters stood on that 30th of May of the memorable year 1431. The sun gayly
shone that morning, and the birds sang joyously in the trees and among the
flowers. The doors of Rouen stood wide open. From far and near the multitude
gathered. There was a sea of heads on the sides of the great market-place, and
in the streets leading to it, and windows and roof-tops were crowded. In the
middle of the square were three high platforms. Two of them, which faced each
other, were evidently set apart for those directly concerned in the proceedings.
The general interest centred, however, in the third platform, of the use of
which there could be no doubt. The flooring rested upon a pile of wood so
arranged that the logs made steps, and from the centre of the platform rose a
stake to a man's height. The base of the pile was surrounded with bundles of
fagots smeared with resin and pitch.

"Come on, little friend," said the innkeeper to Jean, as he went up some stairs.
"I have a nice place for seeing. I am so glad you did not stop with that
miserable Loup---but, holy Ursula! are you ill? Your hand is as cold as ice."

"I am not feeling very well," replied Jean, "and I would rather go back again."

"What! You don't mean to leave just as the spectacle begins! I will get a little
potion for you which my cousin, the good woman---but, holy Ursula! the drums are
already rattling. The judges are mounting the great tribunal. Look, there is his
reverence. He has the parchment in his hand which contains the sentence. Pay
attention. He will read it soon."

Jean did not hear a word. His eyes were fixed upon a distant spot whence,
accompanied by the roll of drums and the shouts of the multitude, a procession
was slowly making its way through the crowd.

"Do you see the cart?" said the innkeeper. "Do you see the witch in it? She is
sitting by the side of Father Martin. That holy man has been praying by her side
all night that the evil spirit may forsake her. Holy Ursula! See how they have
bound her! Her hands are fastened, and her feet are in iron rings with a chain
between."

The cart soon reached the square. Joan was led up to the second platform by
Father Martin. The Bishop of Beauvais read the sentence amid the profound
silence of the multitude:

"In the name of God, Amen.

"We, the Bishop of Beauvais, Master and Vicar of the Inquisition, pronounce
sentence. As Joan, commonly called 'the Maiden,' has relapsed into heresy and
apostasy, she is excommunicated, and herewith given over to the secular power
for the infliction of the punishment provided for the heretic."

Some would have applauded, but they found no encouragement, for Joan had fallen
upon her knees and was praying, and when she raised her head her face was as the
face of an angel. Many began to realize that she was not a criminal, and loud
sobs, indicating the growing change of feeling, were heard here and there.
Observing this, the judges hastened their work. An attendant approached her and
placed a pointed cap on her head with the words, "Heretic, relapser, apostate,
idolatress," written upon it. He then hurried her down the steps and led her to
the pile, at the foot of which the executioner was in waiting.

"Leave me not, Father Martin," she implored, as the executioner seized her and
dragged her up to the platform. The father followed and remained with her as the
executioner bound her to the stake and then turned to descend.

"Pray for me, all pray for me," she cried to the people.

The executioner seized a torch and lit the fagots at the foot of the pile.
Swiftly rose the flames.

"For God's sake, my father," cried Joan, "take care! Quick, quick, hurry down,
but hold the crucifix high before me until I die."

Martin did as she requested. The Bishop of Beauvais approached.

"Bishop, Bishop," said Joan, reproachfully, "you are the cause of my death," and
then as she felt the heat, she exclaimed, "O Rouen, I fear you will have to
suffer for my death."

The flames mounted higher. A dense cloud of smoke concealed her, but now and
then the wind swept it aside, and the people saw, not a devil's witch, but a
praying angel with marvellously beautiful eyes fixed upon heaven. Suddenly the
flames seized her garments. Her last word was "Jesus"---then a piercing death
cry, and all was ended.


#framed-image(
  "images/p02.jpg",
  [The flames mounted higher, and the people saw, not a devil's witch, but a
    praying angel with eyes fixed upon heaven.],
)

Thus perished the Maid of Orleans, rescuer of France. She died forgotten and
forsaken by him for whom she had done all, betrayed through the greed of her own
countrymen, accused from motives of revenge by her enemies. She died the most
cruel of deaths, and yet was as guileless and pure as when she sat under the
Fairy Tree tending her lambs. Joan is a unique figure in the world's history. A
simple peasant maiden, who could neither read nor write, and knew only the
Lord's Prayer, the Credo, and the Ave Maria, she achieved such extraordinary
results by her gift of inspiration that her contemporaries and posterity in
their efforts to explain them have had to attribute so much of the miraculous to
her deeds that some have doubted her very existence.

The old market-place of Rouen now presented another spectacle. "Alas! alas! we
have burned a saint," many said. The crowd remained a long time, as if riveted
to the spot, staring at the fire as it consumed the last vestiges of the victim.

The innkeeper himself was so overcome that he forgot all about his companion.
When he turned to speak to him, Jean was gone.

= VII --- The Rescue

Marie of Chafleur had borne her imprisonment with unshaken courage. She was
resolved that she would not be forced to take the vow, and though she suffered
greatly in her damp, gloomy prison,---she who could still take childish delight
in every little flower,---she remained true to her resolution.

The Abbess, who had been so favorably impressed by her when they first met, was
still more impressed by her firmness, and gave her permission to visit her. Upon
one such occasion the abbess kindly said: "You grieve me, my daughter. Your
obstinacy may compel me to adopt severe measures."

Marie made no reply. She was looking out of the open window at the garden, which
was now in full bloom, and was so absorbed with the view that she did not hear
the Abbess. Her face was all aglow with excitement, her eyes sparkled, and she
gleefully clapped her hands. "Oh, how beautiful, how beautiful!" she cried,
approaching nearer to the window. "Oh, if I could but be among those flowers!"

"You are childish," said the Abbess, without manifesting displeasure, however.
"Listen, and pay attention to what I say."

Marie wiped away her rising tears and looked into the Abbess's face. "It is not
very long ago that you were as young as I," she said, "and, oh, how beautiful
you must have been without that veil! Tell me, have you never enjoyed yourself
in the flowery meadows? Have you never chased the pretty butterflies, never
listened to the songs of the birds, never breathed the fragrance of the flowers?
Oh, tell me."

"Why do you call up such recollections, child?"

"Oh, yes, I know you have, and so you can understand me when I tell you it is
impossible for me to stay within these walls. I must go. Surely, noble lady, you
will not keep me here any longer. Oh, open the doors and let me out. I will go
on foot and travel through the country all alone until I find my uncle. And even
should I not find him, and have to suffer hunger, thirst, cold, and heat, still
I should be happy. So once more, noble lady, I implore you to let me go."

"Child, child, you are asking impossibilities of me."

"Why impossible?"

"You have no idea of the implicit obedience required of us."

"But, noble lady, your vows and your discipline only bind you in your relations
to the convent life, not to the outer world."

"You are mistaken, my daughter. We owe unquestioning obedience in all things to
our superiors. Whatever they demand of us is right. It is not for us to question
or decide."

"How is that, noble lady? Having dedicated yourself to Heaven, can you blindly
follow human dictation?"

"Child, the will of the Church, to which we bow, is the will of Heaven."

"I do not understand that."

"That is because you are not in the right spirit to understand it."

"That may be true, but I am sure of one thing."

"What is that?"

"That you would not poison me even if you were ordered to do so."

"Child," said the astonished Abbess, "what put such a dreadful thought as that
in your mind?"

"Because, though unconsciously, you have really begun to do it."

"You shock me! What do you mean? That I would poison---"

"The poison of the prison atmosphere, noble lady, is just as surely killing me
as if it were real poison. So again I implore you to let me go. Do not degrade
yourself by becoming a party to the shameful conspiracy which has been planned
against me."

The Abbess might have replied to Marie at more length, but she was too
thoroughly convinced of the truth of her words and the injustice which had been
practised toward her to do so; and besides this, Marie's sweetness of nature and
childish ways won more and more not only her sympathy but her affection.

"I cannot give you your freedom, my daughter," she replied, "but I will do all I
can for you. You may stay in the garden during the day, but when the Bishop is
here you will have to go back to the prison. Perhaps mildness may accomplish
more than severity. It is because of this hope, bear in mind, that I make this
concession. Now go. Here is the key to the garden."

Marie fervently kissed her hand and ran off. The Abbess went to the window and
thoughtfully watched her. The joyful expression of her face showed that her
heart approved what her reason and sense of duty half condemned.

Marie's life now grew more cheerful, for the Abbess kept her word. She not only
allowed her to go daily to the garden, but she admitted her to her confidence.
Of course she had not the slightest idea that this would induce her to join the
order, but she reasoned that if their relations became intimate she would not
suspect any such purpose.

John of Luxemburg all this time was administering affairs as if he were the
lawful owner of Marie's property, and so far ignored all her rights that after
deducting the comparatively small sum due to the Bishop, he put the rest of the
receipts into his own pocket without further ceremony. It actually seemed as if
the two men little by little might yet accomplish their purpose. Though Marie
felt very happy when she first set foot in the convent garden and the Abbess
treated her so affectionately, yet the roses on her cheeks began to fade, and
when she was alone in her narrow prison during the Bishop's visits her sorrowful
sighs showed she was not in her usual cheerful spirits. Even in the garden her
joyousness would vanish whenever she came near the high wall which surrounded
it. The consciousness that she was a prisoner embittered every joy, and at last
even made the garden unenjoyable. In this sad frame of mind the scenes of her
childhood seemed to her like bright spots in a lost paradise. As she recalled
the happiness of that paradise, the more keenly she realized the injustice which
had driven her out of it. During that day when all Rouen was witnessing the
awful spectacle in the old market-place, she sat more sorrowful than usual in
her prison. Of course she did not know what was going on, for no news from the
outer world ever found its way within the convent walls. Whatever the cause may
have been, whether her confinement this time had been longer than usual, or
whether she had painted the lost happiness of her childhood in too lively
colors, she was more unhappy than usual.

"My God! My God!" she moaned, "hast Thou utterly forsaken me? What crime have I
committed that calls for such a frightful expiation? If I am guiltless why
should godless men triumph? And you, my uncle! Is it because you are dead that
your help is so long delayed? Oh! you brave one, who all alone confronted those
robbers in the forest! Why wait you so long? Have you been mistaken? Am I not
the one for whom you dared so much? Oh, be quiet, foolish heart, lest I persuade
myself I really am that one."

She gradually regained her composure, smiled through her tears, and lost herself
in fancies of another kind. At last, scared by her own thoughts, she resumed: "O
thou Blessed Virgin, protect him! Keep him far away from here. Those against
whom he would contend single-handed are too strong for him. Protect him."

As she spoke the last words there was a slight noise at the door. "They are
coming to let me out," she said to herself; "the Bishop has gone." She wiped
away her tears and stepped forward. The door opened, but it was a man's figure
that she saw in the dim light, not the sister keeper.

"Is it you, Marie of Chafleur?" the stranger whispered, for he could see nothing
in the prison.

"My God! what is it? Who are you?" said the terrified girl in a low voice.

"Be quiet," whispered the stranger. "If you are Marie of Chafleur, take this
bundle. It contains a page's dress. Hasten! I will watch outside."

The poor girl trembled like an aspen leaf, but she took the bundle. She stood
for a few seconds as if dazed, but quickly made her decision and stepped back
into the prison. It was some time before she could make the change of costume,
for her trembling hands were not as deft as usual, but at last she went out into
the passage in her disguise.

"Give me all your clothes," whispered the stranger, "for if they are left here
they will betray you."

Marie fetched them to him, and after making a bundle of them exactly like the
one he had brought, he took the trembling girl by the hand and led her to the
church door. Then he listened. All was still. "Softly, softly," he murmured as
they left the church.

Who can picture Marie's glad surprise as she looked by daylight into the face of
her protector for whose safety she had just before invoked the Virgin? There was
little time for sentiment, however, for scarcely had Jean closed the door when
they heard voices and steps in the street. He drew Marie down quickly, and they
knelt together as if engaged in their devotions, while he listened intently to
every sound near the entrance; but the steps they had heard were those of
passers-by. Jean whispered, "I believe we have succeeded. Let us thank the Holy
Virgin and Saint Ursula." With tremulous voices they murmured their gratitude,
and then Jean said in a low tone: "Do you feel strong enough, noble lady, to go
on alone?"

"Oh, I will be as strong as a man when away, far away from here," she answered.

"I will take the lead," said Jean. "Follow me at some little distance, so no one
shall suspect we are acquainted with each other. The whole city is in commotion
and crowded with strangers on account of the execution. They will not pay much
attention to us. Do not look around much, lest some one may recognize you. Keep
your eyes downcast, and they will think you have been overcome by the dreadful
spectacle. In this way we may pass through the gate like the other strangers on
their way home, and after that the Holy Virgin will help us the rest of the
way."

Jean arose and left the church, and Marie followed his instructions. Everything
turned out as Jean had said. The two met many groups standing on the walks or
passing along the streets, and at last safely got through the gate. Marie could
scarcely restrain her exultation, but Jean went calmly on, hurrying to the
forest as fast as she could follow him. Marie's joy increased as she felt sure
that she was rescued, for she could not believe that a trace had been left which
would reveal the manner of her escape. She looked around, and finding that no
one was following them, she gave expression to her happiness.

"My noble rescuer," she said, "I cannot longer keep silence and conduct myself
like a Capuchin. It is inconsistent with my costume, you know. I must exult; I
must shout, or I shall die right here before you---"

"Not yet," said Jean, without turning round. "It is not the time for shouting,
still less for dying. We are not safe yet, though the most difficult part of our
undertaking has been accomplished. Your exultation would be noticed from the
city, and then there would be much curiosity among the pages to find out who it
was that was so greatly pleased over the horrible spectacle. During the next few
days they will move heaven and earth to catch the fugitive. Then some one will
be certain to remember the exulting page of to-day."

Jean's advice made such an impression upon Marie that she restrained herself;
but when she found herself within the shelter of the forest and Jean waiting for
her, she could no longer keep still. She flew rather than ran over the green
carpet. Her feelings overcame her when for the first time she found herself in
Nature's majestic temple and felt its subtle and mysterious magic. She fell upon
her knees and poured out a very passion of gratitude to Heaven. She thanked the
Virgin for the happiness of which she had been so long deprived, for her rescue,
and especially for the protection which had been given to her rescuer. Then she
turned to Jean, and her tearful eyes betrayed the emotions of her heart.

"I have no words with which to thank you, gallant knight," said she.

"Oh, my noble lady," replied Jean, "if you only knew how happy it has made me to
have brought you thus far, you would think me recompensed even too richly. But
let us first think of the joy this will bring to the noble La Hire."

"What!" exclaimed Marie, "are you taking me to La Hire?"

"Yes! But let us hurry on, so that we may get out of the English district before
the news of your flight is spread abroad."

They went on again, and shortly met the peasants with whom Jean had left his
horse. He bought another for Marie, and they rode off together. Once more he
safely travelled the dangerous road, and on the next day they had passed the
last city occupied by the English. They met with no difficulties during the rest
of the journey, and after changing their costumes at the lodgings in Chinon,
Jean took Marie to La Hire's apartment.

La Hire was not aware of their arrival at the inn. He was greatly excited, for
he had just heard the news of Joan's death. Aroused to the highest pitch of
fury, he had cursed her enemies, then flung himself into a chair, and seriously
debated whether he should not break his sword rather than serve such a King
longer. He was of too noble a nature, however, to come to such a decision. There
were enemies of the fatherland yet to fight, and he had some other duties to
accomplish. He had just made his decision, when he heard a well-known voice
behind him.

"Here, noble sir, is Marie of Chafleur."

The knight sprang up. Words cannot describe his joy. He stood like a statue,
with his eyes fixed upon her.

"What!" he exclaimed at last, "is this charming girl the little Marie, my
sister's child?" He opened wide his arms, and she flew to his embrace. He kissed
her hair, and lovingly stroked her cheeks.

"My poor child," he gently said, "how you must have suffered!" Marie only
answered with a sigh.

"You shall tell me all about it some other time. Be quiet now, my daughter. From
now on no one shall harm a hair of your head. And this Luxemburg! By Saint
George, he shall make reparation to me for every tear you have shed."

He resumed his seat, and then turned to Jean.

"Come to my heart, my son. I knew that you were as brave and determined and
valiant as any one, but I did not believe you would bring this child back. I am
anxious to know how you did it, but just now I am too full under my doublet to
listen. I believe there are tears running down my beard. I don't know when that
ever happened before. It must be because this is a real heart's joy you have
given me, my boy. Yes, yes, you and poor Joan have both shown what resolute
purpose can do when it is persisted in to the end. Children," he exclaimed to
both of them, "you have made me young again. The end will be fine. Just now I
determined to fight the English still longer, and I know," with a look at Jean,
"who will be with me. But that is not the end I mean. That is only the common
duty. I know a finer end than that." He looked with joyous eyes from Jean to
Marie, and from Marie to Jean. "Yes, a finer end than that, and by Saint George
I will accomplish it."

The valiant knight did accomplish it. Just two years from that day he stood on
the steps of a lordly castle, happier perhaps than he had ever been before in
his life, and watched a carriage which was coming toward the castle amid the
enthusiastic shouts of the peasants. In this carriage the lawful owner of the
castle was making his entrance to take possession, for the English had been
driven out of that whole region.

The master of the castle was Jean Renault, and by his side sat his happy spouse,
Marie of Chafleur.


#align(center)[
  #v(2fr)
  #sym.star\
  #v(-0.5em)
  #sym.star
  #sym.star
  #v(1fr)
]

= Appendix

It is impossible to compile a chronological statement of all the events in the
life of Joan of Arc, as many of the dates are uncertain and some are unknown,
but those given below are measurably accurate.

#list(
  marker: [--],
  [1411, Born at Domremy, France.],
  [1422, Henry VI. of England proclaimed King of France.],
  [1428, The Voices bid Joan to crown the Dauphin and raise the siege of
    Orleans.],
  [1429, Joan goes to the Dauphin and recognizes him as the disguised king; is
    placed in command of the Army; enters Orleans, April 29, and forces the
    English to raise the siege, May 8; subsequently captures Jargeau, Beaugency,
    and other cities, and overwhelmingly defeats the English at Patay; leads the
    Dauphin to Rheims, and assists at his coronation; is ennobled, Dec. 29.],
  [1430, Joan is taken prisoner at Compiègne, May 24.],
  [1431, Joan is sold to the English and delivered by them to the Inquisition,
    Jan. 3; at her first trial is declared guilty of heresy and sorcery and
    sentenced to imprisonment for life; at her second trial upon charges of
    “heresy, relapse, apostasy, and idolatry” is sentenced to be burned at the
    stake; her death, May 30.],
  [1456, Sentence revoked by the Pope.],
  [1904, Preliminary steps toward canonization of Joan taken at Rome.],
)

#set page(footer: none)
#pagebreak()
