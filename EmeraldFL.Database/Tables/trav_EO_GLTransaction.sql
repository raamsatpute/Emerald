/****** Object:  Table [dbo].[trav_EO_GLTransaction]    Script Date: 6/19/2020 1:26:01 AM ******/--
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[trav_EO_GLTransaction](
	[EntryDate] [datetime] NULL,
	[TransDate] [datetime] NULL,
	[Desc] [varchar](100) NULL,
	[SourceCode] [varchar](10) NULL,
	[Reference] [varchar](30) NULL,
	[AcctId] [int] NULL,
	[DebitAmt] [decimal](28, 3) NULL,
	[CreditAmt] [decimal](28, 3) NULL,
	[Period] [int] NULL,
	[Year] [int] NULL,
	[Amount] [decimal](29, 3) NULL,
	[AccountDescription] [varchar](100) NULL,
	[LocationId] [int] NULL,
	[Location] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


