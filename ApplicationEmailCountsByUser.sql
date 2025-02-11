
/*
	Modified this SP so as to fetch data as per Location. This changes is done related to Code Synchronization 
*/
ALTER PROCEDURE [dbo].[ApplicationEmailCountsByUser]
@LocationId as numeric(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT dbo.Users.FIRSTNAME as [First Name], dbo.Users.LASTNAME as [Last Name], COUNT(*) AS [Email Count]
FROM    dbo.EmailLog 
LEFT OUTER JOIN dbo.Users ON dbo.EmailLog.TriggeredByUID = dbo.Users.ID 
LEFT OUTER JOIN dbo.UserMapping um on um.IDUser = dbo.EmailLog.TriggeredByUID and dbo.EmailLog.Location = um.Location and um.Loc_Status in ('A','D')
Where dbo.EmailLog.Location = @LocationId 
GROUP BY dbo.Users.FIRSTNAME, dbo.Users.LASTNAME
END





