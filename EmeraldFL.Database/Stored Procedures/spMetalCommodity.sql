

/****** Object:  StoredProcedure [dbo].[spMetalCommodity]    Script Date: 6/18/2020 11:42:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 10-Dec-2019
-- Description:	This SP Fetch Amount for Metal Summary and Item Details only related to COR 
-- This SP fetch 2 result set as below
-- ResultSet 1 for Location Summary
-- ResultSet 2 for Location's Item Details

-- This SP caters requirement for both Summary and Detail(data for Export functionality) which are identified by value defined in Key
-- @Key = "Summary" for Summation view 
--		  "Detail" Detail View for chosen Year/Month and Plant
-- =============================================
--exec spMetalCommodity 2019,11,'','','Summary' --For Summary
--exec spMetalCommodity 2019,10,'Plant','Mississippi','Detail' --For detail with Location and chosen Plant
--exec spMetalCommodity 2019,10,'','Mississippi','Detail' --For detail with Location and all Plant
--exec spMetalCommodity 2019,10,'Field D','','Detail' --For detail with all Locations and chosen Plant
--exec spMetalCommodity 2019,10,'','','Detail' --For detail with all Locations and all Plant
--exec spMetalCommodity 2019,10,'','','Detail' --For detail with all Locations and all Plant

CREATE PROCEDURE [dbo].[spMetalCommodity]
	@YEAR as int,
	@MONTH as int,
	@PlantCode as varchar(max),
	@LocationName as varchar(100),
	@Key as varchar(15)
AS
BEGIN
		Declare @LocationId as int

		select @LocationId=ID from Locations where (active=1 or id in (14,15)) and Description=@LocationName
		Print @LocationId

		if @PlantCode = '' 
			set @PlantCode = null

		if @LocationName = '' 
			set @LocationName = null

		If @Key = 'Summary'
		Begin
			Select Location, 
			sum(case when Amount<0 then cast(QtyOrdSell as decimal (18,2))*(-1) else cast(QtyOrdSell as decimal(18,2)) end) as Pounds, 
			sum(Amount) as Revenue,
			[FiscalYear], 
			[FiscalPeriod],
			LocationId into #Metal
			From trav_EO_ArDetailHistory ar
			inner join Locations L on L.ID = ar.LocationId and l.Active = 1
			Where catid like 'FG%' and partid like ('%COR%') and
			Case WHEN @PlantCode IS NULL THEN 1
			WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1 and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH
			group by Location,[FiscalYear],[FiscalPeriod],LocationId

			--=======Item Breakup
			Select Location, 
			PartId,
			sum(case when Amount<0 then cast(QtyOrdSell as decimal (18,2))*(-1) else cast(QtyOrdSell as decimal(18,2)) end) as Pounds, 
			sum(Amount) as Revenue,
			[FiscalYear], 
			[FiscalPeriod],
			LocationId into #MetalDesc
			From trav_EO_ArDetailHistory ar
			inner join Locations L on L.ID = ar.LocationId and l.Active = 1
			Where catid like 'FG%' and partid like ('%COR%') and
			Case WHEN @PlantCode IS NULL THEN 1
			WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1 and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH
			group by Location,PartId,[FiscalYear],[FiscalPeriod],LocationId

			Select Location, Pounds, Revenue, case when Pounds = 0 THEN 0 ELSE Revenue/Pounds end as '$/LB' from #Metal order by Revenue desc, Location
			Select Location, PartId, Pounds, Revenue, case when Pounds = 0 THEN 0 ELSE Revenue/Pounds end as '$/LB' from #MetalDesc order by Revenue desc, Location
		End
		Else If @Key = 'Detail'
		Begin
			Select 
				l.Description as Location, 
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
			inner join Locations L on L.ID = ar.LocationId and l.Active = 1
			Where catid like 'FG%' and partid like ('%COR%') and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH and 
			ar.LocationId = isnull(@LocationId, L.ID) and
			Case WHEN @PlantCode IS NULL THEN 1
				WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1			
			
		End
END



GO


