#! /bin/bash          

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/

if [ ! -d $Path/s ]; then mkdir -p $Path/s; fi

while read -r url && read -r output <&3; do
	curl \
		--url `echo $(eval "echo $url")` \
		--output $Path"s/"`echo $(eval "echo $output")`".ht"
done < $HOME/Fund/WhatDownload/urls 3< $HOME/Fund/WhatDownload/outputfile

#while IFS=' ' read url output
#do
#	curl \
#		--url `echo $(eval "echo $url")` \
#		--output `echo $(eval "echo $output")`
#done < ./WhatDownload/Sber
