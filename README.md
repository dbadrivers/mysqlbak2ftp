mysqlbak2ftp
============

mysqldump备份数据库并上传到ftp

说明:
备份多个数据库。备份完成之后会传输到ftp的远程地址，如失败会发mail进行提醒。通过sendEmail程序来实现发mail，通过mysqldump实现备份mysql数据库
相关参数
dbNames=(db1 db2 dba3) 修改db1 db2 db3为需要备份的数据库名称
##mysql
HOST="localhost" #数据库地址
MYUSER="itopm" #备份mysql所使用的用户名
PWD="itopm" #备份备份mysql所使用的用户的密码
##mysql
BACKDIR=/home/itopm.com/${DATE} #备份数据的存放路径 会自动创建
#Eemail
DBAEMAIL=itopm@itopm.com #收件人
FROMMAIL=itopm@itopm.com#发件人
SMTPHOST=smtp.itopm.com #邮件服务器的smtp地址
SMTPASS=itopm #发件人地址的邮箱密码明文
#email
#ftp
ftpServer=itopm.com #ftp地址
ftpUser=ftpuser #ftp用户名
ftpPasswd=itopm.com #ftp密码
remoteDir=/ #ftp远程路径即数据文件要传输的ftp的远程路径,需要提前创建/ 表示根目录
