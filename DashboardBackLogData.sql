-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DashboardBackLogData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

with FullBacklog as
(
	select ID,IsNull(UDT.Count,0) as FullBacklogCount from Locations
	Left outer join
	(
		select 
		Location,
		COUNT(DISTINCT  dbo.unitdatadetail.barcode) AS Count   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		--and (DaysOut >= 45) AND (DaysOut < 90)
		group by Location
	) UDT on Locations.ID = UDT.Location
	where ID in (1,13,9,10) --not in (2,3,4,5,6)
	),dashboarddata as
(
	select ID,Description as LocationName,'ftn' as DaysOut,IsNull(UDT.PercCount,0) as Backlog from Locations
	Left outer join
	(
		select 
		Location,
		(COUNT(DISTINCT  dbo.unitdatadetail.barcode)*100) / (select FullBacklogCount from FullBacklog where FullBacklog.ID = Location ) AS PercCount   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut >= 45) AND (DaysOut < 90)
		group by Location
	) UDT on Locations.ID = UDT.Location
	where ID in (1,13,9,10 )--not in (2,3,4,5,6)
	union all
	select ID,Description as LocationName,'gtn' as DaysOut,IsNull(UDT.PercCount,0) from Locations
	Left outer join
	(
		select 
		Location,
		(COUNT(DISTINCT  dbo.unitdatadetail.barcode)*100) / (select FullBacklogCount from FullBacklog where FullBacklog.ID = Location ) AS PercCount   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut > 90) --AND (DaysOut < 90)
		group by Location
	) UDT on Locations.ID = UDT.Location
	where ID in (1,13,9,10)--not in (2,3,4,5,6)
	union all
	select ID,Description as LocationName,'ltff' as DaysOut,IsNull(UDT.PercCount,0) from Locations
	Left outer join
	(
		select 
		Location,
		(COUNT(DISTINCT  dbo.unitdatadetail.barcode)*100) / (select FullBacklogCount from FullBacklog where FullBacklog.ID = Location ) AS PercCount   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in (select val from exclusions where location = 1 and [desc] = 'cust')--('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in (select val from exclusions where location = 1 and [desc] = 'job')--('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut < 45) --AND (DaysOut < 90)
		group by Location
	) UDT on Locations.ID = UDT.Location
	where ID in(1,13,9,10)--not in (2,3,4,5,6)
)   
select * from dashboarddata as s
PIVOT
(
 sum(Backlog)
 --For DaysOut in (ftn,gtn,ltff)
 For DaysOut in (gtn,ftn,ltff)
 --For DaysOut in (select distinct daysout in s)
) As Pvt4;


begin 

Declare @maxdate as date;
Declare @WeekStartdate as date;
Declare @WeekEndDate as date;


--Week start date
SELECT @WeekStartdate=DATEADD(DAY, 2 - DATEPART(WEEKDAY, GETDATE()-10), CAST(GETDATE()-10 AS DATE)) 
--Week end Date
Select @WeekEndDate=DATEADD(DAY, 8 - DATEPART(WEEKDAY, GETDATE()-10), CAST(GETDATE()-10 AS DATE)) 



select @maxdate = max(Logfordate) from  ShipLogSummary where Logfordate between @WeekStartdate and @WeekEndDate;

--select @WeekStartdate, @WeekEndDate,@maxdate;

WITH dashboardshippingdata as
(
	select Locations.ID,Locations.[Description] as LocationName,isnull(SDT.ThisWeek,'0 / 0')as 'ThisWeek',
	isnull(SDT.Monthly,'0 / 0')as 'Monthly',isnull(SDT.Yearly,'0 / 0') as 'Yearly' from Locations
	Left outer join
	(
	select 
		[Location],
		Convert(varchar(50),DeliveriesWeekly) + ' / '+ Convert(varchar(50), KVAWeekly) as 'ThisWeek',   
		Convert(varchar(50),DeliveriesMonthly) + ' / '+ Convert(varchar(50), KVAMonthly) as 'Monthly',
		Convert(varchar(50),DeliveriesYearly) + ' / '+ Convert(varchar(50), KVAYearly) as 'Yearly'   
		from ShipLogSummary where Logfordate = @maxdate
		
	)SDT on Locations.ID = SDT.Location
	where Locations.ID in (1,13,9,10) --not in (2,3,4,5,6)
)
select * from dashboardshippingdata

end


END
