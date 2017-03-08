### Some profesional software may export a template, 
##    which is not standard csv or json, but in some strangely formated plain text. 
##  We want to periodically export a new version of the template, and make our own customization,
##    and re-import the template into the software to be processed.

##  This script is to get around the massive manual and fussy works, making the whole thing more automated,
#     while also keeping track of all the historical versions of the templates and customizations.

##  Weekly or daily, we export a new version of template from the software, with updated universal settings.
##   So we keep track of the software-exported templates, named like "Template_from_Software_v01.txt". 
#     As time goes by, we will have v02, v03 and so on, usually renewed after a moderate period.

##  In the end of this script, we write out the modified template as a new plain text file,
#    named like "Template_from_Excel_v01.txt", where v01 may become v02, v03, and so on.
#    So we also keep track of the customised templates.
#    This one may be modified much more frequently, as we may want to test many parameter settings.

##  For more advanced use, the strings like "v01" can be replaced with date and time strings.

##### Code start
#  The working directory
my_file_path = "C:/Users/me/Documents/myworkdirectory"

# Name patterns
file_pattern_0 = "Template_from_Software_*"
file_pattern_1 = "Template_from_Excel_*"

# Read in the templates exported from Software
filenames = list.files(path=my_file_path, pattern=file_pattern_0, full.names=TRUE, include.dirs=TRUE)
file_details = file.info(filenames, extra_cols = FALSE)
filenames = rownames(file_details)[order(file_details$mtime, decreasing = T)]
last_template = filenames[1]
rm(file_details)
rm(filenames)
con = file(last_template)
filetext = readLines(con)
close(con)


# change the filetext object
#  Here fill in the code to modify the template based on my customized parameter settings.
#  line1 = filetext[1]
#  filetext[length(filetext)+1] = "haha"
#  filetext[length(filetext)]
# ... 
#  


# After doing the work, also update the date-time information inside the template text:
now_date = format(Sys.Date(), "%d/%m/%Y")
now_time = substr(Sys.time(), 12, 19)
dateline = filetext[grep("Date:", filetext)]
filetext[grep("Date:", filetext)] = paste0(
                                      substr(dateline, 1, gregexpr("Date:", dateline)[[1]][1]+5), 
                                      now_date, 
                                      substr(dateline, gregexpr("Date:", dateline)[[1]][1]+16, nchar(dateline))
                                      )
timeline = filetext[grep("Time:", filetext)]
filetext[grep("Time:", filetext)] = paste0(
                                      substr(timeline, 1, gregexpr("Time:", timeline)[[1]][1]+5), 
                                      now_time, 
                                      substr(timeline, gregexpr("Time:", timeline)[[1]][1]+14, nchar(timeline))
                                      )

#  Write the updated template to a new version. Version number + 1.

filenamesE = list.files(path=my_file_path, pattern=file_pattern_1, full.names=TRUE, include.dirs=TRUE)
file_detailsE = file.info(filenamesE, extra_cols = FALSE)
filenamesE = rownames(file_detailsE)[order(file_detailsE$mtime, decreasing = T)]
last_filename = filenamesE[1]
rm(filenamesE)
rm(file_detailsE)
pos1 = gregexpr(pattern ='from_Excel_v', last_filename)[[1]][1] + 12
pos2 = gregexpr(pattern ='.csv', last_filename)[[1]][1] - 1
last_version = substr(last_filename, pos1, pos2)
last_version = as.numeric(last_version)
this_version = last_version + 1
if (this_version < 10) {
    this_version = paste0(0, this_version)
}
new_template_name = paste0("Template_from_Excel_v", this_version, ".csv")

## Finally, write out the customized template.
writeLines(filetext, con = file(new_template_name), sep = "\n")
