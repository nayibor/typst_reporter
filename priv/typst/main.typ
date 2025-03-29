#import sys.inputs.templatePath: report-from-metadata


#let rowData = json.decode(sys.inputs.rowData)
#let colData = json.decode(sys.inputs.colData)
#let title = json.decode(sys.inputs.title)
#report-from-metadata(rowData,colData,title, apply-default-style: true)