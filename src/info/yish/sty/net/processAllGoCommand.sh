#!/bin/bash



RUN_DATE=`date '+%Y-%m-%d'`
nowTime=`date '+%Y%m%d%H%M%S'`
logFile=/tap/ocs/wlb.scripts/logs/processGoCommand.$RUN_DATE.log
inFolder=/tap/ocs/wlb.scripts/listenCommand/listen 
lockFileFlag=/tap/ocs/wlb.scripts/listenCommand/processGo.lock


echo "Current time: $nowTime, Starting $0...."                                   | tee -a $logFile
if [ -f ${lockFileFlag} ]; then
       echo " lock file found $lockFileFlag (Please delete it if alway locking)" | tee -a $logFile
       exit 1
fi
touch ${lockFileFlag}


cd /tap/ocs/wlb.scripts/listenCommand/listen
for theCommand in `ls *.go`
do
        case "$theCommand" in
            STARTServer.go)
                    echo "STARTServer.go..."                              | tee -a $logFile
                    /tap/ocs/current/admin/startServer.sh                 | tee -a $logFile
                    mv $theCommand done/$theCommand.done.$nowTime
                    echo ""                                               | tee -a $logFile
                    ;;
         
            STOPServer.go)
                    echo "STOPServer.go"                                  | tee -a $logFile
                    /tap/ocs/current/admin/stopServer.sh                  | tee -a $logFile
                    mv $theCommand done/$theCommand.done.$nowTime
                    echo ""                                               | tee -a $logFile
                    ;;
            CHECKServer.go)
                    echo "CHECKServer.go"                                 | tee -a $logFile
                    /tap/ocs/current/admin/checkServer.sh                 | tee -a $logFile
                    mv $theCommand done/$theCommand.done.$nowTime
                    echo ""                                               | tee -a $logFile
                    ;;
            *)
                    echo $"Command: $theCommand  not defined, failed"     | tee -a $logFile
                    mv $theCommand done/$theCommand.failed.$nowTime
                    echo ""                                               | tee -a $logFile
        esac
done

echo "Clear lock files...."                                               | tee -a $logFile
rm ${lockFileFlag}                                                        | tee -a $logFile
echo "Clear lock files....done"                                           | tee -a $logFile
echo ""
