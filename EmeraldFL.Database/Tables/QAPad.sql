CREATE TABLE [dbo].[QAPad] (
    [QAPadId]          INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QAPad_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QAPad_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_QAPad] PRIMARY KEY CLUSTERED ([QAPadId] ASC)
);

