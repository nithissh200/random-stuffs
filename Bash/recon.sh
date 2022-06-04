#!/bin/bash 

target="$1"
resolvers="/opt/tools/wordlists/resolvers.txt"
brutelist="/opt/tools/wordlists/dns"
permlist="/opt/tools/wordlists/perm"

echo "Updating the system"
sudo apt update -y && sudo apt upgrade -y;

echo "Started Subdomain enumeration"
subfinder -d $target -all -o sub;
assetfinder -subs-only $target | tee sub1;
findomain -t $target -u sub2;
yusub $target  | tee sub3;
crobat -s $target | tee sub4;
amass enum -passive -noalts -norecursive -d $1 -o sub5;
puredns bruteforce $brutelist $target -r $resolvers -w sub6;

echo "Sorting out all the results from subdomain enumeration"
cat sub sub1 sub2 sub3 sub4 sub5 sub6 | sort -u >> $target-domains;
rm sub sub1 sub2 sub3 sub4 sub5 sub6;

echo "Starting recursive enumeration"
for sub in $( ( cat $target-domains | rev | cut -d '.' -f 3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 && cat subdomains.txt | rev | cut -d '.' -f 4,3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 ) | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2);do 
subfinder -d $target -silent | anew -q passive.txt 
assetfinder --subs-only $target | anew -q passive.txt
amass enum -passive -d $target | anew -q passive.txt
findomain --quiet -t $target | anew -q passive.txt
done

echo "Sorting out both recurisve and subenum resukts"
cat $target-domains passive.txt | sort -u >> domains;
rm $target-domains passive.txt;
mv domains $target-domains;

echo "Starting Permutations"
cat $target-domains | ripgen -w $permlist | anew tmp;
puredns resolve tmp -r $resolvers -w $target-subdomains;

echo "Sorting out all the domains"
cat $target-domains $target-subdomains | sort -u >> $target-domain;
rm $target-domains $target-subdomains;
mv $target-domain $target-domains;

echo "Started screenshotting"
cat $target-domains | aquatone -chrome-path /snap/bin/chromium -out $target-screenshots;

echo "Running Unimap"
unimap -f $target-domains --min-rate 10000 --fast-scan --ports "0-65535" -q --url-output | tee $target-portscan.txt;

echo "Running HTTPx"
httpx -l $target-portscan.txt -include-chain -store-chain -sc -tech-detect -server -title -cdn -cname -probe | tee $target-httpx-results.txt
