import sys
import re
import os
import subprocess

##Needed paths- Not done Ansible yet.
paths = {'terra-path':"Terraform/"}
commands ={'build': ["terraform apply"], 'destroy': ["terraform destroy"]}
## Main Build/Destroy
def mainFunc(command):
        for v in commands[command]:
            subprocess.call(v, shell=True, cwd=paths["terra-path"])
###Help Function
def help():
        print("""
           ###########Help###########
           Please select from one of the below
           build - builds the development enviroment
           destroy - destroys the development enviroment
           Help - Displays the help information
         """)
###User Input
if len(sys.argv) == 1 or  sys.argv[1] == "help":
   help()
else:
    mainFunc(sys.argv[1])










