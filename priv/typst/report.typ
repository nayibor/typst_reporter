
#let format-table(title,cols,rows) = [
  #set align(center)
  = *#title* Report\
  
  // Medium bold table header.
    #show table.cell.where(y: 0): set text(weight: "medium")

  //for setting a bold header and also showing strokes for specific rows
  #show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  #set table(stroke: (_, y) => if y > 0 { (top: 0.8pt) })
  
  #table(
  columns: { cols.map(col => 1fr) },
  align: center + horizon,
  table.header(..{ cols.map(col => [#col]) },),
  ..rows.map(row => row.map(single => [#single]) ).flatten()
  ),

]

#let report-from-metadata(row-dict,col-dict,title, ..extra-blog-args) = {
  let rows = row-dict
  let columns = col-dict
  let title = title
  
  //contains code for formatting and displaying the table
  let tableDisplay = format-table(title,columns,rows)
  tableDisplay

 }