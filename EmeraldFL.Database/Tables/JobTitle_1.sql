CREATE TABLE [dbo].[JobTitle] (
    [Id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]          VARCHAR (25)     NOT NULL,
    [LastUpdatedBy] VARCHAR (50)     NOT NULL,
    [LastUpdatedOn] DATETIME         NOT NULL,
    CONSTRAINT [PK_JobTitle] PRIMARY KEY CLUSTERED ([Id] ASC)
);

