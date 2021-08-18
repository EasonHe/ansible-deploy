## jenkins +  ansible  deploy  spring boot  and  deploy vue static files  
Support rollback
## ansible-deploy
-  install  jenkins  plugin 
   AnsiColor and,
   Ansible plugin,
   pipeline
- use  jenkinsfile    to  build  project  
- jenkins 部署示例参考doc

## 模板参数
```yaml
apps:
  - script: "{{CMD_OR_SCRIPT}}"                 # 文件或者命令
    name: "{{JOBNAME}}"          # 程序名称
    cwd: "{{DEPLOY_PATH}}"    
    args: "{{ARGS}}"             #启动参数   
    log_file: "{{LOG_FILE}}"     #所有的日志
    error_file: "{{ERROR_FILE}}" #错误或者警告日志
    out_file: "{{OUT_FILE}}"     #正常输出日志    
    env:                         # 环境变量
      COMMON_VARIABLE: true
```
## linux commond to run 
 ```sh
ansible-playbook /home/app/ansible-deploy/spring_deloy.yml \
 -i /home/app/ansible-deploy/inventory/hosts\
 -e deploy_path=/home/app/app/demo/instance01\ 
 -e instance_name=demo-instance01\
 -e user=app\ 
 -e hosts=157\
 -e deploy_file=/home/app/app/demo/demo-0.0.1-SNAPSHOT.jar\
 -e LOG_FILE=~/.pm2/logs/demo.log\   #pm2 模板相关的参数是大写
 -e ops=deploy\
 -e ARGS="-Dserver.port={{service_port}} -jar demo-0.0.1-SNAPSHOT.jar"  
 -e "start_cmd='pm2 delete  spring.yaml && pm2 start spring.yaml'"
```
## 前端工程部署代码片段
```sh
stage('deploy_test01'){
        ansiColor('xterm') {
        ansiblePlaybook( 
        playbook: '/home/ci/sudeploy-test/frontend_deloy.yml',
        inventory: '/home/ci/sudeploy-test/inventory/hosts', 
        colorized: true,
        extraVars: [
          'deploy_path' : "/data/resource/bak/${ProjectName}" ,
          'service_name':  "$ProjectName" ,     //"$ProjectName",
          'user': 'nginx',
          'hosts': "test01",//ip  or  hostname
          'link_path': "/usr/local/nginxserver/nginx/html",
          'link_name': "act",
          'deploy_file':  "$bak_path/$ProjectName/$rsy_name",
        ]
        ) 
  }
    }  
```
