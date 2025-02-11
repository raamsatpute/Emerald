/*
	Modified this SP so as to fetch data as per Location. This changes is done related to Code Synchronization 
*/
--exec ApplicationEmailCounts 11
ALTER PROCEDURE [dbo].[ApplicationEmailCounts]
@LocationId as numeric(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT       dbo.Applications.ApplicationName as [Application Name], COUNT(*) AS [Email Count]
FROM            dbo.EmailLog INNER JOIN
                         dbo.Applications ON dbo.EmailLog.ApplicationId = dbo.Applications.ApplicationId And dbo.EmailLog.Location = dbo.Applications.Location
						 Where dbo.EmailLog.Location = @LocationId 
GROUP BY dbo.Applications.ApplicationName
END



