import sys
import re
import os
import subprocess
helpstr = """
           ###########Help###########
           Please select from one of the below
           build - builds the development enviroment
           destroy - destroys the development enviroment
           help - Displays the help information
         """
paths = {'terra-path':"Terraform/"}
commands ={'build': ["terraform apply"], 'destroy': ["terraform destroy"]}

def mainFunc(command):
        if command == "help":
            print(helpstr)
        else:
            for v in commands[command]:
                subprocess.call(v, shell=True, cwd=paths["terra-path"])
       
if __name__ == "__main__":
    if sys.argv[1] in commands:
        mainFunc(sys.argv[1])
    else:
        mainFunc("help")










