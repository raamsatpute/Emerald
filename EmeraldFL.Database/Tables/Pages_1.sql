CREATE TABLE [dbo].[Pages] (
    [PageID]       INT          IDENTITY (1, 1) NOT NULL,
    [PageName]     VARCHAR (50) NULL,
    [PageIsActive] BIT          CONSTRAINT [DF_Pages_PageIsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Pages] PRIMARY KEY CLUSTERED ([PageID] ASC)
);

