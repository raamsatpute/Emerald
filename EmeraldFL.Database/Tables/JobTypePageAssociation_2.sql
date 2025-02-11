CREATE TABLE [dbo].[JobTypePageAssociation] (
    [JobTypeId]     INT           IDENTITY (1, 1) NOT NULL,
    [JobType]       NVARCHAR (10) NULL,
    [PageID]        INT           NULL,
    [LastUpdated]   DATETIME      NULL,
    [LastUpdatedBy] INT           NULL,
    [DateStamp]     DATETIME      NULL,
    CONSTRAINT [PK_JobTypePageAssociation] PRIMARY KEY CLUSTERED ([JobTypeId] ASC)
);

