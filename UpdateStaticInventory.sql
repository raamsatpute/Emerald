/****** Object:  StoredProcedure [dbo].[UpdateStaticInventory]    Script Date: 7/15/2019 3:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[UpdateStaticInventory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  delete from StaticInventory
insert into StaticInventory  select * from InventoryDetails 
END



