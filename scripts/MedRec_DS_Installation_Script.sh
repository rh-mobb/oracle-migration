#############################################################################
# Create DataSource for WLS 12c Tuning & Troubleshooting workshop
#
# @author Martien van den Akker, Darwin-IT Professionals
# @version 1.1, 2018-01-22
#
#############################################################################
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
dsName = 'MedRecGlobalDataSourceXA'
dsJNDIName = 'jdbc/MedRecGlobalDataSourceXA'
initialCapacity = 5
maxCapacity = 10
capacityIncrement = 1
driverName = 'oracle.jdbc.xa.client.OracleXADataSource'
dbUrl = 'jdbc:oracle:thin:@darlin-vce.darwin-it.local:1521:orcl'
dbUser = 'medrec'
dbPassword = 'welcome1'
#
def createDataSource(dsName, dsJNDIName, initialCapacity, maxCapacity, capacityIncrement, dbUser, dbPassword, dbUrl, targetSvrName):
 # Check if data source already exists
 try:
   cd('/JDBCSystemResources/' + dsName)
   print 'The JDBC Data Source ' + dsName + ' already exists.'
   jdbcSystemResource=cmo
 except WLSTException:
   print 'Creating new JDBC Data Source named ' + dsName + '.'
   edit()
   startEdit()
   cd('/')
   # Create data source
   jdbcSystemResource = create(dsName, 'JDBCSystemResource')
   jdbcResource = jdbcSystemResource.getJDBCResource()
   jdbcResource.setName(dsName)
   # Set JNDI name
   jdbcResourceParameters = jdbcResource.getJDBCDataSourceParams()
   jdbcResourceParameters.setJNDINames([dsJNDIName])
   jdbcResourceParameters.setGlobalTransactionsProtocol('TwoPhaseCommit')
   # Create connection pool
   connectionPool = jdbcResource.getJDBCConnectionPoolParams()
   connectionPool.setInitialCapacity(initialCapacity)
   connectionPool.setMaxCapacity(maxCapacity)
   connectionPool.setCapacityIncrement(capacityIncrement)
   # Create driver settings
   driver = jdbcResource.getJDBCDriverParams()
   driver.setDriverName(driverName)
   driver.setUrl(dbUrl)
   driver.setPassword(dbPassword)
   driverProperties = driver.getProperties()
   userProperty = driverProperties.createProperty('user')
   userProperty.setValue(dbUser)
   # Set data source target
   targetServer = getMBean('/Servers/' + targetSvrName)
   jdbcSystemResource.addTarget(targetServer)
   # Activate changes
   save()
   activate(block='true')
   print 'Data Source created successfully.'
 return jdbcSystemResource

def main():
 # Connect to administration server
 try:
   connect(adminUser, adminPwd, admServerUrl)
   #
   createDataSource(dsName, dsJNDIName, initialCapacity, maxCapacity, capacityIncrement, dbUser, dbPassword, dbUrl,ttServerName)
   #
   print("\nExiting...")
   exit()
 except:
   apply(traceback.print_exception, sys.exc_info())
   exit(exitcode=1)
#call main()
main()
