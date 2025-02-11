/****** Object:  StoredProcedure [dbo].[spCommodity]    Script Date: 6/18/2020 11:39:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kalyani Shelar
-- Create date: 11-Dec-2019
-- Description:	This SP Fetches Metal and Oil commodity summary
-- =============================================
--exec spCommodity 2019,11,'Plant,Field D','','Summary' --For Summary
--exec spCommodity 2019,10,'Plant','Mississippi','Detail' --For detail with Location and chosen Plant
--exec spCommodity 2019,10,'','Mississippi','Detail' --For detail with Location and all Plant
--exec spCommodity 2019,10,'Field D','','Detail' --For detail with all Locations and chosen Plant
--exec spCommodity 2019,10,'','','Detail' --For detail with all Locations and all Plant
--exec spCommodity 2019,10,'','','Detail' --For detail with all Locations and all Plant

alter PROCEDURE [dbo].[spCommodity]
	@YEAR as int,
	@MONTH as int,
	@PlantCode as varchar(max),
	@LocationName as varchar(100),
	@Key as varchar(15)
AS
BEGIN
		Declare @LocationId as int

		select @LocationId=ID from Locations where (active=1 or id in (14,15)) and Description=@LocationName
		Print @LocationId

		if @PlantCode = '' 
			set @PlantCode = null

		if @LocationName = '' 
			set @LocationName = null


	Begin
		exec spMetalCommodity @YEAR,@MONTH,@PlantCode,@LocationName,@Key	
		exec spOilCommodity   @YEAR,@MONTH,@PlantCode,@LocationName,@Key	
			
	End
END



GO


