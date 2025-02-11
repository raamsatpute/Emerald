CREATE TABLE [dbo].[UnitLocationLog] (
    [UnitLocationLogId] INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]           VARCHAR (50) NULL,
    [UnitLocationId]    INT          NULL,
    [ScannedBy]         INT          NULL,
    [DateStamp]         DATETIME     NULL,
    CONSTRAINT [PK_UnitLocationLog] PRIMARY KEY CLUSTERED ([UnitLocationLogId] ASC)
);

