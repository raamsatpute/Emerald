CREATE TABLE [dbo].[PushLogFlags] (
    [PushLogFlagId] INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]       VARCHAR (10) NULL,
    [ScannedBy]     INT          NULL,
    [DateStamp]     DATETIME     CONSTRAINT [DF_PushLogFlags_DateStamp] DEFAULT (getdate()) NULL,
    [ClearedDate]   DATETIME     NULL,
    [ClearedBy]     INT          NULL,
    [PPMInOil]      VARCHAR (15) NULL,
    [PPMInWipe]     VARCHAR (15) NULL,
    CONSTRAINT [PK_PushLogFlags] PRIMARY KEY CLUSTERED ([PushLogFlagId] ASC)
);

