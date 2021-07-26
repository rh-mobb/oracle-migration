print 'Creating the Admin User for WL ....'
#
adminHost=os.environ["ADM_HOST"]
adminPort=os.environ["ADM_PORT"]
admServerUrl = 't3://'+adminHost+':'+adminPort
#
adminUser='weblogic'
adminPwd='welcome1'
#
realmName = 'myrealm'
#
def addUser(realm,username,password,description):
  print 'Prepare User',username,'...'
  if realm is not None:
    authenticator = realm.lookupAuthenticationProvider("DefaultAuthenticator")
    if authenticator.userExists(username)==1:
      print '[Warning]User',username,'has been existed.'
    else:
      authenticator.createUser(username,password,description)
      print '[INFO]User',username,'has been created successfully'


connect(adminUser,adminPwd,admServerUrl)

security=getMBean('/').getSecurityConfiguration()
realm=security.lookupRealm(realmName)
addUser(realm,'administrator','administrator123','MedRec Administrator')

disconnect()
