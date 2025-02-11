CREATE TABLE [dbo].[PCBPrintLog] (
    [PrintLogId] INT      IDENTITY (1, 1) NOT NULL,
    [PrintedBy]  INT      NULL,
    [Datestamp]  DATETIME NULL,
    [IsInitial]  BIT      CONSTRAINT [DF_PCBPrintLog_IsInitial] DEFAULT ((0)) NULL,
    [BatchId]    INT      NULL,
    CONSTRAINT [PK_PCBPrintLog] PRIMARY KEY CLUSTERED ([PrintLogId] ASC)
);

