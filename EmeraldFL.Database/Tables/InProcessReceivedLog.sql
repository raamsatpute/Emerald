CREATE TABLE [dbo].[InProcessReceivedLog] (
    [ReceievedID] INT      IDENTITY (1, 1) NOT NULL,
    [UnitID]      INT      NULL,
    [ReceivedAt]  INT      NULL,
    [Datestamp]   DATETIME NULL
);

