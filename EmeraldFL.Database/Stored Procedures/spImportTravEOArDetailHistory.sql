-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 06-Sep-2019
-- Description:	This SP Imports data from Traverse Server from trav_EO_ArDetailHistory_view view into trav_EO_ArDetailHistory table in EO system. 
--				The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_EO_ArDetailHistory : Holds result set return from Traverse
--				Location: Location id for each location 1=fl,
--
-- =============================================

CREATE PROCEDURE [dbo].[spImportTravEOArDetailHistory]
	@traverse_EO_ArDetailHistory traverse_EO_ArDetailHistory Readonly,
	@Location INT
	
AS
BEGIN
declare @LocationName as [varchar](100)
Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Import', 'Begins Sql Process', GetDate(),@Location)
Begin Try
Delete from trav_EO_ArDetailHistory where LocationId = @Location 

select @LocationName=[Description] from Locations where active=1 and ID=@Location
--print @LocationName
INSERT INTO trav_EO_ArDetailHistory(	
							CompId,								FiscalYear,					FiscalPeriod,				[Description],
							Amount,								ShipDate,					WhseId,						PartId,
							UnitPriceSell,						QtyOrdSell,					QtyShipSell,				CatId,
							TransDate,							SalesAcct,					LocationId,					Location											
							)

SELECT						CompId,								FiscalYear,					FiscalPeriod,				[Description],
							Amount,								ShipDate,					WhseId,						PartId,
							UnitPriceSell,						QtyOrdSell,					QtyShipSell,				CatId,
							TransDate,							SalesAcct,					@Location,					@LocationName

							
FROM @traverse_EO_ArDetailHistory
End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('AR Job Types Failed', error_message(), GetDate(),@Location)
	End Catch

END





