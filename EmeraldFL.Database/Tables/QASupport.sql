CREATE TABLE [dbo].[QASupport] (
    [QASupportId]      INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QASupport_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QASupport_DateStamp] DEFAULT (getdate()) NULL,
    [uShopDate]        DATETIME     NULL,
    [uOvenDate]        DATETIME     NULL,
    [uWeldDate]        DATETIME     NULL,
    [uPowderCoat]      DATETIME     NULL,
    CONSTRAINT [PK_QASupport] PRIMARY KEY CLUSTERED ([QASupportId] ASC)
);

