CREATE TABLE [dbo].[QARecloser] (
    [QARecloserId]     INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QARecloser_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QARecloser_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_QARecloser] PRIMARY KEY CLUSTERED ([QARecloserId] ASC)
);

