-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetPoleChartData]
	-- Add the parameters for the stored procedure here
	@datefilter datetime, 
	@jobType varchar(20)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @WeekStart datetime;
declare @WeekEnd datetime;
--set @datefilter = '2019-04-12';

set @WeekStart = DATEADD(dd, -(DATEPART(dw, @datefilter)-1), @datefilter);
set @WeekEnd = DATEADD(dd, 7-(DATEPART(dw, @datefilter)), @datefilter); 

IF OBJECT_ID('tempdb..#PoleTotals') IS NOT NULL
    DROP TABLE #PoleTotals;

With CalenderDates as 
	(   
	--Get the list of dates between the range provided
	   SELECT 
			DATEADD(DAY,number,@WeekStart) [CalenderDate]--,
		FROM
			master..spt_values 
		WHERE
			type = 'P'
		AND
			DATEADD(DAY,number+0,@WeekStart) <= @WeekEnd
	),
	LocationDetails as
	(
		select CalenderDate,ID,[Description] from CalenderDates cross join Locations where ID in (1,13,9,10)
	),
	LocationDailyCount as 
	(
		select ShipDate,Location,count(JobType) as DailyCount from ShiplogdataTraverse 
		where --Location = 1 and 
		[ServiceType] = 'R' 
		AND JobType = @jobType -- Pole monthly
		and convert(datetime,convert(varchar(10),ShipDate,121)) between  convert(datetime,convert(varchar(10),@WeekStart,121)) and convert(datetime,convert(varchar(10),@WeekEnd,121))
		group by ShipDate,Location 
							--cast(convert(varchar(10),ShipDate,101) as datetime) = cast(convert(varchar(10),getdate()-20,101) as datetime)

	)
	select LocationDetails.CalenderDate,LocationDetails.ID,LocationDetails.Description,isnull(LocationDailyCount.DailyCount,0) as DailyCount
	into #PoleTotals
	from LocationDetails
	left join LocationDailyCount
	on LocationDetails.CalenderDate = LocationDailyCount.ShipDate and LocationDetails.ID = LocationDailyCount.Location

	--Chart datasource 1
	select * from #PoleTotals

	--Chart data source 2 
	select * from ShipLogSummary where convert(datetime,convert(varchar(10),LogForDate,121)) = convert(datetime,convert(varchar(10),@dateFilter,121))
	select CalenderDate,Sum(DailyCount) as DailyCount from #PoleTotals
	group by CalenderDate




END
