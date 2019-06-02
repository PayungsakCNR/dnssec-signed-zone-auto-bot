#/bin/sh

##### DNSSEC-SIGNED-ZONE-AUTO-BOT #####
# Dev : Payungsak Klinchampa (PaOv6.)
# Version : 1.1
# pao@payungsakpk.xyz
######################################

## Zone parameters.
ZONE=example.com     ## Your zone name.
ZONEFILE=example.com.zone  ## Your Zone file.
ZONEFILE_DNSSEC=$ZONEFILE.signed
SALT=`head /dev/urandom | tr -dc a-z0-9 | sha1sum |head -c 16` ## Random NSEC3 string
SERIAL_ORI=`/usr/sbin/named-checkzone $ZONE $ZONEFILE | egrep -ho '[0-9]{10}'`


## Bind9 Service parameters.
SERVICE_NAME=named
BIND9_STATUS=IDontKnow
FILE_TEMP_NAME=temp.sendmail.$ZONE

## Email parameters.
EMAIL_TO='admin@example.com' ## Send Report to this email
EMAIL_FROM='DNSSEC-SIGNED-REPORT<dnssec-signed-report@example.com>' ## Send Report from this email.

########### Initial ###############

# Change work directory
cd /var/cache/bind/

## delete all content in file
cat /dev/null > $FILE_TEMP_NAME

echo "SERIAL Original = " $SERIAL_ORI
echo "SALT = " $SALT

printf "\n";
printf "\n";

echo "Signed Zone Statistic"

## START SIGN ZONE
/usr/sbin/dnssec-signzone -A -3 $SALT -N date -o $ZONE -t $ZONEFILE > $FILE_TEMP_NAME

## Read new Serial 
SERIAL_NOW=`/usr/sbin/named-checkzone $ZONE $ZONEFILE_DNSSEC | egrep -ho '[0-9]{10}'`

echo "SERIAL New = " $SERIAL_NOW

sed -i 's/'$SERIAL_ORI'/'$SERIAL_NOW'/' $ZONEFILE  ##Update Serial into zone file.

SERIAL_FROM_FILE=`grep $SERIAL_NOW $ZONEFILE`

echo "Serial from " $ZONEFILE "is" $SERIAL_FROM_FILE

## Copy Signed zone into /etc/bind/zones/
cp /var/cache/bind/$ZONEFILE_DNSSEC /etc/bind/zones/

## Reload Bind9 Service
service bind9 reload

## Get bind9 [named] service status
i=`ps -eaf | grep -i $SERVICE_NAME |sed '/^$/d' | wc -l`

## Check bind9 service status
if [[ $i > 1 ]]
then
  echo $SERVICE_NAME "service is running"
  BIND9_STATUS='Active'
else
  echo $SERVICE_NAME "service not runnig"
  BIND9_STATUS='Dead!!'
fi


## Add Mail Header , Message to temp.dnssec file
sed -i '1s/^/\n/' $FILE_TEMP_NAME
sed -i '1s/^/Bind9 service status: '$BIND9_STATUS'\n/' $FILE_TEMP_NAME
sed -i '1s/^/Zone serial: '$SERIAL_NOW'\n/' $FILE_TEMP_NAME
sed -i '1s/^/Zone name: '$ZONE'\n/' $FILE_TEMP_NAME
sed -i '1s/^/\n/' $FILE_TEMP_NAME
sed -i '1s/^/This is Result from DNSSEC-SIGNED-ZONE Auto Script\n/' $FILE_TEMP_NAME
sed -i '1s/^/Hello,Admin\n/' $FILE_TEMP_NAME
sed -i '1s/^/\n/' $FILE_TEMP_NAME
sed -i '1s/^/From: '$EMAIL_FROM'\n/' $FILE_TEMP_NAME
sed -i '1s/^/Subject: DNSSEC-SIGNED-REPORT - '$SERIAL_NOW'\n/' $FILE_TEMP_NAME
sed -i '1s/^/To: '$EMAIL_TO'\n/' $FILE_TEMP_NAME

## Add end of file message
echo "" >> $FILE_TEMP_NAME
echo "Have a good day!!" >> $FILE_TEMP_NAME
echo "DNSSEC-SIGNED-REPORT AUTO BOT" >> $FILE_TEMP_NAME
echo "." >> $FILE_TEMP_NAME
echo "" >> $FILE_TEMP_NAME



## Send mail
/usr/sbin/sendmail -t < $FILE_TEMP_NAME
