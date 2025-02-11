# EmeraldFL.SqlSync.Service
SqlSync works by allowing you to define a Source and Target database to be used to execute a script that will sync data across the two databases.  It works by identifying a single Master database and multiple remote databases to sync. 

## IMPORTANT NOTE
**The Data flow rules must be defined and implemented inside the scripts to prevent data from being overwritten during the sync process.**


The Service uses several well known products --
* [TopShelf](http://topshelf-project.com) - Windows Service Framework 
* [Quartz .Net](https://www.quartz-scheduler.net) - Task Scheduling Framework
* [NLog .Net](http://nlog-project.org) - Logging Framework 

This allows you to control the log output, make changes to the schedule, and run as a service.  

There are 2 Config files that allow the configuration of the service:
* NLog.config allows for the logging component to be configured. 
* app.config allows for the service functions to be configured.  

###NLog.Config
This file allows you to attach one or more log targets to the service.  

The service logs the following types of events:
* Trace - very detailed logs, which may include high-volume information such as protocol payloads. This log level is typically only enabled during development.
* Debug - debugging information, less detailed than trace, typically not enabled in production environment.
* Info - information messages, which are normally enabled in production environment.
* Warn - warning messages, typically for non-critical issues, which can be recovered or which are temporary failures.
* Error - error messages - most of the time these are Exceptions.
* Fatal - very serious errors!

See the [Tutorial](https://github.com/NLog/NLog/wiki/Tutorial) for more details.

to control the amount of information displayed on each of the log targets change the to a higher value

 ```
 // Will log all items to the Console and Info, Warn, Error and fatal to the log.
 <logger name="*" minlevel="trace" writeTo="console"  />   
 <logger name="*" minlevel="info" writeTo="logfile"  />
```

The console only displays if the service is run as a stand alone application.  See [TopShelf](http://topshelf-project.com) for more info on the service framework.

###App.Config

```
<connectionStrings>
    <add name="FInventoryConn" connectionString="Server=winiotdev;Initial Catalog=fInventory;Trusted_Connection=true" providerName="System.Data.SqlClient" />
    <add name="4-Way_Electric" connectionString="Server=winiotdev;Initial Catalog=fInventory_Test;Trusted_Connection=true" providerName="System.Data.SqlClient" />
</connectionStrings>
```
One connection string for each database connection.  They must be named, but the value of the name is not important.

```
// Master Database Connection String.
<add key="Source" value="FInventoryConn" />  
//Location of the sql files that will be used to perform the sync
<add key="ScriptPath" value="D:\EmeraldFl\Dev\EmeraldFL.SqlSync.Service\Scripts\" />
//The time between each sync in minutes
<add key="IntervalInMinutes" value="60" />
```

###Sync TO pushes data from the master database to the remote database. Sync From pushes data from the remote database to the master database. 
```
<add key="Sync_1_To_4-Way_Electric" value='{"connection":"4-Way_Electric", "sync_direction":"to", "script":"SyncTo_4-Way_Electric.sql" ,"step": 1}' />
    
```
* Key must start with SyncTo_ followed by some identifier.  The Service uses a StartsWith ("SyncTo_") to determine the remote targets.
* Value is a JSON object that describes the operation.  **NOTE: JSON uses Double Quotes which cause an issue with the App Config.  The Service will replace all Single Quote with Double Quotes prior to parsing the text.**
```
{
  "connection": "4-Way_Electric", //Connection String Name of the database receiving data
  "sync_direction": "to" ,        //to or From 
  "script": "SyncFrom_4-Way_Electric.sql", //path to Sync Script
  "step": "10" //Execution sort order.  These do no have to be sequential.  If the order doesn't matter, set them to a large number like 100
}
```
* connection = the connection defined inside <connectionStrings> settings
* script = the path used to sync the Target Database with the Source Database


The Step determines the order of execute and each script uses a [TSQL MERGE](https://docs.microsoft.com/en-us/sql/t-sql/statements/merge-transact-sql) Command.
The scripts can be modified to handle different data needs.   [Great Article on Merge](http://www.toplinestrategies.com/blogs/application-development/sync-data-changes-tsql-merge) 

```
--- START [State] --------------------------------------

SET IDENTITY_INSERT dbo.[State] ON
MERGE INTO[State] target
using (Select * from [Finventory_Test].[DBO].[State]) src
on target.ID = src.ID
WHEN NOT MATCHED BY TARGET THEN 
	INSERT(Id,Code,Name,LastUpdatedBy,LastUpdatedOn)
		values(src.Id, src.Code, src.Name, src.LastUpdatedBy, src.LastUpdatedOn)
WHEN MATCHED THEN   -- May OVER WRITE CHANGES
	UPDATE  SET 
			 [Code] = src.[Code]
			,[Name] = src.[Name]
			,[LastUpdatedBy] = src.[LastUpdatedBy]
			,[LastUpdatedOn] = src.[LastUpdatedOn]
OUTPUT $action, Inserted.*, Deleted.*;

SET IDENTITY_INSERT dbo.[State] OFF
--- END [State] -----------------------------------------------------------------

```

An Identity_Insert is required if the destination table has an auto-increment identity on the primary key.  Don't forget to turn it off!
<br>
<br>







