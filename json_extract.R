library(jsonlite)
options(encoding="UTF-8")

# This function takes a vector of strings which are in json text format, and return a data frame based on a udf defined for a single json text element.

# UDF1: a json extraction function, returns a named list from a single json text element.
# just fill in this UDF1 function with your own code.

UDF1 = function(jsontxt) { 
  
  Encoding(jsontxt) = "UTF-8"   #  in case it's still not in UTF
  
  if (jsonlite::validate(jsontxt)) {
    js1 = jsonlite::fromJSON(jsontxt)
    if(is.character(js1)){js1 = jsonlite::fromJSON(js1)}
   
    ## here add code to extract the fields of interest
    name1 = if (is.null(js1$something)) NA else something
    name2 = if (is.null(js1$somethingelse)) NA else somethingelse
    
  } else {
  
    # use NA or "" or 0 where appropriate
    name1 = NA
    name2 = NA
    
  }
  
  list(name1 = name1, name2 = name2)
}


json_extract = function(data_column) {

  df1 = data.frame(t(sapply(data_column, UDF1, simplify=T, USE.NAMES = F)))   # UDF1 is defined above
  
  for (i in 1:ncol(df1)) {
    # i=1
    df1[[i]][sapply(df1[[i]], is.null)] = NA
    df1[[i]][sapply(df1[[i]], is_blank)] = NA          # is_blank is defined below.
    df1[[i]] = unlist(df1[[i]])
  }
  
  df1
}


is_blank = function(x) {length(x) == 0}                 # is_blank(): logical, is a vector blank.




