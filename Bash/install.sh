#!/bin/bash

[+] Installing update and dependencies
sudo apt install -y libpcap-dev;
sudo apt update -y && sudo apt update -y;
sudo apt install golang-go;

[+] Installing Golang tools
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest;
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest;
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest;
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest;
go install -v github.com/projectdiscovery/notify/cmd/notify@latest;
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest;
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest;
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest;
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest;
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest;
go install github.com/hakluke/hakrawler@latest;
go install github.com/hakluke/hakrevdns@latest;
go install github.com/d3mondev/puredns/v2@latest;
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest;
go install github.com/tomnomnom/assetfinder@latest;
GO111MODULE=on go get github.com/evilsocket/ditto/cmd/ditto;
go get -u github.com/bp0lr/dmut;
go install github.com/haccer/subjack@latest;
go install github.com/bp0lr/gauplus@latest;
go install github.com/tomnomnom/waybackurls@latest;
go install github.com/tomnomnom/httprobe@latest;
go install github.com/tomnomnom/meg@latest;
go install github.com/003random/getJS@latest;
go get -u -v github.com/shivangx01b/CorsMe;
GO111MODULE=on go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest;
go install github.com/ffuf/ffuf@latest;

[+] Installing Python tools
mkdir /opt/tools;
cd /opt/tools;
git clone https://github.com/devanshbatham/OpenRedireX;
git clone https://github.com/defparam/smuggler;
git clone https://github.com/Evil-Twins-X/SubEvil;
pip3 install apkleaks;
git clone https://github.com/mathis2001/Sp00fy;
git clone https://github.com/maurosoria/dirsearch;
git clone https://github.com/devanshbatham/ParamSpider;
git clone https://github.com/Th0h0/autossrf;
git clone https://github.com/Th0h0/autoredirect;
git clone https://github.com/relarizky/ReverseIP;
git clone https://github.com/eslam3kl/crtfinder;
git clone https://github.com/0xtavian/get_acquisitions.py;
git clone https://github.com/h4rithd/imp-fuzzer;
git clone https://github.com/DEMON1A/Blinder;
