#!/bin/sh

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy.sh"
	exit 1
}

# SQL files are imported into the external Dameng databases directly.

# copy html
echo "begin copy html "
cp -r ../integrity-ui/dist/** ./nginx/html/dist


# copy jar
echo "begin copy integrity-gateway "
cp ../integrity-gateway/target/integrity-gateway.jar ./integrity/gateway/jar

echo "begin copy integrity-auth "
cp ../integrity-auth/target/integrity-auth.jar ./integrity/auth/jar

echo "begin copy integrity-visual "
cp ../integrity-visual/integrity-monitor/target/integrity-visual-monitor.jar  ./integrity/visual/monitor/jar

echo "begin copy integrity-modules-system "
cp ../integrity-modules/integrity-system/target/integrity-modules-system.jar ./integrity/modules/system/jar

echo "begin copy integrity-modules-file "
cp ../integrity-modules/integrity-file/target/integrity-modules-file.jar ./integrity/modules/file/jar

echo "begin copy integrity-modules-job "
cp ../integrity-modules/integrity-job/target/integrity-modules-job.jar ./integrity/modules/job/jar

echo "begin copy integrity-modules-gen "
cp ../integrity-modules/integrity-gen/target/integrity-modules-gen.jar ./integrity/modules/gen/jar
