CREATE TABLE [dbo].[PushLog] (
    [PushLogID]            INT            IDENTITY (1, 1) NOT NULL,
    [Barcode]              VARCHAR (10)   NULL,
    [VerifiedBy]           INT            NULL,
    [DateStamp]            DATETIME       CONSTRAINT [DF_PushLog_DateStamp] DEFAULT (getdate()) NULL,
    [DecomStatus]          BIT            CONSTRAINT [DF_PushLog_DecomStatus] DEFAULT ((0)) NULL,
    [DecomStatusChanged]   DATETIME       NULL,
    [DecomStatusChangedBy] INT            NULL,
    [HasOil]               VARCHAR (3)    NULL,
    [NoOilPPM]             VARCHAR (15)   NULL,
    [FR3]                  VARCHAR (3)    NULL,
    [Job Type]             VARCHAR (15)   NULL,
    [Serial Number]        VARCHAR (50)   NULL,
    [Customer Number]      VARCHAR (10)   NULL,
    [MFGR]                 VARCHAR (50)   NULL,
    [Customer Name]        NVARCHAR (255) NULL,
    [KVA]                  VARCHAR (10)   NULL,
    [PPMOIL]               VARCHAR (15)   NULL,
    [PPMWipe]              VARCHAR (15)   NULL,
    CONSTRAINT [PK_PushLog] PRIMARY KEY CLUSTERED ([PushLogID] ASC)
);

