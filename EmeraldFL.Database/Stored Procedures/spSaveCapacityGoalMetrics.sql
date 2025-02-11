/****** Object:  StoredProcedure [dbo].[spSaveCapacityGoalMetrics]    Script Date: 6/19/2020 1:46:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 20-Dec-2019
-- Description:	This SP saves,updates,deletes data to CapacityGoalMetrics table in EO system. 
--
-- =============================================

ALTER PROCEDURE [dbo].[spSaveCapacityGoalMetrics]
	@eo_CapacityGoalMetrics eo_CapacityGoalMetrics Readonly,
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int,
	@Key as varchar(100)
	
AS
BEGIN

Begin Try

 begin 
 print'Inert'
 if (@Key ='AddUpdate')
 begin 
INSERT INTO CapacityGoalMetrics(	
							FiscalYear,						FiscalPeriod,					OM_GallonsDechlored,				OM_ND_Gal_Shipped,
							OM_Gal_Shipped_2_49,			MM_CU_CC_Loads_Shipped,			MM_Mix_CC_Loads_Shipped,			MM_AL_CC_Loads_Shipped,
							MM_CU_LBS_Sold,					MM_Mix_Sold,					MM_AL_Sold,							PM_LessThan_50_Poles_Decom,
							PM_LessThan_50_Pads_Decom,		PM_Misc_Decom,					PM_LessThan_50_Bushing_Decom,		PM_GreaterThan_50_Poles_Decom,
							PM_Pit_Loads,					PM_Pounds_Granulated_OH,		PM_Units_CheckedIn,					PM_Units_Sampled,
							PM_Repairs,						PM_Units_UnLoaded,				Location,							AddedOn,
							AddedBy,						ModifiedOn,						ModifiedBy
							)

SELECT						src.FiscalYear,					src.FiscalPeriod,				src.OM_GallonsDechlored,			src.OM_ND_Gal_Shipped,
							src.OM_Gal_Shipped_2_49,		src.MM_CU_CC_Loads_Shipped,		src.MM_Mix_CC_Loads_Shipped,		src.MM_AL_CC_Loads_Shipped,
							src.MM_CU_LBS_Sold,				src.MM_Mix_Sold,				src.MM_AL_Sold,						src.PM_LessThan_50_Poles_Decom,
							src.PM_LessThan_50_Pads_Decom,	src.PM_Misc_Decom,				src.PM_LessThan_50_Bushing_Decom,	src.PM_GreaterThan_50_Poles_Decom,
							src.PM_Pit_Loads,				src.PM_Pounds_Granulated_OH,	src.PM_Units_CheckedIn,				src.PM_Units_Sampled,
							src.PM_Repairs,					src.PM_Units_UnLoaded,			src.Location,						src.AddedOn,
							src.AddedBy,					null,							null						

							
FROM @eo_CapacityGoalMetrics as src
Left Outer Join CapacityGoalMetrics trg on src.FiscalYear = trg.FiscalYear and trg.FiscalPeriod = src.FiscalPeriod and trg.Location = src.Location
Where trg.FiscalYear is null and trg.FiscalPeriod is null


update trg
set 
trg.FiscalYear=src.FiscalYear,						
trg.FiscalPeriod=src.FiscalPeriod,					
trg.OM_GallonsDechlored=src.OM_GallonsDechlored,				
trg.OM_ND_Gal_Shipped=src.OM_ND_Gal_Shipped,
trg.OM_Gal_Shipped_2_49=src.OM_Gal_Shipped_2_49,
trg.MM_CU_CC_Loads_Shipped=src.MM_CU_CC_Loads_Shipped,
trg.MM_Mix_CC_Loads_Shipped=src.MM_Mix_CC_Loads_Shipped,
trg.MM_AL_CC_Loads_Shipped=src.MM_AL_CC_Loads_Shipped,
trg.MM_CU_LBS_Sold=src.MM_CU_LBS_Sold,
trg.MM_Mix_Sold=src.MM_Mix_Sold,
trg.MM_AL_Sold=src.MM_AL_Sold,
trg.PM_LessThan_50_Poles_Decom=src.PM_LessThan_50_Poles_Decom,
trg.PM_LessThan_50_Pads_Decom=src.PM_LessThan_50_Pads_Decom,
trg.PM_Misc_Decom=src.PM_Misc_Decom,
trg.PM_LessThan_50_Bushing_Decom=src.PM_LessThan_50_Bushing_Decom,
trg.PM_GreaterThan_50_Poles_Decom=src.PM_GreaterThan_50_Poles_Decom,
trg.PM_Pit_Loads=src.PM_Pit_Loads,
trg.PM_Pounds_Granulated_OH=src.PM_Pounds_Granulated_OH,
trg.PM_Units_CheckedIn=src.PM_Units_CheckedIn,
trg.PM_Units_Sampled=src.PM_Units_Sampled,						
trg.PM_Repairs=src.PM_Repairs,
trg.PM_Units_UnLoaded=src.PM_Units_UnLoaded,		
trg.Location=src.Location,		
trg.ModifiedOn=src.ModifiedOn,						
trg.ModifiedBy=src.ModifiedBy
FROM    @eo_CapacityGoalMetrics AS src
inner join CapacityGoalMetrics as trg on src.FiscalYear = trg.FiscalYear and trg.FiscalPeriod = src.FiscalPeriod and trg.Location = src.Location

end


else if (@Key ='Delete')
begin

delete from CapacityGoalMetrics where FiscalYear=@YEAR and FiscalPeriod=@MONTH and Location=@LocationId


End
--DELETE trg 
--FROM CapacityMetrics trg
--left JOIN @eo_CapacityMetrics src ON src.MetricsDate = trg.MetricsDate and src.Location = trg.Location
--where src.metricsdate is null and trg.location=@LocationId and year(trg.MetricsDate)=@YEAR and Month(trg.MetricsDate)=@MONTH
end

End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Save Capacity Metrics Failed', error_message(), GetDate(),@LocationId)
	End Catch

END





GO


