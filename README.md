jenkins +  ansible  deploy  spring boot  and  deploy vue static files  
Support rollback
# ansible-deploy
1. install  jenkins  plugin 
   AnsiColor and
   Ansible plugin
2.use  jenkinsfile    to  build  project  
Example   in document

##
#commond  
ansible-playbook /home/ci/sudeploy-test/frontend_deloy.yml -i /home/ci/sudeploy-test/inventory/hosts -e deploy_path=/data/resource/bak/ynpc-act-frontend -e service_name=ynpc-act-frontend -e user=nginx -e hosts=test01 -e link_path=/usr/local/nginxserver/nginx/html -e link_name=act -e deploy_file=/home/ci/bak/ynpc-act-frontend/09251542_ynpc-act-frontend

#jenkins run step

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
}
