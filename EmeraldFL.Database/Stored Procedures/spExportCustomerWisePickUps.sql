/****** Object:  StoredProcedure [dbo].[spExportCustomerWisePickUps]    Script Date: 08/14/19 10:15:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 16-Jul-2019
-- Description:	This SP is used to fetch Pickup data to show in Excel file on basis of Customer Name,Month,Year of Check in date
-- =============================================
--exec spExportCustomerWisePickUps 1,'Alabama Power Company', 4, 2019
--exec spExportCustomerWisePickUps 1,'Alabama Power Company', 4, 2019

ALTER PROCEDURE [dbo].[spExportCustomerWisePickUps]
	@LocationId as int,
	@CustomerName as varchar(250),
	@MONTH as int,
	@YEAR as int
AS
BEGIN


SELECT	[Customer_Name]=c.CUST_NAME,
[Dept_Description]=[Dept Code],
[Job_Type_Description]=JobTypeDescr,
[Check_In_Date]=CONVERT(VARCHAR(10), [CHECK IN DATE], 101),
[Process_Date]=CONVERT(VARCHAR(10), [Decom Date], 101),
[Job_Type_ID]=[Job Type],
isnull(COUNT([CHECK IN DATE]),0) as PickUps
		
FROM  UnitData u
INNER JOIN Cust c on c.CUSTOMER_NBR = u.[Customer Number] and c.Location = @LocationId 
WHERE u.Location = @LocationId  And u.UnitStatus = 1 and
month([CHECK IN DATE])=@MONTH and year ([CHECK IN DATE])=@YEAR and cust_name=REPLACE(@CustomerName, '/', ',')
GROUP BY [CHECK IN DATE], c.CUST_NAME,[Job Type],[Decom Date],JobTypeDescr,[Dept Code]
ORDER BY YEAR([CHECK IN DATE]) ASC, MONTH([CHECK IN DATE]) ASC


END

