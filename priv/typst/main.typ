#import sys.inputs.templatePath: report-from-metadata


#let rowData = json.decode(sys.inputs.rowData)
#let colData = json.decode(sys.inputs.colData)
#report-from-metadata(rowData,colData, apply-default-style: true)