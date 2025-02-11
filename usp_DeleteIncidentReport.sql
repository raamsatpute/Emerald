USE [EmeraldGold_QET]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteIncidentReport]    Script Date: 7/15/2019 3:16:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_DeleteIncidentReport]
      @id uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
	Delete from IncidentWitness where  IncidentReportId  = @Id
	Delete from InjuryVictim where IncidentReportId  = @Id
	Delete from IncidentReport where Id = @Id
END





