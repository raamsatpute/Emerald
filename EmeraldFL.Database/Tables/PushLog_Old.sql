CREATE TABLE [dbo].[PushLog_Old] (
    [PushLogID]            INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]              VARCHAR (10) NULL,
    [VerifiedBy]           INT          NULL,
    [DateStamp]            DATETIME     NULL,
    [DecomStatus]          BIT          NULL,
    [DecomStatusChanged]   DATETIME     NULL,
    [DecomStatusChangedBy] INT          NULL
);

