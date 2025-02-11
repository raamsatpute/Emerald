/****** Object:  StoredProcedure [dbo].[spInventoryDashboard]    Script Date: 08/14/19 10:20:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 26-Jul-2019
-- Description:	This SP Fetch Inventory Dashboard related data. This SP returns 4 result set as follow 
--				1.	Check In Data (Though name mentioned is Check In but date range is applied on TransDate column)
--				2.	Processed Data	
--				3.	WIP/UnProcessed data (This contain count Departmentwise)
--				4.  WIP UnProcessed Department with Job BreakUp (This contain Job Type breakups per Department for above result set# 3)
-- =============================================
--exec spInventoryDashboard 7,2019
--exec spInventoryDashboard 7,2019
ALTER PROCEDURE [dbo].[spInventoryDashboard]
	@LocationId as int,
	@YEAR as int
AS
BEGIN

Declare @InvDateFrom as date
Declare @InvDateTo as date
Declare @Cols as nvarchar(max)
Declare @TotCols as nvarchar(max)
Declare @Query as nvarchar(max)

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

set @DateFrom = DateFromParts(@Year-2, 01, 01) -- To get the first day of the year
--Set last date as current date if @Year = curent year else set it to last date of the year
set @DateTo =  DateFromParts(@Year, 
							case when year(getdate()) = @Year then datepart(mm,getdate()) else 12 end,
							case when year(getdate()) = @Year then datepart(dd,getdate()) else 31 end)
print @DateFrom
print @DateTo
--===============Check In Data
SELECT	t.DeptDesc as [Department],
		YEAR([TransDate]) as TransDateY,
		CAST(YEAR([TransDate]) as varchar) as [InventoryPeriod], 
		isnull(COUNT(t.DeptDesc),0) as InventoryCount into #UnitData 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and
[TransDate] between @DateFrom and @DateTo and 
([Dept Code] not like ('%SFS%') and [Dept Code] Not In ('FG Boxes', 'FD Decom', 'FD Service'))
GROUP BY YEAR([TransDate]), t.DeptDesc
UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
		  -- this will eliminate need to check Datatable within Dataset in Front end. 
(
SELECT 'TBD', YEAR(@DateFrom), YEAR(@DateFrom), 0
)
--ORDER BY YEAR([TransDate]) ASC

--select * from #unitdata
SELECT DISTINCT InventoryPeriod, TransDateY into #tmpDisCol FROM  #unitdata ORDER BY TransDateY

SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(InvPeriod) 
                        FROM #dtInventory
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(InventoryPeriod) + ',0)'
                        FROM #tmpDisCol ORDER BY TransDateY
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

SELECT @query = 
'SELECT * into tmpInventory  FROM
(
	SELECT     
		Department,	InventoryPeriod,	InventoryCount
	FROM #UnitData
)X
PIVOT 
(
    sum(InventoryCount)
    FOR [InventoryPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query

Delete from tmpInventory where Department = 'TBD' -- Row deleted as we now have data structure in place. 

SELECT @query = 
'select * , ' + @Totcols + ' as Total from tmpInventory order by ' + @Totcols + ' desc, Department asc'

EXEC SP_EXECUTESQL @query

--============================Processed Data

SELECT	t.DeptDesc as [Department],
		ProcessedY = case when Year([Ship Date]) is not null and Year([Ship Date]) <> '' Then Year([Ship Date])
						  when Year([ProcessDate]) is not null and Year([ProcessDate]) <> '' Then Year([ProcessDate])
						  when Year([CarcassManifestDate]) is not null and Year([CarcassManifestDate]) <> '' Then Year([CarcassManifestDate]) end, 
		InventoryPeriod = case when Year([Ship Date]) is not null and Year([Ship Date]) <> '' Then CAST(YEAR([Ship Date]) as varchar)
						  when Year([ProcessDate]) is not null and Year([ProcessDate]) <> '' Then CAST(YEAR([ProcessDate]) as varchar)
						  when Year([CarcassManifestDate]) is not null and Year([CarcassManifestDate]) <> '' Then CAST(YEAR([CarcassManifestDate]) as varchar) end, 
		isnull(COUNT(t.DeptDesc),0) as InventoryCount into #UnitProcessedData 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and
(([Ship Date] between @DateFrom and @DateTo) OR  
([ProcessDate] between @DateFrom and @DateTo) OR
([CarcassManifestDate] between @DateFrom and @DateTo)) and  
[Dept Code] Not In ('FG Boxes', 'FD Decom', 'FD Service')
GROUP BY YEAR([Ship Date]),Year(ProcessDate),Year(CarcassManifestDate), t.DeptDesc
UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
		  -- this will eliminate need to check Datatable within Dataset in Front end 
(
SELECT 'TBD', YEAR(@DateFrom), YEAR(@DateFrom), 0
)
--ORDER BY YEAR([Ship Date]) ASC

SELECT DISTINCT InventoryPeriod, ProcessedY into #tmpProcessedCol FROM  #UnitProcessedData where ProcessedY between Year(@DateFrom) and Year(@DateTo) ORDER BY ProcessedY

SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(InvPeriod) 
                        FROM #dtInventory
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(InventoryPeriod) + ',0)'
                        FROM #tmpProcessedCol ORDER BY ProcessedY
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

SELECT @query = 
'SELECT * into tmpProcessedInventory  FROM
(
	SELECT     
		Department,	InventoryPeriod,	InventoryCount
	FROM #UnitProcessedData
)X
PIVOT 
(
    sum(InventoryCount)
    FOR [InventoryPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query

Delete from tmpProcessedInventory where Department = 'TBD' -- Row deleted as we now have data structure in place. 

SELECT @query = 
'select * , ' + @Totcols + ' as Total from tmpProcessedInventory order by ' + @Totcols + ' desc, Department asc'

EXEC SP_EXECUTESQL @query

--=========================================WIP Unprocessed Department

SELECT	t.DeptDesc as [Department],
		YEAR([Check In Date]) as CheckInDateY,
		CAST(YEAR([Check In Date]) as varchar) as [InventoryPeriod], 
		isnull(COUNT(t.DeptDesc),0) as InventoryCount into #WIPUnProcessedUnitData 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and UnitStatus = 1 and FieldInventoryYN = 'N' and
[Check In Date] between @DateFrom and @DateTo and 
([Ship Date] is null or [Ship Date] = '') and
(ProcessDate is null or ProcessDate = '') and
(CarcassManifestDate is null or CarcassManifestDate = '') 
GROUP BY YEAR([Check In Date]), t.DeptDesc
UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
		  -- this will eliminate need to check Datatable within Dataset in Front end 
(
SELECT 'TBD', YEAR(@DateFrom), YEAR(@DateFrom), 0
)
--ORDER BY YEAR([Check In Date]) ASC

--select * from #WIPUnProcessedUnitData
SELECT DISTINCT InventoryPeriod, CheckInDateY into #tmpWIPUnprocessedCol FROM  #WIPUnProcessedUnitData ORDER BY CheckInDateY

SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(InvPeriod) 
                        FROM #dtInventory
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')
print @cols
SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(InventoryPeriod) + ',0)'
                        FROM #tmpWIPUnprocessedCol ORDER BY CheckInDateY
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')
print @Totcols
SELECT @query = 
'SELECT * into tmpWIPUnProcessedInventory  FROM
(
	SELECT     
		Department,	InventoryPeriod,	InventoryCount
	FROM #WIPUnProcessedUnitData
)X
PIVOT 
(
    sum(InventoryCount)
    FOR [InventoryPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query

Delete from tmpWIPUnProcessedInventory where Department = 'TBD' -- Row deleted as we now have data structure in place. 

SELECT @query = 
'select * , ' + @Totcols + ' as Total from tmpWIPUnProcessedInventory order by ' + @Totcols + ' desc, Department asc'

EXEC SP_EXECUTESQL @query

--========================================WIP UnProcessed Department with Job BreakUp
SELECT	
		--u.UnitId,
		t.DeptDesc as [Department],
		u.[Job Type],
		YEAR([Check In Date]) as CheckInDateY,
		CAST(YEAR([Check In Date]) as varchar) as [InventoryPeriod], 
		isnull(COUNT(u.[Job Type]),0) as InventoryCount into #WIPUnProcessedUnitData_Job 
FROM  UnitData u
Inner Join TraverseDepartments t on ltrim(rtrim(u.[Dept Code])) = ltrim(rtrim(t.[DeptCode]))
WHERE u.Location = @LocationId and UnitStatus = 1 and FieldInventoryYN = 'N' and
[Check In Date] between @DateFrom and @DateTo and 
([Ship Date] is null or [Ship Date] = '') and
(ProcessDate is null or ProcessDate = '') and
(CarcassManifestDate is null or CarcassManifestDate = '') 
GROUP BY YEAR([Check In Date]), t.DeptDesc, u.[Job Type],u.UnitId
UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
		  -- this will eliminate need to check Datatable within Dataset in Front end 
(
SELECT 'TBD', '', YEAR(@DateFrom), YEAR(@DateFrom), 0
)
--ORDER BY YEAR([Check In Date]) ASC

--select * from #WIPUnProcessedUnitData_Job
SELECT DISTINCT InventoryPeriod, CheckInDateY into #tmpWIPUnprocessedCol_Job FROM  #WIPUnProcessedUnitData_Job ORDER BY CheckInDateY

SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(InvPeriod) 
                        FROM #dtInventory
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')
print @cols
SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(InventoryPeriod) + ',0)'
                        FROM #tmpWIPUnprocessedCol_Job ORDER BY CheckInDateY
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')
print @Totcols
SELECT @query = 
'SELECT * into tmpWIPUnProcessedInventory_Job  FROM
(
	SELECT     
		Department,	[Job Type], InventoryPeriod,	InventoryCount
	FROM #WIPUnProcessedUnitData_Job
)X
PIVOT 
(
    sum(InventoryCount)
    FOR [InventoryPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query

Delete from tmpWIPUnProcessedInventory_Job where Department = 'TBD' -- Row deleted as we now have data structure in place. 

SELECT @query = 
'select * , ' + @Totcols + ' as Total from tmpWIPUnProcessedInventory_Job order by Department asc'

EXEC SP_EXECUTESQL @query

--================================================
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpInventory')
	Begin
		Drop table tmpInventory
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpProcessedInventory')
	Begin
		Drop table tmpProcessedInventory
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpWIPUnProcessedInventory')
	Begin
		Drop table tmpWIPUnProcessedInventory
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpWIPUnProcessedInventory_Job')
	Begin
		Drop table tmpWIPUnProcessedInventory_Job
	End
END

