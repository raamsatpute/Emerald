CREATE TABLE [dbo].[JobTitle]
(
	[Id] UNIQUEIDENTIFIER NOT NULL  DEFAULT (newid()), 
    [Name] VARCHAR(25) NOT NULL, 
    [LastUpdatedBy] VARCHAR(50) NOT NULL, 
    [LastUpdatedOn] DATETIME NOT NULL,
	 CONSTRAINT [PK_JobTitle] PRIMARY KEY CLUSTERED ([Id] ASC)
)

GO

CREATE UNIQUE INDEX [IX_JobTitle] ON [dbo].[JobTitle] ([Name] ASC);
