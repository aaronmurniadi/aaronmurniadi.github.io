#let config(
  column: 2,
  size: 10pt,
  font: "Libertinus Serif",
  paper: "a4",
  title: none,
  authors: (),
  abstract: [],
  doc,
) = {
  // Set and show rules from before.
  set page(
    paper: paper,
    header: context {
      if here().page() == 1 {
        []
      } else {
        [
          #align(
            center + bottom,
            block(inset: (right: 7em, left: 7em))[
              #text(style: "italic", size: 10pt, hyphenate: false)[#title]
            ],
          )
        ]
      }
    },
    numbering: "1",
    margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),
  )

  set par(
    justify: true,
    first-line-indent: 1em,
    leading: 0.50em,
    spacing: 0.75em,
  )

  set text(
    font: font,
    ligatures: true,
    discretionary-ligatures: true,
    size: size,
    spacing: 100% + -1pt,
  )

  show heading.where(
    level: 1,
  ): it => [
    #set align(center)
    #set text(12pt, weight: "semibold", tracking: 0.1em)
    #block(upper(it.body))
    #v(0.5em)
  ]

  show heading.where(
    level: 2,
  ): it => [
    #set align(left)
    #set text(11pt, weight: "semibold")
    #block(it.body)
  ]

  show heading.where(
    level: 3,
  ): it => text(
    size: 10pt,
    weight: "regular",
    style: "italic",
    it.body + [.],
  )

  set footnote.entry(
    indent: 0em,
    gap: 0.5em,
    separator: line(length: 30% + 0pt, stroke: 0.5pt),
    clearance: 1em,
  )

  // title & author list
  let count = authors.len()
  let ncols = calc.min(count, 3)

  place(top + center, float: true, scope: "parent", [
    #set align(center)

    #text(size: 18pt, hyphenate: false, title)

    #v(1.5em)
    #grid(
      columns: (1fr,) * ncols,
      align: center,
      row-gutter: 20pt,
      ..authors.map(author => [
        #author.name \
        #set text(size: 9pt)
        #author.affiliation \
        #link("mailto:" + author.email)
      ]),
    )
    #v(1.5em)
    #text(style: "italic")[*Abstract*]
    #block(inset: (left: 2.5em, right: 2.5em))[
      #par(justify: true)[#abstract]
    ]
    #v(1em)
  ])

  set align(left)

  // Balance the content to make the columns equal height.
  // source: https://forum.typst.app/t/how-to-display-the-table-of-contents-in-two-columns-with-an-even-distribution/4514
  let balance(content) = layout(size => {
    let count = content.at("count")
    let textheight = measure(content, width: size.width).height / count
    let height = measure(content, height: textheight + 9pt, width: size.width).height
    block(height: height, content)
  })
  balance(columns(column)[#doc])
}

#show: document => config(
  column: 2,
  title: [Advancing Theoretical and Computational Approaches for Enhanced Physical Modelling in Complex Systems],
  authors: (
    (
      name: "Theresa Tungsten",
      affiliation: "Artos Institute",
      email: "tung@artos.edu",
    ),
    (
      name: "Eugene Deklan",
      affiliation: "Honduras State",
      email: "e.deklan@hstate.hn",
    ),
    (
      name: "Priya Nandini",
      affiliation: "Calcutta University",
      email: "priya.nandini@caluniv.in",
    ),
    (
      name: "Lucas Meyer",
      affiliation: "ETH Zurich",
      email: "lucas.meyer@ethz.ch",
    ),
    (
      name: "Fatima Al-Mansouri",
      affiliation: "Qatar Research Center",
      email: "f.al-mansouri@qrc.qa",
    ),
  ),
  abstract: [
    This paper presents a novel hybrid methodology that integrates advanced computational algorithms with robust theoretical frameworks to enhance the modeling of complex physical systems. By combining machine learning techniques with traditional simulation approaches, our method achieves improved predictive accuracy and interpretability, particularly in high-dimensional and nonlinear domains. We detail the data collection, preprocessing, and analysis strategies employed, emphasizing the importance of multi-scale and interdisciplinary perspectives. Empirical results demonstrate the scalability and adaptability of our framework across diverse scientific applications, highlighting its potential to bridge the gap between theoretical constructs and practical implementation. The proposed approach offers a significant step forward in the development of flexible, efficient, and interpretable models for complex systems.
  ],
  document,
)

= Introduction
Recent advances in computational modeling have enabled researchers to simulate complex physical systems with unprecedented accuracy and efficiency. These developments have been driven by the integration of high-performance computing, sophisticated algorithms, and robust theoretical frameworks, allowing for the exploration of phenomena previously inaccessible to traditional analytical methods. The present study aims to bridge the gap between theoretical constructs and practical applications by introducing a novel approach that leverages both established and emerging computational paradigms.#footnote[For a comprehensive review of computational modeling in physical sciences, see Smith et al. (2021), which details the evolution of simulation techniques and their impact on scientific discovery.]

By synthesizing insights from multiple disciplines, we propose a methodology that not only enhances predictive capabilities but also improves the interpretability of simulation results. This approach is particularly relevant for systems characterized by high dimensionality and nonlinearity, where conventional techniques often fall short. The following sections outline the theoretical underpinnings, methodological innovations, and empirical validations that collectively advance the state of the art.

The significance of this work lies in its potential to inform both academic research and industrial practice, offering a scalable framework adaptable to a wide range of scientific inquiries.

== Background and Motivation
The study of complex systems has long been a focal point in physics, engineering, and related fields, owing to their ubiquity and the challenges they present. Traditional modeling approaches, while effective in certain contexts, often struggle to capture the intricate interactions and emergent behaviors inherent in such systems.#footnote[Emergent behavior refers to phenomena that arise from the collective dynamics of system components, as discussed in Anderson (1972).]

Recent technological advancements have catalyzed a shift toward more holistic and data-driven methodologies. The motivation for this research stems from the need to develop tools that can accommodate the increasing complexity of modern scientific problems, particularly those involving large-scale simulations and heterogeneous data sources.

=== Prior Approaches
Classical methods, such as finite element analysis and Monte Carlo simulations, have provided valuable insights into system dynamics. However, their applicability is often limited by computational constraints and the assumptions underlying their formulations.#footnote[For example, finite element methods assume linearity and homogeneity, which may not hold in real-world scenarios. See Johnson & Lee (2018) for a discussion of these limitations.]

=== Limitations of Existing Methods
Despite their widespread use, existing computational techniques frequently encounter obstacles when applied to systems with high degrees of freedom or stochastic elements. These challenges manifest as reduced accuracy, increased computational cost, and difficulties in result interpretation. #footnote[Recent studies, such as Wang et al. (2020), highlight the need for more flexible and scalable modeling frameworks to address these issues.]

= Methodology
Our proposed methodology integrates machine learning algorithms with traditional simulation techniques to create a hybrid modeling framework. This approach enables the extraction of meaningful patterns from large datasets while preserving the physical interpretability of the models.
#footnote[The integration of machine learning and physics-based modeling is discussed in detail by Karniadakis et al. (2021).]
The workflow consists of data preprocessing, feature extraction, model training, and validation, each tailored to the specific characteristics of the target system. By iteratively refining the model parameters, we achieve a balance between computational efficiency and predictive accuracy.

== Data Collection
Data were gathered from a combination of experimental measurements and publicly available databases, ensuring a comprehensive representation of the system under study. The dataset includes both time-series and spatially resolved variables, facilitating multi-scale analysis.
#footnote[All experimental protocols were approved by the relevant institutional review boards.]
To minimize bias, data preprocessing steps such as normalization and outlier removal were rigorously applied.

=== Survey Design
The survey instrument was developed in consultation with domain experts to ensure relevance and clarity. Questions were structured to elicit both quantitative and qualitative responses, enabling a nuanced understanding of the phenomena.
#footnote[The survey was piloted with a small group of participants to refine question wording.]
Responses were anonymized to protect participant confidentiality and encourage candid feedback.

=== Sampling Strategy
A stratified sampling approach was employed to capture variability across key demographic and experimental factors. This strategy enhances the generalizability of the findings by ensuring representation from all relevant subgroups.
#footnote[Sampling strata were defined based on prior literature and expert input.]
The final sample size was determined using power analysis to ensure statistical robustness.

== Data Analysis
Data analysis was conducted using a combination of descriptive statistics, inferential tests, and machine learning techniques. The choice of analytical methods was guided by the nature of the data and the research questions posed.
#footnote[All analyses were performed using open-source software packages, including Python and R.]
Results were cross-validated to assess the reliability and reproducibility of the findings.

=== Statistical Methods
Parametric and non-parametric tests were applied as appropriate, with significance thresholds set at conventional levels. Regression models were used to identify key predictors of system behavior.
#footnote[Assumptions of normality and homoscedasticity were checked prior to analysis.]
Model performance was evaluated using standard metrics such as R-squared and mean squared error.

=== Validation Techniques
Model validation involved both internal and external procedures, including split-sample testing and comparison with independent datasets. Sensitivity analyses were conducted to assess the robustness of the results.
#footnote[Validation protocols followed guidelines established by the American Statistical Association.]
Discrepancies between predicted and observed values were systematically investigated.

= Results
The proposed hybrid modeling framework demonstrated superior performance compared to baseline methods, achieving higher predictive accuracy and reduced computational time. Key findings include the identification of previously unrecognized patterns in the data and improved generalizability across different system configurations.
#footnote[Detailed performance metrics are provided in the supplementary materials.]
These results underscore the value of integrating machine learning with traditional simulation techniques in the study of complex systems.

== Quantitative Findings
Statistical analyses revealed significant associations between key variables, supporting the validity of the proposed approach. The hybrid model consistently outperformed conventional methods across multiple evaluation criteria.
#footnote[All reported p-values were below the 0.05 threshold, indicating statistical significance.]
These findings were robust to variations in sample size and data quality, highlighting the versatility of the methodology.

=== Main Outcomes
The main outcomes of this study include the development of a scalable modeling framework, the identification of critical system parameters, and the demonstration of improved predictive capabilities.
#footnote[Future work will focus on extending the framework to additional application domains.]
Collectively, these contributions represent a meaningful advancement in the field of computational modeling.
