/****** Object:  StoredProcedure [dbo].[spTotalSalesMetrics]    Script Date: 6/18/2020 11:36:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 24-Oct-2019
-- Modified date: 22-Nov-2019 (To display 12 months data)
-- Description:	This SP caters requirement for both Summary and Detail(data for Export functionality) which are identified by value defined in Key
	-- @Key = "Summary" for Summation view 
	--		  "Detail" Detail View for chosen Month and Location and Year
	--		  "GrandTotal" Detail view for Horizontal and Vertical Total. 
					--If Location is Passed than display 12 months data for selected Location else display 12 months data for all Locations

--NOTE: @Year and @Month Parameter is mandatory as System calculates 12 months previous based on passed Year/Month 
-- =============================================
--exec spTotalSalesMetrics 2018,3,null,'Summary' --Summary in first result set and Account Description breakup locationwise in 2nd resultset
--exec spTotalSalesMetrics 2019,11,'Florida','Detail' --For Monthly Detail with Location
--exec spTotalSalesMetrics 2019,10,null,'Detail' --For Monthly Detail and for all Location
--exec spTotalSalesMetrics 2019,11,'california','GrandTotal' --For Yearly Detail with Location
--exec spTotalSalesMetrics 2019,11,null,'GrandTotal' --For Yearly Detail and for all Location
--exec spTotalSalesMetrics 2019,11,null,'GrandTotal' --For Yearly Detail and for all Location


ALTER PROCEDURE [dbo].[spTotalSalesMetrics]
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
		Declare @ColSum as varchar(8000)
		Declare @ColGrandTotal as varchar(8000)
		Declare @TotCols as nvarchar(max)
		Declare @MonthNumbers as nvarchar(max)
		Declare @Query as nvarchar(max),
		@LocationId as int

		select @LocationId=ID from Locations where (active=1 or id in (14,15)) and Description=@LocationName
		
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
		--=====================
		if @LocationId = '' 
			set @LocationId = null

		If @Month = '' 
			set @Month = null

		set @PeriodTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
		set @PeriodTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PeriodTo)+1,0)))
		set @PeriodFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodTo) - 11, 0))
		set @MonthNumbers = cast(MONTH(@PeriodFROM) as varchar(2)) + ',' + cast(MONTH(@PeriodTo) as varchar(2))
		
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
		
		--===============================================================================================================================
														-- Total Sales
		--===============================================================================================================================
	If @Key = 'Summary'
		Begin
			Select Location, abs(sum(Amount)) as Amount,
			FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar) as [SalesPeriod], 
			[Year], 
			gl.[Period],
			LocationId
			 into #salesData 
			From trav_EO_GLTransaction gl
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
			Where AcctId like '4%'
			group by Location,[Year],gl.[Period],LocationId
			UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
					  -- this will eliminate need to check Datatable within Dataset in Front end. 
			(
			SELECT 'TBD', 0, '', @Year, @Month,@LocationId
			)
			
			SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(Period) 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')
			
			SELECT @ColGrandTotal = STUFF((SELECT ', sum(' + QUOTENAME(Period) + ')' 
									FROM #dtPickUp 
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')
			print @ColGrandTotal


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

			SELECT @query = 
			'Select tm.Location ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average,
			LocationId from tmpSales tm order by Location'

			EXEC SP_EXECUTESQL @query

			--=================================================Description Breakup
			--Monthly Brakup
			Select  Location, AccountDescription, sum(Amount) as Amount,
			FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar) as [SalesPeriod], 
			[Year], 
			gl.[Period] into #salesDesMonthData
			From trav_EO_GLTransaction gl
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
			Where AcctId like '4%' 
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

			SELECT @query = 
			'Select tm.Location, tm.AccountDescription ' + @NullToZeroCol + ', ' + 'tm.GrandTotal, GrandTotal/12 as Average 
			from tmpDescription tm order by Location'

			EXEC SP_EXECUTESQL @query
			
			--SELECT @query = 
			--'Select ' + @ColGrandTotal + ' from tmpDescription'

			--EXEC SP_EXECUTESQL @query

			--Select 'GrandTotal', @ColGrandTotal from tmpDescription group by @cols
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
		Select Location, 
				AccountDescription as 'Account Description',
				[Year] as N'Fiscal Year',
				gl.[Period] as N'Fiscal Month',
				AcctId as N'Account Id',
				CONVERT(VARCHAR(10),EntryDate, 101) as N'Entry Date',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Trans Date',
				SourceCode as 'Source',
				[Desc] as 'Description',
				Reference as Reference,
				DebitAmt as Debit,
				CreditAmt as Credit,
				Amount as Amount From trav_EO_GLTransaction gl 
		Inner Join Locations l on gl.LocationId = l.Id
		inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
		Where AcctId like '4%' and 
		--Case When @Key = 'Detail' THEN 1 WHEN [Year] in (Select distinct substring(#dtPickUp.Period, 5,len(#dtPickUp.Period))) THEN 1 ELSE 0 END = 1 and
		Case WHEN @Month IS NULL THEN 1 WHEN gl.Period = @Month THEN 1 ELSE 0 END = 1 and
		Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId = @LocationId THEN 1 ELSE 0 END = 1 
	End
	Else If @Key = 'GrandTotal'
	Begin
		Select Location, 
				AccountDescription as 'Account Description',
				[Year] as N'Fiscal Year',
				gl.[Period] as N'Fiscal Month',
				AcctId as N'Account Id',
				CONVERT(VARCHAR(10),EntryDate, 101) as N'Entry Date',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Trans Date',
				SourceCode as 'Source',
				[Desc] as 'Description',
				Reference as Reference,
				DebitAmt as Debit,
				CreditAmt as Credit,
				Amount as Amount From trav_EO_GLTransaction gl 
		Inner Join Locations l on gl.LocationId = l.Id
		inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([Year],gl.[Period],1),'MMM') + '_' + CAST([Year] as varchar)
		Where AcctId like '4%' and 
		[Year] in (Select distinct substring(#dtPickUp.Period, 5,len(#dtPickUp.Period))) and
		Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId = @LocationId THEN 1 ELSE 0 END = 1 
	End
END


GO


