CREATE TABLE [dbo].[PCBOilTanks] (
    [OilTankId]      INT          IDENTITY (1, 1) NOT NULL,
    [Description]    VARCHAR (50) NULL,
    [Capacity]       INT          CONSTRAINT [[dbo]].[PCBOilTanks]]CapacityDefault] DEFAULT ((0)) NULL,
    [InUse]          BIT          CONSTRAINT [[dbo]].[PCBOilTanks]]InUseDefault] DEFAULT ((0)) NULL,
    [PermanentAsset] BIT          CONSTRAINT [[dbo]].[PCBOilTanks]]PermanentAssetDefault] DEFAULT ((0)) NULL,
    [ContinuationId] INT          NULL,
    CONSTRAINT [PK_PCBOilTanks] PRIMARY KEY CLUSTERED ([OilTankId] ASC)
);

