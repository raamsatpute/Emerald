CREATE TABLE [dbo].[SFSBarcodes] (
    [SFSUnitId] INT IDENTITY (1, 1) NOT NULL,
    [Barcode]   INT NULL,
    CONSTRAINT [PK_SFSBarcodes] PRIMARY KEY CLUSTERED ([SFSUnitId] ASC)
);

