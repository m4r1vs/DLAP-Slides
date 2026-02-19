#let accentColor = color.linear-rgb(0, 136, 189)
#let page-header(title) = {
  context [
    #set text(size: 12pt)
    #block(width: 100%, fill: white, height: 74pt)[
      #grid(
        columns: (1fr, 7fr, 1fr),
        fill: white,
        align(left, image("./assets/logo_uhh_notext.svg", height: 60%)),
        align(left + horizon, [
          #v(16pt)
          #text(title, size: 22pt, fill: color.linear-rgb(40, 40, 40))
        ]),
        align(right, image("./assets/logo_sp_stone.svg", height: 35%)),
      )
      #line(
        length: 200%,
        start: (-1in, 0pt),
        end: none,
        stroke: 2pt + accentColor,
      )
    ]
  ]
}

#let title-page(title: [], subtitle: [], authors: [], faculty: [], body) = {
  /*
   * TITLE PAGE
   * */
  set page(
    margin: (right: 1in, left: 1in, top: 2in),
    paper: "a4",
    fill: color.linear-rgb(12, 20, 26),
    header: context [
      #block(width: 100%, fill: white, height: 74pt, outset: (
        x: 1in,
        top: 1in,
        bottom: 0.5in,
      ))[
        #grid(
          columns: (1fr, 1fr),
          fill: white,
          align(left, image("./assets/logo_uhh.svg", height: 74%)),
          align(right, image("./assets/logo_sp_stone.svg", height: 78%)),
        )
      ]
    ],
  )
  set text(
    font: "Public Sans",
    size: 12pt,
    fill: white,
    weight: "extrabold",
    lang: "en",
  )
  set heading(numbering: "1.1.1", supplement: metadata("Shown"))
  align(horizon + left)[
    #text(size: 28pt, title)\
    #v(1em)
    #text(size: 16pt, subtitle)
  ]
  align(bottom + left)[
    #authors\
    #datetime.today().display("[day].[month].[year]")
  ]

  pagebreak()

  /*
   * CONTENT
   * */

  set list(
    marker: (text("■", fill: accentColor, size: 20pt), [-]),
    spacing: 0.5in,
  )
  set text(
    font: "Public Sans",
    size: 9pt,
    fill: black,
    weight: "medium",
    top-edge: 1em,
  )
  set page(
    margin: (right: 1in, left: 1in, top: 1.7in),
    fill: color.linear-rgb(255, 255, 255),
    footer: context [
      #align(right, text(counter(page).display("1/1", both: true), size: 8pt))
    ],
  )
  set enum(indent: 2em)
  set par(spacing: 1.3em, justify: true)

  body

  pagebreak()

  /*
   * BIBLIOGRAPHY
   * */

  set page(header: page-header("References"))
  set text(font: "Public Sans", size: 9pt)
  bibliography("bib.yaml", full: false, title: none)
}

#show figure: it => {
  it.body
  block[
    #set text(size: 12pt)
    #text(it.caption)
  ]
}

#show cite: it => {
  super(it)
}
