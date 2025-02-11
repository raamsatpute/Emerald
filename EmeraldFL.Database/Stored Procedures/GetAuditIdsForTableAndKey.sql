-- =============================================
-- Author:		Obie Hardin
-- Create date: 9/19/2017
-- Description:	Get the list of AuditEntry IDs for an 
-- Audit Entry
-- =============================================
CREATE PROCEDURE  [dbo].[GetAuditIdsForTableAndKey]
	@Table varchar(255),
	@Key varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT 
			[audit].AuditEntryID 
		FROM 
			[AuditEntries] [audit] inner join 
			[AuditEntryProperties] [prop] 
		ON 
			[audit].[AuditEntryID] = [prop].[AuditEntryID]
		WHERE
			[audit].[EntityTypeName] = @Table AND 
			[prop].PropertyName = 'Id' AND
			[prop].OldValue = [prop].NewValue AND
			[prop].OldValue = @Key
END

