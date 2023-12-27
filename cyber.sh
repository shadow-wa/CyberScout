#!/bin/bash

####################################
########Color output ###############
RESET="\e[0m"
GRAY="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"

#################################### functions ##############################
banner () {
                                clear
echo -e "${RED}   ____      _               ____                  _  __  __    _            ${REST}"
echo -e "${RED}  / ___|   _| |__   ___ _ __/ ___|  ___ ___  _   _| |_\ \/ /   | |__  _   _  ${REST}"
echo -e "${RED} | |  | | | | '_ \ / _ \ '__\___ \ / __/ _ \| | | | __|\  /    | '_ \| | | | ${REST}"
echo -e "${RED} | |__| |_| | |_) |  __/ |   ___) | (_| (_) | |_| | |_ /  \    | |_) | |_| | ${REST}"
echo -e "${RED}  \____\__, |_.__/ \___|_|  |____/ \___\___/ \__,_|\__/_/\_\___|_.__/ \__, | ${REST}"
echo -e "${RED}       |___/                                              |_____|     |___/  ${REST}"
echo -e "${GREEN}                                                            Created By :- Shad Warsi ${REST}"
}

divider () {
echo
echo -e "${PURPLE}======================================================${RESET}"
echo
}

help () {
clear
banner
echo
echo -e "USAGE:$0[DOMAIN...] [OPTIONS...]"
echo -e "\t-h , --help Help menu"
echo -e "\t-hx , --httpx Get live domains"
echo -e "\t-u , --urls Get all the urls"
echo -e "\t-p , --parameter Get paameter"
echo -e "\t-w , --wayback Get wayback data"
echo -e "\t--whois Get whoisdata"
echo -e "\t-ps , --portscan Get Port Scanning"
echo

}
############################### Variables ###################################

DOMAIN=$1

if [ $# -eq 0 ] || [ $# -eq 1 ]
then
help
exit 1
fi

if ! [ -d "$DOMAIN" ]
then
mkdir $DOMAIN
cd $DOMAIN
else
echo -e "${RED}Diretory already exists.....Exiting.......${RESET}"
exit 2
fi

#####################Script ########################

banner
divider
echo -e "${BLUE}[-]gathering sub-domain form internet.....${RESET}"
subfinder -silent -d $DOMAIN >> sub_domains.txt
assetfinder $DOMAIN >> sub_domains.txt

VALID_DOMAINS=`cat sub_domains.txt | sort -u`

echo
echo "$VALID_DOMAINS" | tee sub-domains.txt
echo
echo -e "${GREEN}[+]Subdomain gathering completed...${RESET}"
rm sub_domains.txt

##################### case #####################

while [ $# -gt 0 ]
do
case "$2" in
"-h" | --help )
help
exit 4
;;

"-hx" | "--httpx" )
echo -e "${BLUE}[-]Running httpx...${RESET}"
cat sub-domains.txt | httpx | tee live_domain.txt
echo -e "${GREEN}[+]Live sub-domains gathered.........${RESET}"
divider
shift
shift
;;

"-u" | "--url" )
echo -e "${BLUE}[-]Gathering urls from gau.....${RESET}"
gau $DOMAIN | tee urls.txt
echo -e "${GREEN}[+]URLS Gathered......${RESET}"
divider
shift
shift
;;

"-p" | "--parameter" )
echo -e "${BLUE}[-]Gathering parameters using Parameters.....${RESET}"
python3 /home/kali/Desktop/tools/ParamSpider/paramspider.py -d $DOMAIN | tee parameter.txt
echo -e "${GREEN}[+]Parameter Gathered....${RESET}"
divider
shift
shift
;;

"-w" | "--wayback" )
echo -e "${BLUE}[-]Gathering way back data ...${RESET}"
waybackurls $DOMAIN | tee waybackurls.txt
echo -e "${GREEN}[+]Waybackurl Gathered...${RESET}"
divider
shift
shift
;;
"--whois" )
echo -e "${BLUE}[-]Gathering whois from whois.com ...${RESET}"
curl -s https://www.whois.com/whois/$DOMAIN | grep -A 70 "Registry Domain ID:" | tee whois.txt
echo -e "${GREEN}[+]Whois data Gathered ...${RESET}"
divider
shift
;;

"-ps" | "--portscan" )
echo -e "${BLUE}[-]Scanning for Open Ports ...${RESET}"
naabu -silent -host $DOMAIN | tee openport.txt
echo -e "${GREEN}[+]Scanning is Completed ...${RESET}"
divider
shift
shift
;;
esac
done
#################################################################
divider
echo -e "${BLUE} RECON COMPLETED ...${RESET}"
divider