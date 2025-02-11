




CREATE PROCEDURE [dbo].[UpdateStaticInventory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  delete from StaticInventory
insert into StaticInventory  select * from InventoryDetails 
END



