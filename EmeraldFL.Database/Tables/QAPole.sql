CREATE TABLE [dbo].[QAPole] (
    [QAPoleId]         INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QAPole_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QAPole_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_QAPole] PRIMARY KEY CLUSTERED ([QAPoleId] ASC)
);

