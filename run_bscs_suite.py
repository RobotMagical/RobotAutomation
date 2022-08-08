import optparse
import sys
import time
import robot
import argparse
from os import listdir
from os.path import isfile, join

parser = argparse.ArgumentParser(description='Utility to execute given robotfile as last argument ')
parser.add_argument('-env', metavar="ENVIRONMENT", help='Supported ENVIRONMENT values : MAJOR(default),PREPROD',
                    default="MAJOR",choices=['MAJOR', 'PREPROD'])
parser.add_argument('-tag', metavar="TAGS", help='Supported TAGS values : sanity,regression',choices=['sanity', 'regression'])
parser.add_argument('RobotFile', help='Please provide RobotFile name under folder:tests')
args = vars(parser.parse_args())

app_name = "BSCS"
env_name = args['env']
tag_value = args['tag']
env_value = "env:" + env_name
reference_dir = "application/"+app_name+"/"+env_name
result_dir = reference_dir +"/results/"
testsuite_dir = reference_dir +"/tests/"
timestamp = time.strftime("%d%b%Y-%H%M%S")
out_dir = result_dir+timestamp
robot_file = sys.argv[-1]
exitcode = robot.run_cli(['--outputdir', out_dir] + ['--variable', env_value] +['--include', tag_value]+ [testsuite_dir + robot_file],exit=False)
#print("return code:",exitcode)
if exitcode == 252:
    validRobotfiles = [f for f in listdir(testsuite_dir) if isfile(join(testsuite_dir, f))]
    print("\nPlease provide correct RobotFile fullname or prefix*. For example: TC001* will invoke TC001__consumer_account.robot ")
    print("RobotFile name list:\n", validRobotfiles)

