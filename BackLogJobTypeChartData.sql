-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[BackLogJobTypeChartData]
	-- Add the parameters for the stored procedure here
	@JobType varchar(50),
	@LocationId int
AS
BEGIN
	
	with chart as 
(
select 
		[Job Type],
		DaysOut
		--,Location
		--COUNT(DISTINCT  dbo.unitdatadetail.barcode) AS Count   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] = @JobType 
		--in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		--and (DaysOut = 7 Or DaysOut = 45 Or DaysOut = 90)
		--and (DaysOut = 45)
		And Location = @LocationId
		--group by Location
) , chartext as
(
select [Job Type],--Location,
(
case when DaysOut >= 0 and DaysOut <=7  Then '7 Day'  
when DaysOut > 7 and DaysOut <=45  Then '45 Day'  
when DaysOut > 45 and DaysOut <=90  Then '90 Day'  
Else '-1'
End
) as String
 from chart
 ) 
 select String,count([Job Type]) as Count --,Location
 --,[Job Type]
  from chartext 
  group by String--,Location--,[Job Type] 
  having String in ('7 Day','45 Day','90 Day')
  Order by CASE WHEN String = '7 Day' THEN '1'
              WHEN String = '45 Day' THEN '2'
              ELSE String END ASC

END
