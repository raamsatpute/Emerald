-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 15-Jun-2019
-- Description:	This SP Fetch total Pick Ups done for each customer for the Specified Pickup Period (Check In date)
--				PickUp periods are the range between SELECTed MONTH/YEAR to Previous 3 MONTHs
-- =============================================
--exec spCustomerWisePickUps_backup 1, 2, 2019
ALTER PROCEDURE [dbo].[spCustomerWisePickUps_backup]
	@LocationId as int,
	@MONTH as int,
	@YEAR as int
AS
BEGIN

Declare @PickUpDateFROM as date
Declare @PickUpDateTo as date
Declare @Cols as nvarchar(max)
Declare @Query as nvarchar(max)

set @PickUpDateTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0))

SELECT	c.CUST_NAME,  
		MONTH([RECEIVED DATE]) as CheckInDateM, YEAR([RECEIVED DATE]) as CheckInDateY,
		FORMAT([RECEIVED DATE],'MMM') + ' - ' + CAST(YEAR([RECEIVED DATE]) as varchar) as [PickUpPeriod], 
		COUNT([RECEIVED DATE]) as PickUps into #UnitData 
FROM  UnitData u
INNER JOIN Cust c on c.CUSTOMER_NBR = u.[Customer Number] and c.Location = @LocationId
WHERE u.Location = @LocationId and
[RECEIVED DATE] between @PickUpDateFROM and @PickUpDateTo
GROUP BY YEAR([RECEIVED DATE]), MONTH([RECEIVED DATE]) , FORMAT([RECEIVED DATE],'MMM'), c.CUST_NAME
ORDER BY YEAR([RECEIVED DATE]) ASC, MONTH([RECEIVED DATE]) ASC

SELECT DISTINCT PickUpPeriod, CheckInDateY, CheckInDateM into #tmpDisCol FROM  #unitdata ORDER BY CheckInDateY, CheckInDateM

SELECT @cols = STUFF((SELECT ',' + QUOTENAME(PickUpPeriod) 
                        FROM #tmpDisCol ORDER BY CheckInDateY, CheckInDateM 
                FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)') 
            ,1,1,'')

SELECT @query = 
'SELECT * FROM
(
	SELECT     
		Cust_Name,		PickUpPeriod,		PickUps
	FROM #UnitData
)X
PIVOT 
(
    sum(PickUps)
    FOR [PickUpPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query
	
END

