CREATE TABLE [dbo].[MR_Priority] (
    [PriorityId]  INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (25) NULL,
    [SortOrder]   INT          NULL,
    [Status]      BIT          CONSTRAINT [DF_MR_Priority_Active] DEFAULT ((1)) NULL,
    [LocationId]  INT          NULL,
    CONSTRAINT [PK_MR_Priority] PRIMARY KEY CLUSTERED ([PriorityId] ASC)
);

