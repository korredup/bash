#!/bin/bash

clear
#Backup Database

#User + Passwordnya
user="root"
password="aqwe123"
host="localhost"
db_name="jester"

#Dir Backupnya
dir_backup="/home/ndeso/"
date=$(date +"%d-%b-%Y")


#Default Permissionya
umask 400

#Dump ke file .sql
mysqldump --user=$user --password=$password --host=$host $db_name > $dir_backup/$db_name+$date.sql

#Delete Tiap 3 Hari Sekali
find $dir_backup/*.sql -mtime +7 -exec rm {} \;


#Backup /var/www/

#Masuk Direktorinya
cd /var/www/

#Default Permissions
umask 400

#compress ke tar.gz
tar -zcvf $dir_backup/$date.tar.gz belajar > /dev/null 2>&1

#Delete tiap 3 Hari sekali
find $dir_backup/*.tar.gz -mtime +7 -exec rm {} \;
