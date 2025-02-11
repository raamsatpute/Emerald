CREATE TABLE [dbo].[NonPCBOilTanks] (
    [OilTankId]      INT          IDENTITY (1, 1) NOT NULL,
    [Description]    VARCHAR (50) NULL,
    [Capacity]       INT          CONSTRAINT [[dbo]].[NonPCBOilTanks]]CapacityDefault] DEFAULT ((0)) NULL,
    [InUse]          BIT          CONSTRAINT [[dbo]].[NonPCBOilTanks]]InUseDefault] DEFAULT ((0)) NULL,
    [PermanentAsset] BIT          CONSTRAINT [[dbo]].[NonPCBOilTanks]]PermanentAssetDefault] DEFAULT ((0)) NULL,
    [ContinuationId] INT          NULL,
    CONSTRAINT [PK_NonPCBOilTanks] PRIMARY KEY CLUSTERED ([OilTankId] ASC)
);

