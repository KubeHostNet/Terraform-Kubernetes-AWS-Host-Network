## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
import subprocess
import os 

try:
    subprocess.run("terraform output", shell=True, check=True)
except Exception as e:
    print("stdout output:\n", e.output)
    sys.exit()
