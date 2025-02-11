/****** Object:  StoredProcedure [dbo].[spCustomerWisePickUps]    Script Date: 6/17/2020 11:04:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 15-Jun-2019
-- Description:	This SP Fetch total Pick Ups done for each customer for the Specified Pickup Period (TransDate)
--				PickUp periods are the range between SELECTed MONTH/YEAR to Previous 3 MONTHs
-- =============================================
--exec spCustomerWisePickUps 1, 8, 2019
--exec spCustomerWisePickUps 13, 11, 2026
--exec spCustomerWisePickUps 13, 11, 2026
ALTER PROCEDURE [dbo].[spCustomerWisePickUps]k
	@LocationId as int,
	@MONTH as int,
	@YEAR as int
AS s
BEGIN

	Declare @PickUpDateFROM as date
	Declare @PickUpDateTo as date
	Declare @Cols as nvarchar(max)
	Declare @NullToZeroCol as nvarchar(max)
	Declare @TotCols as nvarchar(max)
	Declare @Query as nvarchar(max)

	Declare @Query1 as nvarchar(max)

	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUp')
	Begin
		Drop table tmpPickUp
	End
	set @PickUpDateTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
	set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
	set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0))

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

	SELECT	c.CUST_NAME,
			MONTH([TransDate]) as CheckInDateM, YEAR([TransDate]) as CheckInDateY,
			FORMAT([TransDate],'MMM') + '_' + CAST(YEAR([TransDate]) as varchar) as [PickUpPeriod], 
			isnull(COUNT([TransDate]),0) as PickUps into #UnitData 
	FROM  trav_EO_SrJobs u
	Inner Join TraverseDepartments t on ltrim(rtrim(u.[DeptCode])) = ltrim(rtrim(t.[DeptCode]))
	INNER JOIN Cust c on c.CUSTOMER_NBR = u.[CustId] and c.Location = @LocationId 
	WHERE u.Locationid = @LocationId  And --u.UnitStatus = 1 and
	[TransDate] between @PickUpDateFROM and @PickUpDateTo and
	u.[DeptCode] not in ('FD Service','FG Boxes') and 
	[JobType] in ('PL1P', 'PD1P', 'PD3P', 'SB1P', 'SB3P', 'RC1P', 'RC3P', 'RG1P', 'RG3P', 'NT1P', 'NT3P', 'PL3P')  
	GROUP BY YEAR([TransDate]), MONTH([TransDate]) , FORMAT([TransDate],'MMM'), c.CUST_NAME
	UNION ALL -- Dummmy row added so incase if no data exist atleast we can have data structure, 
		      --this will eliminate need to check Datatable within Dataset in Front end. 
	(
		SELECT 'TBD' as Cust_Name, @MONTH,@YEAR, FORMAT(@Pickupdateto,'MMM') + '_' + CAST(YEAR(@Pickupdateto) as varchar), 0
	)
	ORDER BY YEAR([TransDate]) ASC, MONTH([TransDate]) ASC

	SELECT DISTINCT PickUpPeriod, CheckInDateY, CheckInDateM into #tmpDisCol FROM  #unitdata ORDER BY CheckInDateY, CheckInDateM


	SELECT @cols = STUFF((SELECT ', ' + QUOTENAME(PUPeriod) 
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')



	SELECT @Totcols = STUFF((SELECT '+ isnull(' + QUOTENAME(PickUpPeriod) + ',0)'
							FROM #tmpDisCol ORDER BY CheckInDateY, CheckInDateM 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

	SELECT @NullToZeroCol =(
	  select char(10)+'  , ' + quotename(PUPeriod)
	  +' = '+ + 'isnull('     + quotename(PUPeriod) + ',0)'
							FROM #dtPickUp 
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
			
	SELECT @query = 
	'SELECT Cust_Name'+ @NullToZeroCol +' into tmpPickUp  FROM
	(
		SELECT     
			Cust_Name,	PickUpPeriod,PickUps
		FROM #UnitData
	)X
	PIVOT 
	(   
		 sum(PickUps)
		FOR [PickUpPeriod] in (' + @cols + ')
	) P'

	EXEC SP_EXECUTESQL @query

	Delete from tmpPickUp where Cust_Name = 'TBD' -- Row deleted as we now have data structure in place. 

	SELECT @query = 
	'select * , ' + @Totcols + ' as Total from tmpPickUp order by ' + @Totcols + ' desc, Cust_Name asc'

	EXEC SP_EXECUTESQL @query

	IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUp')
	Begin
		Drop table tmpPickUp
	End
END

