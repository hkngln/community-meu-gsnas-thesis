// Table cases from the v0.5.0 review: the "(devamı)" mechanism must not touch
// the user's table (subheaders, labels, y-indexed settings) and must not label
// the first piece of a table whose caption sits at the bottom of a page.
#import "../lib.typ": *

#show: thesis.with(front-cover: false, back-cover: false, two-sided: false)

= GİRİŞ

#figure(
  table(
    columns: 2,
    table.header([SA], [SB]),
    table.header(level: 2, table.cell(colspan: 2)[SUBHEADER-X]),
    [s1], [s2],
  ),
  caption: [Subheader],
)

#figure([#table(columns: 2, [LA], [LB]) <labeled-table>], caption: [Labeled])

#figure(
  table(columns: 2, table.header([HA], [HB]), table.cell(x: 0, y: 1)[CELL-Y1], [c]),
  caption: [Explicit cell position],
)

#pagebreak()
#v(23cm)

#figure(
  table(columns: 2, table.header([H-A], [H-B]), ..range(40).map(i => ([ROW-#i], [v])).flatten()),
  caption: [Starts at the bottom],
)
