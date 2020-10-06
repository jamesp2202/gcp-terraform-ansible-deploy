import sys
import re
import os
import subprocess


##Needed paths
paths = {
        'terra-path':"Terraform/"
        }
        
build_args = {
              'terraform':"terraform apply"
             }
destroy_args = {
              'terraform':"terraform destroy"
             }
                          

##Build the enviroment
def build():
    for key,value in build_args.items():
        if key == "terraform":
            subprocess.call(value, shell=True, cwd=paths["terra-path"])
        else:
            continue

def destroy():
    for key,value in destroy_args.items():
        if key == "terraform":
            subprocess.call(value, shell=True, cwd=paths["terra-path"])
        else:
            continue





def help():
    print("""
           ###########Help###########
           Please select from one of the below
           build - builds the development enviroment
           destroy - destroys the development enviroment
           Help - Displays the help information
         """)


###User Input
if len(sys.argv) == 1:
   help()
elif sys.argv[1] == "build":
    build()
elif sys.argv[1] == "destroy":
    destroy()
else:
    help()










