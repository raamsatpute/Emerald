CREATE TABLE [dbo].[ManEntryIDs] (
    [ManEntryId]     INT         IDENTITY (1, 1) NOT NULL,
    [LastRecord]     INT         NULL,
    [Prefix]         VARCHAR (5) NULL,
    [CustomerNumber] VARCHAR (6) NULL,
    CONSTRAINT [PK_ManEntryIDs] PRIMARY KEY CLUSTERED ([ManEntryId] ASC)
);

