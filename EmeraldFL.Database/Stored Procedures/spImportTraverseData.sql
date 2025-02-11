/****** Object:  StoredProcedure [dbo].[spImportTraverseData]    Script Date: 08/14/19 10:17:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 24-Oct-2018
-- Description:	This SP Imports data from Traverse Server into EO system. The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_ExportJobTypes : Holds result set of Job Types return from Traverse
--				traverse_ExportCustomers : Holds result set of Customer return from Traverse
--				traverse_ExportJobsView : Holds result set of ExportsJobs_View view return from Traverse
--				Location: Location id for each location 1=fl,
--
/******************
NOTE: Functional logic remains the same as was written in legacy system by other vendor. 
	  This SP was created to improve performance issue which was exist in legacy system.
*******************/
-- =============================================

ALTER PROCEDURE [dbo].[spImportTraverseData]
	@traverse_JobTypes traverse_ExportJobTypes Readonly,
	@traverse_ExportCustomers traverse_ExportCustomers Readonly,
	@traverse_ExportJobs traverse_ExportJobsView Readonly,
	@Location INT,
	@LocationGroup varchar(20)

AS
BEGIN
	--IF @LocationGroup='FL'
	--BEGIN
		exec [spImportTraverseData_FL] @traverse_JobTypes=@traverse_JobTypes,
									@traverse_ExportCustomers=@traverse_ExportCustomers,
									@traverse_ExportJobs=@traverse_ExportJobs,
									@Location=@Location
					
	--END
	--ELSE IF @LocationGroup='MS'
	--BEGIN
	--	exec [spImportTraverseData_MS] @traverse_JobTypes=@traverse_JobTypes,
	--								@traverse_ExportCustomers=@traverse_ExportCustomers,
	--								@traverse_ExportJobs=@traverse_ExportJobs,
	--								@Location=@Location
	--END

	--ELSE
	--BEGIN
	--	exec [spImportTraverseData_CH] @traverse_JobTypes=@traverse_JobTypes,
	--								@traverse_ExportCustomers=@traverse_ExportCustomers,
	--								@traverse_ExportJobs=@traverse_ExportJobs,
	--								@Location=@Location
	--END

END




