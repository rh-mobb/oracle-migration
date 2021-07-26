print 'Deploying MedRec application ....'
# Modify these values as necessary
import os,sys, traceback
scriptName = sys.argv[0]
adminHost=os.environ["ADM_HOST"]
adminPort=os.environ["ADM_PORT"]
admServerUrl = 't3://'+adminHost+':'+adminPort
ttServerName=os.environ["TTSVR_NAME"]
adminUser='weblogic'
adminPwd='welcome1'
#
appName = 'medrec'
appSource = '../ear/medrec.ear'
#
# Deploy the application
def deployApplication(appName, appSource, targetServerName):
  print 'Deploying application ' + appName + '.'
  progress = deploy(appName=appName,path=appSource,targets=targetServerName)
  # Wait for deploy to complete
  while progress.isRunning():
   pass
  print 'Application ' + appName + ' deployed.'
#
#
def main():
  # Connect to administration server
  try:
    connect(adminUser, adminPwd, admServerUrl)
    #
    deployApplication(appName, appSource, ttServerName)
    #
    print("\nExiting...")
    exit()
  except:
    apply(traceback.print_exception, sys.exc_info())
    exit(exitcode=1)
#call main()
main()
