USE [fInventory]
GO
/****** Object:  Table [dbo].[AssignedChecklist]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssignedChecklist](
	[Id] [uniqueidentifier] NOT NULL,
	[ChecklistId] [uniqueidentifier] NOT NULL,
	[RequiredByDate] [datetime] NOT NULL,
	[CompletedOnDate] [datetime] NULL,
	[MissedReason] [varchar](1000) NULL,
	[LastUpdateBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_AssignedChecklist] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssignedChecklistComments]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssignedChecklistComments](
	[Id] [uniqueidentifier] NOT NULL,
	[AssignedChecklistId] [uniqueidentifier] NOT NULL,
	[Comment] [varchar](max) NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_AssignedChecklistComments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssignedChecklistItemResponse]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssignedChecklistItemResponse](
	[Id] [uniqueidentifier] NOT NULL,
	[AssignedChecklistId] [uniqueidentifier] NOT NULL,
	[ChecklistItemId] [uniqueidentifier] NOT NULL,
	[Response] [varchar](50) NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_AssignedChecklistItemResponse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Checklist]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Checklist](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[LocationName] [varchar](50) NOT NULL,
	[Area] [varchar](50) NOT NULL,
	[CheckListAreaTypeId] [uniqueidentifier] NOT NULL,
	[CheckListInspectionTypeId] [uniqueidentifier] NOT NULL,
	[ChecklistFrequencyId] [int] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[SuccessEmails] [varchar](max) NOT NULL,
	[FailEmails] [varchar](max) NOT NULL,
	[CompletionRequiredInDays] [int] NOT NULL,
 CONSTRAINT [PK_Checklist] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChecklistAreaType]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChecklistAreaType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ChecklistAreaType_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChecklistFrequency]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChecklistFrequency](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ChecklistFrequency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChecklistInspectionType]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChecklistInspectionType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ChecklistInspectionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChecklistItem]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChecklistItem](
	[Id] [uniqueidentifier] NOT NULL,
	[ChecklistId] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[FailsEntireList] [bit] NOT NULL,
	[MaintenanceRequiredOnFail] [bit] NOT NULL,
	[MaintenanceTextOnFail] [varchar](1000) NULL,
	[PassText] [varchar](10) NOT NULL,
	[FailText] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ChecklistItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Injury]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Injury](
	[Id] [uniqueidentifier] NOT NULL,
	[InjuryLocationTypeId] [uniqueidentifier] NOT NULL,
	[PersonName] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[OccuredOn] [datetime] NOT NULL,
	[LocationId] [int] null,
	[Area] [varchar](50)  NULL,
	[FreakAccident] [bit] NOT NULL,
	[RequiresSopChange] [bit] NOT NULL,
	[SopChange] [varchar](max) NULL,
	[RequiresHospital] [bit] NOT NULL,
	[DeclinedMedical] [bit] NOT NULL,
	[IsRecordable] [bit] NOT NULL,
	[EmsDispatched] [bit] NOT NULL,
	[EmsContacted] [varchar](50) NULL,
	[EmsContactedAt] [time](7) NULL,
	[EmsContactNumber] [varchar](12) NULL,
 CONSTRAINT [PK_Injury] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InjuryLocation]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InjuryLocation](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](25) NOT NULL,
	[LastUpdateBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_InjuryLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InjuryLocationType]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InjuryLocationType](
	[Id] [uniqueidentifier] NOT NULL,
	[InjuryLocationId] [uniqueidentifier] NOT NULL,
	[InjuryTypeId] [uniqueidentifier] NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_InjuryLocationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InjuryType]    Script Date: 9/8/2017 3:44:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InjuryType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_InjuryType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChecklistItem] ADD  CONSTRAINT [DF_ChecklistItem_PassText]  DEFAULT ('Yes') FOR [PassText]
GO
ALTER TABLE [dbo].[ChecklistItem] ADD  CONSTRAINT [DF_ChecklistItem_FailText]  DEFAULT ('No') FOR [FailText]
GO
ALTER TABLE [dbo].[AssignedChecklist]  WITH CHECK ADD  CONSTRAINT [FK_AssignedChecklist_Checklist] FOREIGN KEY([ChecklistId])
REFERENCES [dbo].[Checklist] ([Id])
GO
ALTER TABLE [dbo].[AssignedChecklist] CHECK CONSTRAINT [FK_AssignedChecklist_Checklist]
GO
ALTER TABLE [dbo].[AssignedChecklistComments]  WITH CHECK ADD  CONSTRAINT [FK_AssignedChecklistComments_AssignedChecklist] FOREIGN KEY([AssignedChecklistId])
REFERENCES [dbo].[AssignedChecklist] ([Id])
GO
ALTER TABLE [dbo].[AssignedChecklistComments] CHECK CONSTRAINT [FK_AssignedChecklistComments_AssignedChecklist]
GO
ALTER TABLE [dbo].[AssignedChecklistItemResponse]  WITH CHECK ADD  CONSTRAINT [FK_AssignedChecklistItemResponse_AssignedChecklist] FOREIGN KEY([AssignedChecklistId])
REFERENCES [dbo].[AssignedChecklist] ([Id])
GO
ALTER TABLE [dbo].[AssignedChecklistItemResponse] CHECK CONSTRAINT [FK_AssignedChecklistItemResponse_AssignedChecklist]
GO
ALTER TABLE [dbo].[AssignedChecklistItemResponse]  WITH CHECK ADD  CONSTRAINT [FK_AssignedChecklistItemResponse_ChecklistItem] FOREIGN KEY([ChecklistItemId])
REFERENCES [dbo].[ChecklistItem] ([Id])
GO
ALTER TABLE [dbo].[AssignedChecklistItemResponse] CHECK CONSTRAINT [FK_AssignedChecklistItemResponse_ChecklistItem]
GO
ALTER TABLE [dbo].[Checklist]  WITH CHECK ADD  CONSTRAINT [FK_Checklist_ChecklistAreaType] FOREIGN KEY([CheckListAreaTypeId])
REFERENCES [dbo].[ChecklistAreaType] ([Id])
GO
ALTER TABLE [dbo].[Checklist] CHECK CONSTRAINT [FK_Checklist_ChecklistAreaType]
GO
ALTER TABLE [dbo].[Checklist]  WITH CHECK ADD  CONSTRAINT [FK_Checklist_ChecklistFrequency] FOREIGN KEY([ChecklistFrequencyId])
REFERENCES [dbo].[ChecklistFrequency] ([Id])
GO
ALTER TABLE [dbo].[Checklist] CHECK CONSTRAINT [FK_Checklist_ChecklistFrequency]
GO
ALTER TABLE [dbo].[Checklist]  WITH CHECK ADD  CONSTRAINT [FK_Checklist_ChecklistInspectionType] FOREIGN KEY([CheckListInspectionTypeId])
REFERENCES [dbo].[ChecklistInspectionType] ([Id])
GO
ALTER TABLE [dbo].[Checklist] CHECK CONSTRAINT [FK_Checklist_ChecklistInspectionType]
GO
ALTER TABLE [dbo].[ChecklistItem]  WITH CHECK ADD  CONSTRAINT [FK_ChecklistItem_Checklist] FOREIGN KEY([ChecklistId])
REFERENCES [dbo].[Checklist] ([Id])
GO
ALTER TABLE [dbo].[ChecklistItem] CHECK CONSTRAINT [FK_ChecklistItem_Checklist]
GO
ALTER TABLE [dbo].[Injury]  WITH CHECK ADD  CONSTRAINT [FK_Injury_InjuryLocationType] FOREIGN KEY([InjuryLocationTypeId])
REFERENCES [dbo].[InjuryLocationType] ([Id])
GO
ALTER TABLE [dbo].[Injury] CHECK CONSTRAINT [FK_Injury_InjuryLocationType]
GO
ALTER TABLE [dbo].[InjuryLocationType]  WITH CHECK ADD  CONSTRAINT [FK_InjuryLocationType_InjuryLocation] FOREIGN KEY([InjuryLocationId])
REFERENCES [dbo].[InjuryLocation] ([Id])
GO
ALTER TABLE [dbo].[InjuryLocationType] CHECK CONSTRAINT [FK_InjuryLocationType_InjuryLocation]
GO
ALTER TABLE [dbo].[InjuryLocationType]  WITH CHECK ADD  CONSTRAINT [FK_InjuryLocationType_InjuryType] FOREIGN KEY([InjuryTypeId])
REFERENCES [dbo].[InjuryType] ([Id])
GO
ALTER TABLE [dbo].[InjuryLocationType] CHECK CONSTRAINT [FK_InjuryLocationType_InjuryType]
GO


Alter table [Users] 
	ADD IsIRAdmin bit DEFAULT 0

Alter table [Users] 
	ADD IsEnvChklstAdmin bit DEFAULT 0
	