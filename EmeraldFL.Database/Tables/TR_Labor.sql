CREATE TABLE [dbo].[TR_Labor] (
    [LaborId]        INT        IDENTITY (1, 1) NOT NULL,
    [TRTechnicianID] INT        NULL,
    [Hours]          FLOAT (53) NULL,
    [LaborDate]      DATETIME   NULL,
    [Datestamp]      DATETIME   CONSTRAINT [DF_TR_Labor_Datestamp] DEFAULT (getdate()) NULL,
    [RequestID]      INT        NULL
);

