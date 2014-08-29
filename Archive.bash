#!/bin/bash

mkdirName(){
	for word in $1
		do
			if [[ $dirName != '' ]]
				then	
					dirName="${dirName}_${word}"
				else
					dirName="${word}"
			fi
	done
} 

########
# MAIN #
########

ARCHIVE='archive'

if [[ $(find . -maxdepth 1 -name "*.html" | wc -l) > 0 ]]
	then
		archives=$(ls $ARCHIVE)
		date=$(date | cut -d' ' -f2-4,6)
		dirName=''
		mkdirName "$date"
		$(mkdir $ARCHIVE/$dirName)
		$(cp -r *.html $ARCHIVE/$dirName)
		$(/bin/bash ./support/Clean.bash)
fi
