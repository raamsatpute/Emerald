

CREATE PROCEDURE [dbo].[ApplicationEmailCounts]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT       dbo.Applications.ApplicationName as [Application Name], COUNT(*) AS [Email Count]
FROM            dbo.EmailLog INNER JOIN
                         dbo.Applications ON dbo.EmailLog.ApplicationId = dbo.Applications.ApplicationId
GROUP BY dbo.Applications.ApplicationName
END

