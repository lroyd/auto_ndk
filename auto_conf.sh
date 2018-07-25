#!/bin/bash

PWD=$(pwd)
INCUBATOR_PATH=$(pwd)/incubator

PRO_DIR_PATH= 
PRO_NAME=

PRO_JNI_LIBS_NAME=
PRO_JNI_CROSS_COMPILE_PATH=

PRO_JAVA_PACKAGE_NAME=
PRO_JAVA_CLASS_NAME=


function print_env_arge(){
	echo -e "=================================================================================="
	echo -e "1.PRO_DIR_PATH = $PRO_DIR_PATH";
	echo -e "2.PRO_NAME = $PRO_NAME";
	echo -e "3.PRO_JNI_LIBS_NAME = $PRO_JNI_LIBS_NAME";
	echo -e "4.PRO_JNI_CROSS_COMPILE_PATH = $PRO_JNI_CROSS_COMPILE_PATH";
	echo -e "5.PRO_JAVA_PACKAGE_NAME = $PRO_JAVA_PACKAGE_NAME";
	echo -e "6.PRO_JAVA_CLASS_NAME = $PRO_JAVA_CLASS_NAME";
	echo -e "=================================================================================="
}

function create_conf(){	
	rm -rf config_site.cfg
	touch config_site.cfg
	echo "[BASE_SETTING]">> config_site.cfg
	echo "PRO_DIR_PATH=$PRO_DIR_PATH" >> config_site.cfg
	echo "PRO_NAME=$PRO_NAME" >> config_site.cfg
	echo >> config_site.cfg
	echo "[JNI_SETTING]">> config_site.cfg
	echo "PRO_JNI_LIBS_NAME=$PRO_JNI_LIBS_NAME" >> config_site.cfg
	echo "PRO_JNI_CROSS_COMPILE_PATH=$PRO_JNI_CROSS_COMPILE_PATH" >> config_site.cfg
	echo >> config_site.cfg
	echo "[JAVA_SETTING]">> config_site.cfg
	echo "PRO_JAVA_PACKAGE_NAME=$PRO_JAVA_PACKAGE_NAME" >> config_site.cfg
	echo "PRO_JAVA_CLASS_NAME=$PRO_JAVA_CLASS_NAME" >> config_site.cfg

	echo -e "create config_site.cfg done!!";
}


cd $PWD

echo "=================================================================================="
echo "EN TARO ADUN"
echo "WELCOME TO UES AUTO CONF FOR ANDROID NDK"
echo "AUTHOR:LROYD.H"
echo "VERSION:1.0"
echo "=================================================================================="

if [ -f config_site.cfg ]; then
	echo -ne "The config_site.cfg already exists, whether to cover[y/n][default:\033[36my\033[0m]:"
	read arge
	if [ "$arge" = "" ]; then
		rm -rf config_site.cfg
	fi
fi

echo -ne "Please enter the project PATH = [default:\033[36mPWD\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	PRO_DIR_PATH=$(pwd);
else
	PRO_DIR_PATH=$arge;
fi

echo -ne "Please enter the project NAME = [default:\033[36msample_native\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	PRO_NAME=sample_native;
else
	PRO_NAME=$arge;
fi

echo -ne "Please enter the JNI Dynamic library NAME = [default:\033[36mnative_template\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	PRO_JNI_LIBS_NAME=native_template;
else
	PRO_JNI_LIBS_NAME=$arge;
fi

echo -ne "Please enter the JNI cross complile PATH = [default:\033[36mNDK_PATH\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	echo -e "\033[31m error: !! NOT set jni cross complile path \033[0m";
	exit 1
else
	PRO_JNI_CROSS_COMPILE_PATH=$arge;
fi

echo -ne "Please enter the Java Package NAME = [default:\033[36mcom.gundoom.ndk\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	PRO_JAVA_PACKAGE_NAME=com.gundoom.ndk;
else
	PRO_JAVA_PACKAGE_NAME=$arge;
fi

echo -ne "Please enter the Java Class NAME for jni = [default:\033[36mTemplate\033[0m]	\r\n"
read arge
if [ "$arge" = "" ]; then
	PRO_JAVA_CLASS_NAME=Template;
else
	PRO_JAVA_CLASS_NAME=$arge;
fi

print_env_arge

echo -ne "The parameter setting is completed, or whether the project is created [y/n]:"
read arge
if [ "$arge" = "y" ]; then
	echo -e "initializing project";
	create_conf
	
	exec ./generator.sh config_site.cfg $INCUBATOR_PATH
	
	
else
	exit 1
fi






