import sys
import re
import os


paths = {'google-key-path':"/mnt/c/Users/James/Web Project/Terraform/google-key.json", 'terra-path':"/mnt/c/Users/James/Web Project/Terraform/"}

def build():
    print("Exporting google application credentials")
    os.system('export GOOGLE_APPLICATION_CREDENTIALS={{paths["google-key-path"}}')
    print("key exported")
    os.system('cd' paths["terra-path"])
    #os.system("terraform apply")
    

def destroy():
    print("destroy")



def help():
    print("""
           ###########Help###########
           Please select from one of the below
           build - builds the development enviroment
           destroy - destroys the development enviroment
           Help - Displays the help information
         """)

           
###User Input Loop
if len(sys.argv) == 1:
   help()
elif sys.argv[1] == "build":
    build()
elif sys.argv[1] == "destroy":
    print("destroy")
else:
    help()










