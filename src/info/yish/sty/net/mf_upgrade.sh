#!/bin/ksh 

# this script created for the mutual fund upgrade, 
# should use the minor root to execute this script.

LOG_FILE="mf_upgrade.sh.$(date +%Y%m%d%H%M%S).log"

OLD_LANG=$LANG
export LANG=EN

cat /dev/null > $LOG_FILE

echo ">>> Start to initialize all of the required path..." | tee -a $LOG_FILE

mkdir -v -p /home/mfs/bloomberg &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/configfile &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/datafile &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/datafile/backup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/datafile/error &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/datafile/loaded &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/datafile/processing &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/bloomberg/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/cert &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/dayend &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/dayend/logs &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/dayend/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/dayend/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/deploy_backup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/etwealth &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/etwealth/backup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/etwealth/configFile &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/etwealth/datafile &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/fonts &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/fonts/CMap &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/housekeeper &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/housekeeper/logs &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/housekeeper/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/import &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/config &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/export_file &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/export_file_archive &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/import_file &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/import_file_archive &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/interface/logs &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/mfbackup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/mfbackup/backup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/mfbackup/harden &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/mfbackup/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/mfbackup/tmp_exp &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/rod &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/rod/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/rod/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/Bond &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/Bond/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/Bond/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/IPQ &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/IPQ/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/IPQ/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/MSP &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/MSP/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/MSP/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/UTQUES &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/UTQUES/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/UTQUES/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/log &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/logs &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfs/statement/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfopr/logs &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfopr/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfopr/script_bkup &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfopr/script_bkup/script &2>1 | tee -a $LOG_FILE
mkdir -v -p /home/mfopr/senior &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/bond &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/cifconversion &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/cifconversion/old &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/consolid &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/dayend &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/dividend &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/orderConf &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/pconf &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/rod &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/settle &2>1 | tee -a $LOG_FILE
mkdir -v -p /usr/WebSphere/AppServer/installedApps/mfapp2.ear/mfapp2.war/report/statement &2>1 | tee -a $LOG_FILE

ln -v -s /usr/WebSphere/AppServer /utWebSphere &2>1 | tee -a $LOG_FILE

echo ">>> Path initialization done." | tee -a $LOG_FILE

RULE_ENGINE_PKG=/home/mfs/RuleEngine_New.tar
HOME_SCRIPT_PKG=/home/mfs/HomeScript_New.tar

old_path="`pwd`"

echo ">>> Start to copy files to /usr/RuleEngine ..." | tee -a $LOG_FILE
cd /usr/RuleEngine
cp -v -f $RULE_ENGINE_PKG /usr/RuleEngine/ | tee -a $LOG_FILE
tar -xvf $(basename $RULE_ENGINE_PKG) | tee -a $LOG_FILE
chmod -v -R mfs:operator * | tee -a $LOG_FILE
chmod -v -R 644 * | tee -a $LOG_FILE
chmod -v -R 755 *.sh | tee -a $LOG_FILE
echo ">>> Copy files to /usr/RuleEngine done." | tee -a $LOG_FILE

echo ">>> Start to copy files to /home/mfs ..." | tee -a $LOG_FILE
cp -v -R -f /home/mfs/home2/mfs/* /home/mfs/ | tee -a $LOG_FILE
chown -v -R mfs:operator /home/mfs/* | tee -a $LOG_FILE
find /home/mfs/ -type d               -exec chmod -v 775 {} \; | tee -a $LOG_FILE
find /home/mfs/ -type f -name "*"     -exec chmod -v 755 {} \; | tee -a $LOG_FILE
find /home/mfs/fonts/ -type f         -exec chmod -v 644 {} \; | tee -a $LOG_FILE
find /home/mfs/ -type f -name "*.xml" -exec chmod -v 644 {} \; | tee -a $LOG_FILE
echo ">>> Copy files to /home/mfs done." | tee -a $LOG_FILE

echo ">>> Start to copy files to /home/mfopr ..." | tee -a $LOG_FILE
cp -v -R -f /home/mfs/home2/mfopr/* /home/mfopr/ | tee -a $LOG_FILE
chown -v -R mfs:operator /home/mfopr   | tee -a $LOG_FILE
chown -v -R mfs:operator /home/mfopr/* | tee -a $LOG_FILE
find /home/mfopr/ -type d               -exec chmod -v 775 {} \; | tee -a $LOG_FILE
find /home/mfopr/ -type f -name "*"     -exec chmod -v 755 {} \; | tee -a $LOG_FILE
find /home/mfopr/ -type f -name "*.xml" -exec chmod -v 644 {} \; | tee -a $LOG_FILE
echo ">>> Copy files to /home/mfopr done." | tee -a $LOG_FILE

echo ">>> Start to copy files to /home/mfsmopr1 ..." | tee -a $LOG_FILE
cp -v -R -f /home/mfs/home2/mfsmopr1/* /home/mfsmopr1/ | tee -a $LOG_FILE
chown -v -R mfs:operator /home/mfsmopr1   | tee -a $LOG_FILE
chown -v -R mfs:operator /home/mfsmopr1/* | tee -a $LOG_FILE
find /home/mfsmopr1/ -type f -name "*.sh"     -exec chmod -v 755 {} \; | tee -a $LOG_FILE
find /home/mfsmopr1/ -type f -name "*.csh"    -exec chmod -v 755 {} \; | tee -a $LOG_FILE
echo ">>> Copy files to /home/mfsmopr1 done." | tee -a $LOG_FILE

echo ">>> Start to copy files to /home/mfsmsop1 ..." | tee -a $LOG_FILE
cp -v -R -f /home/mfs/home2/mfsmsop1/* /home/mfsmsop1/ | tee -a $LOG_FILE
chown -v -R mfsmsop1:operator /home/mfsmsop1/* | tee -a $LOG_FILE
find /home/mfsmsop1/ -type f -name "*.sh"     -exec chmod -v 755 {} \; | tee -a $LOG_FILE
find /home/mfsmsop1/ -type f -name "*.csh"    -exec chmod -v 755 {} \; | tee -a $LOG_FILE
echo ">>> Copy files to /home/mfsmsop1 done." | tee -a $LOG_FILE

echo ">>> Start to copy files to /home/mqm ..." | tee -a $LOG_FILE
cp -v -R -f /home/mfs/home2/mqm/* /home/mqm/ | tee -a $LOG_FILE
chown -v -R mqm:mqm /home/mqm/* | tee -a $LOG_FILE
find /home/mqm/ -type f -name "*.sh"            -exec chmod -v 755 {} \; | tee -a $LOG_FILE
find /home/mqm/ -type f -name "channelSecurity" -exec chmod -v 755 {} \; | tee -a $LOG_FILE
echo ">>> Copy files to /home/mqm done." | tee -a $LOG_FILE

echo ">>> Write /etc/suoders for operators ... " | tee -a $LOG_FILE

echo ">>> Write /etc/suoders for operators done " | tee -a $LOG_FILE

export LANG=$OLD_LANG


