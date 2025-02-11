CREATE TABLE [dbo].JobTitle (
    [Id]             UNIQUEIDENTIFIER CONSTRAINT [DF_JT_Id] DEFAULT (newid()) NOT NULL,
    [Name]          VARCHAR (50) NOT NULL,
    [LastUpdatedBy] VARCHAR (50) NOT NULL,
    [LastUpdatedOn] DATETIME     NOT NULL,
    CONSTRAINT [PK_JobTitle] PRIMARY KEY CLUSTERED ([Id] ASC)
);
 
 