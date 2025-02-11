-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DashboardbacklogDetails] 
	-- Add the parameters for the stored procedure here
	@locName varchar(50),
	@dataFilter varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

If @dataFilter ='gtn'
begin
	select 
		--top 100 
		Location as LocationName, Barcode,[Customer Number] as 'CustomerName',
		CONVERT(varchar, [Received Date], 101) as ReceivedDate,CONVERT(varchar, [Promise Date], 105) as PromiseDate,DaysOut,[Job Type] as JobType,KVA,AMPS
		--COUNT(DISTINCT  dbo.unitdatadetail.barcode) AS Count   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut > 90)-- AND (DaysOut < 90)
		And location in (select ID from Locations where [Description] = @locName and Active = 1)
end
Else if @dataFilter ='ftn'
begin
     select 
		--top 100 
		Location as LocationName, Barcode,[Customer Number] as 'CustomerName',
		CONVERT(varchar, [Received Date], 101) as ReceivedDate,CONVERT(varchar, [Promise Date], 105) as PromiseDate,DaysOut,[Job Type] as JobType,KVA,AMPS
		--COUNT(DISTINCT  dbo.unitdatadetail.barcode) AS Count   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut >= 45) AND (DaysOut < 90)
		And location in (select ID from Locations where [Description] = @locName and Active = 1)
end
Else if @dataFilter ='ltff'
begin
     select 
		--top 100 
		Location as LocationName, Barcode,[Customer Number] as 'CustomerName',
		CONVERT(varchar, [Received Date], 101) as ReceivedDate,CONVERT(varchar, [Promise Date], 105) as PromiseDate,DaysOut,[Job Type] as JobType,KVA,AMPS
		--COUNT(DISTINCT  dbo.unitdatadetail.barcode) AS Count   
		from UnitDataDetail
		where ServiceType = 'R' and TransType = 'Approved' and BatchCode = 'SRIPRO' and [Dept Code] not like '%Rewind%'   
		and unitstatus=1 and  [Is Warranty] <> 'Y' and ([Ship Date] is null or [Ship Date] = '') 
		and ([Test Date] is null  or [Test Date] = '') and ([Paint Date] is null  or [Paint Date] = '')  
		And  dbo.unitdatadetail.[customer number] Not in ('000352','000028','000190','000047','008888','001041','009999')  
		And dbo.unitdatadetail.[job type] Not in ('MISC','21','No Mapping Provided','PS','22','31')  
		And  dbo.unitdatadetail.[JOB type] 
		in ('CAP','CNPL','OS1P','OS3P','PD1P','PD3P','PL1P','RC1P','RC3P','RG1P','RG3P','SB3P')  
		and (DaysOut < 45)-- AND (DaysOut < 90)
		And location in (select ID from Locations where [Description] = @locName and Active = 1)
end

END
