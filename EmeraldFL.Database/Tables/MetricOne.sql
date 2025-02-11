CREATE TABLE [dbo].[MetricOne] (
    [MetricOneId]     INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]         VARCHAR (20) NULL,
    [Received_Date]   DATETIME     NULL,
    [MetricOneSumId]  INT          NULL,
    [StraightRepair]  BIT          CONSTRAINT [DF_MetricOne_StraightRepair] DEFAULT ((0)) NULL,
    [TestNoPaint]     BIT          CONSTRAINT [DF_MetricOne_TestNoPaint] DEFAULT ((0)) NULL,
    [MPCO]            BIT          CONSTRAINT [DF_MetricOne_MPCO] DEFAULT ((0)) NULL,
    [SoldFromStock]   BIT          CONSTRAINT [DF_MetricOne_SoldFromStock] DEFAULT ((0)) NULL,
    [TestPaintNoShip] BIT          CONSTRAINT [DF_MetricOne_TestPaintNoShip] DEFAULT ((0)) NULL,
    [EstCustomer]     BIT          CONSTRAINT [DF_MetricOne_EstCustomer] DEFAULT ((0)) NULL,
    [EstFTI]          BIT          CONSTRAINT [DF_MetricOne_EstFTI] DEFAULT ((0)) NULL,
    [UnitsIn02]       BIT          CONSTRAINT [DF_MetricOne_UnitsIn02] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_MetricOne] PRIMARY KEY CLUSTERED ([MetricOneId] ASC)
);

