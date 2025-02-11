CREATE TABLE [dbo].[QARegulator] (
    [QARegulatorId]    INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QARegulator_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QARegulator_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_QARegulator] PRIMARY KEY CLUSTERED ([QARegulatorId] ASC)
);

