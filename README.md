# dnssec-signed-zone-auto-bot
dnssec-signed-zone-auto-bot

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
