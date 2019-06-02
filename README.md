# dnssec-signed-zone-auto-bot

dnssec-signed-zone-auto-bot

![alt text](https://s3-ap-southeast-1.amazonaws.com/s3.paov6.com/dnssec-auto-bot/DNSSEC.jpg)

# How to use

1.Download this script.<br />
2.Copy into your zone file directory (for me /var/cache/bind).<br />
3.in zone file directory , you must store KSK,ZSK Key.<br />
4.Change some parameter , etc zone name , zone file , ... <br />
5.If you want to send report , you must install mail server service (for me postfix). in this script report send by sendmail command. <br />
4.run $ chmod +x dnssec-signed-zone-auto-bot.sh <br />
5.add cronjob by $ crontab -e <br />
5.setup cronjob <br />
6.Done!! <br />

# Update History

V1.1 -> Add Change work directory to /var/cache/bind/
