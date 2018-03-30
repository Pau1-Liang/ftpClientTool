#!/bin/bash

# created by marsweng on 12/Mar, for convert the old mutual fund script 
# from AIX to adapt to the new Linux environment

LOG_FILE="mf_convert.sh.$(date +%Y%m%d%H%M%S).log"

src_path=home/
dst_path=home2

mkdir -p $dst_path
chomd -R 777 $dst_path

find $src_path -type d -name "*" | sed 's/^home\//home2\//g' | xargs mkdir -p 

find $src_path -type f -name "*" > OLD.TMP 

cat <<EOF > $dst_path/mfopr/script/as.profile

export MFSHHOME=/home/mfopr/script
export MFSHLOGS=/home/mfopr/logs
export MFSHUSERGRP=operators

EOF

echo 'export PATH=/usr/bin:/etc:/usr/sbin:$MFSHHOME' >> $dst_path/mfopr/script/as.profile

cat /dev/null > $LOG_FILE
cat /dev/null > SUDOERS_CMD.TXT
while read filePath 
do
	dstFilePath=`echo "${filePath}" | sed 's/home\//home2\//g'`
	fileName=`basename $filePath`
	fileDir=`dirname $filePath`
	if [[ "$fileDir"  == "home/mfs/interface/config" \
		|| "$fileDir" == "home/mfs/fonts/CMap" \
		|| "$fileDir" == "home/mfs/fonts" ]]; then 
		cp $filePath $dstFilePath
		continue
	fi
	
	if [[ "$fileName" == "ctrlsh" ]]; then
		echo '#!/bin/ksh' > $dstFilePath
		echo 'sudo su - root -c /home/mfopr/script/$1' >> $dstFilePath
		continue
	fi

	echo "$filePath" >> $LOG_FILE

	rst=`grep 'pgmname=' $filePath`
	if [[ $? -eq 0 && "$rst" != "" ]]; then 
		CMD_ALIAS_KEY=`echo "$fileName" | awk '{gsub("[.]", "_");print toupper($0);}'`
		CMD_ALIAS_VAL=`echo "$rst" | awk -F"=" '
			BEGIN{
				cmdList = "";
			}{
				gsub("\r", "");
				tmpStr = ("/usr/bin/su - root -c /home/mfopr/script/" $2);
				if (cmdList == "") {
					cmdList = tmpStr;
				} else {
					cmdList = (cmdList "," tmpStr);
				}
			}END{
				print cmdList;
			}
		'`
		echo "Cmnd_Alias ${CMD_ALIAS_KEY}=${CMD_ALIAS_VAL}" | tee -a SUDOERS_CMD.TXT
	fi
	
	awk '
	{
		gsub("\r", "")
		if ($0 ~ /^\s*echo\s+.+\\c/ || \
			$0 ~ /^\s*echo\s+.+\$MAIN_SELECT_OPR/ || \
			$0 ~ /^\s*echo\s+.+\$MAIN_SELECT00/ || \
			$0 ~ /^\s*echo\s+.+\$SJ_SELECTOP/|| \
			$0 ~ /^\s*echo\s+.+\$SJ_SELECTSO/) {
			sub("echo ", "echo -e ");
		}
		
		if (FILENAME ~ /as.path$/ && $0 ~ /_OPT=/) {
			gsub("\"$", " dummy\"");
		}
		
		if (FILENAME !~ /.tws$/ && $0 ~ /^\s*MYNAME=/) {
			print ". /home/mfopr/script/as.profile "
		}
		
		if (FILENAME ~ /as.stopall$/  && $0 ~ /^\s*stop_commserver$/) {
			gsub("^", "#");
		}
		
		if (FILENAME ~ /as.startall$/ && ($0 ~ /^\s*start_commserver$/ || $0 ~ /^\s*\/usr\/bin\/X11\/xhost.*$/)) {
			gsub("^", "#");
		}

		print $0;
	}' $filePath | sed -e 's/WebSphere2/WebSphere/g' \
		-e 's/r6mfsm220001Node01Cell/lxmfsuatapp1vNode01Cell/g' > $dstFilePath

done < OLD.TMP

echo "create HomeScript_New.tar"
rm -f HomeScript_New.tar
tar -cvf HomeScript_New.tar home2/* | tee -a $LOG_FILE


#cd RuleEngine/
#cat ./st.sh | sed -e 's/WebSphere2/WebSphere/g' \
#		-e 's/r6mfsm220001Node01Cell/lxmfsuatapp1vNode01Cell/g' > st.sh.tmp
#cat st.sh.tmp > st.sh
#rm -f st.sh.tmp
#
#rm -f RuleEngine_New.tar
#tar -cvf ../RuleEngine_New.tar ./* | tee -a $LOG_FILE

