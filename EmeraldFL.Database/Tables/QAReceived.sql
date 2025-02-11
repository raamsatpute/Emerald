CREATE TABLE [dbo].[QAReceived] (
    [QAReceivedId]     INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QAReceived_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QAReceived_DateStamp] DEFAULT (getdate()) NULL,
    [Removed]          BIT          CONSTRAINT [DF_QAReceived_Remove] DEFAULT ((0)) NULL,
    [RemovedDate]      DATETIME     NULL,
    CONSTRAINT [PK_QAReceived] PRIMARY KEY CLUSTERED ([QAReceivedId] ASC)
);

