#!/bin/bash

RED='\033[0:31m'

if [ $# -lt 4 ]; then
	echo -e "\e[31mERROR\e[0m"
	echo "Usage: ./pullNodes [db_name] [migration_table_name] [base_url]"
	echo "Usage: ./pullNodes [db_name] [migration_table_name] [new_base_url] [old_base_url]"
	exit
fi

# This one's a doosy:            
#1) DRUSH command to select the correct database and table from SQL server
#2) pipes to sed to add 1st URL
#3) pipes to sed to add second URL
#4) strips first line (SQL column names)
#5) then redirects to text file
drush @aoda.$1.dev sql-query "SELECT sourceid1,destid1 from "$1"."$2"" \
| sed -e 's_^[0-9]*_'$3'/node/&_' \
| sed -e 's_[0-9]*$_ '$4'/node/&_' \
| sed -n '2,$p' \
> nodelists/$1-nodelist.txt