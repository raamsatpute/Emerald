CREATE TABLE [dbo].[TR_PerformedByTech] (
    [TRPerformedByTechID] INT IDENTITY (1, 1) NOT NULL,
    [TRTechnicianID]      INT NULL,
    [RequestId]           INT NULL,
    CONSTRAINT [PK_TR_PerformedByTech] PRIMARY KEY CLUSTERED ([TRPerformedByTechID] ASC)
);

