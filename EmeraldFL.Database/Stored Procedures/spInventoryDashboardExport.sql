/****** Object:  StoredProcedure [dbo].[spInventoryDashboardExport]    Script Date: 08/14/19 10:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kalyani S
-- Create date: 26-Jul-2019
-- Description:	This SP Fetch Inventory Dashboard related data. This SP returns 3 result set as follow 
--				1.	Check In Data (Though name mentioned is Check In but date range is applied on TransDate column)
--				2.	Processed Data	
--				3.	WIP/UnProcessed data
-- =============================================

--exec spInventoryDashboardExport  1,2017,'Decommission','CheckedIn',''
--exec spInventoryDashboardExport 1,2018,'PCB Disposal','CheckedIn','GrandTotal'
--exec spInventoryDashboardExport 1,2018,'Polemount SFS Remanufactured','Processed'
--exec spInventoryDashboardExport 1,2019,'Decommission','Unprocessed'
--exec spInventoryDashboardExport 1,2019,'Decommission','Unprocessed'
ALTER PROCEDURE [dbo].[spInventoryDashboardExport]
	@LocationId as int,
	@YEAR as int,
	@DepartmentDescription varchar(250),
	@Key as varchar(50),
	@KeyGrandTotal as varchar(15)
AS
BEGIN

Declare @InvDateFrom as date
Declare @InvDateTo as date
Declare @Cols as nvarchar(max)
Declare @TotCols as nvarchar(max)
Declare @Query as nvarchar(max)

Declare @Query1 as nvarchar(max)


Declare @DateFrom as Date
Declare @DateTo as Date

Select CAST(a as varchar) as InvPeriod into #dtInventory From
(
(Select (@Year - 2) as a) 
Union
(Select (@Year - 1) as b)  
Union
(Select (@Year) as c) 
)a

if @KeyGrandTotal='GrandTotal'
begin
set @DateFrom = DateFromParts(@Year-2, 01, 01)
end
else
begin
set @DateFrom = DateFromParts(@Year, 01, 01) -- To get the first day of the year
end
--Set last date as current date if @Year = curent year else set it to last date of the year
set @DateTo =  DateFromParts(@Year, 
							case when year(getdate()) = @Year then datepart(mm,getdate()) else 12 end,
							case when year(getdate()) = @Year then datepart(dd,getdate()) else 31 end)

							print @DateFrom
							print @DateTo

if @Key='CheckedIn'
--===============Check In Data Start===============
begin
SELECT	t.DeptDesc as [Department_Description],
		u.JobTypeDescr as Job_Type_Description,
		CONVERT(VARCHAR(10), u.[Check In Date], 101)as Check_In_Date,
		Process_Date=CONVERT(VARCHAR(10), u.ProcessDate, 101),	
		Carcass_Manifest_Date=CONVERT(VARCHAR(10), u.CarcassManifestDate, 101),	
		Ship_Date	=CONVERT(VARCHAR(10), u.[Ship Date], 101),
		Bill_To_ID	='',
		Job_Transaction_ID	=[Job Type],
		Misc_No	='',
		Nameplate_Description='',	
		Serial_Number=u.[Serial Number]--,
		--isnull(COUNT(t.DeptDesc),0) as InventoryCount 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and
[TransDate] between @DateFrom and @DateTo and 
t.DeptDesc=isnull(@DepartmentDescription,'') and
([Dept Code] not like ('%SFS%') and [Dept Code] Not In ('FG Boxes', 'FD Decom', 'FD Service'))
ORDER BY YEAR([TransDate]) ASC
end
--===============Check In Data End===============


if @Key='Processed'
--============================Processed Data Start============================
begin
SELECT	t.DeptDesc as [Department_Description],
		u.JobTypeDescr as Job_Type_Description,
		CONVERT(VARCHAR(10), u.[Check In Date], 101)as Check_In_Date,
		Process_Date=CONVERT(VARCHAR(10), u.ProcessDate, 101),	
		Carcass_Manifest_Date=CONVERT(VARCHAR(10), u.CarcassManifestDate, 101),	
		Ship_Date	=CONVERT(VARCHAR(10), u.[Ship Date], 101),
		Bill_To_ID	='',
		Job_Transaction_ID	=[Job Type],
		Misc_No	='',
		Nameplate_Description='',	
		Serial_Number=u.[Serial Number]--,
		--isnull(COUNT(t.DeptDesc),0) as InventoryCount 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and
t.DeptDesc=isnull(@DepartmentDescription,'') and
(([Ship Date] between @DateFrom and @DateTo) OR  
([ProcessDate] between @DateFrom and @DateTo) OR
([CarcassManifestDate] between @DateFrom and @DateTo)) and  
[Dept Code] Not In ('FG Boxes', 'FD Decom', 'FD Service')
ORDER BY YEAR([Ship Date]) ASC
end
--============================Processed Data End============================

if @Key='Unprocessed'
--=========================================WIP Unprocessed Department Start=========================================
begin
SELECT	t.DeptDesc as [Department_Description],
		u.JobTypeDescr as Job_Type_Description,
		CONVERT(VARCHAR(10), u.[Check In Date], 101)as Check_In_Date,
		Process_Date=CONVERT(VARCHAR(10), u.ProcessDate, 101),	
		Carcass_Manifest_Date=CONVERT(VARCHAR(10), u.CarcassManifestDate, 101),	
		Ship_Date	=CONVERT(VARCHAR(10), u.[Ship Date], 101),
		Bill_To_ID	='',
		Job_Transaction_ID	=[Job Type],
		Misc_No	='',
		Nameplate_Description='',	
		Serial_Number=u.[Serial Number]--,
		--isnull(COUNT(t.DeptDesc),0) as InventoryCount 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and UnitStatus = 1 and FieldInventoryYN = 'N' and
t.DeptDesc=isnull(@DepartmentDescription,'') and
[Check In Date] between @DateFrom and @DateTo and 
([Ship Date] is null or [Ship Date] = '') and
(ProcessDate is null or ProcessDate = '') and
(CarcassManifestDate is null or CarcassManifestDate = '') 
ORDER BY YEAR([Check In Date]) ASC
--=========================================WIP Unprocessed Department Start=========================================
end
END

