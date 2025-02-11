<Query Kind="Statements">
  <Connection>
    <ID>56204edf-5b1b-480a-86e2-58500f3dcf8c</ID>
    <Persist>true</Persist>
    <Driver>EntityFrameworkDbContext</Driver>
    <CustomAssemblyPath>D:\EmeraldFl\Dev\EmeraldFL.DataAccess\bin\Debug\EmeraldFL.DataAccess.dll</CustomAssemblyPath>
    <CustomTypeName>EmeraldFL.DataAccess.Model.EmeraldDataContext</CustomTypeName>
    <AppConfigPath>D:\EmeraldFl\Dev\EmeraldFL.Web\Web.config</AppConfigPath>
  </Connection>
</Query>

Debug.Listeners.Clear();
string masterDb = "Finventory";

List<string> tables = new List<string> 
	{"State"
	,"Locations"
	,"JobTitle"

	,"ChecklistAreaType"
	,"ChecklistFrequency"
	,"ChecklistInspectionType"
	,"AssignedChecklist" 
	,"AssignedChecklistComments"
	,"AssignedChecklistItemResponse"
	,"Checklist"
	,"ChecklistItem"

	,"IncidentCategory"
	,"IncidentReport"
	,"InjuryLocation"
	,"InjuryType"
	,"IncidentWitness"
	,"InjuryVictim"
	,"InjuryDetail"
};

StringBuilder sbOutput = new StringBuilder();


foreach (var table in tables)
{
	var sql = $"Select c.name from sys.tables t inner join Sys.columns c on t.object_ID = c.object_ID and t.Name = '{table}'";
	var cols = this.Database.SqlQuery<string>(sql) ;

	sql = $"Select c.name from sys.tables t inner join Sys.columns c on t.object_ID = c.object_ID and t.Name = '{table}' and is_identity = 1";
	var hasIdentity = this.Database.SqlQuery<string>(sql).Any();




	int c = 0;

	StringBuilder sb = new StringBuilder($"--- START [{table}] --------------------------------------\n\n");
	
	if (hasIdentity)
		sb.AppendLine($"SET IDENTITY_INSERT dbo.[{table}] ON");
	
	sb.AppendLine($"MERGE INTO[{table}] target");
	sb.AppendLine($"using (Select * from [{masterDb}].[DBO].[{table}]) src");
	sb.AppendLine($"on target.ID = src.ID");
	sb.AppendLine($"WHEN NOT MATCHED BY TARGET THEN ");
	sb.AppendLine($"	INSERT({string.Join(",", cols)})");
	sb.AppendLine($"		values(src.{string.Join(", src.", cols)})");
	sb.AppendLine($"WHEN MATCHED THEN");
	sb.AppendLine($"	UPDATE  SET ");
	foreach (var col in cols.Where(co => co.ToLower() != "id"))
	{
		string e = (c++ == 0) ? " " : ",";
		sb.AppendLine($"			{e}[{col}] = src.[{col}]");
	}
//	sb.AppendLine($"WHEN NOT MATCHED BY SOURCE THEN");
//	sb.AppendLine($"	INSERT INTO [FInventory].[DBO].[{table}]({string.Join(",", cols)})");
//	sb.AppendLine($"		values({string.Join(",", cols)})");
	sb.AppendLine($"OUTPUT $action, Inserted.*, Deleted.*;");
	sb.AppendLine($"");
	
	if (hasIdentity)
		sb.AppendLine($"SET IDENTITY_INSERT dbo.[{table}] OFF");
	
	sb.AppendLine($"--- END [{table}] -----------------------------------------------------------------\n\n");
	sbOutput.AppendLine(sb.ToString());
}

sbOutput.ToString().Dump();