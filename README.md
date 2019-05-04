# dnssec-signed-zone-auto-bot
dnssec-signed-zone-auto-bot

# How to use

1.Download this script.
2.Copy into your zone file directory (for me /var/cache/bind).
3.in zone file directory , you must store KSK,ZSK Key.
4.Change some parameter , etc zone name , zone file , ...
5.If you want to send report , you must install mail server service (for me postfix). in this script report send by sendmail command.
4.run $ chmod +x dnssec-signed-zone-auto-bot.sh
5.add cronjob by $ crontab -e
5.setup cronjob
6.Done!!
