/****** Object:  StoredProcedure [dbo].[spPickUps]    Script Date: 6/17/2020 11:02:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 28-Jun-2019
-- Description:	This SP fetch Pickups Customer Wise and Location wise
-- =============================================
--exec spCustomerWisePickUps 1, 8, 2019
--exec spCustomerWisePickUps 13, 11, 2026
--exec spCustomerWisePickUps 13, 11, 2026


Alter PROCEDURE [dbo].[spPickUps]
	@LocationId as int,
	@MONTH as int,
	@YEAR as int
AS
BEGIN

--Below SP fetch Customer-wise result set, with no break ups 
exec spCustomerWisePickUps @LocationId, @Month, @Year

--Below SP fetch Location-wise result set with Department as breakup in 2nd result set
exec spLocationWisePickUps_Dept @LocationId, @Month, @Year
END

