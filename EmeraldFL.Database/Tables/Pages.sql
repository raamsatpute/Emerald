CREATE TABLE [dbo].[Pages] (
    [PageID]   INT          IDENTITY (1, 1) NOT NULL,
    [PageName] VARCHAR (50) NULL,
    CONSTRAINT [PK_Pages] PRIMARY KEY CLUSTERED ([PageID] ASC)
);

