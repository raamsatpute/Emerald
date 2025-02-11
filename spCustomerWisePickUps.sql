-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 15-Jun-2019
-- Description:	This SP Fetch total Pick Ups done for each customer for the Specified Pickup Period (Check In date)
--				PickUp periods are the range between SELECTed MONTH/YEAR to Previous 3 MONTHs
-- =============================================
--exec spCustomerWisePickUps 1, 6, 2019
--exec spCustomerWisePickUps 13, 6, 2019
ALTER PROCEDURE [dbo].[spCustomerWisePickUps]
	@LocationId as int,
	@MONTH as int,
	@YEAR as int
AS
BEGIN

Declare @PickUpDateFROM as date
Declare @PickUpDateTo as date
Declare @Cols as nvarchar(max)
Declare @TotCols as nvarchar(max)
Declare @Query as nvarchar(max)

Declare @Query1 as nvarchar(max)

set @PickUpDateTo = (SELECT DATEFROMPARTS(@YEAR, @MONTH, 1))
print @PickUpDateTo
set @PickUpDateTo =(SELECT DATEADD(dd,-1,dateadd(mm,DATEDIFF(mm,0,@PickUpDateTo)+1,0)))
set @PickUpDateFROM = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @PickUpDateTo) - 3, 0))

print @PickUpDateTo
print @PickUpDateFROM


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
		MONTH([CHECK IN DATE]) as CheckInDateM, YEAR([CHECK IN DATE]) as CheckInDateY,
		FORMAT([CHECK IN DATE],'MMM') + '_' + CAST(YEAR([CHECK IN DATE]) as varchar) as [PickUpPeriod], 
		isnull(COUNT([CHECK IN DATE]),0) as PickUps into #UnitData 
FROM  UnitData u
INNER JOIN Cust c on c.CUSTOMER_NBR = u.[Customer Number] and c.Location = @LocationId 
WHERE u.Location = @LocationId  And u.UnitStatus = 1 and
[CHECK IN DATE] between @PickUpDateFROM and @PickUpDateTo
GROUP BY YEAR([CHECK IN DATE]), MONTH([CHECK IN DATE]) , FORMAT([CHECK IN DATE],'MMM'), c.CUST_NAME
ORDER BY YEAR([CHECK IN DATE]) ASC, MONTH([CHECK IN DATE]) ASC

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

SELECT @query = 
'SELECT * into tmpPickUp  FROM
(
	SELECT     
		Cust_Name,	PickUpPeriod,		PickUps
	FROM #UnitData
)X
PIVOT 
(
    sum(PickUps)
    FOR [PickUpPeriod] in (' + @cols + ')
) P'

EXEC SP_EXECUTESQL @query

SELECT @query = 
'select * , ' + @Totcols + ' as Total from tmpPickUp order by ' + @Totcols + ' desc, Cust_Name asc'

EXEC SP_EXECUTESQL @query

IF Exists (Select * from Information_Schema.Tables Where Table_Name = N'tmpPickUp')
Begin
	Drop table tmpPickUp
End
END

