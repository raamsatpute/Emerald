CREATE TABLE [dbo].[AuditEntries] (
    [AuditEntryID] [int] NOT NULL IDENTITY,
    [EntitySetName] [nvarchar](255),
    [EntityTypeName] [nvarchar](255),
    [State] [int] NOT NULL,
    [StateName] [nvarchar](255),
    [CreatedBy] [nvarchar](255),
    [CreatedDate] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.AuditEntries] PRIMARY KEY ([AuditEntryID])
)

GO

CREATE TABLE [dbo].[AuditEntryProperties] (
    [AuditEntryPropertyID] [int] NOT NULL IDENTITY,
    [AuditEntryID] [int] NOT NULL,
    [RelationName] [nvarchar](255),
    [PropertyName] [nvarchar](255),
    [OldValue] [nvarchar](max),
    [NewValue] [nvarchar](max),
    CONSTRAINT [PK_dbo.AuditEntryProperties] PRIMARY KEY ([AuditEntryPropertyID])
)

GO

CREATE INDEX [IX_AuditEntryID] ON [dbo].[AuditEntryProperties]([AuditEntryID])

GO

ALTER TABLE [dbo].[AuditEntryProperties] 
ADD CONSTRAINT [FK_dbo.AuditEntryProperties_dbo.AuditEntries_AuditEntryID] 
FOREIGN KEY ([AuditEntryID])
REFERENCES [dbo].[AuditEntries] ([AuditEntryID])
ON DELETE CASCADE

GO

GO
Create view vw_DisplayAuditEntryProperties 
	AS 	SELECT [AuditEntryPropertyID] as Id, [AuditEntryID], [RelationName], [PropertyName], [OldValue], [NewValue]  FROM [dbo].[AuditEntryProperties]


GO
Create view vw_DisplayAuditEntries 
	AS SELECT a.[AuditEntryID] as ID,[EntitySetName],[EntityTypeName],[State],[StateName],[CreatedBy],[CreatedDate] FROM [AuditEntries] a 
	
	GO


ALTER TABLE INJURY
  ADD LastUpdatedBy VARCHAR(50)

ALTER TABLE INJURY
  ADD LastUpdatedOn DATETIME

  GO
/****** Object:  StoredProcedure [dbo].[GetAuditIdsForTableAndKey]    Script Date: 9/20/2017 5:37:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
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

GO
/****** Object:  StoredProcedure [dbo].[UpdateStaticInventory]    Script Date: 9/20/2017 5:37:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO