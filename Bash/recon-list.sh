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
cat sub sub1 sub2 sub3 sub4 sub5 sub6 | sort -u | anew $target-domains; 

echo "[+] Starting Mutating domains"
cat $target-domains | ripgen -w $permutations | anew tmp;

echo "[+] Resolving Mutated domains"
puredns resolve tmp -r $resolvers -w $target-subdomain;
rm tmp;

echo "[+] Collaborating both the domains"
cat $target-domain $target-subdomain | sort -u | anew $target-subdomains;
rm $target-domain $target-subdomain;

