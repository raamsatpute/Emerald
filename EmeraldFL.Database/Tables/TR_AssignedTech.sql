CREATE TABLE [dbo].[TR_AssignedTech] (
    [TRAssignedTechID] INT IDENTITY (1, 1) NOT NULL,
    [TRTechnicianID]   INT NULL,
    [RequestId]        INT NULL,
    CONSTRAINT [PK_TR_AssignedTech] PRIMARY KEY CLUSTERED ([TRAssignedTechID] ASC)
);

