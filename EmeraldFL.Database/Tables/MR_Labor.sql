CREATE TABLE [dbo].[MR_Labor] (
    [LaborId]        INT        IDENTITY (1, 1) NOT NULL,
    [MRTechnicianID] INT        NULL,
    [Hours]          FLOAT (53) NULL,
    [LaborDate]      DATETIME   NULL,
    [Datestamp]      DATETIME   CONSTRAINT [DF_MR_Labor_Datestamp] DEFAULT (getdate()) NULL,
    [RequestID]      INT        NULL
);

