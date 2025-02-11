CREATE TABLE [dbo].[QAPaint] (
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QAPaint_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [QAPaintId]        INT          IDENTITY (1, 1) NOT NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QAPaint_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_QAPaint] PRIMARY KEY CLUSTERED ([QAPaintId] ASC)
);

