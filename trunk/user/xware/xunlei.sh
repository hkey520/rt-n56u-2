#!/bin/sh
# optimize by Huang YingNing <huangyingning at google mail system> 2018
#

logger()
{
	title=$2
	msg=$3
	echo "${title}:${msg}"
}

rand_sleep()
{
	min=$1
	max=$2
	max=$((${max} - ${min} + 1))
	num=$(date +%s)
	num=$((${num} % ${max} + ${min}))
	logger -t "等待" "${num}秒"
	sleep ${num}
}

echo "xunlei : $$"
# ps | grep -F 'xunlei.sh' | grep -v -F grep 
if ps | grep -F '{xunlei.sh}' | grep -v $$ | grep -v -F grep -q ; then 
	rand_sleep 1 5
fi
# ps | grep -F '{xunlei.sh}' | grep -v $$ | grep -v -F grep | awk '{print $1}' | xargs kill -9 > /dev/null 2>&1
xunleienable=`nvram get xunlei_enable`
patch=`ls -l /media/ | awk '/^d/ {print $NF}' | sed -n '1p'`
if [ -z $patch ]; then
	sleep 7
	patch=`ls -l /media/ | awk '/^d/ {print $NF}' | sed -n '1p'`
	if [ -z $patch ]; then
		logger -t "远程迅雷下载" "未检测到挂载硬盘,程序退出。" 
#		nvram set xunlei_enable="0"
#		exit 0
	fi
	/usr/bin/xunlei.sh &
	exit 0;
fi
xunleidir="/media/$patch"
nvram set xunlei_dir="$xunleidir"
logger -t "远程迅雷下载目录：$xunleidir"

if [ "$xunleienable" != 1 -a -n "`pidof ETMDaemon`" ]; then
	killall ETMDaemon EmbedThunderManager
	sed -i '/xunlei/d' /etc/storage/post_wan_script.sh 
	logger -t "远程迅雷下载" "已关闭。" 
	nvram set xunlei_enable="0"
	exit 0
fi

if [ "$xunleienable" != 1 ]; then
	logger -t "远程迅雷下载" "未开启" 
	exit 0
fi

if [ ! -f "$xunleidir/xunlei/portal" ]; then
	mkdir -p "$xunleidir/xunlei/"
	tar -xzvf "/etc_ro/xware.tgz" -C "$xunleidir/xunlei/"
	logger -t "远程迅雷下载" "成功解压至：$xunleidir/xunlei/"
fi

if [ ! -x "$xunleidir/xunlei/portal" ]; then
	chmod 777 "$xunleidir/xunlei/portal"
fi

codeline=""
OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH="$xunleidir/xunlei/lib:/lib:/opt/lib:/usr/share/bkye:/usr/share:${LD_LIBRARY_PATH}"
while [ -z "$codeline" ]
do
	logger -t "远程迅雷下载" "启动中..."
	if [ ! -f $xunleidir/xunlei/portal ]; then
		logger -t "远程迅雷下载" "$xunleidir/xunlei/portal不存在！"
		exit 0;
	fi
	$xunleidir/xunlei/portal > /tmp/xunlei.conf
	codeline=`grep "THE ACTIVE CODE IS" /tmp/xunlei.conf`
	if [ -z "$codeline" ]; then
		codeline=`grep "THIS DEVICE HAS BOUND TO USER" /tmp/xunlei.conf`
		if [ -z "$codeline" ]; then
			logger -t "远程迅雷下载" "启动失败，正在重试中，请检查！"
			killall ETMDaemon EmbedThunderManager
			rand_sleep 1 7
			if ps | grep -F '[ETMDaemon]' | grep -v grep | grep -F Z -q ; then
				logger -t "远程迅雷下载" "存在ETMDaemon 僵尸进程，终止启动！"
				exit 0
			fi
		fi
	fi
done
code=`expr "$codeline" : '[^\:]*: \([^.]*\)'`
nvram set xunlei_sn="$code"
#export LD_LIBRARY_PATH=/lib:/opt/lib
export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}
sed -i '/xunlei/d' /etc/storage/post_wan_script.sh
cat >> /etc/storage/post_wan_script.sh << EOF
/usr/bin/xunlei.sh&
EOF
logger -t "远程迅雷下载" "守护进程启动在：$xunleidir/xunlei。"
