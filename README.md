# getting-and-cleaning-data
Repo for peer assessment week 4

You can perform a summary of the data in the `data` directory by running
the `run_analysis.R` script.

This script does the following:

* Merge the data corresponding to the given observations in `data/test` and `data/train`
* Extracts the only variables with measurements of mean and standard deviation
* Adds the subject and activity column to the merged frame
* Cleans the variable names
* And write the file called `tidy_data.txt`

=Note:= You can also uncomment line 84 of the `run_analysis.R` script so you can
have the whole merged data frame :simple_smile: