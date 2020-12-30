#!/bin/bash
bak_path=/opt/hdc/bak
echo "select a work to do "
select var in "wxtv-admin-server" "wxtv-wechat-server" "wxtv-box-hub" "wxtv-admin-frontend" "wxtv-mri-server" "rpns-backend" "rpns-frontend" ; do
  path="${bak_path}/$var"
  if [ ! -d ${path} ] ;then
  echo "the path ${path}  not exis"
  exit 111;
  fi
  break;
done
echo "You have selected $var"

case $var in
"wxtv-admin-frontend")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done
ansible-playbook /opt/hdc/soft/ansible-deploy/frontend_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
 -e deploy_path="/opt/weixin/bak/$var" \
 -e service_name="$var" \
 -e user="app" \
 -e hosts="wxtv-" \
 -e link_path='/home/app/app/openresty/nginx/html' \
 -e link_name='pcadmin' \
 -e deploy_file="$bak_path/${var}/$version"

 echo "$var finished deployment";;

"wxtv-admin-server")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done

port=8251
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="admin-server" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> ${ProjectName}.log 2>&1 &'"
echo $?
echo "$var finished deployment";;

"wxtv-wechat-server")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done
#实例1
port=8201
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="wechat-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8202
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="wechat-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}02.log 2>&1 &'"
echo "$var finished deployment"

#第二和第三台主机
port=8201
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="wechat-[02-03]" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8202
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="wechat-server[01:02]" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}02.log 2>&1 &'"
echo "$var finished deployment";;

#########box-hub
"wxtv-box-hub")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done
#实例1
port=8211
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="box-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8212
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="box-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}02.log 2>&1 &'"
echo "$var finished deployment";;

#第二和第三台主机
port=8211
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="box-[02-03]" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8212
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="box-hub[01:02]" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> /data01/weixin_logs/${ProjectName}02.log 2>&1 &'"
echo "$var finished deployment";;
#########################mir
"wxtv-mir-server")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done
#实例1
port=8261
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="mri-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> ${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8261
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="mri-02" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> ${ProjectName}01.log 2>&1 &'"

port=8261
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="mri-03" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Dserver.port=$port -jar $version --server.address=0.0.0.0  >> ${ProjectName}01.log 2>&1 &'"
echo "$var finished deployment";;

######rpns-backend
"rpns-backend")
  name=`ls -t $bak_path/${var}/ | awk  -F '/'  '{print $NF}'`
  select  version in `echo $name` ; do
    echo  $version
    break
  done
#实例1
port=8221
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="rpns-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Djava.security.egd=file:/dev/./urandom -jar $version  --Rbackend.context-path=/rpns --Rbackend.port=$port --Rcluster.back.host=192.168.98.154 --Rcluster.back.port=11093  >> /opt/data/weixin_logs/${ProjectName}01.log 2>&1 &'"

if (test $? -ne 0)
then
echo "第一个实例部署失败"
exit 222
fi
#实例2
port=8221
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="rpns-02" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Djava.security.egd=file:/dev/./urandom -jar $version  --Rbackend.context-path=/rpns --Rbackend.port=$port --Rcluster.back.host=192.168.98.154 --Rcluster.back.port=11093  >> ${ProjectName}01.log 2>&1 &'"

port=8221
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance02" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="rpns-03" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup  java -Djava.security.egd=file:/dev/./urandom -jar $version  --Rbackend.context-path=/rpns --Rbackend.port=$port --Rcluster.back.host=192.168.98.154 --Rcluster.back.port=11093  >> ${ProjectName}01.log 2>&1 &'"
echo "$var finished deployment";;

rpns-frontend)
port=8151
ProjectName=$var
ansible-playbook /opt/hdc/soft/ansible-deploy/spring_deloy.yml -i /opt/hdc/soft/ansible-deploy/inventory/hosts \
-e deploy_path="/opt/weixin/app/$ProjectName/instance01" \
-e service_name="$var" \
-e user="weixin" \
-e hosts="rpns-01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup java  -Djava.security.egd=file:/dev/./urandom    -jar  $version --Rinitial.backends=192.168.98.154:8221 --Rsocket.host=111.48.254.23 --Rsocket.port=8151 --Rcluster.front.port=11094     >> /opt/data/weixin_logs/${ProjectName}${port}.log  2>&1 &'"
;;
*)
echo "go";;
esac
