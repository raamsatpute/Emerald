 /****** Object:  Index [PK_Users]    Script Date: 9/8/2017 5:10:47 PM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Users_UserID_Status' AND object_id = OBJECT_ID('dbo.Users'))
BEGIN
    DROP INDEX [IX_Users_UserID_Status] ON [dbo].[Users];
END

/****** Object:  Index [IX_Users_UserID&Status]    Script Date: 9/8/2017 5:09:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Users_UserID_Status] ON [dbo].[Users]
(
	[USERID] ASC,
	[STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_UnitData_QueryOptimization' AND object_id = OBJECT_ID('dbo.UnitData'))
BEGIN
    DROP INDEX [IX_UnitData_QueryOptimization] ON [dbo].[UnitData];
END

CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization] ON [dbo].[UnitData]
(
	[UnitStatus] ASC,
	[Job Type] ASC,
	[Ship Date] ASC,
	[Dept Code] ASC,
	[Customer Number] ASC,
	[Barcode] ASC,
	[Est First] ASC,
	[Promise Date] ASC,
	[EstApproved] ASC
)
INCLUDE ( 	[KVA],
	[RECEIVED DATE],
	[PRI_VOLT],
	[SEC_VOLT],
	[Serial Number],
	[Type],
	[Volts],
	[AMPS],
	[uShipDate],
	[uPaintDate],
	[uTestDate],
	[Decom Date],
	[EstComplete],
	[ushopdate],
	[uwelddate],
	[uovendate],
	[upowdercoat]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_SFSComments_QueryOptimization' AND object_id = OBJECT_ID('dbo.SFSComments'))
BEGIN
    DROP INDEX [IX_SFSComments_QueryOptimization] ON [dbo].[SFSComments];
END

CREATE NONCLUSTERED INDEX [IX_SFSComments_QueryOptimization] ON [dbo].[SFSComments]
(
	[Barcode] ASC,
	[UID] ASC,
	[SFS_CommentId] ASC,
	[Comment] ASC,
	[DateStamp] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_UnitData_QueryOptimization_2' AND object_id = OBJECT_ID('dbo.UnitData'))
BEGIN
    DROP INDEX [IX_UnitData_QueryOptimization_2] ON [dbo].[UnitData];
END

CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_2] ON [dbo].[UnitData]
(
	[Promise Date] ASC,
	[UnitStatus] ASC,
	[EstComplete] ASC,
	[uShipDate] ASC,
	[Est First] ASC,
	[Dept Code] ASC,
	[Job Type] ASC
)
INCLUDE ( 	[UnitId],
	[Barcode],
	[Customer Number],
	[Ship Date],
	[EstApproved]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_UnitData_QueryOptimization_3' AND object_id = OBJECT_ID('dbo.UnitData'))
BEGIN
    DROP INDEX [IX_UnitData_QueryOptimization_3] ON [dbo].[UnitData];
END

CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_3] ON [dbo].[UnitData]
(
	[UnitStatus] ASC,
	[Customer Number] ASC,
	[Promise Date] ASC,
	[Est First] ASC,
	[EstApproved] ASC,
	[Job Type] ASC,
	[Barcode] ASC
)
INCLUDE ( 	[RECEIVED DATE],
	[uShipDate],
	[uPaintDate],
	[uTestDate],
	[Decom Date]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_UnitData_QueryOptimization_4' AND object_id = OBJECT_ID('dbo.UnitData'))
BEGIN
    DROP INDEX [IX_UnitData_QueryOptimization_4] ON [dbo].[UnitData];
END

CREATE  NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_4] ON [dbo].[UnitData]
(
	[UnitStatus] ASC,
	[Dept Code] ASC,
	[Job Type] ASC
)
INCLUDE ( 	[Barcode],
	[KVA],
	[RECEIVED DATE],
	[PRI_VOLT],
	[SEC_VOLT],
	[Serial Number],
	[Customer Number],
	[Type],
	[Volts],
	[AMPS],
	[Promise Date],
	[Ship Date],
	[uShipDate],
	[uPaintDate],
	[uTestDate],
	[EstApproved],
	[Est First],
	[Decom Date],
	[EstComplete],
	[ushopdate],
	[uwelddate],
	[uovendate],
	[upowdercoat]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_UnitData_QueryOptimization_5' AND object_id = OBJECT_ID('dbo.QAComments'))
BEGIN
    DROP INDEX [IX_UnitData_QueryOptimization_5] ON [dbo].[QAComments];
END
CREATE NONCLUSTERED INDEX [IX_UnitData_QueryOptimization_5] ON [dbo].[UnitData]
(
	[Job Type] ASC,
	[UnitStatus] ASC,
	[Promise Date] ASC,
	[Customer Number] ASC
)
INCLUDE ( 	[RECEIVED DATE],
	[uShipDate]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_QAComments' AND object_id = OBJECT_ID('dbo.QAComments'))
BEGIN
    DROP INDEX [IX_QAComments] ON [dbo].[QAComments];
END
 
CREATE NONCLUSTERED INDEX [IX_QAComments] ON [dbo].[QAComments]
(
	[Barcode] ASC,
	[UID] ASC,
	[QAComId] ASC,
	[Comment] ASC,
	[DateStamp] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
