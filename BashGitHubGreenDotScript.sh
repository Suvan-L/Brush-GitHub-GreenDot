#!/bin/sh

# 提交函数
#	- 参数1：指定循环提交次数
#
commit(){
	for i in $(seq 1 ${1})
	do
		echo "test ${1}">>UselessData.data

		git add .
		git commit -m "today ${i} commit"

	done
}

# 设置下一天日期
# 	- 当前日期设置为下一天
#
setNextDate(){
	nextDate=$(date -d next-day +%Y%m%d)
	date -s ${nextDate}
}

# 流程函数
#	- 参数1: 指定循环提交次数
#	- 同时执行提交函数和设置函数
#
flow(){
	commit ${1}
	setNextDate
}

# 执行思路
# 	1. 初始化仓库
# 	2. 设置系统时间(硬件时间设置成系统时间)
# 	3. 循环读取文件内容（config.txt） 
#   	- 逐行读取，| 分隔字符串，存入数组
#		- 提交操作（修改文件，提交到 git）
#   	- 系统时间修改至下一天
# 	4. 结束

echo '********************* begin do shell script *******************'
date -s "2014-12-28 00:00:00"
hwclock --hctosys

git init
git config --global core.autocrlf false 


cat config.txt | while read line;
do 
	OLD_IFS="$IFS"  
    IFS="|"  
    arr=($line)
    IFS="$OLD_IFS" 
 
    unset arr[7]

	for count in ${arr[*]}
	do
		# echo "$count"
		flow $count
	done
done
echo '*********************  finished shell script *******************'