



CREATE PROCEDURE [dbo].[ApplicationEmailCountsByUser]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT        dbo.Users.FIRSTNAME as [First Name], dbo.Users.LASTNAME as [Last Name], COUNT(*) AS [Email Count]
FROM            dbo.EmailLog LEFT OUTER JOIN
                         dbo.Users ON dbo.EmailLog.TriggeredByUID = dbo.Users.ID
GROUP BY dbo.Users.FIRSTNAME, dbo.Users.LASTNAME
END



