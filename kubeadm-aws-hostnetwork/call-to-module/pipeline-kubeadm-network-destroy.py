## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
import subprocess
import os 

subprocess.run("terraform destroy -auto-approve -var-file="+os.environ['TF_VAR_PATH_TO_K8S_IAM_KEYS']+"awspublickey.tfvars -var-file="+os.environ['TF_VAR_PATH_TO_K8S_IAM_KEYS']+"awsvpcmeta.tfvars -var-file="+os.environ['TF_VAR_PATH_TO_K8S_IAM_KEYS']+"awskeymeta.tfvars", shell=True, check=True)
