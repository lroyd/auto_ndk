#!/bin/bash


CONF_NAME="$1"
INCUBATOR="$2"


#[BASE_SETTING]
PRO_DIR_PATH=
PRO_NAME=
#[JNI_SETTING]
PRO_JNI_LIBS_NAME=
PRO_JNI_CROSS_COMPILE_PATH=
PRO_JNI_MODE=0
PRO_JNI_PLUS_LIBS=

#[JAVA_SETTING]
PRO_JAVA_PACKAGE_NAME=
PRO_JAVA_CLASS_NAME=
PRO_JAVA_JAR=

SCRIPT=$(basename $0)
function usage(){
	echo -e "\nUSAGE: $SCRIPT file \n"
	exit 1
}

function read_env_arge(){
	echo -e "read config file, one moment please."
	for LINE in `cat $CONF_NAME`
	do
		case $LINE in
			PRO_DIR_PATH=*) 
				PRO_DIR_PATH=${LINE#*=}
				echo -e "set PRO_DIR_PATH = \033[36m$PRO_DIR_PATH\033[0m"
				;;
			PRO_NAME=*) 
				PRO_NAME=${LINE#*=}
				echo -e "set PRO_NAME = \033[36m$PRO_NAME\033[0m"
				;;
			PRO_JNI_LIBS_NAME=*) 
				PRO_JNI_LIBS_NAME=${LINE#*=}
				echo -e "set PRO_JNI_LIBS_NAME = \033[36m$PRO_JNI_LIBS_NAME\033[0m"
				;;
			PRO_JNI_CROSS_COMPILE_PATH=*) 
				PRO_JNI_CROSS_COMPILE_PATH=${LINE#*=}
				echo -e "set PRO_JNI_CROSS_COMPILE_PATH = \033[36m$PRO_JNI_CROSS_COMPILE_PATH\033[0m"
				;;
			PRO_JAVA_PACKAGE_NAME=*) 
				PRO_JAVA_PACKAGE_NAME=${LINE#*=}
				echo -e "set PRO_JAVA_PACKAGE_NAME = \033[36m$PRO_JAVA_PACKAGE_NAME\033[0m"
				;;
			PRO_JAVA_CLASS_NAME=*) 
				PRO_JAVA_CLASS_NAME=${LINE#*=}
				echo -e "set PRO_JAVA_CLASS_NAME = \033[36m$PRO_JAVA_CLASS_NAME\033[0m"
				;;				
			*) 
				#echo $LINE
				;;
		esac
	done
	
	if [ "$PRO_DIR_PATH" -a "$PRO_NAME" -a "$PRO_JNI_LIBS_NAME" -a "$PRO_JNI_CROSS_COMPILE_PATH" -a "$PRO_JAVA_PACKAGE_NAME" -a "$PRO_JAVA_CLASS_NAME" ]; then
		echo $PRO_DIR_PATH/$PRO_NAME
		if [ -d $PRO_DIR_PATH/$PRO_NAME ];then rm -rf $PRO_DIR_PATH/$PRO_NAME; fi
		return 0;
	else

		return 1;
	fi
}

#创建文件结构
function _dir(){
	if [ ! -d $INCUBATOR/Jni ] || [ ! -f $INCUBATOR/Java/Template.java ]; then
		echo -e "\033[31merror:not found incubator package!!!!!\033[0m";
		return 1;
	fi

	mkdir -p $PRO_DIR_PATH/$PRO_NAME
	mkdir -p $PRO_DIR_PATH/$PRO_NAME/Jni
	mkdir -p $PRO_DIR_PATH/$PRO_NAME/Java
	cp -r $INCUBATOR/Jni $PRO_DIR_PATH/$PRO_NAME
	cp $INCUBATOR/Java/Template.java $PRO_DIR_PATH/$PRO_NAME/Java/$PRO_JAVA_CLASS_NAME.java
	
	sed -i 's/T0/'$PRO_JNI_LIBS_NAME'/g' $PRO_DIR_PATH/$PRO_NAME/Jni/CMakeLists.txt
	sed -i 's!T0!'$PRO_JNI_CROSS_COMPILE_PATH'!g' $PRO_DIR_PATH/$PRO_NAME/Jni/config/toolchain-cross.cmake
	
	#目前只有简单模式 
	JAVA_CLASS_NAME=${PRO_JAVA_PACKAGE_NAME//\./\/}\/$PRO_JAVA_CLASS_NAME
	JNI_FUNC_HEAD=${PRO_JAVA_PACKAGE_NAME//\./\_}

	sed -i 's!T0!'$JAVA_CLASS_NAME'!g' $PRO_DIR_PATH/$PRO_NAME/Jni/jni/c1.c
	sed -i 's/T1/'Java_$JNI_FUNC_HEAD\_$PRO_JAVA_CLASS_NAME\_classInitNative'/g' $PRO_DIR_PATH/$PRO_NAME/Jni/jni/c1.c
	sed -i 's/T2/'Java_$JNI_FUNC_HEAD\_$PRO_JAVA_CLASS_NAME\_devEnable'/g' $PRO_DIR_PATH/$PRO_NAME/Jni/jni/c1.c
	sed -i 's/T3/'Java_$JNI_FUNC_HEAD\_$PRO_JAVA_CLASS_NAME\_devDisable'/g' $PRO_DIR_PATH/$PRO_NAME/Jni/jni/c1.c
	sed -i 's/T4/'Java_$JNI_FUNC_HEAD\_$PRO_JAVA_CLASS_NAME\_devContral'/g' $PRO_DIR_PATH/$PRO_NAME/Jni/jni/c1.c
	#
	sed -i 's/T0/'$PRO_JAVA_CLASS_NAME'/g' $PRO_DIR_PATH/$PRO_NAME/Java/$PRO_JAVA_CLASS_NAME.java
	sed -i 's/T1/'$PRO_JAVA_PACKAGE_NAME'/g' $PRO_DIR_PATH/$PRO_NAME/Java/$PRO_JAVA_CLASS_NAME.java
	sed -i 's/T2/'$PRO_JNI_LIBS_NAME'/g' $PRO_DIR_PATH/$PRO_NAME/Java/$PRO_JAVA_CLASS_NAME.java	
	
	return 0;
}

if [ $# -lt 1 ] ; then
usage
fi

read_env_arge
if [ $? = 1 ]; then
	echo -e "\033[31m parameter parsing error \033[0m";
	exit 1
else
	_dir
	if [ $? = 0 ]; then echo -e "============= project creation completion ============="; fi
fi



