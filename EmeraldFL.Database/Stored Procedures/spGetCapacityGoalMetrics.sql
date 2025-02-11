/****** Object:  StoredProcedure [dbo].[spGetCapacityGoalMetrics]    Script Date: 6/19/2020 1:45:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 20-Dec-2019
-- Description:	This SP Fetch Metal Config Goal from table CapacityGoalMetrics to delete 

-- =============================================
--exec spGetCapacityGoalMetrics '2',2019,12
--exec spGetCapacityGoalMetrics '2',2019,12
ALTER PROCEDURE [dbo].[spGetCapacityGoalMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int
	as
BEGIN

Select *
from CapacityGoalMetrics
where FiscalYear=@YEAR and FiscalPeriod=@MONTH and Location=@LocationId	
END

GO


