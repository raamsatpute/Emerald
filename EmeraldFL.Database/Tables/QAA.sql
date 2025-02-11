CREATE TABLE [dbo].[QAA] (
    [QAAId]           INT          IDENTITY (1, 1) NOT NULL,
    [QAId]            INT          NULL,
    [Barcode]         VARCHAR (20) NULL,
    [FlagCleared]     BIT          CONSTRAINT [DF_QAA_FlagCleared] DEFAULT ((0)) NULL,
    [Flagged]         BIT          CONSTRAINT [DF_QAA_Flagged_1] DEFAULT ((0)) NULL,
    [FlaggedBy]       INT          NULL,
    [ClearedBy]       INT          NULL,
    [FlaggedDate]     DATETIME     NULL,
    [ClearedDate]     DATETIME     NULL,
    [Job Type]        VARCHAR (5)  NULL,
    [KVA]             VARCHAR (10) NULL,
    [QAArea]          VARCHAR (15) NULL,
    [Location]        INT          NULL,
    [datestamp]       DATETIME     CONSTRAINT [DF_QAA_datestamp] DEFAULT (getdate()) NULL,
    [ResponsibleTech] INT          NULL,
    CONSTRAINT [PK_QAA] PRIMARY KEY CLUSTERED ([QAAId] ASC)
);

