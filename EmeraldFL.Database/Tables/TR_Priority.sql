CREATE TABLE [dbo].[TR_Priority] (
    [PriorityId]  INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (25) NULL,
    [SortOrder]   INT          NULL,
    [Status]      BIT          NULL,
    [LocationId]  INT          NULL,
    CONSTRAINT [PK_TR_Priority] PRIMARY KEY CLUSTERED ([PriorityId] ASC)
);

