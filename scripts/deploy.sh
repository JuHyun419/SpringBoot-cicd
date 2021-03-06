#!/bin/bash
BUILD_JAR=$(ls /home/ec2-user/jenkins/build/libs/*.jar) # jar 경로
JAR_NAME=$(basename $BUILD_JAR) # basename: 경로와 확장자를 제거한 순수 파일 이름
echo "> build 파일명: $JAR_NAME" # /home/ec2-user/deploy.log

echo "> build 파일 복사" # /home/ec2-user/deploy.log
DEPLOY_PATH=/home/ec2-user/
cp $BUILD_JAR $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" # /home/ec2-user/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." # /home/ec2-user/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  sudo kill -15 $CURRENT_PID
  sleep 7
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포" # /home/ec2-user/deploy.log
#nohup java -jar $DEPLOY_JAR /dev/null 2>&1 &
nohup java -jar $DEPLOY_JAR > /dev/null 2> /dev/null < /dev/null &