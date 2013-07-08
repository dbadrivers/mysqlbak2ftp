#!/bin/bash
#Mysqldump   database  & ftp backfile

# Copyleft dbadrivers@gmail.com liups@int-yt.com  
# File name:  mysqlbak2ftp.sh

dbNames=(fengshuo wdm)
scriptsDir=`pwd`
DATE=`date +%Y-%m-%d`
TIME=`date +%H%M`
##mysql
HOST="localhost"
PWD="password"
MYUSER="baku"
#MYSQL="mysql -u${MYUSER} -p${PWD}"
MYSQLDUMP="/usr/local/mysql/bin/mysqldump -u${MYUSER} -p${PWD}"
##mysql
BACKDIR=/home/bakmysql/${DATE}
#Eemail
DBAEMAIL=itopm.com@itopm.com
FROMMAIL=itopm.com@itopm.com
SMTPHOST=smtp.itopm.com
SMTPASS=itopm.com
#email
#ftp
ftpServer=itopm.com
ftpUser=itopm
ftpPasswd=itopm.com
remoteDir=/
#ftp
IP=`/sbin/ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`;export IP
if ! test -d ${BACKDIR}
then
        mkdir -p ${BACKDIR}
fi
for dbname in ${dbNames[*]}
do
mkdir -p ${BACKDIR}/${dbname}_${TIME}
cd ${BACKDIR}/${dbname}_${TIME}
$MYSQLDUMP --default-character-set=utf8 -R --hex-blob --single-transaction --opt $dbname --log-error=${dbname}_${DATE}_${TIME}.err >${dbname}.${DATE}.${TIME}.sql
RC=$?
if [ $RC -ne "0" ]; then
$scriptsDir/sendEmail -f $FROMMAIL -t ${DBAEMAIL} -s $SMTPHOST -u "Err_${IP}_DB_bak_FAIL"  -m "RT,PLEASE CHECK!critical!" -xu "$FROMMAIL" -xp "$SMTPASS"
else
echo "Mysql bakup ${dbname} ok at `date`" >>/home/bakmysql/${DATE}/bakok.log
##ftp begin
/usr/bin/ftp -niv <<!
open $ftpServer
user $ftpUser $ftpPasswd
binary
cd $remoteDir
lcd ${BACKDIR}/${dbname}_${TIME}
mput *.sql
bye
!
RC=$?
if [ $RC -ne "0" ]; then
$scriptsDir/sendEmail -f $FROMMAIL -t ${DBAEMAIL} -s $SMTPHOST -u "Err_${IP}_DB_bak_ftp_FAIL"  -m "RT,PLEASE CHECK!critical!" -xu "$FROMMAIL" -xp "$SMTPASS"
else
echo "Mysql bakup  ${dbname} ftp ok at `date`" >>/home/bakmysql/${DATE}/bakok.log
fi
##ftp end
fi
done
