
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[BackLogJobTypeBarChartData]
	-- Add the parameters for the stored procedure here
	@JobType varchar(50)
AS
BEGIN
	
	
select Locations.Description,isnull(Backlog.Count,0) from Locations 
left join 
(
SELECT        ISNULL(COUNT(DISTINCT dbo.UnitDataDetail.Barcode), 0) AS Count, location
FROM            dbo.UnitDataDetail 
WHERE        (dbo.UnitDataDetail.ServiceType = 'R') AND (dbo.UnitDataDetail.TransType = 'Approved') AND (dbo.UnitDataDetail.BatchCode = 'SRIPRO') AND (dbo.UnitDataDetail.[Dept Code] NOT LIKE '%Rewind%') AND 
                         (dbo.UnitDataDetail.UnitStatus = 1) AND (dbo.UnitDataDetail.[Is Warranty] <> 'Y') AND (dbo.UnitDataDetail.[Ship Date] IS NULL OR
                         dbo.UnitDataDetail.[Ship Date] = '') AND (dbo.UnitDataDetail.[TEST DATE] IS NULL OR
                         dbo.UnitDataDetail.[TEST DATE] = '') AND (dbo.UnitDataDetail.[Paint DATE] IS NULL OR
                         dbo.UnitDataDetail.[Paint DATE] = '') AND (dbo.UnitDataDetail.[Customer Number] NOT IN ('000352', '000028', '000190', '000047', '008888', '001041', '009999')) AND (dbo.UnitDataDetail.[Job Type] NOT IN ('MISC', 
                         '21', 'No Mapping Provided', 'PS', '22', '31')) AND (dbo.UnitDataDetail.[Job Type] = @JobType) AND (location IN (1, 13, 9, 10))
GROUP BY location
) as Backlog
on Locations.Id = Backlog.Location
where locations.ID IN (1, 13, 9, 10)


END

