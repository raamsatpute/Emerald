CREATE TABLE [dbo].[UnitData] (
    [UnitId]              INT           IDENTITY (1, 1) NOT NULL,
    [Job Type]            VARCHAR (15)  NULL,
    [Barcode]             VARCHAR (25)  NULL,
    [UID]                 INT           NULL,
    [KVA]                 VARCHAR (10)  NULL,
    [RECEIVED DATE]       DATE          NULL,
    [PRI_VOLT]            VARCHAR (20)  NULL,
    [SEC_VOLT]            VARCHAR (20)  NULL,
    [TEST DATE]           DATE          NULL,
    [Paint DATE]          DATE          NULL,
    [Serial Number]       VARCHAR (50)  NULL,
    [Customer Number]     VARCHAR (10)  NULL,
    [Location]            INT           NULL,
    [Type]                VARCHAR (15)  NULL,
    [Volts]               VARCHAR (10)  NULL,
    [AMPS]                VARCHAR (15)  NULL,
    [Promise Date]        DATE          NULL,
    [Ship Date]           DATE          NULL,
    [uShipDate]           DATE          NULL,
    [uPaintDate]          DATE          NULL,
    [uTestDate]           DATE          NULL,
    [EstApproved]         DATE          NULL,
    [Dept Code]           VARCHAR (5)   NULL,
    [Est First]           VARCHAR (5)   NULL,
    [MFGR]                VARCHAR (50)  NULL,
    [TAPS]                VARCHAR (5)   NULL,
    [WEIGHT1]             VARCHAR (15)  NULL,
    [W_PANEL_WITH]        VARCHAR (5)   NULL,
    [PANEL_SER]           VARCHAR (25)  NULL,
    [LOOP_RAD]            VARCHAR (15)  NULL,
    [IMP]                 VARCHAR (15)  NULL,
    [DESC]                VARCHAR (50)  NULL,
    [BUSH_CNT]            VARCHAR (15)  NULL,
    [J_OTIME_FLAG]        VARCHAR (5)   NULL,
    [DateStamp]           DATETIME      CONSTRAINT [DF_UnitData_DateStamp] DEFAULT (getdate()) NULL,
    [UnitStatus]          BIT           CONSTRAINT [DF_UnitData_UnitStatus] DEFAULT ((1)) NULL,
    [Decom Date]          DATETIME      NULL,
    [EstComplete]         DATETIME      NULL,
    [uDecomDate]          DATETIME      NULL,
    [J_CUST_PO_]          VARCHAR (25)  NULL,
    [ushopdate]           DATETIME      NULL,
    [uwelddate]           DATETIME      NULL,
    [uovendate]           DATETIME      NULL,
    [upowdercoat]         DATETIME      NULL,
    [J_JOB_TOTAL]         FLOAT (53)    NULL,
    [BUDGET_AMT]          FLOAT (53)    NULL,
    [J_PO_REL_NBR]        VARCHAR (50)  NULL,
    [Comment]             VARCHAR (150) NULL,
    [UnitTransferredTo]   VARCHAR (5)   NULL,
    [TransferDate]        DATETIME      NULL,
    [UnitTransferredFrom] VARCHAR (5)   NULL,
    [TransRecDate]        DATETIME      NULL,
    [UnitLocation]        VARCHAR (50)  NULL,
    [CompanyIdNumber]     VARCHAR (25)  NULL,
    [PickupLocation]      VARCHAR (50)  NULL,
    [ShipToLocation]      VARCHAR (50)  NULL,
    [PPMSelection]        VARCHAR (5)   NULL,
    [ScrapReason]         VARCHAR (20)  NULL,
    CONSTRAINT [PK_UnitData] PRIMARY KEY CLUSTERED ([UnitId] ASC)
);










GO
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_5]
    ON [dbo].[UnitData]([Job Type] ASC, [UnitStatus] ASC, [Promise Date] ASC, [Customer Number] ASC)
    INCLUDE([RECEIVED DATE], [uShipDate]);


GO
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_4]
    ON [dbo].[UnitData]([UnitStatus] ASC, [Dept Code] ASC, [Job Type] ASC)
    INCLUDE([Barcode], [KVA], [RECEIVED DATE], [PRI_VOLT], [SEC_VOLT], [Serial Number], [Customer Number], [Type], [Volts], [AMPS], [Promise Date], [Ship Date], [uShipDate], [uPaintDate], [uTestDate], [EstApproved], [Est First], [Decom Date], [EstComplete], [ushopdate], [uwelddate], [uovendate], [upowdercoat]);


GO
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_3]
    ON [dbo].[UnitData]([UnitStatus] ASC, [Customer Number] ASC, [Promise Date] ASC, [Est First] ASC, [EstApproved] ASC, [Job Type] ASC, [Barcode] ASC)
    INCLUDE([RECEIVED DATE], [uShipDate], [uPaintDate], [uTestDate], [Decom Date]);


GO
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_2]
    ON [dbo].[UnitData]([Promise Date] ASC, [UnitStatus] ASC, [EstComplete] ASC, [uShipDate] ASC, [Est First] ASC, [Dept Code] ASC, [Job Type] ASC)
    INCLUDE([UnitId], [Barcode], [Customer Number], [Ship Date], [EstApproved]);


GO
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization]
    ON [dbo].[UnitData]([UnitStatus] ASC, [Job Type] ASC, [Ship Date] ASC, [Dept Code] ASC, [Customer Number] ASC, [Barcode] ASC, [Est First] ASC, [Promise Date] ASC, [EstApproved] ASC)
    INCLUDE([KVA], [RECEIVED DATE], [PRI_VOLT], [SEC_VOLT], [Serial Number], [Type], [Volts], [AMPS], [uShipDate], [uPaintDate], [uTestDate], [Decom Date], [EstComplete], [ushopdate], [uwelddate], [uovendate], [upowdercoat]);

