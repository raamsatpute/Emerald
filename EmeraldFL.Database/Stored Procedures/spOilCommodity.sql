/****** Object:  StoredProcedure [dbo].[spOilCommodity]    Script Date: 6/18/2020 11:41:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 10-Dec-2019
-- Description:	This SP Fetch Amount for Oil Summary and Item Details only related to OIL
-- This SP fetch 2 result set as below
-- ResultSet 1 for Location Summary
-- ResultSet 2 for Location's Item Details

-- This SP caters requirement for both Summary and Detail(data for Export functionality) which are identified by value defined in Key
-- @Key = "Summary" for Summation view 
--		  "Detail" Detail View for chosen Year/Month and Plant
-- =============================================
--exec spMetalCommodity 2018,11,'','','Summary' --For Summary
--exec spOilCommodity 2019,10,'Plant','Mississippi','Detail' --For detail with Location and chosen Plant
--exec spOilCommodity 2019,10,'','Mississippi','Detail' --For detail with Location and all Plant
--exec spOilCommodity 2019,10,'Field D','','Detail' --For detail with all Locations and chosen Plant
--exec spOilCommodity 2018,1,'','CSP','Detail' --For detail with all Locations and all Plant
--exec spOilCommodity 2018,1,'','CSP','Detail' --For detail with all Locations and all Plant

CREATE PROCEDURE [dbo].[spOilCommodity]
	@YEAR as int,
	@MONTH as int,
	@PlantCode as varchar(max),
	@LocationName as varchar(100),
	@Key as varchar(15)
AS
BEGIN
		Declare @LocationId as int

		
		select @LocationId=ID from Locations where (active=1 or id in (14)) and Description=@LocationName
		Print @LocationId

		if @PlantCode = '' 
			set @PlantCode = null

		if @LocationName = '' 
			set @LocationName = null

		If @Key = 'Summary'
		Begin
			Select Location, 
			sum(case when Amount<0 then cast(QtyOrdSell as decimal (18,2))*(-1) else cast(QtyOrdSell as decimal(18,2)) end) as Gallons, 
			sum(Amount) as Revenue,
			[FiscalYear], 
			[FiscalPeriod],
			LocationId into #Oil
			From trav_EO_ArDetailHistory ar
			inner join Locations L on L.ID = ar.LocationId and ((l.Active = 1)or id in (14))
			Where catid like 'FG%' and partid like ('%OIL%') and
			Case WHEN @PlantCode IS NULL THEN 1
			WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1 and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH
			group by Location,[FiscalYear],[FiscalPeriod],LocationId

			--=======Item Breakup
			Select Location, 
			PartId,
			sum(case when Amount<0 then cast(QtyOrdSell as decimal (18,2))*(-1) else cast(QtyOrdSell as decimal(18,2)) end) as Gallons, 
			sum(Amount) as Revenue,
			[FiscalYear], 
			[FiscalPeriod],
			LocationId into #OilDesc
			From trav_EO_ArDetailHistory ar
			inner join Locations L on L.ID = ar.LocationId and ((l.Active = 1)or id in (14))
			Where catid like 'FG%' and partid like ('%OIL%') and
			Case WHEN @PlantCode IS NULL THEN 1
			WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1 and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH
			group by Location,PartId,[FiscalYear],[FiscalPeriod],LocationId

			Select Location, Gallons, Revenue, case when Gallons = 0 THEN 0 ELSE Revenue/Gallons end as '$/GL' from #Oil order by Revenue desc, Location
			Select Location, PartId, Gallons, Revenue, case when Gallons = 0 THEN 0 ELSE Revenue/Gallons end as '$/GL' from #OilDesc order by Revenue desc, Location
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
			inner join Locations L on L.ID = ar.LocationId and ((l.Active = 1)or id in (14))
			Where catid like 'FG%' and partid like ('%OIL%') and
			[FiscalYear] = @YEAR and 
			[FiscalPeriod] = @MONTH and 
			ar.LocationId = isnull(@LocationId, L.ID) and
			Case WHEN @PlantCode IS NULL THEN 1
				WHEN ar.WhseId IN (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@PlantCode, ',')) THEN 1 ELSE 0 END = 1			
			
		End
END



GO


