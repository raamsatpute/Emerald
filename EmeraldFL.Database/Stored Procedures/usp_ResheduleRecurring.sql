CREATE PROCEDURE usp_ResheduleRecurring
     
AS
BEGIN


DECLARE @assigned TABLE
(
	cid UNIQUEIDENTIFIER,
	lid INT,
	HasOpen BIT,
	LastCompletedOnDate DATETIME
)


INSERT INTO @assigned
	SELECT ID, LID,MAX(HasOpen) AS HasOpen, Max(dtm) FROM (
		SELECT DISTINCT
			c.Id AS ID, 
			a.LocationId AS LID,
			CASE
				WHEN CompletedOnDate IS NOT NULL THEN 0
			ELSE 1 END AS HasOpen,
			CompletedOnDate AS Dtm
		from AssignedChecklist a 
			inner join checklist c ON a.checklistId = c.id
			inner join ChecklistFrequency f ON c.ChecklistFrequencyId = f.Id
		) S
		GROUP BY S.ID, S.LID

SELECT c.Name as CheckListName
      ,l.LocationName  as LocationName
      ,CASE 
		WHEN C.ChecklistFrequencyId = 2 THEN  DATEADD(DAY,1,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 3 THEN  DATEADD(DAY,7,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 4 THEN  DATEADD(DAY,30,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 5 THEN  DATEADD(MONTH,1,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 6 THEN  DATEADD(YEAR,1,CONVERT(DATE, A.RequiredByDate, 101))
		ELSE A.RequiredByDate 
	   END AS REQUIREDBYDATE
  FROM [AssignedChecklist] A
		INNER JOIN [Checklist] C ON A.ChecklistId = C.Id
		INNER JOIN Locations l on l.ID = c.LocationId
		INNER JOIN @assigned x ON a.ChecklistId = x.cid and a.LocationId = x.lid
		WHERE HASOPEN = 0



INSERT INTO AssignedChecklist
	SELECT NEWID()
      ,A.[ChecklistId]
      ,CASE 
		WHEN C.ChecklistFrequencyId = 2 THEN  DATEADD(DAY,1,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 3 THEN  DATEADD(DAY,7,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 4 THEN  DATEADD(DAY,30,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 5 THEN  DATEADD(MONTH,1,CONVERT(DATE, A.RequiredByDate, 101))
		WHEN C.ChecklistFrequencyId = 6 THEN  DATEADD(YEAR,1,CONVERT(DATE, A.RequiredByDate, 101))
		ELSE A.RequiredByDate 
	   END AS REQUIREDBYDATE
      ,NULL AS CompletedOnDate
      ,'' AS MissedReason
      ,'SYSTEM GENERATED' AS LastupedUpdatedBy
      ,GETDATE() AS LastedUPdatedDate
      ,A.[LocationId] AS LocationID
  FROM [AssignedChecklist] A
		INNER JOIN [Checklist] C ON A.ChecklistId = C.Id
		INNER JOIN @assigned x ON a.ChecklistId = x.cid and a.LocationId = x.lid
		WHERE HASOPEN = 0

		
END


