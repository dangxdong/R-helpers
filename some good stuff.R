# This file includes some usefull little tools

# Get the path containing this script
args = commandArgs(trailingOnly = F)
my_path_kafka_resubmit = normalizePath(dirname(sub("^--file=", "", args[grep("^--file=", args)])))


# Get arguments from shell when run the Rscript from terminal.
arguments = commandArgs(TRUE)
if (length(arguments) > 0) {
  my_argument1 = as.character(arguments[1])
} else {
  my_argument1 = "default value"
}

