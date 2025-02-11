/****** Object:  Table [dbo].[trav_EO_SrJobs]    Script Date: 6/19/2020 1:27:07 AM ******/--
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[trav_EO_SrJobs](
	[DeptCode] [varchar](50) NULL,
	[DeptDescr] [varchar](500) NULL,
	[Department] [varchar](500) NULL,
	[BatchId] [varchar](50) NULL,
	[Source] [int] NULL,
	[TransID] [varchar](50) NULL,
	[TransType] [int] NULL,
	[TransStatus] [int] NULL,
	[NamePlateDescr] [varchar](500) NULL,
	[JobDescr] [varchar](500) NULL,
	[JobTypeDescription] [varchar](500) NULL,
	[LocId] [varchar](50) NULL,
	[CustId] [varchar](50) NULL,
	[CustName] [varchar](500) NULL,
	[BillToID] [varchar](50) NULL,
	[JobType] [varchar](500) NULL,
	[MiscNum] [varchar](500) NULL,
	[ShipDate] [datetime] NULL,
	[CheckInDate] [datetime] NULL,
	[TransDate] [datetime] NULL,
	[CarcassManifestDate] [datetime] NULL,
	[ProcessDate] [datetime] NULL,
	[FieldInventory] [bit] NULL,
	[LocationID] [int] NULL,
	[KVA] [varchar](100) NULL,
	[AMPS] [varchar](100) NULL,
	[Serial_Number] [varchar](100) NULL,
	[ServiceType] [nvarchar](max) NULL,
	[LBS] [varchar](100) NULL,
	[Metal] [varchar](100) NULL,
	[InvcAmount] [decimal](20, 10) NULL,
	[LastInvcDate] [datetime] NULL,
	[InvcStatus] [int] NULL,
	[InvcStatusName] [varchar](100) NULL,
	[Location] [varchar](100) NULL,
	[Test Date] [datetime] NULL,
	[TestCompletedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


