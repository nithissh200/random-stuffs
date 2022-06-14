#!/bin/bash
target=$1
wordlists=/opt/tools/wordlists/dns
resolvers=/opt/tools/wordlists/resolvers.txt
permutations=/opt/tools/wordlists/perm

echo "[+] Starting Subdomain Enumeration"
subfinder -dL $target -o sub;
cat $target | assetfinder -subs-only | tee sub1;
findomain -f $target -u sub2;
cat $target | while read domain; do crobat -s $target | tee sub3; done
cat $target | yusub | tee sub4;
amass enum -passive -df $target -o sub5;

echo "[+] Started Subdomain Bruteforcing"
cat $target | while read domain; do shuffledns -d $domain -w $wordlists -r $resolvers -silent | tee sub6; done ;

echo "[+] Sorting out both Enumerated domains and Bruteforced domains into single file"
cat sub sub1 sub2 sub3 sub4 sub5 sub6 | sort -u | anew output-domains; 

echo "[+] Starting Mutating domains"
cat output-domains | ripgen -w $permutations | anew tmp;

echo "[+] Resolving Mutated domains"
puredns resolve tmp -r $resolvers -w output-subdomain;
rm tmp;

echo "[+] Collaborating both the domains"
cat output-domain output-subdomain | sort -u | anew output-subdomains;
rm output-domain output-subdomain;

echo "[+] Running a portscan"
unimap -f output-subdomains --min-rate 10000 --fast-scan --ports "0-65535" -q --url-output | tee output-portscan;

echo "[+] Running a HTTPx on a portscan for getting complete information about the tech"
httpx -l output-portscan -cl -ct -location -title -td -method -cname -fr -tld-probe -csp-probe -server -threads 100 -o output-httpx-info;
cat $target-httpx-info | awk '{print $1}' | tee $target-httpx-results;

echo "[+] Started taking screenshots using Gowitness"
gowitness file -f output-httpx-result  --chrome-path /snap/bin/chromium -F -P ./output-screenshots;

echo "[+] Running nuclei"
nuclei -l output-httpx-results -o $target-nuclei-results;

echo "[+] Running Jaeles"
xargs -a output-httpx-results -P 40 -I% sh -c 'jaeles scan -u % -s ~/pro-signatures -c 20' | tee output-jaeles.log
