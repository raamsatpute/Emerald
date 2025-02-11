CREATE PROCEDURE usp_DeleteInjuryReport
      @id uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
	Delete from IncidentWitness where  IncidentReportId  = @Id
	Delete from InjuryVictim where IncidentReportId  = @Id
	Delete from IncidentReport where Id = @Id
END


