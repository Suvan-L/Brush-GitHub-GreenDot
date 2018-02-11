#!/bin/sh
# --------------------------------------------
# 自定义函数
# --------------------------------------------

# 提交函数
#	- 参数1：指定循环提交次数
#   - 参数2：设置提交时间
#
commit(){
	echo "*************************** ${2} ***************************"
	for i in $(seq 1 ${1})
	do
		echo "${1}">>update.data

		git add .
		git commit --date="${2}" -am "today ${i} commit"
	done
}

# 【NO】设置系统时间
#	- 已不使用，改为设置 git 时间
# 	- 自动获取当前系统时间，并设置成下一天
#
setNextDate(){
	nextDate=$(date -d next-day +%Y%m%d)
	date -s ${nextDate}
}


# --------------------------------------------
# Shell 脚本执行动作
# --------------------------------------------

# 执行思路
#	1. 定义变量
#		- time: 开始提交时间
#
# 	2. 初始化仓库
#		- 构建 .git()
#		- 取消 Git 操作时符号自动转换（行结束符，提交：LF -> CRLF，迁出 -> LF -> CSRF）
#			- Linux 或 Mac 使用 LF 作为行结束符
#			- Windows 是 CSRF
#	3. 文件处理
#		- 列转行  7（row） X 53（col） ->  53（row） X 53（col） 	
#
# 	4. 循环读取设计文件
#		- config.txt 内容 
#   	- 逐行读取，'|' 分隔每行字符串，存入数组
#		- 遍历数组
#			- 每个元素代表当日提交次数
#			- 根据提交次数，并设置时间，执行 commit()
#
#	5. 删除临时文件
#
echo '********************* begin do shell script *******************'

# 1. 定义变量
# date -s "2014-12-28 00:00:00"
# hwclock --hctosys
time="2014-12-27";

# 2. 初始化仓库
git init
git config --global core.autocrlf false 

# 3. 文件处理
awk '{for(i=0;++i<=NF;)a[i]=a[i]?a[i] FS $i:$i}END{for(i=0;i++<NF;)print a[i]}' picture.txt > tmp.txt

# 4.循环读取设计文件
cat tmp.txt | while read line;
do  
    arr=($line)
	for count in ${arr[*]}
	do
		time=`date -d "${time}  days" "+%Y-%m-%d"`
		commit $count $time
	done
done

# 5.删除临时文件
rm tmp.txt

echo '*********************  finished shell script *******************'