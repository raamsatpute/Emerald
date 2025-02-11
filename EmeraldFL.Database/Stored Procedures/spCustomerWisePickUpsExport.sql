GO
/****** Object:  StoredProcedure [dbo].[spCustomerWisePickUpsExport]    Script Date: 6/17/2020 11:03:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 09-Aug-2019
-- Description:	This SP Fetch total Pick Ups done for each customer for the Specified Pickup Period (TransDate)
--				PickUp periods are the range between SELECTed MONTH/YEAR to Previous 3 MONTHs
--Modified on 27-Nov-19 to incorporate Export query for Department wise
-- =============================================
--exec spCustomerWisePickUpsExport 1,5, 2019,'Tallahassee/ City of','','Customer',''
--exec spCustomerWisePickUpsExport 1,8, 2019,'Alabama Power Company','','Customer','grandtotal'
--exec spCustomerWisePickUpsExport 1,9, 2019,'Alabama Power Company','','Customer',''
--exec spCustomerWisePickUpsExport 1,8, 2019,'Sumter Electric Coop Inc','','Customer',''

--exec spCustomerWisePickUpsExport 1,10, 2018,null,'Florida','Department','' --Monthly Detail with Location
--exec spCustomerWisePickUpsExport null,10, 2018,null,'Florida','Department',''--Monthly Detail for all Location
--exec spCustomerWisePickUpsExport 1,10, 2019,null,'Florida','Department','GrandTotal' --Yearly Detail with Location
--exec spCustomerWisePickUpsExport null,10, 2019,null,'Florida','Department','GrandTotal' --Yearly Detail for all Location
--exec spCustomerWisePickUpsExport null,10, 2019,null,'Florida','Department','GrandTotal' --Yearly Detail for all Location
--exec spCustomerWisePickUpsExport null,10, 2019,null,'Florida','Department','GrandTotal' --Yearly Detail for all Location
--exec spCustomerWisePickUpsExport null,10, 2019,null,'Florida','Department','GrandTotal' --Yearly Detail for all Location

alter PROCEDURE [dbo].[spCustomerWisePickUpsExport]
	@LocationId as int,
	@MONTH as int,
	@YEAR as int,
	@CustomerName as varchar(250),
	@LocationName as varchar(100),
	@Key as varchar(15), -- To identify Export query for Customer or Department
	@KeyGrandTotal as varchar(15) -- To identify export query for Monthly or Yearly
AS
BEGIN
	Declare @PickUpDateFROM as date
	Declare @PickUpDateTo as date
	Declare @Cols as nvarchar(max)
	Declare @TotCols as nvarchar(max)
	Declare @Query as nvarchar(max)

	Declare @Query1 as nvarchar(max)

	set @PickUpDateTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))

	if @LocationId = '' 
		set @LocationId = null

	If @Month = '' 
		set @Month = null

	If @Key = 'Customer'
		Begin
		if @KeyGrandTotal='GrandTotal'
		begin
			set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
			set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0))
		end
		else
		begin
			set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
			set @PickUpDateFROM =(SELECT DATEFROMPARTS(@YEAR, @MONTH, 1)) 
		end

		Select FORMAT(a,'MMM') + '_' + CAST(YEAR(a) as varchar) as PuPeriod into #dtPickUp From
		(
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0)) as a
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 2, 0)) as b
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 1, 0)) as c
		Union
		Select (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 0, 0)) as d
		)a

		SELECT	
			l.[Description] as Location, 
			DeptDescr as N'Department Description', 
			JobTypeDescription as N'Job Type Description',
			JobType as N'Job Type ID',
			CONVERT(VARCHAR(10),u.TransDate, 101)  as N'Transaction Date',
			CONVERT(VARCHAR(10),u.CheckInDate, 101)  as N'Check In Date',
			CONVERT(VARCHAR(10),u.ProcessDate, 101)  as N'Process Date',
			CONVERT(VARCHAR(10),u.CarcassManifestDate, 101)  as N'Carcass Manifest Date',
			CONVERT(VARCHAR(10),u.ShipDate, 101)  as N'Ship Date',
			'' as 'MFGR',
			Metal,
			KVA,	
			AMPS,	
			LBS,
			TransId as N'Job Transaction Id',
			CustName as N'Customer Name'
		FROM  trav_EO_SrJobs u
		Inner Join TraverseDepartments t on ltrim(rtrim(u.[DeptCode])) = ltrim(rtrim(t.[DeptCode]))
		INNER JOIN Cust c on c.CUSTOMER_NBR = u.[CustId] and c.Location = @LocationId 
		INNER Join Locations l on l.id = u.LocationId and l.[Status] = 'A'
		WHERE u.LocationId = @LocationId  And
		[TransDate] between @PickUpDateFROM and @PickUpDateTo
		and ((c.cust_name =isnull(REPLACE(@CustomerName, '@', ','),'') and @CustomerName <> '')or(@CustomerName ='')) and
		u.[DeptCode] not in ('FD Service','FG Boxes') and 
		[JobType] in ('PL1P', 'PD1P', 'PD3P', 'SB1P', 'SB3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P','NT1P', 'NT3P', 'PL3P')
		ORDER BY YEAR([TransDate]) ASC, MONTH([TransDate]) ASC
	End
	Else If @Key = 'Department'
		Begin
		select @LocationId=ID from Locations where (active=1) and Description=@LocationName
		if @KeyGrandTotal='GrandTotal'
		begin
			set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
			set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 11, 0))
		end
		else
		begin
			set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
			set @PickUpDateFROM =(SELECT DATEFROMPARTS(@YEAR, @MONTH, 1)) 
		end

		SELECT	
			l.[Description] as Location, 
			DeptDescr as N'Department Description', 
			JobTypeDescription as N'Job Type Description',
			JobType as N'Job Type ID',
			CONVERT(VARCHAR(10),u.TransDate, 101)  as N'Transaction Date',
			CONVERT(VARCHAR(10),u.CheckInDate, 101)  as N'Check In Date',
			CONVERT(VARCHAR(10),u.ProcessDate, 101)  as N'Process Date',
			CONVERT(VARCHAR(10),u.CarcassManifestDate, 101)  as N'Carcass Manifest Date',
			CONVERT(VARCHAR(10),u.ShipDate, 101)  as N'Ship Date',
			'' as 'MFGR',
			Metal,
			KVA,	
			AMPS,	
			LBS,
			TransId as N'Job Transaction Id',
			CustName as N'Customer Name'
		FROM  trav_EO_SrJobs u
		Inner Join TraverseDepartments t on ltrim(rtrim(u.[DeptCode])) = ltrim(rtrim(t.[DeptCode]))
		INNER Join Cust c on c.CUSTOMER_NBR = u.[CustId] and c.Location = u.LocationId
		INNER Join Locations l on l.id = u.LocationId and l.[Status] = 'A'
		WHERE 
		Case WHEN @LocationId IS NULL THEN 1 WHEN LocationId = @LocationId THEN 1 ELSE 0 END = 1 and
		[TransDate] between @PickUpDateFROM and @PickUpDateTo and
		u.[DeptCode] not in ('FD Service','FG Boxes') and 
		[JobType] in ('PL1P', 'PD1P', 'PD3P', 'SB1P', 'SB3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'NT1P', 'NT3P', 'PL3P')
		ORDER BY YEAR([TransDate]) ASC, MONTH([TransDate]) ASC
	End
END

