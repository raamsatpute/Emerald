
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
GO

SET NUMERIC_ROUNDABORT OFF;
GO

IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END
GO

USE [$(DatabaseName)];
GO

/*
The column [dbo].[UnitData].[TransferDate] is being dropped, data loss could occur.

The column [dbo].[UnitData].[TransRecDate] is being dropped, data loss could occur.

The column [dbo].[UnitData].[UnitTransferredFrom] is being dropped, data loss could occur.

The column [dbo].[UnitData].[UnitTransferredTo] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[UnitData])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT
GO

/*
Table [dbo].[SoldTo] is being dropped.  Deployment will halt if the table contains data.
*/

IF EXISTS (select top 1 1 from [dbo].[SoldTo])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT
GO

/*
Table [dbo].[TransferredUnits] is being dropped.  Deployment will halt if the table contains data.
*/

IF EXISTS (select top 1 1 from [dbo].[TransferredUnits])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT
GO

/*
Table [dbo].[TruckingCompany] is being dropped.  Deployment will halt if the table contains data.
*/

IF EXISTS (select top 1 1 from [dbo].[TruckingCompany])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT
GO

PRINT N'Dropping [dbo].[DF_TransferredUnits_UnitStatus]...';
GO

ALTER TABLE [dbo].[TransferredUnits] DROP CONSTRAINT [DF_TransferredUnits_UnitStatus];
GO

PRINT N'Dropping [dbo].[DF_TransferredUnits_DateStamp]...';
GO

ALTER TABLE [dbo].[TransferredUnits] DROP CONSTRAINT [DF_TransferredUnits_DateStamp];
GO

PRINT N'Dropping [dbo].[FK_Injury_InjuryLocationType]...';
GO

ALTER TABLE [dbo].[Injury] DROP CONSTRAINT [FK_Injury_InjuryLocationType];
GO

PRINT N'Dropping [dbo].[SoldTo]...';
GO

DROP TABLE [dbo].[SoldTo];
GO

PRINT N'Dropping [dbo].[TransferredUnits]...';
GO

DROP TABLE [dbo].[TransferredUnits];
GO

PRINT N'Dropping [dbo].[TruckingCompany]...';
GO

DROP TABLE [dbo].[TruckingCompany];
GO

PRINT N'Dropping <unnamed>...';
GO

PRINT N'Dropping <unnamed>...';
GO

PRINT N'Dropping <unnamed>...';
GO

PRINT N'Dropping <unnamed>...';
GO

PRINT N'Dropping <unnamed>...';
GO

PRINT N'Starting rebuilding table [dbo].[Injury]...';
GO

BEGIN TRANSACTION;
GO

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO

SET XACT_ABORT ON;
GO

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Injury])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Injury] ([Id], [InjuryLocationTypeId], [PersonName], [Description], [OccuredOn], [LocationId], [Area], [FreakAccident], [RequiresSopChange], [SopChange], [RequiresHospital], [DeclinedMedical], [IsRecordable], [EmsDispatched], [EmsContacted], [EmsContactedAt], [EmsContactNumber])
        SELECT   [Id],
                 [InjuryLocationTypeId],
                 [PersonName],
                 [Description],
                 [OccuredOn],
                 [LocationId],
                 [Area],
                 [FreakAccident],
                 [RequiresSopChange],
                 [SopChange],
                 [RequiresHospital],
                 [DeclinedMedical],
                 [IsRecordable],
                 [EmsDispatched],
                 [EmsContacted],
                 [EmsContactedAt],
                 [EmsContactNumber]
        FROM     [dbo].[Injury]
        ORDER BY [Id] ASC;
    END
GO

DROP TABLE [dbo].[Injury];
GO

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Injury]', N'Injury';
GO

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Injury1]', N'PK_Injury', N'OBJECT';
GO

COMMIT TRANSACTION;
GO

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

PRINT N'Altering [dbo].[UnitData]...';
GO

ALTER TABLE [dbo].[UnitData] DROP COLUMN [TransferDate], COLUMN [TransRecDate], COLUMN [UnitTransferredFrom], COLUMN [UnitTransferredTo];
GO

PRINT N'Creating [dbo].[AuditEntries]...';
GO

PRINT N'Creating [dbo].[AuditEntryProperties]...';
GO

PRINT N'Creating [dbo].[AuditEntryProperties].[IX_AuditEntryID]...';
GO

PRINT N'Creating [dbo].[IncidentCategory]...';
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

PRINT N'Creating [dbo].[IncidentReport]...';
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

PRINT N'Creating [dbo].[IncidentWitness]...';
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

PRINT N'Creating [dbo].[InjuryDetail]...';
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

PRINT N'Creating [dbo].[State]...';
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;
GO

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

PRINT N'Creating [dbo].[InjuryLocation].[IX_InjuryLocation]...';
GO

PRINT N'Creating [dbo].[InjuryLocationType].[IX_InjuryLocation_Id_InjuryTypeId]...';
GO

PRINT N'Creating [dbo].[InjuryLocationType].[IX_InjuryLocationId]...';
GO

PRINT N'Creating [dbo].[InjuryLocationType].[IX_InjuryType]...';
GO

PRINT N'Creating unnamed constraint on [dbo].[IncidentCategory]...';
GO

PRINT N'Creating [dbo].[DF_IncidentReport_Id]...';
GO

PRINT N'Creating [dbo].[DF_IncidentWitness_Id]...';
GO

PRINT N'Creating [dbo].[DF_InjuryDetail_Id]...';
GO

PRINT N'Creating unnamed constraint on [dbo].[InjuryLocation]...';
GO

PRINT N'Creating unnamed constraint on [dbo].[InjuryLocationType]...';
GO

PRINT N'Creating unnamed constraint on [dbo].[InjuryType]...';
GO

PRINT N'Creating [dbo].[FK_Injury_InjuryLocationType]...';
GO

PRINT N'Creating [dbo].[FK_dbo.AuditEntryProperties_dbo.AuditEntries_AuditEntryID]...';
GO

PRINT N'Creating [dbo].[FK_IncidentReport_IncidentCategory]...';
GO

PRINT N'Creating [dbo].[FK_IncidentReport_State1]...';
GO

PRINT N'Creating [dbo].[FK_IncidentWitness_IncidentReport]...';
GO

PRINT N'Creating [dbo].[FK_InjuryDetail_Injury]...';
GO

PRINT N'Creating [dbo].[FK_InjuryDetail_InjuryLocation]...';
GO

PRINT N'Creating [dbo].[FK_InjuryDetail_InjuryType]...';
GO

PRINT N'Refreshing [dbo].[MetricB]...';
GO

EXECUTE sp_refreshsqlmodule N'[dbo].[MetricB]';
GO

PRINT N'Refreshing [dbo].[MetricMSDetail]...';
GO

EXECUTE sp_refreshsqlmodule N'[dbo].[MetricMSDetail]';
GO

PRINT N'Refreshing [dbo].[MetricOneDetail]...';
GO

EXECUTE sp_refreshsqlmodule N'[dbo].[MetricOneDetail]';
GO

PRINT N'Altering [dbo].[UnitDataDetail]...';
GO

ALTER VIEW dbo.UnitDataDetail
AS
SELECT        CASE WHEN [decom date] IS NOT NULL THEN 'True' WHEN [utestdate] IS NOT NULL THEN 'True' WHEN [upaintdate] IS NOT NULL THEN 'True' WHEN ([est first] = 'Y' AND (([PROMISE DATE] IS NULL AND 
                         [EstApproved] IS NULL))) THEN 'True' WHEN
                             (SELECT        COUNT(*) AS Removed
                               FROM            QAReceived
                               WHERE        dbo.QAReceived.Barcode = dbo.UnitData.barcode AND Removed = 1) > 0 THEN 'True' ELSE 'False' END AS Exclude, CASE WHEN dbo.[Job Types].[Job Type Description] IS NULL 
                         THEN 'Unknown' ELSE dbo.[Job Types].[Job Type Description] END AS [Desc], CASE WHEN dbo.UnitData.[ushipdate] IS NOT NULL THEN DATEDIFF(d, dbo.UnitData.[received DATE], dbo.unitdata.ushipdate) 
                         WHEN dbo.UnitData.[promise date] IS NULL THEN DATEDIFF(d, dbo.UnitData.[received DATE], GETDATE()) WHEN dbo.UnitData.[promise date] IS NOT NULL THEN DATEDIFF(d, dbo.UnitData.[promise DATE], 
                         GETDATE()) ELSE NULL END AS DaysOut, dbo.UnitData.UnitId, dbo.UnitData.[Job Type], dbo.[Job Types].[Job Type Description], dbo.UnitData.Barcode, dbo.UnitData.UID, dbo.UnitData.KVA, 
                         dbo.UnitData.[RECEIVED DATE], dbo.UnitData.PRI_VOLT, dbo.UnitData.SEC_VOLT, dbo.UnitData.[TEST DATE], dbo.UnitData.[Paint DATE], dbo.UnitData.[Serial Number], dbo.UnitData.[Customer Number], 
                         dbo.UnitData.Location, dbo.UnitData.Type, dbo.UnitData.Volts, dbo.UnitData.AMPS, dbo.UnitData.[Promise Date], dbo.UnitData.uShipDate, dbo.UnitData.uPaintDate, dbo.UnitData.uTestDate, 
                         dbo.UnitData.[Ship Date], dbo.UnitData.EstApproved, dbo.UnitData.[Dept Code], dbo.UnitData.UnitStatus, dbo.UnitData.[Est First], dbo.UnitData.[Decom Date], dbo.UnitData.EstComplete, dbo.UnitData.MFGR, 
                         dbo.UnitData.TAPS, dbo.UnitData.WEIGHT1, dbo.UnitData.W_PANEL_WITH, dbo.UnitData.PANEL_SER, dbo.UnitData.LOOP_RAD, dbo.UnitData.IMP, dbo.UnitData.BUSH_CNT, dbo.UnitData.[DESC] AS Description, 
                         dbo.UnitData.uDecomDate, dbo.UnitData.J_CUST_PO_, dbo.UnitData.ushopdate, dbo.UnitData.uwelddate, dbo.UnitData.uovendate, dbo.UnitData.upowdercoat, dbo.UnitData.DateStamp
FROM            dbo.UnitData LEFT OUTER JOIN
                         dbo.[Job Types] ON dbo.UnitData.[Job Type] = dbo.[Job Types].[Job Type]
GO

PRINT N'Refreshing [dbo].[Unitdetailcounts]...';
GO

EXECUTE sp_refreshsqlmodule N'[dbo].[Unitdetailcounts]';
GO

PRINT N'Creating [dbo].[vw_DisplayAuditEntry]...';
GO

PRINT N'Creating [dbo].[vw_DisplayAuditEntryProperties]...';
GO

PRINT N'Creating [dbo].[GetAuditIdsForTableAndKey]...';
GO

PRINT N'Altering [dbo].[UnitDataDetail].[MS_DiagramPane1]...';
GO

EXECUTE sp_updateextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4[60] 2) )"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UnitData"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 259
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 33
         End
         Begin Table = "Job Types"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 119
               Right = 463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 48
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'UnitDataDetail';
GO

PRINT N'Checking existing data against newly created constraints';
GO

USE [$(DatabaseName)];
GO

PRINT N'Update complete.';
GO

/*
Deployment script for fInventory

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

 