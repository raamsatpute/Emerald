CREATE TABLE [dbo].[NonPCBPrintLog] (
    [PrintLogId] INT      IDENTITY (1, 1) NOT NULL,
    [PrintedBy]  INT      NULL,
    [Datestamp]  DATETIME NULL,
    [IsInitial]  BIT      NULL,
    [BatchId]    INT      NULL,
    CONSTRAINT [PK_NonPCBPrintLog] PRIMARY KEY CLUSTERED ([PrintLogId] ASC)
);

