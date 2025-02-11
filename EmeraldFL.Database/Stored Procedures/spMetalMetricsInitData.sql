/****** Object:  StoredProcedure [dbo].[spMetalMetricsInitData]    Script Date: 6/18/2020 11:54:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kalyani S
-- Create date: 23-Oct-2019
-- Description:	This SP Fetch Metal Oil Dashboard related init data which is require to bind following. This SP returns 3 result set as follow 
--				1.	Location 
--				2.	Plant
--				3.	Item
-- =============================================
--exec spMetalMetricsInitData  '14,15'
--exec spMetalMetricsInitData  '14,15'

CREATE PROCEDURE [dbo].[spMetalMetricsInitData]
@LocationId as varchar(20),
@Key as varchar(20)
	AS
BEGIN
	-------------------------Location Start---------------------------
	IF ( EXISTS ( Select l.id, l.Description from locations l where (l.Active = 1 or (id in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ','))))  ) )
    Select l.id, l.Description from locations l where (l.Active = 1 or (id in (SELECT FIELDVALUE FROM FN_STRING_TO_TABLE_STRING(@LocationId, ','))))
	ELSE
    SELECT TOP 0 NULL AS location


	--Select l.id, l.Description from locations l where l.Active = 1
	-------------------------Location End---------------------------

	-------------------------Plant Start---------------------------
	IF ( EXISTS ( select distinct WhseId from trav_EO_ArDetailHistory where catid like 'fg%' and WhseId is not null and WhseId <>'') )
    select distinct WhseId from trav_EO_ArDetailHistory where catid like 'fg%' and WhseId is not null and WhseId <>'' order by WhseId
	ELSE
    SELECT TOP 0 NULL AS WhseId

	--select distinct WhseId from trav_EO_ArDetailHistory where catid like 'fg%' and WhseId is not null and WhseId <>''--PlantId
	-------------------------Plant End---------------------------

	-------------------------Item Start---------------------------
	if @Key='Metal'
	Begin

	IF ( EXISTS ( select distinct partid from trav_EO_ArDetailHistory where catid like 'fg%' and partid  is not null and partid <>'' and partid not like ('%OIL%')) )
    select distinct partid from trav_EO_ArDetailHistory where catid like 'fg%' and partid  is not null and partid <>'' and partid not like ('%OIL%')order by partid
	ELSE
    SELECT TOP 0 NULL AS partid

	end

	if @Key='Oil'
	Begin

	IF ( EXISTS ( select distinct partid from trav_EO_ArDetailHistory where catid like 'fg%' and partid  is not null and partid <>'' and partid like ('%OIL%')) )
    select distinct partid from trav_EO_ArDetailHistory where catid like 'fg%' and partid  is not null and partid <>'' and partid like ('%OIL%') order by partid
	ELSE
    SELECT TOP 0 NULL AS partid

	end

	--select distinct partid from trav_EO_ArDetailHistory where catid like 'fg%' and partid  is not null and partid <>''--ItemId
	-------------------------Item End---------------------------
END


GO


