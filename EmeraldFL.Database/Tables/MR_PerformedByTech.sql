CREATE TABLE [dbo].[MR_PerformedByTech] (
    [MRPerformedByTechID] INT IDENTITY (1, 1) NOT NULL,
    [MRTechnicianID]      INT NULL,
    [RequestId]           INT NULL,
    CONSTRAINT [PK_MR_PerformedByTech] PRIMARY KEY CLUSTERED ([MRPerformedByTechID] ASC)
);

