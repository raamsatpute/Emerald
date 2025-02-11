/****** Object:  StoredProcedure [dbo].[spImportTravEOArDetailHistory]    Script Date: 6/19/2020 1:34:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 06-Sep-2019
-- Description:	This SP Imports data from Traverse Server from trav_EO_ArDetailHistory_view view into trav_EO_ArDetailHistory table in EO system. 
--				The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_EO_ArDetailHistory : Holds result set return from Traverse
--				Location: Location id for each location 1=fl,
--
-- =============================================

ALTER PROCEDURE [dbo].[spImportTravEOArDetailHistory]
	@traverse_EO_ArDetailHistory traverse_EO_ArDetailHistory Readonly,
	@Location INT
	
AS
BEGIN

declare @LocationName as [varchar](100)
Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Import', 'Begins Sql Process', GetDate(),@Location)
Begin Try
Delete from trav_EO_ArDetailHistory where LocationId = @Location 

select @LocationName=[Description] from Locations where (active=1 or id in (14)) and ID=@Location
--print @LocationName
INSERT INTO trav_EO_ArDetailHistory(	
							CompId,								FiscalYear,					FiscalPeriod,				[Description],
							Amount,								ShipDate,					WhseId,						PartId,
							UnitPriceSell,						QtyOrdSell,					QtyShipSell,				CatId,
							TransDate,							SalesAcct,					LocationId,					Location,
							TransType,							GLAcctSales											
							)

SELECT						CompId,								FiscalYear,					FiscalPeriod,				[Description],
							Amount,								ShipDate,					WhseId,						PartId,
							UnitPriceSell,						QtyOrdSell,					QtyShipSell,				CatId,
							TransDate,							SalesAcct,					@Location,					@LocationName,
							TransType,							GLAcctSales

							
FROM @traverse_EO_ArDetailHistory

UPDATE trav_EO_ArDetailHistory set SalesAcct=case TransType when 1 then 'Invoice'
															when -1 then 'Credit Memo'
															when -2 then 'Payment'  end 

End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('AR Job Types Failed', error_message(), GetDate(),@Location)
	End Catch

END






GO


