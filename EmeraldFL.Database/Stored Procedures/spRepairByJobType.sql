/****** Object:  StoredProcedure [dbo].[spRepairByJobType]    Script Date: 6/18/2020 11:47:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 29-Nov-2019
-- Description:	This SP Fetch Repair count for Summary and Job Description Details for 3 Locations i.e. FL,MS and KS
-- This SP fetch 2 result set as below
-- ResultSet 1 for Location Summary
-- ResultSet 2 for Job Description Details

-- This SP caters requirement for both Summary and Detail(data for Export functionality) which are identified by value defined in Key
-- @Key = "Summary" for Summation view 
--		  "MonthlyDetail" Detail View against chosen Month/Year except Total column(Vertical and Horizontal) 
--		  For Total (Horizontal and Vertical) no key required, by default system construct date to and from date (for 12 months)
--		  based on passed month and year
-- =============================================
--exec spRepairByJobType '1',2019,11,'','Summary' -- LocationWise Summary and JobType as Breakup
--exec spRepairByJobType '',2019,6,'Mississippi','MonthlyDetail' --Monthly Detail with Location
--exec spRepairByJobType '',2019,7,'','MonthlyDetail' --Monthly Detail for all Location
--exec spRepairByJobType '',2019,11,'mississippi','' --Yearly Detail with Location
--exec spRepairByJobType '',2019,11,'','' --Yearly Detail for all Location
--exec spRepairByJobType '',2019,11,'','' --Yearly Detail for all Location

CREATE PROCEDURE [dbo].[spRepairByJobType]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int,
	@LocationName as varchar(100),
	@Key as varchar(15)
AS
BEGIN
		Declare @PeriodFROM as date
		Declare @PeriodTo as date
		Declare @Cols as nvarchar(max)
		Declare @NullToZeroCol as nvarchar(max)
		Declare @TotCols as nvarchar(max)
		Declare @MonthNumbers as nvarchar(max)
		Declare @Query as nvarchar(max)

		--================================================
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpLoc')
		Begin
			Drop table tmpLoc
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpLocTotal')
		Begin
			Drop table tmpLocTotal
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpJobs')
		Begin
			Drop table tmpJobs
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpJobsTotal')
		Begin
			Drop table tmpJobsTotal
		End
		--=====================
		
		if @LocationName = '' 
			set @LocationName = null

		if @YEAR = '' 
			set @YEAR = null

		if @Month = '' 
			set @Month = null

		set @PeriodTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
		set @PeriodTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PeriodTo)+1,0)))
		set @PeriodFrom = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 11, 0))

		Select FORMAT(a,'MMM') + '_' + CAST(YEAR(a) as varchar) as Period into #dtPickUp From
		(
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 11, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 10, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 9, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 8, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 7, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 6, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 5, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 4, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 3, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 2, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 1, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 0, 0)) as a
		)a
		
		If @Key = 'MonthlyDetail'	
		Begin
			set @PeriodFrom = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
			set @PeriodTo = (SELECT DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @PeriodFrom) + 1, 0)))
		End	

		--===============================================================================================================================
														-- Repair Location Wise
		--===============================================================================================================================
		If @Key = 'Summary'
		Begin
			set @LocationId = ('1,13,9') --For Florida, Mississippi and Kansas
			SELECT	l.[Description] as Location,
			MONTH([ShipDate]) as ShipDateM, YEAR([ShipDate]) as ShipDateY,
			FORMAT([ShipDate],'MMM') + '_' + CAST(YEAR([ShipDate]) as varchar) as [ShipPeriod], 
			isnull(COUNT([ShipDate]),0) as ShipCount into #LocData 
			FROM  trav_EO_SrJobs u
			INNER Join Locations l on l.id = u.LocationId and l.Active = 1
			WHERE 
			u.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and
			[ShipDate] between @PeriodFrom and @PeriodTo and [ShipDate] >= '2018-10-01 00:00:00.000' and
			u.[DeptCode] not in ('FD Service','FD Decom','DISPSL', 'DECOM','PCB') and
			[JobType] in ('PL1P', 'PD1P', 'PD3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'SB1P', 'SB3P', 'OS1P', 'OS3P')
			GROUP BY YEAR([ShipDate]), MONTH([ShipDate]) , FORMAT([ShipDate],'MMM'), l.[Description]			
			UNION ALL	-- Dummmy row added so incase if no data exist atleast we can have data structure, 
						-- this will eliminate need to check Datatable within Dataset in Front end. 
			(
			SELECT 'TBD', MONTH(@PeriodFrom), YEAR(@PeriodFrom),FORMAT(@PeriodFrom,'MMM') + '_' + CAST(YEAR(@PeriodFrom) as varchar), 0
			)
									
			SELECT DISTINCT ShipPeriod, ShipDateY, ShipDateM into #tmpDisCol FROM  #LocData ORDER BY ShipDateY, ShipDateM
			
			SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

			SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(ShipPeriod) + ',0)'
										FROM #tmpDisCol ORDER BY ShipDateY, ShipDateM 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

			SELECT @NullToZeroCol =(
			  select char(10)+'  , ' + quotename(Period)
			  +' = '+ + 'isnull('     + quotename(Period) + ',0)'
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 

			SELECT @query = 
				'SELECT Location'+ @NullToZeroCol +' into tmpLoc  FROM
				(
					SELECT     
						Location,	ShipPeriod, ShipCount
					FROM #LocData
				)X
				PIVOT 
				(   
					 sum(ShipCount)
					FOR [ShipPeriod] in (' + @cols + ')
				) P'

			EXEC SP_EXECUTESQL @query

			Delete from tmpLoc where Location = 'TBD' -- Row deleted as we now have data structure in place. 
			
			SELECT @query = 
			'select * , ' + @Totcols + ' as Total into tmpLocTotal from tmpLoc'
			EXEC SP_EXECUTESQL @query

			SELECT @query = 
			'select *, cast(cast(Total as numeric(18,2))/12 as numeric(18,2)) as Average from tmpLocTotal order by ' + @Totcols + ' desc, Location asc'			
			EXEC SP_EXECUTESQL @query
			print '@Totcols'
			print @Totcols
			--=================================================Description Breakup
			SELECT	l.[Description] as Location, 
			JobTypeDescription,
			MONTH([ShipDate]) as ShipDateM, YEAR([ShipDate]) as ShipDateY,
			FORMAT([ShipDate],'MMM') + '_' + CAST(YEAR([ShipDate]) as varchar) as [ShipPeriod], 
			isnull(COUNT([ShipDate]),0) as ShipCount into #JobData 
			FROM  trav_EO_SrJobs u
			INNER Join Locations l on l.id = u.LocationId and l.Active = 1
			WHERE 
			u.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and
			[ShipDate] between @PeriodFrom and @PeriodTo and [ShipDate] >= '2018-10-01 00:00:00.000' and
			u.[DeptCode] not in ('FD Service','FD Decom','DISPSL', 'DECOM','PCB') and
			[JobType] in ('PL1P', 'PD1P', 'PD3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'SB1P', 'SB3P', 'OS1P', 'OS3P')
			GROUP BY YEAR([ShipDate]), MONTH([ShipDate]) , FORMAT([ShipDate],'MMM'), l.[Description], JobTypeDescription
			UNION ALL	-- Dummmy row added so incase if no data exist atleast we can have data structure, 
						-- this will eliminate need to check Datatable within Dataset in Front end. 
			(
			SELECT 'TBD', '', MONTH(@PeriodFrom), YEAR(@PeriodFrom),FORMAT(@PeriodFrom,'MMM') + '_' + CAST(YEAR(@PeriodFrom) as varchar), 0
			)
									
			SELECT DISTINCT ShipPeriod, ShipDateY, ShipDateM into #tmpDisJobCol FROM  #JobData  ORDER BY ShipDateY, ShipDateM
			
			SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

			SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(ShipPeriod) + ',0)'
										FROM #tmpDisJobCol ORDER BY ShipDateY, ShipDateM 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

			SELECT @NullToZeroCol =(
			  select char(10)+'  , ' + quotename(Period)
			  +' = '+ + 'isnull('     + quotename(Period) + ',0)'
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 

			SELECT @query = 
				'SELECT Location,JobTypeDescription'+ @NullToZeroCol +' into tmpJobs  FROM
				(
					SELECT     
						Location, JobTypeDescription, ShipPeriod, ShipCount
					FROM #JobData 
				)X
				PIVOT 
				(   
					 sum(ShipCount)
					FOR [ShipPeriod] in (' + @cols + ')
				) P'

			EXEC SP_EXECUTESQL @query

			Delete from tmpJobs where Location = 'TBD' -- Row deleted as we now have data structure in place. 

			SELECT @query = 
			'select * , ' + @Totcols + ' as Total into tmpJobsTotal from tmpJobs'	
			EXEC SP_EXECUTESQL @query
			print '@Totcols'
			print @Totcols


		
			SELECT @query = 
			'select *, cast(cast(Total as numeric(18,2))/12 as numeric(18,2)) as Average from tmpJobsTotal order by ' + @Totcols + ' desc, Location asc'	
			EXEC SP_EXECUTESQL @query

			--================================================
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpLoc')
			Begin
				Drop table tmpLoc
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpLocTotal')
			Begin
				Drop table tmpLocTotal
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpJobs')
			Begin
				Drop table tmpJobs
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpJobsTotal')
			Begin
				Drop table tmpJobsTotal
			End
			--=====================
		End
		Else --This query caters all detail, please be noted below PeriodFrom and PeriodTo are construct based on 
			-- If key supplied as "MonthlyDetail" then LocationWise data for selected Month_Year column against Location wise
			-- If Key is blank, detail view will contain data for the periods of 12 months from the supplied month_year, 
			-- blank key is applicable for Horizontal and Vertical Grand Total, in this case date constructed is default i.e. 
			-- same as we use for Summary key	
		Begin
			If @LocationName = '' or @LocationName is null
				set @LocationId = ('1,13,9') --For Florida, Mississippi and Kansas
			Else
				select @LocationId=ID from Locations where (active=1) and [Description]=@LocationName
			
			Select  
				l.Description as Location,
				REPLACE(u.CustName,',','') as N'Customer Name',			
				u.DeptDescr as N'Dept Description',
				u.JobTypeDescription as N'Job Type Description',
				u.DeptCode as N'Dept Code',
				u.JobType as N'Job Type Id',
				u.BatchId as N'Batch Code',
				u.AMPS,
				u.KVA,
				u.LBS,
				u.Metal,
				u.InvcAmount as N'Invoice Amount',
				u.TransId as N'Job Transaction Id',
				CONVERT(VARCHAR(10),u.ShipDate, 101) as N'Ship Date',
				CONVERT(VARCHAR(10),u.LastInvcDate, 101) as N'Last Invoice Date',
				Case When InvcStatus = 1 then 'Invoiced' else 'Not Invoiced' end as N'Invoice Status'
			from trav_EO_SrJobs u
			INNER JOIN Cust c on c.CUSTOMER_NBR = u.[CustId]  and c.Location = u.Locationid --and
			--c.Location in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) 
			INNER JOIN Locations l on l.Id = u.[LocationId]  and l.Active = 1
			WHERE 
			u.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and
			--Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId = @LocationId THEN 1 ELSE 0 END = 1 and
			[ShipDate] between @PeriodFrom and @PeriodTo and
			[ShipDate] >= '2018-10-01 00:00:00.000' and
			u.[DeptCode] not in ('FD Service','FD Decom','DISPSL', 'DECOM','PCB') and
			[JobType] in ('PL1P', 'PD1P', 'PD3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'SB1P', 'SB3P', 'OS1P', 'OS3P')
		End
END


GO


