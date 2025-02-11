/****** Object:  StoredProcedure [dbo].[spGetCapacityMetrics]    Script Date: 6/19/2020 1:42:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 18-Nov-2019
-- Description:	This SP Fetch Metal Config data from table CapacityMetrics to delete

-- =============================================
--exec spGetCapacityMetrics '7',2019,12
--exec spGetCapacityMetrics '7',2019,12
--exec spGetCapacityMetrics '7',2019,12
ALTER PROCEDURE[dbo].[spGetCapacityMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int
	as
BEGIN
	select * from CapacityMetrics where Location=@LocationId and year(MetricsDate)=@YEAR and month(MetricsDate)	=@MONTH
END


GO


