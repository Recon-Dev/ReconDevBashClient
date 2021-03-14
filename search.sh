#!/bin/bash
#usage ./search.sh <domain> e.g. ./search.sh ford.com
endpoint="https://api.recon.dev/dev/search?apiKey=$1&domain=$2"
results=""
while :
do
        contents=$(curl "$endpoint")
        pageresults=$(echo "$contents" | jq -r '.Results')
        results="$results$pageresults"
        endpoint=$(echo "$contents" | jq -r '.Next_page')
        if [ ${#endpoint} -le 1 ]
        then
                break
        fi
done
# this is the full json results. below is an example of how to modify it to get different outputs
#echo $results | jq -r

# this will output it in a format like so :https://184.50.6.76     www.usarcent.army.mil
# https://184.50.6.76     www.usarec.army.mil
# https://184.50.6.76     www.usarj.army.mil
# https://184.50.6.76     www.usfk.mil
# https://184.50.6.76     www.wv.ng.mil
echo $results | jq -r '.[]|{"ip","dns":(.rawDomains[]|.)} | [.ip,.dns]|@tsv'


# this will output just the domains that end in your search
# finalresults=$(echo "$results" | jq -r '.[]|.domains|.[]' | sort | uniq)

# for i in $finalresults
# do
#       case "$i" in *$1) echo $i;; esac
# done
