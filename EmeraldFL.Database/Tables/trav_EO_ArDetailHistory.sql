
/****** Object:  Table [dbo].[trav_EO_ArDetailHistory]    Script Date: 6/19/2020 1:24:32 AM ******/--
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[trav_EO_ArDetailHistory](
	[CompId] [varchar](100) NULL,
	[FiscalYear] [int] NULL,
	[FiscalPeriod] [int] NULL,
	[Description] [varchar](500) NULL,
	[Amount] [decimal](38, 9) NULL,
	[ShipDate] [datetime] NULL,
	[WhseId] [varchar](100) NULL,
	[PartId] [varchar](100) NULL,
	[UnitPriceSell] [decimal](38, 9) NULL,
	[QtyOrdSell] [decimal](28, 10) NULL,
	[QtyShipSell] [decimal](28, 10) NULL,
	[CatId] [varchar](50) NULL,
	[LocationId] [int] NULL,
	[Location] [varchar](100) NULL,
	[TransDate] [datetime] NULL,
	[SalesAcct] [varchar](50) NULL,
	[TransType] [int] NULL,
	[GLAcctSales] [varchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


