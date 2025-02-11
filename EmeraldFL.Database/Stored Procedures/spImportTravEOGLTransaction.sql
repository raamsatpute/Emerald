-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 06-Sep-2019
-- Description:	This SP Imports data from Traverse Server from trav_EO_GLTransaction_view view into trav_EO_GLTransaction table in EO system. 
--				The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_EO_GLTransaction : Holds result set return from Traverse
--				Location: Location id for each location 1=fl,
--
-- =============================================

ALTER PROCEDURE [dbo].[spImportTravEOGLTransaction]
	@traverse_EO_GLTransaction traverse_EO_GLTransaction Readonly,
	@Location INT
	
AS
BEGIN
declare @LocationName as [varchar](100)
Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Import', 'Begins Sql Process', GetDate(),@Location)
Begin Try
Delete from trav_EO_GLTransaction where LocationId = @Location
select @LocationName=[Description] from Locations where active=1 and ID=@Location

INSERT INTO trav_EO_GLTransaction(	
							EntryDate,						TransDate,						[Desc],						SourceCode,
							Reference,						AcctId,							DebitAmt,					CreditAmt,
							Period,							[Year],							Amount,						AccountDescription,
							LocationId,						Location
							)

SELECT						EntryDate,						TransDate,						[Desc],						SourceCode,
							Reference,						AcctId,							DebitAmt,					CreditAmt,
							Period,							[Year],							Amount,						AccountDescription,
							@Location,						@LocationName
							
							 
FROM @traverse_EO_GLTransaction
End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('GL Job Types Failed', error_message(), GetDate(),@Location)
	End Catch

END




