##Nikeplus

These are some scripts to collect tweets posted by people who track their runs using Nike+

##How to run

Edit nike.rb and add your Twitter api credentials. 
Set up mongodb if you don't have it. 
Start nike.rb and leave it running long enough to collect tens of thousands of tweets.

[hours / days later]

Run histogram.rb to process the tweets in the db, get some stats, and generate the inputs for the R charts.

Run "Rscript charts.R" to generate the charts.
