
/****** Object:  StoredProcedure [dbo].[spRepairBySales]    Script Date: 6/18/2020 11:48:08 PM ******/
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
--exec spRepairBySales '1',2019,11,'','Summary' -- LocationWise Summary and JobType as Breakup
--exec spRepairBySales '',2019,11,'Florida','Detail' --For Monthly Detail with Location
--exec spRepairBySales '',2019,10,null,'Detail' --For Monthly Detail and for all Location
--exec spRepairBySales '',2019,11,'california','GrandTotal' --For Yearly Detail with Location
--exec spRepairBySales '',2019,11,null,'GrandTotal' --For Yearly Detail and for all Location
--exec spRepairBySales '',2019,11,null,'GrandTotal' --For Yearly Detail and for all Location

CREATE PROCEDURE [dbo].[spRepairBySales]
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
		Declare @ColSum as varchar(8000)
				
		--================================================
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesMonth')
		Begin
			Drop table tmpSalesMonth
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSales')
		Begin
			Drop table tmpSales
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesDesMonth')
		Begin
			Drop table tmpSalesDesMonth
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpDescription')
		Begin
			Drop table tmpDescription
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesDesYear')
		Begin
			Drop table tmpSalesDesYear
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
			Select Location, sum(abs(Amount)) as Amount,
			FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar) as [SalesPeriod], 
			[Year], 
			gl.[Period],
			LocationId
			 into #salesData 
			From trav_EO_GLTransaction gl
			Inner Join Locations l on l.Id = gl.LocationId and l.Active = 1
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
			inner join TraverseAccount ta on ltrim(rtrim(ta.AcctDescription)) = ltrim(rtrim(gl.AccountDescription))
			Where gl.AcctId like '4%' and
			gl.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) 
			group by Location,[Year],gl.[Period],LocationId
			UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
					  -- this will eliminate need to check Datatable within Dataset in Front end. 
			(
			SELECT 'TBD', 0, '', @Year, @Month,0
			)
			
			SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')
			
			--SELECT @TotCols = STUFF((SELECT ', sum(' + QUOTENAME(Period) + ')' 
			--						FROM #dtPickUp 
			--				FOR XML PATH(''), TYPE
			--				).value('.', 'NVARCHAR(MAX)') 
			--			,1,1,'')

			SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(Period) + ',0)'
										FROM #dtPickUp
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
				'SELECT Location'+ @NullToZeroCol +' ,LocationId into tmpSalesMonth FROM
				(
					SELECT     
						Location,	SalesPeriod, Amount,LocationId
					FROM #salesData
				)X
				PIVOT 
				(   
					 sum(Amount)
					FOR [SalesPeriod] in (' + @cols + ')
				) P'
			
			EXEC SP_EXECUTESQL @query

			SELECT @colSum = STUFF((SELECT '+' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')
			
			Delete from tmpSalesMonth where Location = 'TBD' -- Row deleted as we now have data structure in place. 
			
			SELECT @query = 
			'Select tm.Location ' + @NullToZeroCol + ', ' + @colSum + ' as GrandTotal,
			LocationId into tmpSales from tmpSalesMonth tm '
			
			EXEC SP_EXECUTESQL @query

			--SELECT @query = 
			--'Select tm.Location ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average,
			--LocationId from tmpSales tm order by Location'
			print 'OK'
			print @Totcols

			SELECT @query = 
			'Select tm.Location ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average,
			LocationId from tmpSales tm order by ' + @Totcols + ' desc, Location asc'


			EXEC SP_EXECUTESQL @query

			--=================================================Description Breakup
			Select  Location, gl.AccountDescription, sum(abs(Amount)) as Amount,
			FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar) as [SalesPeriod], 
			[Year], 
			gl.[Period] into #salesDesMonthData
			From trav_EO_GLTransaction gl
			Inner Join Locations l on l.Id = gl.LocationId and l.Active = 1
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
			inner join TraverseAccount ta on ltrim(rtrim(ta.AcctDescription)) = ltrim(rtrim(gl.AccountDescription))
			Where gl.AcctId like '4%' and
			gl.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ','))  
			group by Location,AccountDescription,[Year],gl.[Period]
			UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
					  -- this will eliminate need to check Datatable within Dataset in Front end. 
			(
			SELECT 'TBD','',0, '', @Year, @Month
			)
			
			SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(Period) 
									FROM #dtPickUp 
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
				'SELECT Location, [AccountDescription]'+ @NullToZeroCol +' into tmpSalesDesMonth FROM
				(
					SELECT Location, [AccountDescription], SalesPeriod, Amount
					FROM #salesDesMonthData
				)X
				PIVOT 
				(   
					 sum(Amount)
					FOR [SalesPeriod] in (' + @cols + ')
				) P'

			EXEC SP_EXECUTESQL @query

			SELECT @colSum = STUFF((SELECT '+' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

			Delete from tmpSalesDesMonth where Location = 'TBD' -- Row deleted as we now have data structure in place. 
		
			SELECT @query = 
			'Select tm.Location, tm.AccountDescription' + @NullToZeroCol + ', ' + @colSum + ' as GrandTotal 
			into tmpDescription from tmpSalesDesMonth tm order by Location, AccountDescription'

			EXEC SP_EXECUTESQL @query

			--SELECT @query = 
			--'Select tm.Location, tm.AccountDescription ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average 
			--from tmpDescription tm order by Location'		

			SELECT @query = 
			'Select tm.Location, tm.AccountDescription ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average 
			from tmpDescription tm order by ' + @Totcols + ' desc, Location asc'




			EXEC SP_EXECUTESQL @query
			--================================================
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesMonth')
			Begin
				Drop table tmpSalesMonth
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSales')
			Begin
				Drop table tmpSales
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesDesMonth')
			Begin
				Drop table tmpSalesDesMonth
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpDescription')
			Begin
				Drop table tmpDescription
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpSalesDesYear')
			Begin
				Drop table tmpSalesDesYear
			End
			--=====================
		End
	Else If @Key = 'Detail'	
	Begin
		If @LocationName = '' or @LocationName is null
			set @LocationId = ('1,13,9') --For Florida, Mississippi and Kansas
		Else
			select @LocationId=ID from Locations where (active=1) and [Description]=@LocationName

	--select @LocationId=ID from Locations where active=1 and Description=@LocationName
		Select Location, 
				ta.AcctDescription as 'Account Description',
				[Year] as N'Fiscal Year',
				gl.[Period] as N'Fiscal Month',
				gl.AcctId as N'Account Id',
				CONVERT(VARCHAR(10),EntryDate, 101) as N'Entry Date',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Trans Date',
				SourceCode as 'Source',
				[Desc] as 'Description',
				Reference as Reference,
				DebitAmt as Debit,
				CreditAmt as Credit,
				abs(Amount)as Amount From trav_EO_GLTransaction gl 
		Inner Join Locations l on gl.LocationId = l.Id  and l.Active = 1
		inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
		inner join TraverseAccount ta on ltrim(rtrim(ta.AcctDescription)) = ltrim(rtrim(gl.AccountDescription))
		Where
		gl.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and 
		gl.AcctId like '4%' and 
		--Case When @Key = 'Detail' THEN 1 WHEN [Year] in (Select distinct substring(#dtPickUp.Period, 5,len(#dtPickUp.Period))) THEN 1 ELSE 0 END = 1 and
		Case WHEN @Month IS NULL THEN 1 WHEN gl.Period = @Month THEN 1 ELSE 0 END = 1 and
		Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) THEN 1 ELSE 0 END = 1 
	End
	Else If @Key = 'GrandTotal'
	Begin
		If @LocationName = '' or @LocationName is null
			set @LocationId = ('1,13,9') --For Florida, Mississippi and Kansas
		Else
			select @LocationId=ID from Locations where (active=1) and [Description]=@LocationName

		Select Location, 
				gl.AccountDescription as 'Account Description',
				[Year] as N'Fiscal Year',
				gl.[Period] as N'Fiscal Month',
				gl.AcctId as N'Account Id',
				CONVERT(VARCHAR(10),EntryDate, 101) as N'Entry Date',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Trans Date',
				SourceCode as 'Source',
				[Desc] as 'Description',
				Reference as Reference,
				DebitAmt as Debit,
				CreditAmt as Credit,
				abs(Amount) as Amount From trav_EO_GLTransaction gl 
		Inner Join Locations l on gl.LocationId = l.Id  and l.Active = 1
		inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
		inner join TraverseAccount ta on ltrim(rtrim(ta.AcctDescription)) = ltrim(rtrim(gl.AccountDescription))
		Where 
		gl.Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and
		gl.AcctId like '4%' and 
		[Year] in (Select distinct substring(#dtPickUp.Period, 5,len(#dtPickUp.Period))) and
		Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) THEN 1 ELSE 0 END = 1 
	End
END


GO


