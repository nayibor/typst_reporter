
  
#let format-session-matter(blog-info) = [
  = Blog Details
  #line(length: 100%)  
  #v(1em)  
  *Id*: #blog-info.id\

  *Title*: #blog-info.title\	

   *Body*:
  
   #blog-info.body\
  
]


#let report-from-metadata(row-dict,col-dict, ..extra-blog-args) = {
  let rows = row-dict
  let columns = col-dict
  //contains  code for displaying blog information
  //let sessionmatter = format-session-matter(meta)
  //sessionmatter
  
 }