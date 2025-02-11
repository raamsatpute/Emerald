/****** Object:  StoredProcedure [dbo].[spSaveCapacityMetrics]    Script Date: 6/19/2020 1:43:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 16-Dec-2019
-- Description:	This SP saves,updates,deletes data in CapacityMetrics table in EO system on basis of Key passed. 
--
-- =============================================

ALTER PROCEDURE [dbo].[spSaveCapacityMetrics]
	@eo_CapacityMetrics eo_CapacityMetrics Readonly,
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
				INSERT INTO CapacityMetrics(	
											MetricsDate,						EM_HeadCount,					EM_HoursWorked,				OM_GallonsOH_50_499,
											OM_NDGallonsOH,						OM_GallonsOH_2_49,				OM_GallonsDechlored,		PM_PitLoads,
											PM_PoundsGranulatedOH,				PM_UnitsUnLoaded,				Location,					AddedOn,
											AddedBy,							ModifiedOn,						ModifiedBy					
											)

				SELECT						src.MetricsDate,					src.EM_HeadCount,				src.EM_HoursWorked,			src.OM_GallonsOH_50_499,
											src.OM_NDGallonsOH,					src.OM_GallonsOH_2_49,			src.OM_GallonsDechlored,	src.PM_PitLoads,
											src.PM_PoundsGranulatedOH,			src.PM_UnitsUnLoaded,			src.Location,				src.AddedOn,
											src.AddedBy,						null,							null					

							
				FROM @eo_CapacityMetrics as src
				Left Outer Join CapacityMetrics trg on src.MetricsDate = trg.MetricsDate and trg.Location = src.Location
				Where trg.MetricsDate is null


				update trg
				set 
				trg.MetricsDate=src.MetricsDate,						
				trg.EM_HeadCount=src.EM_HeadCount,					
				trg.EM_HoursWorked=src.EM_HoursWorked,				
				trg.OM_GallonsOH_50_499=src.OM_GallonsOH_50_499,							
				trg.OM_NDGallonsOH=src.OM_NDGallonsOH,						
				trg.OM_GallonsOH_2_49=src.OM_GallonsOH_2_49,				
				trg.OM_GallonsDechlored=src.OM_GallonsDechlored,		
				trg.PM_PitLoads=src.PM_PitLoads,
				trg.PM_PoundsGranulatedOH=src.PM_PoundsGranulatedOH,				
				trg.PM_UnitsUnLoaded=src.PM_UnitsUnLoaded,				
				trg.Location=src.Location,		
				trg.ModifiedOn=src.ModifiedOn,						
				trg.ModifiedBy=src.ModifiedBy
				FROM    @eo_CapacityMetrics AS src
				inner join CapacityMetrics as trg on src.MetricsDate = trg.MetricsDate and src.Location = trg.Location



				DELETE trg 
				FROM CapacityMetrics trg
				left JOIN @eo_CapacityMetrics src ON src.MetricsDate = trg.MetricsDate and src.Location = trg.Location
				where src.metricsdate is null and trg.location=@LocationId and year(trg.MetricsDate)=@YEAR and Month(trg.MetricsDate)=@MONTH

			end

		else if (@Key ='Delete')
			begin

				delete from CapacityMetrics where Year(MetricsDate)=@YEAR and Month(MetricsDate)=@MONTH and Location=@LocationId


			End
end

End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Save Capacity Metrics Failed', error_message(), GetDate(),@LocationId)
	End Catch

END




