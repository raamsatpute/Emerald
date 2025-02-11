CREATE TABLE [dbo].[MetricMS] (
    [MetricMSId]      INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]         VARCHAR (20) NULL,
    [Received Date]   DATETIME     NULL,
    [MetricMSSumId]   INT          NULL,
    [StraightRepair]  BIT          CONSTRAINT [DF_MetricMS_StraightRepair] DEFAULT ((0)) NULL,
    [TestNoPaint]     BIT          CONSTRAINT [DF_MetricMS_TestNoPaint] DEFAULT ((0)) NULL,
    [MPCO]            BIT          NULL,
    [SoldFromStock]   BIT          CONSTRAINT [DF_MetricMS_SoldFromStock] DEFAULT ((0)) NULL,
    [TestPaintNoShip] BIT          CONSTRAINT [DF_MetricMS_TestPaintNoShip] DEFAULT ((0)) NULL,
    [EstCustomer]     BIT          CONSTRAINT [DF_MetricMS_EstCustomer] DEFAULT ((0)) NULL,
    [EstFTI]          BIT          CONSTRAINT [DF_MetricMS_EstFTI] DEFAULT ((0)) NULL,
    [Unitsin02]       BIT          CONSTRAINT [DF_MetricMS_Unitsin02] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_MetricMS] PRIMARY KEY CLUSTERED ([MetricMSId] ASC)
);

