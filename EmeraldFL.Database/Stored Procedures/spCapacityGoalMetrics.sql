/****** Object:  StoredProcedure [dbo].[spCapacityGoalMetrics]    Script Date: 6/19/2020 1:44:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 20-Dec-2019
-- Description:	This SP Fetch Metal Config Goal from table CapacityGoalMetrics

-- =============================================
--exec spCapacityGoalMetrics '2',2019,12
--exec spCapacityGoalMetrics '2',2019,12
ALTER PROCEDURE [dbo].[spCapacityGoalMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int
	as
BEGIN
Declare @CapacityGoalMetricsCount as int

select @CapacityGoalMetricsCount=count(1) from CapacityGoalMetrics where FiscalYear=@YEAR and FiscalPeriod=@MONTH and Location=@LocationId	
print @CapacityGoalMetricsCount

--if @CapacityGoalMetricsCount >0
--Begin 
Select GoalMetricsId
FiscalYear,
FiscalPeriod,
OM_GallonsDechlored=convert(numeric(18,2),OM_GallonsDechlored),
OM_ND_Gal_Shipped=convert(numeric(18,2),OM_ND_Gal_Shipped),
OM_Gal_Shipped_2_49=convert(numeric(18,2),OM_Gal_Shipped_2_49),
MM_CU_CC_Loads_Shipped=convert(numeric(18,2),MM_CU_CC_Loads_Shipped),
MM_Mix_CC_Loads_Shipped=convert(numeric(18,2),MM_Mix_CC_Loads_Shipped),
MM_AL_CC_Loads_Shipped=convert(numeric(18,2),MM_AL_CC_Loads_Shipped),
MM_CU_LBS_Sold=convert(numeric(18,2),MM_CU_LBS_Sold),
MM_Mix_Sold=convert(numeric(18,2),MM_Mix_Sold),
MM_AL_Sold=convert(numeric(18,2),MM_AL_Sold),
PM_LessThan_50_Poles_Decom=convert(numeric(18,2),PM_LessThan_50_Poles_Decom),
PM_LessThan_50_Pads_Decom=convert(numeric(18,2),PM_LessThan_50_Pads_Decom),
PM_Misc_Decom=convert(numeric(18,2),PM_Misc_Decom),
PM_LessThan_50_Bushing_Decom=convert(numeric(18,2),PM_LessThan_50_Bushing_Decom),
PM_GreaterThan_50_Poles_Decom=convert(numeric(18,2),PM_GreaterThan_50_Poles_Decom),
PM_Pit_Loads=convert(numeric(18,2),PM_Pit_Loads),
PM_Pounds_Granulated_OH=convert(numeric(18,2),PM_Pounds_Granulated_OH),
PM_Units_CheckedIn=convert(numeric(18,2),PM_Units_CheckedIn),
PM_Units_Sampled=convert(numeric(18,2),PM_Units_Sampled),
PM_Repairs=convert(numeric(18,2),PM_Repairs),
PM_Units_UnLoaded=convert(numeric(18,2),PM_Units_UnLoaded),
Location,
AddedOn,
AddedBy,
ModifiedOn,
ModifiedBy
from CapacityGoalMetrics
where FiscalYear=@YEAR and FiscalPeriod=@MONTH and Location=@LocationId	
--End


END

GO


