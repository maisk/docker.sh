#!/bin/bash

DOCKER_SH_VERSION=1.0.3
HELP_COLL_SIZE=18;

if [ "x$1" == "xversion" ]; then
	echo $DOCKER_SH_VERSION;
	exit;
fi


function print_config_help {
	echo "CONFIG VARIABLES:"
	echo "==================================================";
	echo ""
	echo "RUNING VARIABLES"
	echo "--------------------------------------------------";
	echo "DOCKER_HOME        :"
	echo "IMAGE_NAME         :"
	echo "CONTAINER_NAME     :"
	echo "IMAGE_VERSION      :"
	echo "IMAGE_TAG          :"
	echo "DOCKER_FILE        :"
	echo "RUN_VOLUMES        :"
	echo "RUN_PORTS          :"
	echo "RUN_LINKS          :"
	echo "RUN_ENV            :"
	echo "RUN_HOSTS          :"
	echo "RUN_PARAMS         :"
	echo "CUSTOM_ACTIONS     :"
	echo ""
	echo "TESTING VARIABLES  "
	echo "--------------------------------------------------";
	echo "DOCKER_TEST_DIR    :"
	echo "DOCKER_TEST_SCRIPT :"
	echo "DOCKER_TEST_SCRIPT_IN:"
	echo "DOCKER_TEST_SCRIPT_CLEAN:"
	echo ""
	echo "BUILDING VARIABLES  "
	echo "--------------------------------------------------";
	echo "DOCKER_BUILD_DIR   :"
	echo "DOCKER_BUILD_ARGS  :"
	echo "DOCKER_TEMPLATE_FILE:"
	echo "DOCKER_TEMPLATE_VARS:";
}


function print_exec_help {

	echo ""
	echo "INITIALIZATION PARAMS:"
	echo "DOCKER_EXEC_DEFAULT_WD   : VALUES: PWD DEFAULT "
	echo "DOCKER_EXEC_WD_MAPPING   : "
	echo ""
	echo "RUNNING PARAMS : "
	echo "EXEC_ARGS"
	echo "EXEC_WD"
	echo "DEFAULT_WD"
	echo ""
	echo "Please use --interactive  --tty instead -i -t "
	echo ""
	echo "examples: "
	echo '>  env EXEC_ARGS="-u developer" EXEC_WD=/tmp docker.sh exec bash -c "whoami && pwd"'
	echo '>  echo "select now()"|psql -U postgres dbname'
	echo '>  env EXEC_ARGS="--interactive  --tty -u developer" DEFAULT_WD=PWD  docker.sh -w /opt/ins/docker exec psql dbname'

}

function print_help {
	1>&2 echo "Usage: $0 [OPTIONS] [COMMANDS]";
	1>&2 echo ""
	1>&2 echo "Options: "
	1>&2 echo '----------------------------------------------------------------------';
	1>&2 echo " -d         : dry-run"
	1>&2 echo " -w DIR     : directory for files: conf, cidfile"
	1>&2 echo " -c conf    : load config"
	1>&2 echo " -p cidfile : load pid from file"
	1>&2 echo ""
	1>&2 echo "Commands:";
	1>&2 echo '----------------------------------------------------------------------';
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "help";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "help:config";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "help:exec";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "example";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "ps";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "build";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "tag";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "test";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "run";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "run:bash" "run container with bash entripoint";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "remove";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "start";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "stop";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" 'bash'   '$1: pwd';
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "find    ";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "inspect ";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "ip      ";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "info";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "top";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "logs";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "ls";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "cat";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "copy";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "exec" "docker.sh help:exec";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "save";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" 'get_var'  '$1: variable name  ex:   eval `docker.sh get_var RUN_VOLUMES` ; set RUN_VOLUMES env variable';
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" 'echo_var' '$1: variable name ex: echo_var CONTAINER_NAME ;  echo_var RUN_VOLUMES[*]';
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "echo:vars";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "echo:conf";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "container";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "export:conf";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "export:vars" "create tmp file with config variable declarations, echo file name";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "make-default-conf";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "edit" "edit file inside container";
	1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n" "version";
	actions_help
	1>&2 echo  '----------------------------------------------------------------------';
	1>&2 printf "%-${HELP_COLL_SIZE}s:\n" ""
	1>&2 printf "%-${HELP_COLL_SIZE}s:\n" "example: $0 -d -c ex1.conf -c ex2.conf info remove build run"
	1>&2 echo ""

}

function config_example {
		echo "";
		echo "#docker.conf.sh:";
		echo "########################################";
		echo 'DOCKER_HOME="."';
		echo 'DOCKER_BUILD_DIR="."';
		echo 'IMAGE_NAME=my_repo';
		echo 'CONTAINER_NAME=my_container';
		echo 'DOCKER_FILE=Dockerfile';
		echo 'RUN_VOLUMES=("data/tmp:/tmp:rw" "data/var/log:/var/log:rw")'
		echo 'RUN_PORTS=("80:80" "19:19")'
		echo 'RUN_LINKS=("postgresql:postgres")'
		echo 'RUN_ENV=("MY_ENV_VARIABLE=my_value")'
		echo 'RUN_HOSTS=("test.local:127.0.0.1")'
		echo 'RUN_PARAMS="-d -it"';
		echo "";

}


function actions_help {
	if [ "x${CUSTOM_ACTIONS}" != "x" ]; then
		1>&2 echo '----------------------------------------------------------------------';
		1>&2 echo "CUSTOM ACTIONS:";
		AL1=${#ACTION_NAMES[@]}
		((LL=AL1-1))
		for i in `seq 0 $LL`;do
			1>&2 printf "%-${HELP_COLL_SIZE}s: %s\n"  ${ACTION_NAMES[$i]} "${ACTION_DESCRIPTIONS[$i]}";
		done
	fi
}


CONF_VAR_NAMES=(
	"DOCKER_HOME"
	"DOCKER_BUILD_DIR"
	"DOCKER_BUILD_ARGS"
	"IMAGE_NAME"
	"CONTAINER_NAME"
	"IMAGE_VERSION"
	"IMAGE_TAG"
	"DOCKER_FILE"
	"RUN_VOLUMES"
	"RUN_PORTS"
	"RUN_LINKS"
	"RUN_ENV"
	"RUN_HOSTS"
	"RUN_PARAMS"
	"DOCKER_TEST_SCRIPT"
	"DOCKER_TEST_DIR"
	"DOCKER_TEST_SCRIPT_IN"
	"DOCKER_TEST_SCRIPT_CLEAN"
	"CUSTOM_ACTIONS"
	"DOCKER_EXEC_DEFAULT_WD"
	"DOCKER_EXEC_WD_MAPPING"
	"DOCKER_TEMPLATE_FILE"
	"DOCKER_TEMPLATE_VARS"
);


__VAR_NAMES_INIT=`compgen -A variable|sort`;
#VARS="`set -o posix ; set`";

__MY_DIR=`readlink -f  .`;
__DEFAULT_DIR=1;
__DEFAULT_CONF=1;
__DEFAULT_CIDFILE=1;
__CONF="docker.conf.sh"
CIDFILE=".docker_container_id"
DRY_RUN=0
C=0;

if [ "x${DOCKER_SH_LIB_MODE}" != "x1" ];then
	while getopts "dc:p:w:"  opt; do
		case $opt in
			d)
				C=$((C+1))
				DRY_RUN=1
				#echo "#1 $((OPTIND-1))"
			;;
			w)
				if [[ "$OPTARG" == -* ]]; then
					1>&2 echo "EMPTY ARGUMENT -w";
					print_help;
					exit 13;
				fi
				__DEFAULT_DIR=0;
				__MY_DIR=`readlink -f  $OPTARG`;
				__DEFAULT_CIDFILE=0;
				CIDFILE=${__MY_DIR}/.docker_container_id
				#DOCKER_HOME=$__MY_DIR;
				if [ ! -d $__MY_DIR ]; then
					1>&2 echo "-w DIRECTORY: $__MY_DIR NOT FOUND";
					exit 12;
				fi;
				C=$((C+2))
			;;
			p)
				if [[ "$OPTARG" == -* ]]; then
					1>&2 echo "EMPTY ARGUMENT -p";
					print_help;
					exit 13;
				fi
				CIDFILE=$OPTARG;
				__DEFAULT_CIDFILE=0;
				C=$((C+2))
			;;
			c)
				if [[ "$OPTARG" == -* ]]; then
					1>&2 echo "EMPTY ARGUMENT -c";
					print_help;
					exit 13;
				fi
				__DEFAULT_CONF=0;
				__CONF_TMP=`readlink -f $OPTARG`;
				if [ ! -f "${__CONF_TMP}" ]; then
					1>&2  echo "ERROR: ${__CONF_TMP} NOT FOUND";
					exit 10;
				fi;
				DOCKERSH_CONFIG_DIR=`dirname $__CONF_TMP`;
				source $__CONF_TMP;
				C=$((C+2))
			;;
			\?)
				1>&2 echo "Invalid option: -$OPTARG"
			;;
		esac
	done

else

	__DEFAULT_DIR=0;
	__MY_DIR=`readlink -f  ${DOCKER_SH_LIB_W_DIR}`;
	__DEFAULT_CIDFILE=0;
		CIDFILE=${__MY_DIR}/.docker_container_id
		if [ ! -d $__MY_DIR ]; then
			1>&2 echo "DOCKER_SH_LIB_MODE DIRECTORY: $__MY_DIR NOT FOUND";
			exit 12;
		fi;
fi

if [ "$C" -gt "0" ]; then
	shift $C;
fi

if [[ "$__DEFAULT_CONF" == "1" ]]; then
		if [ -f "${__MY_DIR}/.docker.sh.conf" ]; then
				__CONF=.docker.sh.conf
		fi;
		if  [ -f ${__MY_DIR}/${__CONF} ]; then
			DOCKERSH_CONFIG_DIR=${__MY_DIR};
			source ${__MY_DIR}/${__CONF}
			if [  -f ${__MY_DIR}/docker_user.conf.sh ]; then
					. ${__MY_DIR}/docker_user.conf.sh
			fi
			else
				if [[ "x$1" == "xexample" ]]; then
						config_example;
						exit 1;
				fi;
				if [[ "x$1" == "xhelp" ]]; then
						print_help;
						exit 1;
				fi;
				if [[ "x$1" == "xhelp:config" ]]; then
						print_config_help;
						exit 1;
				fi;
				if [[ "x$1" == "xhelp:exec" ]]; then
						print_exec_help;
						exit 1;
				fi;
				1>&2  echo "ERROR: ${__MY_DIR}/${__CONF} NOT FOUND";
				1>&2  echo "try:";
				1>&2 echo "${0} example";
				1>&2 echo "${0} help";
				1>&2 echo "${0} help:config";
				1>&2 echo "";
				exit 10;
		fi
fi


if [ "x$1" == "xversion" ]; then
	echo $DOCKER_SH_VERSION;
	exit;
fi

PARSE_NAMES_FLAG=0
if [[ "x$1" == xecho* ]] || [[ "x$1" ==  "xinfo" ]] || [[ "x$1" == xexport* ]] ; then
	PARSE_NAMES_FLAG=1
fi

if [[ "x${IMAGE_NAME}" == "x" ]]; then
	if [[ "x${IMAGE_REPOSITORY}" != "x" ]]; then
		IMAGE_NAME=$IMAGE_REPOSITORY
	else
		1>&2 echo "ERROR VARIABLE IMAGE_NAME NOT SET";
		exit 316;
	fi
fi;



if [ "$PARSE_NAMES_FLAG" -eq 1 ];then

	__VARS_FILE1=$(tempfile)
	echo "$__VAR_NAMES_INIT" > $__VARS_FILE1
	__VARS_FILE2=$(tempfile)
	compgen -A variable|sort > $__VARS_FILE2

	EXCLUDE_P="^C$|^__|^opt$|^CIDFILE$|^DRY_RUN$";
	#SCRIPT_CONF_VARS="`grep -vFe "$VARS" <<<"$(set -o posix ; set)"|awk -F= '{print $1}'|grep -Ev "$EXCLUDE_P"`"; unset VARS;
	SCRIPT_CONF_VARS="`diff ${__VARS_FILE1} ${__VARS_FILE2}|grep '^>'|sed 's/> //'|grep -Ev "$EXCLUDE_P"`";
	rm -f ${__VARS_FILE1};
	rm -f ${__VARS_FILE2};


	EXTRA_CONF_VAR_NAMES=();
	for v2 in $SCRIPT_CONF_VARS; do
		flag1=0;
		for v1 in ${CONF_VAR_NAMES[@]}; do
			if [[ "$v2" == "$v1" ]]; then
				flag1=1;
			fi
		done;
		if [[ "$flag1" == "0" ]];then
				EXTRA_CONF_VAR_NAMES+=($v2)
		fi
	done;

	ALL_CONF_VAR_NAMES=("${CONF_VAR_NAMES[@]}" "${EXTRA_CONF_VAR_NAMES[@]}")

fi

if [[ "x${CONTAINER}" == "x" ]]; then
	if [  -f ${CIDFILE} ]; then
		CONTAINER=$(cat "${CIDFILE}")
	fi;
fi;



if [ "x${CUSTOM_ACTIONS}" != "x" ]; then
	c=0;
	for asig in "${CUSTOM_ACTIONS[@]}"; do
		#echo "$asig";
		#read -d s1 s2 s3 s4 <<< $( echo ${asig} | awk -F"|" '{print $1" "$2" "$3" "$4}' )
		IFS='|' read -d '' -ra asig_arr < <(printf '%s\0' "$asig")
		ACTION_NAMES[$c]="${asig_arr[0]}";
		ACTION_FUNCTIONS[$c]="${asig_arr[1]}";
		ACTION_DESCRIPTIONS[$c]="${asig_arr[2]}";
		ACTION_FLAGS[$c]="${asig_arr[3]}";
		((c+=1))
	done
fi

if [ "x${DOCKER_EXEC_WD_MAPPING}" != "x" ]; then
	c=0;
	for line in "${DOCKER_EXEC_WD_MAPPING[@]}"; do
		read v1 v2  <<< $( echo ${line} | awk -F":" '{print $1" "$2}' )
		DOCKER_EXEC_WD_MAPPING_KEY[$c]=`readlink -f $v1`;
		DOCKER_EXEC_WD_MAPPING_VAL[$c]=$v2;
		((c+=1))
	done
	#echo "KEYS: ${DOCKER_EXEC_WD_MAPPING_KEY[*]}"
	#echo "VALS: ${DOCKER_EXEC_WD_MAPPING_VAL[*]}"
fi


if [ "x${DOCKER_SH_LIB_MODE}" != "x1" ] && [ -z "$1" ]; then
		print_help
		exit
fi

	if [ -z "$DOCKER_HOME" ]; then
		1>&2 echo "ERROR: VARIABLE DOCKER_HOME NOT SET";
		exit 16;
	fi;

	if [[ "${__DEFAULT_DIR}" == "0" ]];then
		DOCKER_HOME_FULL=$__MY_DIR;
	else
		DOCKER_HOME_FULL=`readlink -f  $DOCKER_HOME`;
	fi

	if [[ ! -d ${DOCKER_HOME_FULL} ]]; then
		1>&2 echo "DOCKER HOME DIR: ${DOCKER_HOME_FULL} NOT FOUND";
		exit 22;
	fi;


	if [ ! -z "$DOCKER_BUILD_DIR" ]; then
		if [[ "$DOCKER_BUILD_DIR" != /* ]]; then
			DOCKER_BUILD_DIR="${DOCKER_HOME_FULL}/${DOCKER_BUILD_DIR}";
		fi
		DOCKER_BUILD_DIR_FULL=`readlink -f  $DOCKER_BUILD_DIR`;
	fi

	if [ ! -z "$DOCKER_TEST_DIR" ]; then
		if [[ "$DOCKER_TEST_DIR" != /* ]]; then
			DOCKER_TEST_DIR="${DOCKER_HOME_FULL}/${DOCKER_TEST_DIR}";
		fi
		DOCKER_TEST_DIR_FULL=`readlink -f  $DOCKER_TEST_DIR`;
	fi


	if [ ! -z "$CIDFILE" ]; then
		if [[ "$CIDFILE" != /* ]]; then
			CIDFILE="${DOCKER_HOME_FULL}/${CIDFILE}";
		fi
		CIDFILE=`readlink -f  $CIDFILE`;
	fi





function check_docker_build_dir {
	if [[ "x${DOCKER_BUILD_DIR}" == "x" ]]; then
		1>&2 echo "ERROR: VARIABLE DOCKER_BUILD_DIR NOT SET";
		exit 16;
	fi;
	if [[ ! -d ${DOCKER_BUILD_DIR_FULL} ]]; then
		1>&2 echo "DOCKER BUILD DIR: ${DOCKER_BUILD_DIR_FULL} NOT FOUND";
		exit 16;
	fi;
}



RUN_OK="1";
#if [[ -z "$RUN_PARAMS" && -z "$RUN_ENV" && -z "$RUN_LINKS" && -z "$RUN_PORTS"  && -z "$RUN_VOLUMES" ]]; then
#	RUN_OK="0";
#fi
if [[ ! -z "$ALLOW_RUN"  && "$ALLOW_RUN" -eq "0" ]]; then
	RUN_OK="0";
fi;



if [ -z "${IMAGE_VERSION}" ]; then
	DOCKER_NAME="${IMAGE_NAME}"
else
	DOCKER_NAME="${IMAGE_NAME}:${IMAGE_VERSION}"
fi

if [ ! -z "${IMAGE_TAG}" ]; then
	TAG_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
fi


function check_status {

	if [ "$?" -ne "0" ]; then
			1>&2  echo "ERROR! ";
		exit 3;
	fi;
}

###########################################################
###########################################################
###########################################################


function _test {


	if [[ "x${DOCKER_TEST_DIR}" == "x" &&  "x${DOCKER_BUILD_DIR}" != "x" ]]; then
			DOCKER_TEST_DIR = $DOCKER_BUILD_DIR;
	fi

	if [[ "x${DOCKER_TEST_DIR}" == "x" ]]; then
		1>&2 echo "ERROR: VARIABLE DOCKER_TEST_DIR NOT SET";
		exit 16;
	fi;
	if [[ ! -d ${DOCKER_TEST_DIR_FULL} ]]; then
		1>&2 echo "DOCKER TEST DIR: ${DOCKER_TEST_DIR_FULL} NOT FOUND";
		exit 22;
	fi;


	if [[  "x${DOCKER_TEST_SCRIPT}" == "x" ]]; then
		1>&2 echo " DOCKER_TEST_SCRIPT not set";
	fi



	function ASSERT {
		if [[ "$2" = "$3" ]]; then
			echo -e "\e[32m TEST OK: $1 \e[39m";
		else
			echo -e "\e[31m TEST FAILURE: $1\e[39m"
		fi
	};
	function ASSERT_ERROR {
		echo -e "\e[31m TEST FAILURE: $1\e[39m"
	}
	function ASSERT_OK {
		echo -e "\e[32m TEST OK: $1 \e[39m";
	}

	CDIR=`pwd`;
	if [[ "x${DOCKER_TEST_SCRIPT_CLEAN}" != "x" ]]; then
		cd $DOCKER_TEST_DIR_FULL;
		echo -e "\e[96m --> TEST_PATH : `pwd`\e[39m";
		echo -e "\e[96m --> TEST SCRIPT CLEAN: ${DOCKER_TEST_SCRIPT_CLEAN}\e[39m"
		. ./${DOCKER_TEST_SCRIPT_CLEAN}
		cd ${CDIR};
	fi

	echo -e "\e[96m --> Starting container $DOCKER_NAME";
	CIDFILE=/tmp/docker.sh.test.pid
	echo -e "\e[33m";
	remove >/dev/null 2>&1;
	_run;
	echo -e "\e[39m";
	sleep 1;
	echo_conf > /tmp/docker.sh.test.conf
	#echo "TEST CONFIG"
	#echo "--------------------------------------------------"
	#cat /tmp/docker.sh.test.conf
	#echo "--------------------------------------------------"

	DOCKER_SH="docker.sh -c /tmp/docker.sh.test.conf -p /tmp/docker.sh.test.pid"
	cd $DOCKER_TEST_DIR_FULL;
	echo -e "\e[96m --> TEST_PATH : `pwd`\e[39m";

	if [[ ! -s  ./${DOCKER_TEST_SCRIPT} ]]; then
		1>&2 echo "ERROR: CANOT FIND $PWD/${DOCKER_TEST_SCRIPT}";
		exit 24;
	fi
	#echo "TEST:  ${DOCKER_TEST_DIR_FULL}/${DOCKER_TEST_SCRIPT}"
	echo -e "\e[96m --> TEST SCRIPT: ${DOCKER_TEST_SCRIPT}\e[39m"

	. ./${DOCKER_TEST_SCRIPT}

	if [[ -s  ./${DOCKER_TEST_SCRIPT_IN} ]]; then
		TEST_LIB=/tmp/docker_sh_test_lib
		echo ""> $TEST_LIB
		declare -f ASSERT >>$TEST_LIB
		echo "">> $TEST_LIB
		declare -f ASSERT_ERROR >>$TEST_LIB
		echo "">> $TEST_LIB
		declare -f ASSERT_OK >>$TEST_LIB
		echo "">> $TEST_LIB

		docker cp $TEST_LIB ${CONTAINER_NAME}:/tmp
		TEST_SCRIPT_IN=/tmp/docker_test_script_in
		echo "#!/bin/bash" > ${TEST_SCRIPT_IN}
		echo ". $TEST_LIB" >> ${TEST_SCRIPT_IN}
		echo "">>${TEST_SCRIPT_IN}
		cat ${DOCKER_TEST_SCRIPT_IN} |egrep -v "#!/bin/bash" >> ${TEST_SCRIPT_IN}
		chmod +x  ${TEST_SCRIPT_IN}
		docker cp ${TEST_SCRIPT_IN} ${CONTAINER_NAME}:/tmp

		echo -e "\e[96m --> exec internal test\e[39m";
		${DOCKER_SH} exec ${TEST_SCRIPT_IN}
	fi

	echo -e "\e[96m --> Stopping container"
	${DOCKER_SH} remove >/dev/null
	echo -e "\e[39m";

}


function render_template {
	File="$1"
	VARS_FILE=$2

	if [ "x${VARS_FILE}" != "x" ]; then
		if [ -f "${VARS_FILE}" ]; then
			set -a
			source $VARS_FILE;
			set +a
		else
			echo "ERROR ${VARS_FILE} NOT FOUND"
		fi
	fi
	while read -r line ; do
		while [[ "$line" =~ (\$\{_[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
			LHS=${BASH_REMATCH[1]}
			RHS="$(eval echo "\"$LHS\"")"
			line=${line//$LHS/$RHS}
		done
		echo "$line";
	done < $File
}


function build_template {
	echo "build template";
	if [ "x${DOCKER_TEMPLATE_FILE}" == "x" ];then
		echo "ERROR: DOCKER_TEMPLATE_FILE variable missing";
		exit 1;
	fi
	OUTPUT_FILE="${DOCKER_HOME_FULL}/${DOCKER_FILE}";
	echo "## GENERATED FILE Do Not Edit" > "${OUTPUT_FILE}";
	echo "" >> "${OUTPUT_FILE}";
	echo "" >> "${OUTPUT_FILE}";

	VARS_FILE="";
	if [ "x${DOCKER_TEMPLATE_VARS}" != "x" ];then
		VARS_FILE="${DOCKER_HOME_FULL}/${DOCKER_TEMPLATE_VARS}";
	fi
	render_template "${DOCKER_HOME_FULL}/${DOCKER_TEMPLATE_FILE}"  "${VARS_FILE}" >> "${OUTPUT_FILE}";


}

function build {
	check_docker_build_dir;

	BUILD_PATH=$DOCKER_BUILD_DIR_FULL;

	MY_BUILD_PARAMS="";
	for i in ${DOCKER_BUILD_ARGS[@]}; do
		MY_BUILD_PARAMS="$MY_BUILD_PARAMS ${i}";
	done;

	if [ "$DRY_RUN" -eq "0" ]; then
		cd $BUILD_PATH;
		pwd
		echo $DOCKER_CMD;
		echo "docker build $MY_BUILD_PARAMS -f ${DOCKER_HOME_FULL}/${DOCKER_FILE} -t $DOCKER_NAME   --rm .";
		docker build $MY_BUILD_PARAMS -f ${DOCKER_HOME_FULL}/${DOCKER_FILE} -t $DOCKER_NAME   --rm .
	else
		DOCKER_CMD="docker build $MY_BUILD_PARAMS -f ${DOCKER_HOME_FULL}/${DOCKER_FILE} -t $DOCKER_NAME --rm .";
		echo "";
		echo "cd $BUILD_PATH"
		echo $DOCKER_CMD;
	fi

	check_status;
}


function tag {

	check_docker_build_dir;

	if [ -z "${TAG_NAME}" ]; then
			1>&2 echo "ERROR: VARIABLE TAG_NAME NOT SET";
			exit 16;
	fi;

	BUILD_PATH=$DOCKER_BUILD_DIR_FULL;

	if [ "$DRY_RUN" -eq "0" ]; then
		cd $BUILD_PATH;
		pwd
		echo $DOCKER_CMD;
		docker tag -f ${DOCKER_NAME} ${TAG_NAME}
	else
		DOCKER_CMD="docker tag -f docker tag -f ${DOCKER_NAME} ${TAG_NAME}";
		echo "";
		echo "cd $BUILD_PATH"
		echo $DOCKER_CMD;
	fi

	check_status;
}



function _run {

	ENTRYPOINT="";
	if [[ -n "$1" ]]; then
		ENTRYPOINT="$1"
	fi

	if [[ "$RUN_OK" -eq "0" ]]; then
		1>&2  echo "run not supported";
		exit 5;
	fi

	MY_VOLUMES="";
	for v in ${RUN_VOLUMES[@]}; do

		VOL_OK="-v";
		VOL=$(echo $v | tr ":" "\n")
		i=0;
		for m in $VOL
		do
			i=$((i + 1))
			if [ "$i" -eq 1 ]; then
				if [[ $m != /* ]]; then
					ok="${DOCKER_HOME_FULL}/$m";
				else
					ok=$m;
				fi
				VOL_OK="$VOL_OK ${ok}";
			else
				VOL_OK="$VOL_OK:${m}";
			fi;
		done

		MY_VOLUMES="$MY_VOLUMES $VOL_OK";
	done;

	#echo "VOLUMES: $MY_VOLUMES";

	MY_PORTS="";
	for p in ${RUN_PORTS[@]}; do
		MY_PORTS="$MY_PORTS -p $p";
	done;


	MY_LINKS="";
	for p in ${RUN_LINKS[@]}; do
		MY_LINKS="$MY_LINKS --link $p";
	done;


	MY_PARAMS="";
	for i in ${RUN_PARAMS[@]}; do
		MY_PARAMS="$MY_PARAMS ${i}";
	done

	ENV_FILE=`mktemp`
	AI=${!RUN_ENV[*]}
	for i in $AI; do
		echo ${RUN_ENV[i]} >> $ENV_FILE
	done

	MY_HOSTS="";
	for i in ${RUN_HOSTS[@]}; do
		MY_HOSTS="$MY_HOSTS --add-host=${i}";
	done

	if [[ -n "$ENTRYPOINT" ]]; then
		#DOCKER_CMD="docker run -i -t $IMAGE_NAME ${ENTRYPOINT}";
		DOCKER_CMD="docker run  -i --entrypoint  ${ENTRYPOINT} -t $IMAGE_NAME ";
	else
		if [[ -s $ENV_FILE ]]; then
			ENV_CMD="--env-file $ENV_FILE"
		else
			ENV_CMD=""
		fi;
		DOCKER_CMD="docker run --cidfile="$CIDFILE" $ENV_CMD $MY_PARAMS $MY_VOLUMES $MY_PORTS $MY_LINKS $MY_HOSTS --name $CONTAINER_NAME $DOCKER_NAME";
		#DOCKER_CMD="docker run  $ENV_CMD $MY_PARAMS $MY_VOLUMES $MY_PORTS $MY_LINKS $MY_HOSTS --name $CONTAINER_NAME $DOCKER_NAME";
	fi
	if [ "$DRY_RUN" -eq "0" ]; then
		if [[ -s $ENV_FILE ]]; then
			echo "ENV_FILE:"
			cat $ENV_FILE
			echo ""
		fi
		echo '----------------------------------------------------------------------'
		echo $DOCKER_CMD;
		echo '----------------------------------------------------------------------'

		#ID=$($DOCKER_CMD)
		ID=`$DOCKER_CMD`

		check_status;

		docker inspect $ID  >/dev/null 2>&1 || rm "$CIDFILE"

		#echo $ID
		#echo $ID>$CIDFILE
	else
		if [[ -s $ENV_FILE ]]; then
			echo "ENV_FILE:"
			cat $ENV_FILE
			echo "";
		fi;
		echo $DOCKER_CMD;
	fi

	#echo "rm ENV: $ENV_FILE"
	rm  $ENV_FILE



}



function exec_bash  {
	if [ "$DRY_RUN" -eq "0" ]; then
		if [ -z "$1" ]; then
			docker exec -i -t $CONTAINER /bin/bash -l
		else
			docker exec -i -t $CONTAINER  /bin/sh -c "cd $1; bash -l"
		fi
	else
		if [ -z "$1" ]; then
			echo "docker exec -i -t $CONTAINER /bin/bash -l"
		else
			echo "docker exec -i -t $CONTAINER /bin/sh -c 'cd $1; bash -l'"
		fi
	fi
	exit;

}

function _remove {

if [ "$DRY_RUN" -eq "0" ]; then
	echo "docker stop $CONTAINER_NAME";
	echo "docker rm -v $CONTAINER_NAME";
	if [[ -f $CIDFILE ]];then
		echo "rm $CIDFILE";
	fi
	docker stop $CONTAINER_NAME 2>/dev/null
	docker rm -v $CONTAINER_NAME 2>/dev/null
	if [[ -f $CIDFILE ]];then
		rm $CIDFILE
	fi
else
	echo "docker stop $CONTAINER_NAME";
	echo "docker rm -v $CONTAINER_NAME";
	if [[ -f $CIDFILE ]];then
		echo "rm $CIDFILE";
	fi
fi

}

function _copy {
	if [ -z "$1" ]; then
		1>&2  echo "Usage: $0 copy [PATH_IN] [PATH_OUT]";
			exit
	fi
	if [ -z "$2" ]; then
		1>&2  echo "Usage: $0 copy [PATH_IN] [PATH_OUT]";
			exit
	fi

	#if [ -z "${CONTAINER}" ]; then
	#		echo "canot find container";
	#	exit;
	#fi

	echo "docker cp $CONTAINER_NAME:$1 $2";
	docker cp $CONTAINER_NAME:$1 $2
	exit;

}

function edit {
	if [ -z "$1" ]; then
		1>&2  echo "Usage: $0 edit [FILE]";
			exit
	fi

	if [ -z "${CONTAINER}" ]; then
		1>&2  echo "canot find container";
		exit;
	fi

	FILEPATH="/var/lib/docker/aufs/mnt/${CONTAINER}/$1";

	echo $FILEPATH
	sudo gedit $FILEPATH
	exit

}

function _ls {
	if [ -z "$1" ]; then
		1>&2  echo "Usage: $0 ls [PATH]";
			exit;
	fi

	#FILEPATH="/var/lib/docker/aufs/mnt/${CONTAINER}/$2";
	#docker exec -i -t $CONTAINER_NAME file $2
	docker exec -i -t $CONTAINER_NAME ls -altr $1
	exit;

}

function _cat {
	if [ -z "$1" ]; then
			1>&2  echo "Usage: $0 cat [PATH]";
			exit 1;
	fi

	docker exec -i -t $CONTAINER_NAME cat $1
	return;

}

function _top {
	docker top $CONTAINER_NAME
	check_status;
}

function logs {
	docker logs $CONTAINER_NAME
	check_status;
}

function _find {
	docker exec -i -t $CONTAINER_NAME find /
	check_status;
}


function inspect {

	if [ -z "${CONTAINER}" ]; then
		docker inspect $CONTAINER_NAME
	else
		echo "container:  ${CONTAINER}";
		docker inspect $CONTAINER
	fi

	check_status;
}

function get_ip {
	if [ -z "${CONTAINER}" ]; then
		1>&2  echo "canot find container";
		return;
	fi
	#echo "container:  ${CONTAINER}";
	docker inspect $CONTAINER | grep \"IPAddress\": | sed -e 's/.*: "//; s/".*//'|tail -1
	return;
}

function _start {
	docker start $CONTAINER_NAME
	check_status;
}

function _save {
	echo "docker save $DOCKER_NAME > $CONTAINER_NAME.tar"
	docker save $DOCKER_NAME > $CONTAINER_NAME.tar
	check_status;
}

function _stop {
	docker stop $CONTAINER_NAME
}

function print_ps {
	docker ps
}
function print_info {
	echo   "# ------------------------------------------------------------------------------------------------";
	if [[ ! "x$CONTAINER" = "x" ]]; then
		echo   " CONTAINER             : "$(_container);
		echo   " CONTAINER12           : "$(_container12);
		echo   " CONTAINER_ROOT        : /var/lib/docker/aufs/mnt/${CONTAINER}";
		echo "#"
	fi
	echo   " DOCKER_NAME           : $DOCKER_NAME";
	echo   " DOCKER_HOME_FULL      : $DOCKER_HOME_FULL";
	echo   " DOCKER_BUILD_DIR_FULL : $DOCKER_BUILD_DIR_FULL";
	echo   " DOCKER_TEST_DIR_FULL  : $DOCKER_TEST_DIR_FULL"
	echo   " DOCKER_TEST_SCRIPT    : $DOCKER_TEST_SCRIPT"
	echo   " EXTRA_CONF_VAR_NAMES  : ${EXTRA_CONF_VAR_NAMES[*]}";
	echo   " DOCKER_FILE           : $DOCKER_FILE";
	echo   " IMAGE_NAME            : $IMAGE_NAME";
	echo   " CONTAINER_NAME        : $CONTAINER_NAME";
	echo   " PIDFILE               : $CIDFILE"
	echo "# RUN PARAMETERS:"
	printf ' RUN_HOSTS       : %s\n' "${RUN_HOSTS[*]}";
	printf ' RUN_ENV         : %s\n' "${RUN_ENV[*]}";
	printf ' RUN_PORTS       : %s\n' "${RUN_PORTS[*]}";
	printf ' RUN_VOLUMES     : %s\n' "${RUN_VOLUMES[*]}";
	printf ' RUN_LINKS       : %s\n' "${RUN_LINKS[*]}";
	printf ' RUN_PARAMS      : %s\n' "${RUN_PARAMS[*]}";

	echo "# OTHER PARAMETERS:"
	for SV in ${CONF_VAR_NAMES[*]};do
			NOTFUND=`echo "$SV" | egrep -e "^DOCKER_HOME" -e "^DOCKER_BUILD_DIR" -e "^IMAGE_NAME" -e "^CONTAINER_NAME" -e "^DOCKER_FILE" \
			 -e "^RUN_VOLUMES" -e "^RUN_PORTS" -e "^RUN_LINKS" -e "^RUN_ENV" -e "^RUN_HOSTS" -e "^RUN_PARAMS" -e "^DOCKER_TEST"|| echo "Y"`;
			if [ "x${NOTFUND}" == "xY" ];then

				SVV=${!SV}
				if [ "x${SVV}" != "x" ];then
					IS_ARRAY=`declare -p ${SV}  2> /dev/null | grep -q 'declare \-a' && echo "Y"`
					if [ "x${IS_ARRAY}" == "xY" ]; then
						echo " ${SV} : ${SVV} ...";
					else
						if [[ ${SVV} == *$'\n'* ]];then
							echo " ${SV} : ..."
						else
							echo " ${SV} : ${SVV}"
						fi
					fi
				fi
				#declare -p $SV 2>/dev/null;
			fi
	done;

	echo "# EXTRA_CONF_VARIABLES:";
	for SV in ${EXTRA_CONF_VAR_NAMES[*]};do
			if [[ ${!SV} == *$'\n'* ]];then
					echo " ${SV} : .........."
				else
					echo " ${SV} : ${!SV}";
				fi
				#echo " ${SV} : ${!SV}";
		#declare -p $SV 2>/dev/null;
	done;
	echo   "# ------------------------------------------------------------------------------------------------";




}


function _echo_var {
	if [[ ! "x${!1}" == "x" ]];then
		if [[ "$VN" == "DOCKER_HOME" ]]; then
			declare -p  'DOCKER_HOME_FULL'| sed s/DOCKER_HOME_FULL=/DOCKER_HOME=/;
		elif [[ "$VN" == "DOCKER_BUILD_DIR" ]]; then
			declare -p  'DOCKER_BUILD_DIR_FULL'| sed s/DOCKER_BUILD_DIR_FULL=/DOCKER_BUILD_DIR=/;
		elif [[ "$VN" == "DOCKER_TEST_DIR" ]]; then
			declare -p  'DOCKER_TEST_DIR_FULL'| sed s/DOCKER_TEST_DIR_FULL=/DOCKER_TEST_DIR=/;
		else
			declare -p $1
		fi
	fi
}


function echo_var {
	echo "${!1}"
}

function get_var {
	declare -p ${1}
}

function echo_vars {
	for VN in "${ALL_CONF_VAR_NAMES[@]}";do
		_echo_var $VN;
	done;
}

function export_vars {
	VAR_FILE=`mktemp`;
	echo_vars > $VAR_FILE
	echo $VAR_FILE
}

function echo_conf {
	echo "####################################################################"
	echo "#generated:  `date +%Y-%m-%d_%H:%M:%S" "%Z -u`"
	echo "####################################################################"
	echo ""
	echo "#MAIN PARAMS:"

	#DOCKER_HOME="."
	#DOCKER_BUILD_DIR="."

	for VN in ${CONF_VAR_NAMES[@]};do
		_echo_var $VN;
	done;
	echo "#EXTRA PARAMS:"
	for VN in ${EXTRA_CONF_VAR_NAMES[@]};do
		_echo_var $VN;
	done;

}


function make_default_conf {
	CONF_FILE=.docker.sh.conf
	echo_conf > $CONF_FILE
	echo "$CONF_FILE  CREATED:";
	cat $CONF_FILE
}


#CHECK: /home/user/opt/dev1/devkits/dk1/docker/generic
#/home/user/opt/dev1

function _translate_exec_wd {
	IN_DIR=${EXEC_WD}
	if [ "x${DOCKER_EXEC_WD_MAPPING}" == "x" ]; then
		return;
	fi
	c=0;
	for key in "${DOCKER_EXEC_WD_MAPPING_KEY[@]}";do
		if [ "${IN_DIR##$key}" != "$IN_DIR" ];then
			REPLACEMENT="${DOCKER_EXEC_WD_MAPPING_VAL[$c]}"
			EXEC_WD=${IN_DIR/$key/$REPLACEMENT}
			return
		fi
		#if [ "x${key}" == "x${IN_DIR}" ];then
		#	EXEC_WD="${DOCKER_EXEC_WD_MAPPING_VAL[$c]}"
		#	return;
		#fi
		((c+=1))
	done
}

function docker_exec {
	ARGS='';
	for ai in "$@";do  ARGS="$ARGS `printf "%q" "$ai"`"; done
	#echo "docker.sh ARGS: $ARGS"
	if [[ "x${DEFAULT_WD}" == "x"  &&  "x${DOCKER_EXEC_DEFAULT_WD}" != "x" ]]; then
		DEFAULT_WD="${DOCKER_EXEC_DEFAULT_WD}";
	fi
	if [[ "x${EXEC_WD}" == "x" && "x${DEFAULT_WD}" == "xPWD" ]]; then
		H_PWD=`pwd`;
		EXEC_WD=`readlink -f ${H_PWD}`;
	fi

	CD_CMD='';
	if [ "x${EXEC_WD}" != "x" ];then
		if [ "x${DOCKER_EXEC_WD_MAPPING}" != "x" ]; then
			_translate_exec_wd
		fi
		#echo "WORKING_DIR : $EXEC_WD"

		if [ "x${EXEC_WD_ON_ERROR}" == "xEXIT" ];then
			CD_CMD=" test -d ${EXEC_WD} && cd ${EXEC_WD} || (echo \"WD ERROR: ${EXEC_WD} NOT EXISTS\"; exit 2) &&";
		else
			CD_CMD="cd ${EXEC_WD} 2>/dev/null ; ";
		fi
	fi;

	if [ -t 0 ] && [ "x${EXEC_ARGS}" == "x" ]; then
		EXEC_ARGS="--interactive  --tty"
	fi

	SUDO_CMD='';
	if [ "x${EXEC_GOSU}" != "x" ];then
		SUDO_CMD="gosu ${EXEC_GOSU}";
	elif [ "x${EXEC_SUDO}" != "x" ];then
		SUDO_CMD="sudo -u ${EXEC_SUDO}";
	fi
	if [ "x${EXEC_USER}" != "x" ];then
		EXEC_ARGS="${EXEC_ARGS} -u ${EXEC_USER}";
	fi

	BASH_EXTRA_ARGS=''
	if [[ $EXEC_ARGS == *"--interactive"* ]]; then
     BASH_EXTRA_ARGS="-i";
	fi

	if [ "$DRY_RUN" -eq "1" ]; then
			echo "docker exec ${EXEC_ARGS} $CONTAINER ${SUDO_CMD} bash ${BASH_EXTRA_ARGS} -c  \"$CD_CMD $ARGS\""
			return;
	fi

	if [ -t 0 ]; then
		docker exec ${EXEC_ARGS} $CONTAINER ${SUDO_CMD} bash ${BASH_EXTRA_ARGS} -c "$CD_CMD  $ARGS"
	else
		OK_EXEC_ARGS=${EXEC_ARGS/--tty/}
		cat - | docker exec -i ${OK_EXEC_ARGS} $CONTAINER ${SUDO_CMD} bash -c "$CD_CMD  $ARGS"
	fi
	return;
}



function _container12() {
	c12=`echo $CONTAINER|cut -c1-12`;
	run_test=`docker ps|grep "^$c12"|wc -l`;
	#echo "3# $run_test #"
	if [ "x${run_test}" != "x1" ];then
		echo '';
		return;
	fi
	echo $c12;
}

function _container {
	c12=$(_container12)
	if [ "x${c12}" == 'x' ];then
		echo '';
	else
		echo $CONTAINER;
	fi
}


FIRST_ARG=1
function print_banner  {
	if [ "$FIRST_ARG" -eq "0" ]; then
		arg=$1;
		echo "-------------------------------------------------------------------------------------";
		echo "${arg}:";
		echo "-------------------------------------------------------------------------------------";
		echo ""
	fi
}

if [ "x${DOCKER_SH_LIB_MODE}" != "x1" ];then
while (( "$#" )); do
	var=$1;
	shift

	case $var in
				"help")
					print_banner $var;
					print_help;
					;;
				"help:config")
					print_banner $var;
					print_config_help;
					;;
				"help:exec")
					print_banner $var;
					print_exec_help;
					;;
				"build:template")
					print_banner $var;
					build_template;
					;;
				"build")
					print_banner $var;
				build;
					;;
				"tag")
					print_banner $var;
				tag;
					;;
				"test")
					print_banner $var;
				_test;
					;;
					"run")
						print_banner $var;
						_run;
					;;
			"run:bash")
				print_banner $var;
				run "/bin/bash";
					;;
				"bash")
					#print_banner $var;
				exec_bash "$@";
					;;
				"remove")
					print_banner $var;
				_remove;
					;;
				"exec")
					docker_exec "$@"
					exit;
					;;
				"copy")
					print_banner $var;
				_copy "$@";
					;;
				"edit")
					print_banner $var;
				edit "$@";
					;;
				"ls")
					print_banner $var;
				_ls "$@";
					;;
				"cat")
				_cat "$@";
				exit;
					;;
			"find")
				print_banner $var;
				_find;
			;;
			"top")
				print_banner $var;
				_top;
			;;
			"logs")
				print_banner $var;
				logs;
			;;
			"inspect")
				print_banner $var;
				inspect;
			;;
			"ip")
				get_ip;
				exit;
			;;
			"container")
				_container
				exit;
			;;
			"container12")
				_container12
				exit;
			;;
			"start")
				print_banner $var;
				_start;
			;;
			"stop")
				print_banner $var;
				_stop;
			;;
			"info")
				print_banner $var;
				print_info;
			;;
			"ps")
				print_banner $var;
				print_ps;
			;;
			"save")
				print_banner $var;
				_save;
			;;
			"example")
				print_banner $var;
				config_example;
			;;
			"get_var")
			get_var $1
			shift;
			;;
			"echo_var")
			echo_var $1
			shift;
			;;
			"echo:conf")
				print_banner $var;
				echo_conf;
			;;
			"make-default-conf")
				print_banner $var;
				make_default_conf;
			;;
			"echo:vars")
				print_banner $var;
				echo_vars;
			;;
			"version")
				echo $DOCKER_SH_VERSION;
			;;
			"export:vars")
				export_vars;
			;;
		 *)
				EXEC_FLAG=0
				if [ "x${ACTION_NAMES}" != "x" ]; then
					AL1=${#ACTION_NAMES[@]}
					((LL=AL1-1))
					for i in `seq 0 $LL`;do
						if [ "x${var}" == "x${ACTION_NAMES[$i]}" ];then
							if [ "x${ACTION_FUNCTIONS[$i]}" != "x" ];then
								EFLAGS=''
								if [ "x${ACTION_FLAGS[$i]}" != "x" ];then
									EFLAGS=#{ACTION_FLAGS[$i]};
								fi
								EXEC_FLAG=1
								if [ "x${EFLAGS}" == "xno_parse_args" ]; then
									eval "${ACTION_FUNCTIONS[$i]}" "$@"
								else
									ARGS='';
									for ai in "$@";do
										ARGS="$ARGS `printf "%q" "$ai"`";
									done
									#echo $ARGS
									#echo "${ACTION_FUNCTIONS[$i]}"
									eval "${ACTION_FUNCTIONS[$i]}" $ARGS
								fi
								exit;
							fi
						fi
					done
				fi

				if [ $EXEC_FLAG -eq 0 ];then
							 1>&2  echo "UNKNOWN COMMAND: $var";
				fi
					;;
	 esac
	echo "";
	FIRST_ARG=0
done
fi





