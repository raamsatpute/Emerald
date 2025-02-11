CREATE TABLE [dbo].[UserHistory] (
    [PageRequestId] INT          IDENTITY (1, 1) NOT NULL,
    [UID]           INT          NULL,
    [Datestamp]     DATETIME     CONSTRAINT [DF_UserHistoy_Datestamp] DEFAULT (getdate()) NULL,
    [PageName]      VARCHAR (25) NULL,
    [SessionGUID]   VARCHAR (36) NULL,
    [ApplicationId] INT          NULL
);

