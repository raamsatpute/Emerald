CREATE TABLE [dbo].[SampleBatches] (
    [BatchId]            INT          IDENTITY (1, 1) NOT NULL,
    [BatchName]          VARCHAR (50) NULL,
    [SentToLab]          INT          NULL,
    [DateStamp]          DATETIME     CONSTRAINT [DF_SampleBatches_DateStamp] DEFAULT (getdate()) NULL,
    [InventoryLocation]  INT          NULL,
    [BatchComplete]      BIT          CONSTRAINT [DF_SampleBatches_BatchComplete] DEFAULT ((0)) NULL,
    [ProcessingDate]     DATETIME     NULL,
    [ReportNumber]       VARCHAR (50) NULL,
    [ShippingNumber]     VARCHAR (75) NULL,
    [ReceivedDate]       DATETIME     NULL,
    [ProcessingComplete] DATETIME     NULL,
    [CustomerNumber]     INT          NULL,
    [CustomerLoad]       VARCHAR (50) NULL,
    CONSTRAINT [PK_SampleBatches] PRIMARY KEY CLUSTERED ([BatchId] ASC)
);

