/****** Object:  StoredProcedure [dbo].[spCapacityMetrics]    Script Date: 6/19/2020 1:41:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 18-Nov-2019
-- Description:	This SP Fetch Metal Config data from table CapacityMetrics

-- =============================================
--exec spCapacityMetrics '1',2019,11
--exec spCapacityMetrics '1',2019,11
ALTER PROCEDURE [dbo].[spCapacityMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int
	as
BEGIN
Declare @DailyMetricsCount as int,
		@NosOfDays as int,
		@DATE1 AS Datetime,
		@Day as int 

DECLARE @CapacityMetricsData TABLE (
		[MetricsDate]Date NULL,
		[EM_HeadCount]	Numeric(18,5) NULL,
		[EM_HoursWorked]	Numeric(18,5) NULL,
		[OM_GallonsOH_50_499]	Numeric(18,5) NULL,
		[OM_NDGallonsOH]	Numeric(18,5) NULL,
		[OM_GallonsOH_2_49]	Numeric(18,5) NULL,
		[OM_GallonsDechlored]	Numeric(18,5) NULL,
		[PM_PitLoads]	Numeric(18,5) NULL,
		[PM_PoundsGranulatedOH]	Numeric(18,5) NULL,
		[PM_UnitsUnLoaded]	Numeric(18,5) NULL,
		[Location] int,
		[AddedOn] datetime NULL,
		[AddedBy] int NULL,
		[ModifiedOn] datetime NULL,
		[ModifiedBy] int NULl		
)


If(( Month(getDate()) = @MONTH) and (year(getdate())=@year))
		begin
		set @NosOfDays = (SELECT day(getdate()))
		print @NosOfDays		
		end
--Else If Month(getDate()) > @MONTH
--Else If (@year<year(getdate()))
else
		begin
		set @NosOfDays = (SELECT DAY(EOMONTH(DATEFROMPARTS(@year,@MONTH,1))))	
		print @NosOfDays
		end

--set @NosOfDays = (SELECT DAY(EOMONTH(DATEFROMPARTS(@year,@month,1))))
set @Day = 1

While @Day<= @NosOfDays
Begin
Set @DATE1 = (SELECT CAST(cast(@Year as varchar(4)) + '-' + cast(@Month as varchar(2))+ '-' + cast(@Day as varchar(2))  AS DATE))
print @DATE1
Insert into @CapacityMetricsData
(
	 [MetricsDate],
	 Location
)
Values
(
	cast(@DATE1 as date),
	@LocationId
)	
Set @Day += 1
End

select @DailyMetricsCount=count(1) from CapacityMetrics 
where year(MetricsDate)=@YEAR 
and month(MetricsDate)=@MONTH 
and Location in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ','))
print '@DailyMetricsCount'
print @DailyMetricsCount

if @DailyMetricsCount =0
Begin 
Select [MetricsDate]= MetricsDate,--CONVERT(VARCHAR(10),[MetricsDate], 101),
[EM_HeadCount]=convert(numeric(18,2),[EM_HeadCount]),
[EM_HoursWorked]=convert(numeric(18,2),[EM_HoursWorked]),
[OM_GallonsOH_50_499]=convert(numeric(18,2),[OM_GallonsOH_50_499]),
[OM_NDGallonsOH]=convert(numeric(18,2),[OM_NDGallonsOH]),
[OM_GallonsOH_2_49]=convert(numeric(18,2),[OM_GallonsOH_2_49]),
[OM_GallonsDechlored]=convert(numeric(18,2),[OM_GallonsDechlored]),
[PM_PitLoads]=convert(numeric(18,2),[PM_PitLoads]),
[PM_PoundsGranulatedOH]=convert(numeric(18,2),[PM_PoundsGranulatedOH]),
[PM_UnitsUnLoaded]=convert(numeric(18,2),[PM_UnitsUnLoaded])
 from @CapacityMetricsData
End

else if @DailyMetricsCount >0
begin
--select * from @CapacityMetricsData


select 
--MetricsDate= cast(hash_tbl_CM.MetricsDate as date),

--EM_HeadCount=convert(numeric(18,2),isnull(tbl_CM.EM_HeadCount,0)),
--EM_HoursWorked=convert(numeric(18,2),isnull(tbl_CM.EM_HoursWorked,0)),
--OM_GallonsOH_50_499=convert(numeric(18,2),isnull(tbl_CM.OM_GallonsOH_50_499,0)),
--OM_NDGallonsOH=convert(numeric(18,2),isnull(tbl_CM.OM_NDGallonsOH,0)),
--OM_GallonsOH_2_49=convert(numeric(18,2),isnull(tbl_CM.OM_GallonsOH_2_49,0)),
--OM_GallonsDechlored=convert(numeric(18,2),isnull(tbl_CM.OM_GallonsDechlored,0)),
--PM_PitLoads=convert(numeric(18,2),isnull(tbl_CM.PM_PitLoads,0)),
--PM_PoundsGranulatedOH=convert(numeric(18,2),isnull(tbl_CM.PM_PoundsGranulatedOH,0)),
--PM_UnitsUnLoaded=convert(numeric(18,2),isnull(tbl_CM.PM_UnitsUnLoaded,0))

cast(hash_tbl_CM.MetricsDate as date) as MetricsDate ,
convert(numeric(18,2),isnull(tbl_CM.EM_HeadCount,0)) as EM_HeadCount,
convert(numeric(18,2),isnull(tbl_CM.EM_HoursWorked,0)) as EM_HoursWorked,
convert(numeric(18,2),isnull(tbl_CM.OM_GallonsOH_50_499,0)) as OM_GallonsOH_50_499,
convert(numeric(18,2),isnull(tbl_CM.OM_NDGallonsOH,0)) as OM_NDGallonsOH,
convert(numeric(18,2),isnull(tbl_CM.OM_GallonsOH_2_49,0)) as OM_GallonsOH_2_49,
convert(numeric(18,2),isnull(tbl_CM.OM_GallonsDechlored,0))as  OM_GallonsDechlored,
convert(numeric(18,2),isnull(tbl_CM.PM_PitLoads,0)) as  PM_PitLoads,
convert(numeric(18,2),isnull(tbl_CM.PM_PoundsGranulatedOH,0)) as PM_PoundsGranulatedOH,
convert(numeric(18,2),isnull(tbl_CM.PM_UnitsUnLoaded,0)) as PM_UnitsUnLoaded
  from CapacityMetrics tbl_CM
right outer JOIN @CapacityMetricsData hash_tbl_CM on cast(tbl_CM.MetricsDate as date)=cast(hash_tbl_CM.MetricsDate as date) 
and tbl_CM.Location=hash_tbl_CM.Location

order by hash_tbl_CM.MetricsDate
end
print '@DailyMetricsCount'
print @DailyMetricsCount		
END

--select cast('12/04/2019' as date)