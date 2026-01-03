---
date: 2026-01-01
last_modified_date: 2026-01-01
title: Get font family and sizes from PDF
layout: post
---

I have a hobby[^1] of recreating the typesetting of beautiful documents in
[LaTeX](<[https://www.latex-project.org/](https://www.latex-project.org/)>) or,
more recently, [Typst](<[https://typst.app/](https://typst.app/)>). The first
step is to obtain the PDF source; ideally, this is the true PDF and not a scan
of the document. The next step is to find the paper size, which is fairly easy
to do by checking the document properties. The hard part is identifying the
fonts the PDF was typeset in, including the specific font sizes. To help with
this, I turned to [GoogleGemini](<[https://gemini.google.com/](https://gemini.google.com/)>) to create a
Python script that analyzes the PDF and prints the page size, with the font name
and size for each paragraph.

[^1]: You can see more of my typesettings [here](/typst-collection).

```python
from pdfminer.high_level import extract_pages
from pdfminer.layout import LTTextContainer, LTChar

# Path to the PDF file, can be full or relative path
path = r'25-180_8m59.pdf'

for page_no, page_layout in enumerate(extract_pages(path), 1):

    # PDF coordinates are in points (1 inch = 72 points)
    width_pt = page_layout.width
    height_pt = page_layout.height

    # Convert to Inches
    w_in = round(width_pt / 72, 2)
    h_in = round(height_pt / 72, 2)

    # Convert to Centimeters
    w_cm = round(width_pt * 2.54 / 72, 2)
    h_cm = round(height_pt * 2.54 / 72, 2)

    # Print the formatted page header (Inches and CM included)
    print(f"========= [PAGE {page_no} ({w_in} x {h_in} in / {w_cm} x {h_cm} cm)] ==========\n")

    for element in page_layout:
        if isinstance(element, LTTextContainer):
            font_size = 0
            font_name = "Unknown"

            for text_line in element:
                if hasattr(text_line, '__iter__'):
                    for character in text_line:
                        if isinstance(character, LTChar):
                            font_size = character.size
                            font_name = character.fontname
                            break
                elif isinstance(text_line, LTChar):
                    font_size = text_line.size
                    font_name = text_line.fontname

                if font_size > 0:
                    break

            clean_text = element.get_text().strip()
            if clean_text:
                # Keep font size in points as it is the standard for typography
                print(f"[{font_name}, {round(font_size, 1)}] {clean_text}\n")
```

I am using the document
[25-180 Doe v. Dynamic Physical Therapy, LLC (12/08/2025)](<[https://www.supremecourt.gov/opinions/25pdf/25-180_8m59.pdf](https://www.supremecourt.gov/opinions/25pdf/25-180_8m59.pdf)>)
from the
[Supreme Court of the United States](<[https://www.supremecourt.gov/](https://www.supremecourt.gov/)>)
as an example. The output is as follows:

```shell
========= [PAGE 1] ==========

[PDDHNP+CenturySchoolbook, 9.0] Cite as:  607 U. S. ____ (2025)

[PDDHNP+CenturySchoolbook, 9.0] 1

[PDDHNP+CenturySchoolbook, 9.0] Per Curiam

[TimesNewRomanPS-BoldMT, 15.0] SUPREME COURT OF THE UNITED STATES

[PDDHNP+CenturySchoolbook, 11.0] JOHN DOE v. DYNAMIC PHYSICAL
THERAPY, LLC, ET AL.

[PDDHNP+CenturySchoolbook, 9.0] ON PETITION FOR WRIT OF CERTIORARI TO THE COURT
OF APPEAL OF LOUISIANA, FIRST CIRCUIT

[PDDHNP+CenturySchoolbook, 9.0] No. 25–180.  Decided December 8, 2025

[PDDHNP+CenturySchoolbook, 11.0] PER CURIAM.
Louisiana immunizes healthcare providers from civil lia-
bility during public health emergencies.  La. Rev. Stat. Ann.
§29:771(B)(2)(c)(i) (West 2022).  Below, the Louisiana Court
of Appeal held that this state statute barred plaintiff ’s fed-
eral  claims.    2024–0723,  pp. 11–12  (1  Cir.  12/27/24),  404
So. 3d  1008,  1017–1018,  writ  denied,  2025–00105  (La.
4/29/25), 407 So. 3d 623.  That decision is incorrect.  Defin-
ing the scope of liability under state law is the State’s pre-
rogative.  But a State has no power to confer immunity from
federal causes of action.  See, e.g., Howlett v. Rose, 496 U. S.
356,  383  (1990);  Haywood  v.  Drown,  556  U. S.  729,  740
(2009); Williams v. Reed, 604 U. S. 168, 174 (2025).  “[T]he
Judges in every State” are bound to follow federal law, “any
Thing in the Constitution or Laws of any state to the Con-
trary notwithstanding.”  U. S. Const., Art. VI, cl. 2.
  Plaintiff ’s  federal  claims  may  well  fail  on  other  federal
grounds.  Cf. Cummings v. Premier Rehab Keller, 596 U. S.
212, 222 (2022).  But that is for the Louisiana courts to de-
cide  in  the  first  instance.    The  petition  for  certiorari  is
granted, the judgment of the Louisiana Court of Appeal is
reversed, and the case is remanded for further proceedings
not inconsistent with this opinion.

[PDDIAE+CenturySchoolbook-Italic, 11.0] It is so ordered.
```

Success! Now I can move on to the challenging task of mimicking the elegant
layout of this document.

If you ever ventured in this hobby, I hope this helps you out.

Cheers!
