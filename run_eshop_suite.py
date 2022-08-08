import sys
import time
import robot

import argparse
parser = argparse.ArgumentParser(description='Utility to execute given robotfile as last argument ')
parser.add_argument('-env', metavar="ENVIRONMENT", help='Supported ENVIRONMENT values : MAJOR,PREPROD(default),PRODUCTION',
                    default="PREPROD",choices=['MAJOR', 'PREPROD','PRODUCTION'])
parser.add_argument('-tag', metavar="TAGS")
parser.add_argument('RobotFile', help='Please provide Robot filename under folder:tests ')
args = vars(parser.parse_args())

app_name = "ESHOP"
env_name = args['env']
tag_value = args['tag']
env_value = "env:" + env_name
reference_dir = "application/"+app_name+"/"+env_name
result_dir = reference_dir +"/results/"
testsuite_dir = reference_dir +"/tests/"
timestamp = time.strftime("%d%b%Y-%H%M%S")
out_dir = result_dir+timestamp
robot_file = sys.argv[-1]
robot.run_cli(['--outputdir', out_dir] + ['--variable', env_value] +['--include', tag_value]+ [testsuite_dir + robot_file])


