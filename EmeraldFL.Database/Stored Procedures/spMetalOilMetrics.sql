/****** Object:  StoredProcedure [dbo].[spMetalOilMetrics]    Script Date: 6/18/2020 11:56:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 23-Oct-2019
-- Description:	This SP Fetch all Metal and Oil related tables as per the value passsed for @MetricsType
-- =============================================
--exec spMetalOilMetrics '1',2019,12,'','','Summary','Metal',''
--exec spMetalOilMetrics '1,13',2019,10,'','','Summary','Oil',''
--exec spMetalOilMetrics '1,13',2019,10,'','','Summary','Oil',''
ALTER PROCEDURE [dbo].[spMetalOilMetrics]
	@LocationId as varchar(8000),
	@YEAR as int,
	@MONTH as int,
	@PlantCode as varchar(Max),
	@PartCode as varchar(Max),
	@Key as varchar(15),
	@MetricsType as varchar(15),
	@Filter as varchar(500)
AS
BEGIN
	If @MetricsType = 'Metal'
	Begin
		exec spMetalMetrics @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key
		exec spMetalMetrics_ByType @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key
		exec spMetalMetrics_ByLocation @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key,@Filter
	End
	Else If @MetricsType = 'Oil'
	Begin
		exec spOilMetrics @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key
		exec spOilMetrics_ByType @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key
		exec spOilMetrics_ByLocation @LocationId,@YEAR,@MONTH,@PlantCode,@PartCode,@Key,@Filter
	End
END

