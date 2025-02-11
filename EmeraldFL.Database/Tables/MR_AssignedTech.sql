CREATE TABLE [dbo].[MR_AssignedTech] (
    [MRAssignedTechID] INT IDENTITY (1, 1) NOT NULL,
    [MRTechnicianID]   INT NULL,
    [RequestId]        INT NULL,
    CONSTRAINT [PK_MR_AssignedTech] PRIMARY KEY CLUSTERED ([MRAssignedTechID] ASC)
);

