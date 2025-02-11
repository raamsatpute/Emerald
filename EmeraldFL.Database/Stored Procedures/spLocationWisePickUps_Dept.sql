GO
/****** Object:  StoredProcedure [dbo].[spLocationWisePickUps_Dept]    Script Date: 6/17/2020 11:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 27-Nov-2019
-- Description:	This SP Fetch total Pick Ups done locationwise
--				PickUp periods are the range between SELECTed MONTH/YEAR to Previous 12 months
-- =============================================
--exec spLocationWisePickUps_Dept 1, 11, 2019
--exec spLocationWisePickUps_Dept 1, 11, 2019

Alter PROCEDURE [dbo].[spLocationWisePickUps_Dept]
	@LocationId as int,
	@MONTH as int,
	@YEAR as int
AS
BEGIN

	Declare @PickUpDateFROM as date
	Declare @PickUpDateTo as date
	Declare @Cols as nvarchar(max)
	Declare @NullToZeroCol as nvarchar(max)
	Declare @TotCols as nvarchar(max)
	Declare @Query as nvarchar(max)

	Declare @Query1 as nvarchar(max)

	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUp')
	Begin
		Drop table tmpPickUp
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpTotal')
	Begin
		Drop table tmpPickUpTotal
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpDept')
	Begin
		Drop table tmpPickUpDept
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpTotalDept')
	Begin
		Drop table tmpPickUpTotalDept
	End

	set @PickUpDateTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
	set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
	set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 11, 0))

	Select FORMAT(a,'MMM') + '_' + CAST(YEAR(a) as varchar) as PuPeriod into #dtPickUp From
	(
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 11, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 10, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 9, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 8, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 7, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 6, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 5, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 4, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 2, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 1, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 0, 0)) as a
	)a


	SELECT	l.[Description] as Location,
			MONTH([TransDate]) as CheckInDateM, YEAR([TransDate]) as CheckInDateY,
			FORMAT([TransDate],'MMM') + '_' + CAST(YEAR([TransDate]) as varchar) as [PickUpPeriod], 
			isnull(COUNT([TransDate]),0) as PickUps into #UnitData 
	FROM  trav_EO_SrJobs u
	Inner Join TraverseDepartments t on ltrim(rtrim(u.[DeptCode])) = ltrim(rtrim(t.[DeptCode]))
	INNER Join Locations l on l.id = u.LocationId and l.[Status] = 'A'
	WHERE 
	[TransDate] between @PickUpDateFROM and @PickUpDateTo and
	u.[DeptCode] not in ('FD Service','FG Boxes') and 
	[JobType] in ('PL1P', 'PD1P', 'PD3P', 'SB1P', 'SB3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'NT1P', 'NT3P', 'PL3P')  
	GROUP BY YEAR([TransDate]), MONTH([TransDate]) , FORMAT([TransDate],'MMM'), l.[Description]
	ORDER BY YEAR([TransDate]) ASC, MONTH([TransDate]) ASC

	SELECT DISTINCT PickUpPeriod, CheckInDateY, CheckInDateM into #tmpDisCol FROM  #unitdata ORDER BY CheckInDateY, CheckInDateM

	SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(PUPeriod) 
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')



	SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(PickUpPeriod) + ',0)'
							FROM #tmpDisCol ORDER BY CheckInDateY, CheckInDateM 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

	SELECT @NullToZeroCol =(
	  select char(10)+'  , ' + quotename(PUPeriod)
	  +' = '+ + 'isnull('     + quotename(PUPeriod) + ',0)'
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
			
	SELECT @query = 
	'SELECT Location'+ @NullToZeroCol +' into tmpPickUp  FROM
	(
		SELECT     
			Location,	PickUpPeriod,PickUps
		FROM #UnitData
	)X
	PIVOT 
	(   
		 sum(PickUps)
		FOR [PickUpPeriod] in (' + @cols + ')
	) P'

	EXEC SP_EXECUTESQL @query

	SELECT @query = 
	'select * , ' + @Totcols + ' as Total into tmpPickUpTotal from tmpPickUp '

	EXEC SP_EXECUTESQL @query

	SELECT @query = 
	'select *, cast(cast(Total as numeric(18,2))/12 as numeric(18,2)) as Average from tmpPickUpTotal order by ' + @Totcols + ' desc, Location asc'

	EXEC SP_EXECUTESQL @query

	--======================Department Breakup
	SELECT	l.[Description] as Location,
			u.DeptDescr as Department,
			MONTH([TransDate]) as CheckInDateM, YEAR([TransDate]) as CheckInDateY,
			FORMAT([TransDate],'MMM') + '_' + CAST(YEAR([TransDate]) as varchar) as [PickUpPeriod], 
			isnull(COUNT([TransDate]),0) as PickUps into #UnitDataDept 
	FROM  trav_EO_SrJobs u
	Inner Join TraverseDepartments t on ltrim(rtrim(u.[DeptCode])) = ltrim(rtrim(t.[DeptCode]))
	INNER Join Locations l on l.id = u.LocationId and l.[Status] = 'A'
	WHERE 
	[TransDate] between @PickUpDateFROM and @PickUpDateTo and
	u.[DeptCode] not in ('FD Service','FG Boxes') and 
	[JobType] in ('PL1P', 'PD1P', 'PD3P', 'SB1P', 'SB3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'NT1P', 'NT3P', 'PL3P')  
	GROUP BY YEAR([TransDate]), MONTH([TransDate]) , FORMAT([TransDate],'MMM'), l.[Description], u.DeptDescr
	ORDER BY YEAR([TransDate]) ASC, MONTH([TransDate]) ASC

	SELECT DISTINCT PickUpPeriod, CheckInDateY, CheckInDateM into #tmpDisColDept FROM  #UnitDataDept ORDER BY CheckInDateY, CheckInDateM

	SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(PUPeriod) 
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')



	SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(PickUpPeriod) + ',0)'
							FROM #tmpDisColDept ORDER BY CheckInDateY, CheckInDateM 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

	SELECT @NullToZeroCol =(
	  select char(10)+'  , ' + quotename(PUPeriod)
	  +' = '+ + 'isnull('     + quotename(PUPeriod) + ',0)'
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
			
	SELECT @query = 
	'SELECT Location, Department'+ @NullToZeroCol +' into tmpPickUpDept  FROM
	(
		SELECT     
			Location, Department, PickUpPeriod, PickUps
		FROM #UnitDataDept
	)X
	PIVOT 
	(   
		 sum(PickUps)
		FOR [PickUpPeriod] in (' + @cols + ')
	) P'

	EXEC SP_EXECUTESQL @query

	SELECT @query = 
	'select * , ' + @Totcols + ' as Total into tmpPickUpTotalDept from tmpPickUpDept '

	EXEC SP_EXECUTESQL @query

	SELECT @query = 
	'select *, cast(cast(Total as numeric(18,2))/12 as numeric(18,2)) as Average from tmpPickUpTotalDept order by ' + @Totcols + ' desc, Location asc'

	EXEC SP_EXECUTESQL @query
	--======================Department Breakup=========================

	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUp')
	Begin
		Drop table tmpPickUp
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpTotal')
	Begin
		Drop table tmpPickUpTotal
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpDept')
	Begin
		Drop table tmpPickUpDept
	End
	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUpTotalDept')
	Begin
		Drop table tmpPickUpTotalDept
	End
END

