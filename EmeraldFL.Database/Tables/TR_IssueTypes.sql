CREATE TABLE [dbo].[TR_IssueTypes] (
    [TechIssueTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [IssueType]       VARCHAR (50) NULL,
    [IssueCategory]   VARCHAR (10) NULL,
    [Status]          BIT          CONSTRAINT [DF_TR_IssueTypes_Status] DEFAULT ((1)) NULL,
    [LocationID]      INT          NULL,
    CONSTRAINT [PK_TechIssueTypes] PRIMARY KEY CLUSTERED ([TechIssueTypeID] ASC)
);

