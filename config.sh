#!/usr/bin/env bash
#Example from: http://stackoverflow.com/questions/5228345/bash-script-how-to-reference-a-file-for-variables

source config.properties

if [ "$OOS_MODULE_APEX" = "N" ]; then
  OOS_MODULE_ORDS=N;
  OOS_MODULE_TOMCAT=N;
  OOS_MODULE_NODE4ORDS=N;
else
  OOS_MODULE_ORDS=Y;
  OOS_MODULE_TOMCAT=Y;
fi;

#Always install Node.js
OOS_MODULE_NODEJS=Y

if [ "$OOS_MODULE_ORACLE" = "N" ]; then
  OOS_MODULE_NODE_ORACLEDB=N;
fi;


if [ -z "$OOS_SQLCL_FILE_URL" ]; then
  OOS_MODULE_SQLCL=N
else
  OOS_MODULE_SQLCL=Y
  OOS_SQLCL_FILENAME=${OOS_SQLCL_FILE_URL##*/}
fi

echo \*\*\* Module Configuration \*\*\*
echo OS: $OOS_OS_TYPE
echo Oracle XE: $OOS_MODULE_ORACLE
echo SQLcl: $OOS_MODULE_SQLCL
echo APEX: $OOS_MODULE_APEX
echo ORDS: $OOS_MODULE_ORDS
echo Tomcat: $OOS_MODULE_TOMCAT
echo Node4ORDS: $OOS_MODULE_NODE4ORDS
echo Node.js: $OOS_MODULE_NODEJS
echo Node-oracledb: $OOS_MODULE_NODE_ORACLEDB

OOS_ORACLE_FILENAME=${OOS_ORACLE_FILE_URL##*/}
OOS_ORACLE_FILENAME_RPM=${OOS_ORACLE_FILENAME%.*}
OOS_APEX_ZIP_FILENAME=${OOS_APEX_FILE_URL##*/}
OOS_TOMCAT_ZIP_FILENAME=${OOS_TOMCAT_FILE_URL##*/}
OOS_ORDS_FILENAME=${OOS_ORDS_FILE_URL##*/}



#Call Validations
source ./scripts/config_validation.sh
