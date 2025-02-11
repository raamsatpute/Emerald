/****** Object:  StoredProcedure [dbo].[spMetalMetrics]    Script Date: 6/18/2020 11:51:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 23-Oct-2019, Rewrite on 03-Dec-19 as per client changed requirement
-- Description:	This SP Fetch summary for Metal's Pounds and Revenue seperately
-- @LocationId : Holds value for passed location
-- @YEAR : Holds value for passed year
-- @Month : Holds value for passed month 
-- @PlantCode : Holds value for passed Plants
-- @PartCode : Holds value for passed Itemid
-- @Key : Indicates if resultset required for Summary ('Summary') or for Export functionality ('Detail' or 'GrandTotal')
-- =============================================

--exec spMetalMetrics '1',2019,12,'','ALCOR,CUCOR,CUNUG,CUWIND,MIXCOR,SSINI','Summary'

--exec spMetalMetrics '1,13',2019,10,'','','Summary'
--exec spMetalMetrics '1,13',2019, 11, '','','Detail' --For Monthly Detail
--exec spMetalMetrics '1,13',2019, 11, '','','GrandTotal' --For Yearly Detail 
--exec spMetalMetrics '1,13',2019, 11, '','','GrandTotal' --For Yearly Detail 


CREATE PROCEDURE [dbo].[spMetalMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int,
	@PlantCode as varchar(Max),
	@PartCode as varchar(Max),
	@Key as varchar(15)
AS
BEGIN
print @PartCode
		Declare @PeriodFROM as date
		Declare @PeriodTo as date
		Declare @Cols as nvarchar(max)
		Declare @NullToZeroCol as nvarchar(max)
		Declare @TotCols as nvarchar(max)
		Declare @MonthNumbers as nvarchar(max)
		Declare @Query as nvarchar(max)
		Declare @ColSum as varchar(8000)

		--================================================
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpAmtMonth')
		Begin
			Drop table tmpAmtMonth
		End
		IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpAmtTotal')
		Begin
			Drop table tmpAmtTotal
		End
		--================================================
		if @PlantCode = '' 
			set @PlantCode = null

		if @PartCode = '' 
			set @PartCode = null

		if @Month = '' 
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
														-- Metal Ponds/Revenue
		--===============================================================================================================================
		If @Key = 'Summary'
		Begin
			Select Entity, 
			sum(Total) as PoundAmt, 
			MetalPeriod, FiscalYear, FiscalPeriod into #arQtyData from 
			(
				--For Pounds
					Select 
					'Pounds' as 'Entity',
					case when Amount<0 then cast(QtyOrdSell as decimal (18,2))*(-1) else cast(QtyOrdSell as decimal(18,2)) end as Total,
					FORMAT(datefromparts(fiscalyear,fiscalperiod,1),'MMM') + '_' + CAST([fiscalYear] as varchar) as [MetalPeriod], 
					fiscalyear, 
					fiscalperiod
					From trav_EO_ArDetailHistory ar
					inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([FiscalYear],ar.[FiscalPeriod],1),'MMM') + '_' + CAST([FiscalYear] as varchar)
					inner join Locations L on L.ID = ar.LocationId and (l.Active = 1 or L.ID = 14)
					Where catid like 'FG%' and partid not like ('%OIL%') and GLAcctSales like '4%'
					--Below all Filter removed as Cody wants the summary of all data without any filter on it as per email on 09-Dec-19
					--Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and 
					--Case WHEN @PartCode IS NULL THEN 1 
					--WHEN ar.PartId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PartCode, ',')) THEN 1 ELSE 0 END = 1 and
					--Case WHEN @PlantCode IS NULL THEN 1
					--WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1
				UNION ALL
				--For Revenue
					Select 
					'Revenue' as 'Entity',
					cast(Amount as decimal(18,2)) as Total,
					FORMAT(datefromparts(fiscalyear,fiscalperiod,1),'MMM') + '_' + CAST([fiscalYear] as varchar) as [MetalPeriod], 
					fiscalyear, 
					fiscalperiod
					From trav_EO_ArDetailHistory ar
					inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([FiscalYear],ar.[FiscalPeriod],1),'MMM') + '_' + CAST([FiscalYear] as varchar)
					inner join Locations L on L.ID = ar.LocationId and (l.Active = 1 or L.ID = 14)
					Where catid like 'FG%' and partid not like ('%OIL%') and GLAcctSales like '4%'
					--Below all Filter removed as Cody wants the summary of all data without any filter on it
					--Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and 
					--Case WHEN @PartCode IS NULL THEN 1 
					--WHEN ar.PartId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PartCode, ',')) THEN 1 ELSE 0 END = 1 and
					--Case WHEN @PlantCode IS NULL THEN 1
					--WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1
				UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
						  -- this will eliminate need to check Datatable within Dataset in Front end. 
				(
					SELECT 'TBD', 0, '', @Year, @Month
				)
			)a group by Entity, MetalPeriod, fiscalyear,fiscalperiod

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
				'SELECT Entity'+ @NullToZeroCol +' into tmpAmtMonth FROM
				(
					SELECT     
						Entity,	MetalPeriod, PoundAmt
					FROM #arQtyData
				)X
				PIVOT 
				(   
					 sum(PoundAmt)
					FOR [MetalPeriod] in (' + @cols + ')
				) P'

			EXEC SP_EXECUTESQL @query

			SELECT @colSum = STUFF((SELECT '+' + QUOTENAME(Period) 
						FROM #dtPickUp 
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
			,1,1,'')

			Delete from tmpAmtMonth where Entity = 'TBD' -- Row deleted as we now have data structure in place. 

			SELECT @query = 
			'Select Entity' + @NullToZeroCol + ', ' + @colSum + ' as GrandTotal into tmpAmtTotal from tmpAmtMonth tm' 

			EXEC SP_EXECUTESQL @query

			SELECT @query = 
			'Select Entity' + @NullToZeroCol + ', ' + 'GrandTotal, GrandTotal/12 as Average
			 from tmpAmtTotal'

			EXEC SP_EXECUTESQL @query

			--================================================
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpAmtMonth')
			Begin
				Drop table tmpAmtMonth
			End
			IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpAmtTotal')
			Begin
				Drop table tmpAmtTotal
			End
			--================================================
		End
		Else If @Key = 'Detail'
		Begin
			Select l.Description as Location, 
				ar.FiscalYear as N'Fiscal Year',
				FiscalPeriod as 'Period',
				PartId as N'Item Id',
				WhseId as N'Location Id',
				SalesAcct as N'Sales Acct',
				ar.[Description] as 'Description',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Transaction Date',
				case when Amount < 0 then cast(QtyOrdSell as decimal(18,2))*(-1) else cast(QtyOrdSell as decimal (18,2)) end as N'Qty Order Sell',
				 [Amount]=cast (Amount as decimal (18,2)) 
			From trav_EO_ArDetailHistory ar 
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([FiscalYear],ar.[FiscalPeriod],1),'MMM') + '_' + CAST([FiscalYear] as varchar)
			Inner Join Locations l on ar.LocationId = l.Id and (l.[Active] = 1 OR l.Id = 14)
			Where catid like 'FG%' and partid not like ('%OIL%') and GLAcctSales like '4%' and 
			Case WHEN @Month IS NULL THEN 1 WHEN ar.FiscalPeriod = @Month THEN 1 ELSE 0 END = 1 --and
			--Below all Filter removed as Cody wants the summary of all data without any filter on it
			--Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and 
			----Case WHEN @PartCode IS NULL THEN 1 WHEN ar.PartId = @PartCode THEN 1 ELSE 0 END = 1 and
			--Case WHEN @PartCode IS NULL THEN 1 
			--	WHEN ar.PartId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PartCode, ',')) THEN 1 ELSE 0 END = 1 and
			--Case WHEN @PlantCode IS NULL THEN 1
			--WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1
		End
		Else If @Key = 'GrandTotal'
		Begin
			Select l.Description as Location, 
				ar.FiscalYear as N'Fiscal Year',
				FiscalPeriod as 'Period',
				PartId as N'Item Id',
				WhseId as N'Location Id',
				SalesAcct as N'Sales Acct',
				ar.[Description] as 'Description',
				CONVERT(VARCHAR(10),TransDate, 101) as N'Transaction Date',
				case when Amount < 0 then cast(QtyOrdSell as decimal(18,2))*(-1) else cast(QtyOrdSell as decimal (18,2)) end as N'Qty Order Sell',
				 [Amount]=cast (Amount as decimal (18,2)) 
			From trav_EO_ArDetailHistory ar 
			inner join #dtPickUp on #dtPickUp.Period = FORMAT(datefromparts([FiscalYear],ar.[FiscalPeriod],1),'MMM') + '_' + CAST([FiscalYear] as varchar)
			Inner Join Locations l on ar.LocationId = l.Id and (l.[Active] = 1 OR l.Id = 14)
			Where catid like 'FG%' and partid not like ('%OIL%') and GLAcctSales like '4%'--and 
			--Below all Filter removed as Cody wants the summary of all data without any filter on it
			----FiscalYear in (Select distinct substring(#dtPickUp.Period, 5,len(#dtPickUp.Period))) and
			--Locationid in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ',')) and 
			--Case WHEN @PartCode IS NULL THEN 1 WHEN ar.PartId = @PartCode THEN 1 ELSE 0 END = 1 and
			--Case WHEN @PartCode IS NULL THEN 1 
			--	WHEN ar.PartId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PartCode, ',')) THEN 1 ELSE 0 END = 1 and
			--Case WHEN @PlantCode IS NULL THEN 1
			--WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1
		End
END


GO


