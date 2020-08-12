#!/bin/bash
bak_path=/home/app/bak
echo "select a work to do "
select var in "wxtv-admin-server" "wxtv-wechat-server" "Free" "wxtv-admin-frontend" "varys"; do
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
ansible-playbook /home/app/ansible-deploy/frontend_deloy.yml -i /home/app/ansible-deploy/inventory/hosts \
 -e deploy_path="/home/app/bak/$var" \
 -e service_name="$var" \
 -e user="app" \
 -e hosts="wxtv-test01" \
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

port=2001
ProjectName=$var
ansible-playbook /home/app/ansible-deploy/spring_deloy.yml -i /home/app/ansible-deploy/inventory/hosts \
-e deploy_path="/home/app/$ProjectName" \
-e service_name="$var" \
-e user="app" \
-e hosts="wxtv-test01" \
-e service_port="$port" \
-e deploy_file="$bak_path/${ProjectName}/$version" \
-e "start_cmd='nohup /home/app/opt/jdk/bin/java -Dserver.port=$port -jar $version --server.address=0.0.0.0  > ${ProjectName}.log 2>&1 &'"

echo "$var finished deployment";;
*)
echo "go";;
esac
