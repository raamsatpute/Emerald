CREATE TABLE [dbo].[OilRecords] (
    [OilRecordId] INT        IDENTITY (1, 1) NOT NULL,
    [Date]        DATE       NULL,
    [NewOilOH]    FLOAT (53) CONSTRAINT [DF_OilRecords_NewOilOH] DEFAULT ((0)) NULL,
    [RegenOilOH]  FLOAT (53) CONSTRAINT [DF_OilRecords_RegenOilOH] DEFAULT ((0)) NULL,
    [DieselOH]    FLOAT (53) CONSTRAINT [DF_OilRecords_DieselOH] DEFAULT ((0)) NULL,
    [NewOilOut]   FLOAT (53) CONSTRAINT [DF_OilRecords_NewOilOut] DEFAULT ((0)) NULL,
    [RegenOilOut] FLOAT (53) CONSTRAINT [DF_OilRecords_RegenOilOut] DEFAULT ((0)) NULL,
    [SpaceTankT]  FLOAT (53) CONSTRAINT [DF_OilRecords_SpaceTankT] DEFAULT ((0)) NULL,
    [SpaceTankG]  FLOAT (53) CONSTRAINT [DF_OilRecords_SpaceTankG] DEFAULT ((0)) NULL,
    [SpaceTankC]  FLOAT (53) CONSTRAINT [DF_OilRecords_SpaceTaankC] DEFAULT ((0)) NULL,
    [SpaceTankB]  FLOAT (53) CONSTRAINT [[dbo]].[OilRecords]]SpaceTankBDefault] DEFAULT ((0)) NULL,
    [uLocation]   INT        NULL,
    CONSTRAINT [PK_OilRecords] PRIMARY KEY CLUSTERED ([OilRecordId] ASC)
);

