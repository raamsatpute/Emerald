/****** Object:  StoredProcedure [dbo].[spUsers]    Script Date: 08/14/19 10:22:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 10-Apr-2019
-- Description:	This SP Insert/Edit/Delete Users and User Module Mapping based on value passed in following input parameters
--				tbl_Users : Holds result set of Users entered/selected from User screen
--				tbl_UserMapping : Holds result set of Module Mapping Mapped/Selected from User Module Screen
--				@IdUser : Contains User Id from User screen. 0 in case of new User
--				@SaveUser: Flagging to identify System whether to Insert/Update/Delete User or User Module Mapping. 
--				@CreatedOrModifiedBy: Contain UserId who had created or modified User/UserModuleMapping
--				DML operations work with the combination of @IdUser and @SaveUser
--							@IdUser = 0: Insert new User and User Module Mapping
--							@IdUser>0 and @SaveUser = 1: Update existing User and Modify esixting User's Location status, 
--														 also if any new location is mapped than Insert that Location in UserMapping table. This is set from User screen.
--							@IdUser>0 and @SaveUser = 0: Update existing User Module Mapping from User Module Mapping screen
--							@IdUser>0 and @SaveUser = 2: Soft Delete User and User Mapping from Database. This is set from User screen
-- =============================================

ALTER PROCEDURE [dbo].[spUsers]
	@Users tbl_Users Readonly,
	@UserMapping tbl_UserMapping Readonly,
	@IdUser Int=0,
	@SaveUser int = 0,
	@CreatedOrModifiedBy int = 0
AS
BEGIN
	Begin Try
		Begin Transaction
			--========Insert User and Mapping=====================================
			if @IdUser = 0
			Begin
				Declare @userId as int
				Insert Into Users(
							FIRSTNAME,		LASTNAME,	USERID,
							[PASSWORD],		LASTLOGIN,	STATUS,
							EmailAddress,
							CreatedBy,		CreatedOn,	ModifiedBy,	ModifiedOn) 
				Select
							FIRSTNAME,		LASTNAME,	USERID,
							[PASSWORD],		LASTLOGIN,	STATUS,
							EmailAddress,
							@CreatedOrModifiedBy,	getdate(), null, null
				FROM @Users 

				set @userId = @@identity

				Update Users set tmpParentId = @userId where id = @userId

				Insert Into UserMapping(
							IDUser,									Location,							Loc_Status,							[IsAdmin],					
							[Backlog],								[Backlogadmin],						[FieldInvAdmin],					[FieldService],		
							[MaintenanceRequestAdmin],				[MaintenanceRequests],				[MaintenanceTechnician],			[PCBLab],				
							[PCBPRocessing],						[PCBProcessOffice],					[InternalLabResults],				[LocationUser],				
							[LocationReportUser],					[SpecBookAdmin],					[Specbookuser],						[OilManagement],
							[LogReport],							[CheckInLog],						[ContainerLog],						[DashboardAdmin],			
							[DashboardUser],						[Decom],							[DecomHistory],						[DecomLog],			
							[DecomLogAdmin],						[DecomLogUser],						[DragonLogAdmin],					[DragonLogUser],		
							[InProc],								[IsEnvChklstAdmin],					[IsIRAdmin],						[MapAdmin],					
							[MapUser],								[MetricsAdmin],						[MetricsUser],						[OilLog],
							[PackageLog],							[Paint],							[PushLog],							[QAAdmin],					
							[QADock],								[QAPAd],							[QAPaint],							[QAPole],			
							[QAReceived],							[QARecloser],						[QARegulator],						[QASupport],			
							[ReadOnly],								[SalesPortal],						[ShippingLogAdmin],					[ShippingLogUser],						
							[TechRequestAdmin],						[TechRequests],						[TechTechnician],					[TrailerAdmin],
							[TrailerInProc],						[TrailerRequest],					[TransitionInfo],					[WHAPCO],					
							[WHMPCO],								[tmpparentId],
							CreatedBy,								CreatedOn,							ModifiedBy,							ModifiedOn)
				Select
							@userId,								isnull(Location,0),					isnull(Loc_Status,0),				isnull([IsAdmin],0),					
							isnull([Backlog],1),					isnull([Backlogadmin],1),			isnull([FieldInvAdmin],0),			isnull([FieldService],0),	
							isnull([MaintenanceRequestAdmin],0),	isnull([MaintenanceRequests],0),	isnull([MaintenanceTechnician],0),	isnull([PCBLab],0),				
							isnull([PCBPRocessing],0),				isnull([PCBProcessOffice],0),		isnull([InternalLabResults],0),		isnull([LocationUser],0),			
							isnull([LocationReportUser],0),			isnull([SpecBookAdmin],0),			isnull([Specbookuser],0),			isnull([OilManagement],1),
							isnull([LogReport],1),					isnull([CheckInLog],0),				isnull([ContainerLog],0),			isnull([DashboardAdmin],0),
							isnull([DashboardUser],0),				isnull([Decom],0),					isnull([DecomHistory],0),			isnull([DecomLog],0),		
							isnull([DecomLogAdmin],0),				isnull([DecomLogUser],0),			isnull([DragonLogAdmin],0),			isnull([DragonLogUser],0),		
							isnull([InProc],0),						isnull([IsEnvChklstAdmin],0),		isnull([IsIRAdmin],0),				isnull([MapAdmin],0),				
							isnull([MapUser],0),					isnull([MetricsAdmin],0),			isnull([MetricsUser],0),			isnull([OilLog],0),
							isnull([PackageLog],0),					isnull([Paint],0),					isnull([PushLog],0),				isnull([QAAdmin],0),					
							isnull([QADock],0),						isnull([QAPAd],0),					isnull([QAPaint],0),				isnull([QAPole],0),			
							isnull([QAReceived],0),					isnull([QARecloser],0),				isnull([QARegulator],0),			isnull([QASupport],0),			
							isnull([ReadOnly],0),					isnull([SalesPortal],0),			isnull([ShippingLogAdmin],0),		isnull([ShippingLogUser],0),		
							isnull([TechRequestAdmin],0),			isnull([TechRequests],0),			isnull([TechTechnician],0),			isnull([TrailerAdmin],0),
							isnull([TrailerInProc],0),				isnull([TrailerRequest],0),			isnull([TransitionInfo],0),			isnull([WHAPCO],0),					
							isnull([WHMPCO],0),						isnull([tmpParentId],0),
							@CreatedOrModifiedBy,					getdate(),							null,								null
				FROM @UserMapping as um Where um.Loc_Status = 'A' or um.Loc_Status = 'D'
			End
			--========Update User and Mapping. Insert if in case new Location is activated for User=====================================
			Else If @IdUser > 0 And @SaveUser = 1 
			Begin
				Update u set 
							u.FIRSTNAME = sourceUsers.FirstName,		u.LASTNAME = sourceUsers.LASTNAME,			u.USERID = sourceUsers.USERID,
							u.[PASSWORD] = case when sourceUsers.[PASSWORD] <> '' then sourceUsers.[PASSWORD] else u.[Password] end,		
							u.[STATUS] = sourceUsers.[STATUS],
							u.EmailAddress = sourceUsers.EmailAddress,
							u.ModifiedBy = @CreatedOrModifiedBy,
							u.ModifiedOn = getDate()
				FROM @Users as sourceUsers
				Inner Join Users u on u.id = sourceUsers.Id where u.Id = @IdUser

				Update um set	um.Loc_Status = isnull(sourceUM.Loc_Status,0),
								um.ModifiedBy = @CreatedOrModifiedBy,
								um.ModifiedOn = getdate()
				FROM @UserMapping as sourceUM
				Inner Join UserMapping um on um.idUser = sourceUM.IdUser and um.Location = sourceUM.Location
				where um.IdUser = @IdUser

				Insert Into UserMapping(
							IDUser,									Location,							Loc_Status,							[IsAdmin],					
							[Backlog],								[Backlogadmin],						[FieldInvAdmin],					[FieldService],		
							[MaintenanceRequestAdmin],				[MaintenanceRequests],				[MaintenanceTechnician],			[PCBLab],				
							[PCBPRocessing],						[PCBProcessOffice],					[InternalLabResults],				[LocationUser],				
							[LocationReportUser],					[SpecBookAdmin],					[Specbookuser],						[OilManagement],
							[LogReport],							[CheckInLog],						[ContainerLog],						[DashboardAdmin],			
							[DashboardUser],						[Decom],							[DecomHistory],						[DecomLog],			
							[DecomLogAdmin],						[DecomLogUser],						[DragonLogAdmin],					[DragonLogUser],		
							[InProc],								[IsEnvChklstAdmin],					[IsIRAdmin],						[MapAdmin],					
							[MapUser],								[MetricsAdmin],						[MetricsUser],						[OilLog],
							[PackageLog],							[Paint],							[PushLog],							[QAAdmin],					
							[QADock],								[QAPAd],							[QAPaint],							[QAPole],			
							[QAReceived],							[QARecloser],						[QARegulator],						[QASupport],			
							[ReadOnly],								[SalesPortal],						[ShippingLogAdmin],					[ShippingLogUser],						
							[TechRequestAdmin],						[TechRequests],						[TechTechnician],					[TrailerAdmin],
							[TrailerInProc],						[TrailerRequest],					[TransitionInfo],					[WHAPCO],					
							[WHMPCO],								[tmpparentId],
							CreatedBy,								CreatedOn,							ModifiedBy,							ModifiedOn)
				Select
							@IdUser,										isnull(sourceUM.Location,0),				isnull(sourceUM.Loc_Status,0),				isnull(sourceUM.[IsAdmin],0),					
							isnull(sourceUM.[Backlog],1),					isnull(sourceUM.[Backlogadmin],1),			isnull(sourceUM.[FieldInvAdmin],0),			isnull(sourceUM.[FieldService],0),	
							isnull(sourceUM.[MaintenanceRequestAdmin],0),	isnull(sourceUM.[MaintenanceRequests],0),	isnull(sourceUM.[MaintenanceTechnician],0),	isnull(sourceUM.[PCBLab],0),				
							isnull(sourceUM.[PCBPRocessing],0),				isnull(sourceUM.[PCBProcessOffice],0),		isnull(sourceUM.[InternalLabResults],0),	isnull(sourceUM.[LocationUser],0),			
							isnull(sourceUM.[LocationReportUser],0),		isnull(sourceUM.[SpecBookAdmin],0),			isnull(sourceUM.[Specbookuser],0),			isnull(sourceUM.[OilManagement],1),
							isnull(sourceUM.[LogReport],1),					isnull(sourceUM.[CheckInLog],0),			isnull(sourceUM.[ContainerLog],0),			isnull(sourceUM.[DashboardAdmin],0),
							isnull(sourceUM.[DashboardUser],0),				isnull(sourceUM.[Decom],0),					isnull(sourceUM.[DecomHistory],0),			isnull(sourceUM.[DecomLog],0),		
							isnull(sourceUM.[DecomLogAdmin],0),				isnull(sourceUM.[DecomLogUser],0),			isnull(sourceUM.[DragonLogAdmin],0),		isnull(sourceUM.[DragonLogUser],0),		
							isnull(sourceUM.[InProc],0),					isnull(sourceUM.[IsEnvChklstAdmin],0),		isnull(sourceUM.[IsIRAdmin],0),				isnull(sourceUM.[MapAdmin],0),				
							isnull(sourceUM.[MapUser],0),					isnull(sourceUM.[MetricsAdmin],0),			isnull(sourceUM.[MetricsUser],0),			isnull(sourceUM.[OilLog],0),
							isnull(sourceUM.[PackageLog],0),				isnull(sourceUM.[Paint],0),					isnull(sourceUM.[PushLog],0),				isnull(sourceUM.[QAAdmin],0),					
							isnull(sourceUM.[QADock],0),					isnull(sourceUM.[QAPAd],0),					isnull(sourceUM.[QAPaint],0),				isnull(sourceUM.[QAPole],0),			
							isnull(sourceUM.[QAReceived],0),				isnull(sourceUM.[QARecloser],0),			isnull(sourceUM.[QARegulator],0),			isnull(sourceUM.[QASupport],0),			
							isnull(sourceUM.[ReadOnly],0),					isnull(sourceUM.[SalesPortal],0),			isnull(sourceUM.[ShippingLogAdmin],0),		isnull(sourceUM.[ShippingLogUser],0),		
							isnull(sourceUM.[TechRequestAdmin],0),			isnull(sourceUM.[TechRequests],0),			isnull(sourceUM.[TechTechnician],0),		isnull(sourceUM.[TrailerAdmin],0),
							isnull(sourceUM.[TrailerInProc],0),				isnull(sourceUM.[TrailerRequest],0),		isnull(sourceUM.[TransitionInfo],0),		isnull(sourceUM.[WHAPCO],0),					
							isnull(sourceUM.[WHMPCO],0),					isnull(sourceUM.[tmpParentId],0),
							@CreatedOrModifiedBy,							getdate(),									null,										null
				FROM @UserMapping as sourceUM
				Left Outer Join UserMapping um on um.idUser = sourceUM.IdUser and um.Location = sourceUM.Location
				where um.IdUser is null and (sourceUM.Loc_Status = 'A' or sourceUM.Loc_Status = 'D')
			End
			--========Update User Module Mapping=====================================
			Else If @IdUser > 0 And @SaveUser = 0
			Begin
				Update um set 
							um.[IsAdmin] = isnull(sourceUM.[IsAdmin],0),							
							um.[Backlog] = isnull(sourceUM.[Backlog],0),							um.[Backlogadmin] = isnull(sourceUM.[Backlogadmin],0),					
							um.[FieldInvAdmin] = isnull(sourceUM.[FieldInvAdmin],0),				um.[MaintenanceRequestAdmin] = isnull(sourceUM.[MaintenanceRequestAdmin],0),	
							um.[MaintenanceRequests] = isnull(sourceUM.[MaintenanceRequests],0),	um.[MaintenanceTechnician] = isnull(sourceUM.[MaintenanceTechnician],0),	
							um.[DashboardAdmin]= isnull(sourceUM.[DashboardAdmin],0),				um.[DashboardUser]= isnull(sourceUM.[DashboardUser],0),
							um.[PCBLab] = isnull(sourceUM.[PCBLab],0),								um.[InternalLabResults] = isnull(sourceUM.[InternalLabResults],0),		
							um.[LocationUser] = isnull(sourceUM.[LocationUser],0),					um.[LocationReportUser] = isnull(sourceUM.[LocationReportUser],0),		
							um.[SpecBookAdmin] = isnull(sourceUM.[SpecBookAdmin],0),				um.[Specbookuser] = isnull(sourceUM.[Specbookuser],0),			
							um.[OilManagement] = isnull(sourceUM.[OilManagement],0),				um.[LogReport] = isnull(sourceUM.[LogReport],0),				
							um.[ReadOnly] = isnull(sourceUM.[ReadOnly],0),
							um.ModifiedBy = @CreatedOrModifiedBy,									um.ModifiedOn = getDate()
				FROM @UserMapping as sourceUM
				Inner Join UserMapping um on um.idUser = sourceUM.IdUser and um.Location = sourceUM.Location
				where um.IdUser = @IdUser
			End
			--========Delete User and Mapping=====================================
			Else If @IdUser > 0 And @SaveUser = 2
			Begin
				Delete UserMapping Where IdUser = @IdUser
				--Delete Users where ID = @IdUser
				Update Users set IsUserObsolete = 1, Status = 'I' where ID = @IdUser --Soft Delete user to prevent data loss as User id's are used in multiple tables
			End
		Commit Tran
	End Try
	Begin Catch 
	Rollback Tran
	End Catch
END





