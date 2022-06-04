#!/bin/bash 

target="$1"
resolvers="/opt/tools/wordlists/resolvers.txt"
brutelist="/opt/tools/wordlists/dns"
permlist="/opt/tools/wordlists/perm"
ports="80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152"

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

echo "Running httpx"
httpx -l $target-domains -p $ports -include-chain -store-chain -sc -tech-detect -server -title -cdn -cname -probe -threads 100 -o $target-httpx;

echo "Running Nuclei"
nuclei -l $target-httpx -o $target-nuclei;

echo "Running Jaeles"
xargs -a $target-httpx -I% sh -c 'jaeles scan -c 50 -u % -s ~/pro-signatures' | tee jaeles.log
