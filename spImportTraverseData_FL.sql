-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 24-Oct-2018
-- Description:	This SP Imports data from Traverse Server into EO system. The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_ExportJobTypes : Holds result set of Job Types return from Traverse
--				traverse_ExportCustomers : Holds result set of Customer return from Traverse
--				traverse_ExportJobsView : Holds result set of ExportsJobs_View view return from Traverse
--				Location: Location id for each location 1=fl,
/******************
NOTE: Functional logic remains the same as was written in legacy system by other vendor. 
	  This SP was created to improve performance issue which was exist in legacy system.
*******************/
-- =============================================

ALTER PROCEDURE [dbo].[spImportTraverseData_FL]
	@traverse_JobTypes traverse_ExportJobTypes Readonly,
	@traverse_ExportCustomers traverse_ExportCustomers Readonly,
	@traverse_ExportJobs traverse_ExportJobsView Readonly,
	@Location INT

AS
BEGIN
	Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Import', 'Begins Sql Process', GetDate(),@Location)
	--=========================Update/Insert Job Types=========================
	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('1', error_message(), GetDate(),@Location)
		UPDATE targetJobTypes SET targetJobTypes.[Job Type Description] = sourceJobTypes.[Descr]
		FROM @traverse_JobTypes as sourceJobTypes
		Inner Join [Job Types] as targetJobTypes ON ltrim(rtrim(targetJobTypes.[Job Type])) = ltrim(rtrim(sourceJobTypes.[JobType]))
					AND targetJobTypes.Location=@Location
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Job Types Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('2', error_message(), GetDate(),@Location)
		Insert Into [Job Types] ([Job Type], [Job Type Description],Location)
		Select sourceJobTypes.[JobType],sourceJobTypes.[Descr],@Location From @traverse_JobTypes as sourceJobTypes
		Left Outer Join [Job Types] as targetJobTypes ON ltrim(rtrim(targetJobTypes.[Job Type])) = ltrim(rtrim(sourceJobTypes.[JobType]))
		AND targetJobTypes.Location=@Location
		Where targetJobTypes.[Job Type] is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Job Types Import Failed', error_message(), GetDate(),@Location)
	End catch
	
	--=========================Update/Insert Customers=========================
	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('3', error_message(), GetDate(),@Location)
		UPDATE targetCustomer set targetCustomer.[Cust_Name] = sourceCustomer.[CustName]
		FROM @traverse_ExportCustomers as sourceCustomer
		Inner Join [cust] as targetCustomer ON ltrim(rtrim(targetCustomer.[Customer_NBR])) = ltrim(rtrim(sourceCustomer.[CustId]))
												and targetCustomer.idLocation=@Location
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Customers Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('4', error_message(), GetDate(),@Location)
		INSERT Into [cust] ([Customer_NBR], [Cust_Name],idLocation,Location) 
		Select sourceCustomer.[CustId], sourceCustomer.[CustName],@Location,@Location From @traverse_ExportCustomers as sourceCustomer
		Left Outer Join [cust] as targetCustomer ON ltrim(rtrim(targetCustomer.[Customer_NBR])) = ltrim(rtrim(sourceCustomer.[CustId]))
		and targetCustomer.idLocation=@Location
		Where targetCustomer.[Customer_NBR] is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Customers Import Failed', error_message(), GetDate(),@Location)
	End Catch

	--=========================Update/Insert UnitData=========================
	Begin Try
		--First deactivate all barcodes then activate only those barcodes which do exist in traverse. 
		--This is required as there are cases where Barcodes from Traverse are getting deleted after data are imported into EO.
		--This logic was already there in all code as well
		Update UnitData set UnitStatus = 0 where UnitData.Location=@Location

		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('5', error_message(), GetDate(),@Location)
		Update targetUnitData
			SET	targetUnitData.[Job Type] = sourceExportJobs.[Job Type], targetUnitData.[KVA] = sourceExportJobs.[KVA],
				targetUnitData.[PRI_VOLT] = sourceExportJobs.[PRI_VOLT], targetUnitData.[SEC_VOLT] = sourceExportJobs.[SEC_VOLT],
				targetUnitData.[Serial Number] = sourceExportJobs.[Serial Number], targetUnitData.[Customer Number] = sourceExportJobs.[Customer Number],
				targetUnitData.[Type] = sourceExportJobs.[Type], targetUnitData.[Volts] = sourceExportJobs.[Volts],
				targetUnitData.[Amps] = sourceExportJobs.[Amps], 
				--targetUnitData.[Dept Code] = Case when sourceExportJobs.[Dept Code] = 'Decom' then '02' else '01' end,
				targetUnitData.[Dept Code] =  sourceExportJobs.[Dept Code],
				targetUnitData.[imp] = sourceExportJobs.[imp], targetUnitData.[MFGR] = sourceExportJobs.[MFGR],
				targetUnitData.[TAPS] = sourceExportJobs.[TAPS], 
				targetUnitData.[CORE LBS] = sourceExportJobs.[CORE LBS],
				targetUnitData.[W_PANEL_WITH] = sourceExportJobs.[W_PANEL_WITH],
				targetUnitData.[PANEL_SER] = sourceExportJobs.[PANEL_SER], targetUnitData.[LOOP_RAD] = sourceExportJobs.[LOOP_RAD],
				targetUnitData.[desc] = sourceExportJobs.[desc], targetUnitData.[BUSH_CNT] = sourceExportJobs.[BUSH_CNT],
				targetUnitData.[J_OTIME_FLAG] = sourceExportJobs.[J_OTIME_FLAG], targetUnitData.[est first] = sourceExportJobs.[est first],
				targetUnitData.[TEST DATE] = case when ISDate(sourceExportJobs.[TEST DATE]) = 1 then sourceExportJobs.[TEST DATE] else null end, 
				targetUnitData.[uTestDate] = case when ISDate(sourceExportJobs.[TEST DATE]) = 1 then sourceExportJobs.[TEST DATE] else null end, 
				targetUnitData.[Paint DATE] = case when ISDate(sourceExportJobs.[Paint DATE]) = 1 then sourceExportJobs.[Paint DATE] else null end,
				targetUnitData.[uPaintDATE] = case when ISDate(sourceExportJobs.[Paint DATE]) = 1 then sourceExportJobs.[Paint DATE] else null end,
				targetUnitData.[Decom Date] = case when ISDate(sourceExportJobs.[Decom Date]) = 1 then sourceExportJobs.[Decom Date] else null end, 
				targetUnitData.[uDecomDate] = case when ISDate(sourceExportJobs.[Decom Date]) = 1 then sourceExportJobs.[Decom Date] else null end, 
				targetUnitData.[Promise Date] = case when ISDate(sourceExportJobs.[Promise Date]) = 1 then sourceExportJobs.[Promise Date] else null end,
				targetUnitData.[RECEIVED DATE] = case when ISDate(sourceExportJobs.[RECEIVED DATE]) = 1 then sourceExportJobs.[RECEIVED DATE] else null end, 
				targetUnitData.[Ship Date] = case when ISDate(sourceExportJobs.[Ship Date]) = 1 then sourceExportJobs.[Ship Date] else null end,
				targetUnitData.[uShipDate] = case when targetUnitData.[uShipDate] is null or  targetUnitData.[uShipDate] = '' 
												then 
												case when ISDate(sourceExportJobs.[Ship Date]) = 1 
												then sourceExportJobs.[Ship Date] else null end 
												else
												targetUnitData.[uShipDate] end,	
				targetUnitData.[EstComplete] = case when ISDate(sourceExportJobs.[EST. COMPLETED DATE]) = 1 then sourceExportJobs.[EST. COMPLETED DATE] else null end, 
				targetUnitData.[EstApproved] = case when ISDate(sourceExportJobs.[EST. Approved DATE]) = 1 then sourceExportJobs.[EST. Approved DATE] else null end,
				targetUnitData.[FullWeight] = sourceExportJobs.[FullWeight], 
				targetUnitData.[PODDate] = case when ISDate(sourceExportJobs.[PODDate]) = 1 then sourceExportJobs.[PODDate] else null end, 
				targetUnitData.[Gallons] = sourceExportJobs.[Gallons], targetUnitData.[CarcassWeightLB] = sourceExportJobs.[CarcassWeightLB],
				targetUnitData.[TransDate] = case when ISDate(sourceExportJobs.[TransDate]) = 1 then sourceExportJobs.[TransDate] else null end, 
				targetUnitData.[PCBPPM] = sourceExportJobs.[PCBPPM],
				targetUnitData.[RFSDATE] = case when ISDate(sourceExportJobs.[RFSDATE]) = 1 then sourceExportJobs.[RFSDATE] else null end,
				targetUnitData.[CertNo] = sourceExportJobs.[CertNo], targetUnitData.[ServiceType] = sourceExportJobs.[ServiceType],
				/*Tanklog*/
				targetUnitData.[TankNumber] = sourceExportJobs.[TankNumber], targetUnitData.[JobTypeDescr] = sourceExportJobs.[JobTypeDescr],
				targetUnitData.[GallonsOilFlush] = sourceExportJobs.[GallonsOilFlush], targetUnitData.[CarcassWeightKG] = sourceExportJobs.[CarcassWeightKG],
				targetUnitData.[OilManifestDate] = case when ISDate(sourceExportJobs.[OilManifestDate]) = 1 then sourceExportJobs.[OilManifestDate] else null end, 
				targetUnitData.[OilManifestNo] = sourceExportJobs.[OilManifestNo],
				
				targetUnitData.[TransType] = sourceExportJobs.[TransType], targetUnitData.[BatchCode] = sourceExportJobs.[BatchId],
				targetUnitData.[Startdate] = case when ISDate(sourceExportJobs.[Startdate]) = 1 then sourceExportJobs.[Startdate] else null end , 
				targetUnitData.[Is Warranty] = sourceExportJobs.[Is Warranty],
				targetUnitData.[FieldInventoryYn] = sourceExportJobs.[FieldInventoryYn],
				targetUnitData.[CHECK IN DATE] = sourceExportJobs.[CHECK IN DATE],
				targetUnitData.[UnitStatus] = 1
				FROM @traverse_ExportJobs as sourceExportJobs
				Inner Join UnitData  as targetUnitData with(nolock) ON ltrim(rtrim(targetUnitData.Barcode)) = ltrim(rtrim(sourceExportJobs.[JOB NUMBER]))
														and targetUnitData.Location=@Location
		End Try
		Begin Catch
			Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Units Data Update Failed', error_message(), GetDate(),@Location)
		End Catch
		
		Begin Try
			--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('6', error_message(), GetDate(),@Location)
			Insert INTO UnitData (
				[Barcode], [Job Type], [KVA], [PRI_VOLT], [SEC_VOLT], [Serial Number], 
				[Customer Number], [Type], [Volts], [Amps], 
				[Dept Code], 
				[imp], [MFGR], [TAPS], [CORE LBS], [W_PANEL_WITH], [PANEL_SER], 
				[LOOP_RAD], [desc], [BUSH_CNT], [J_OTIME_FLAG], [est first], 
				[TEST DATE], 
				[uTestDate],
				[Paint DATE], 
				[uPaintDate],
				[Decom Date],
				[uDecomDate],
				[Promise Date],
				[RECEIVED DATE],
				[Ship Date],
				[uShipDate], 
				[EstComplete],
				[EstApproved],
				[FullWeight], 
				[PODDate],
				[Gallons], [CarcassWeightLB], 
				[TransDate],
				[PCBPPM], 
				[RFSDate],
				[CertNo], [ServiceType], 
				/*Tank log*/
				[TankNumber], [JobTypeDescr], [GallonsOilFlush], 
				[CarcassWeightKG],
				[OilManifestDate],
				[OilManifestNo], 
				
				[TransType], [BatchCode], 
				[Startdate],
				[Is Warranty], [FieldInventoryYn], [UnitStatus], [Location],
				[CHECK IN DATE])
			Select 
				sourceExportJobs.[Job Number], sourceExportJobs.[Job Type], sourceExportJobs.[KVA], sourceExportJobs.[PRI_VOLT], sourceExportJobs.[SEC_VOLT], sourceExportJobs.[Serial Number], 
				sourceExportJobs.[Customer Number], sourceExportJobs.[Type], sourceExportJobs.[Volts], sourceExportJobs.[Amps], 
				--Case when sourceExportJobs.[Dept Code] = 'Decom' then '02' else '01' end,
				sourceExportJobs.[Dept Code],
				sourceExportJobs.[imp], sourceExportJobs.[MFGR], sourceExportJobs.[TAPS], sourceExportJobs.[CORE LBS], sourceExportJobs.[W_PANEL_WITH], sourceExportJobs.[PANEL_SER],
				sourceExportJobs.[LOOP_RAD], sourceExportJobs.[desc], sourceExportJobs.[BUSH_CNT], sourceExportJobs.[J_OTIME_FLAG], sourceExportJobs.[est first],
				case when ISDate(sourceExportJobs.[TEST DATE]) = 1 then sourceExportJobs.[TEST DATE] else null end,
				case when ISDate(sourceExportJobs.[TEST DATE]) = 1 then sourceExportJobs.[TEST DATE] else null end, --for uTestDate
				case when ISDate(sourceExportJobs.[Paint DATE]) = 1 then sourceExportJobs.[Paint DATE] else null end,
				case when ISDate(sourceExportJobs.[Paint DATE]) = 1 then sourceExportJobs.[Paint DATE] else null end, --for uPaintDate
				case when ISDate(sourceExportJobs.[Decom Date]) = 1 then sourceExportJobs.[Decom Date] else null end,
				case when ISDate(sourceExportJobs.[Decom Date]) = 1 then sourceExportJobs.[Decom Date] else null end, --for uDecomDate
				case when ISDate(sourceExportJobs.[Promise Date]) = 1 then sourceExportJobs.[Promise Date] else null end,
				case when ISDate(sourceExportJobs.[RECEIVED DATE]) = 1 then sourceExportJobs.[RECEIVED DATE] else null end,
				case when ISDate(sourceExportJobs.[Ship Date]) = 1 then sourceExportJobs.[Ship Date] else null end,
				case when targetUnitData.[uShipDate] is null or  targetUnitData.[uShipDate] = '' --for uShipDate 
												then 
												case when ISDate(sourceExportJobs.[Ship Date]) = 1 
												then sourceExportJobs.[Ship Date] else null end 
												else
												targetUnitData.[uShipDate] end,	
				case when ISDate(sourceExportJobs.[EST. COMPLETED DATE]) = 1 then sourceExportJobs.[EST. COMPLETED DATE] else null end,
				case when ISDate(sourceExportJobs.[EST. Approved DATE]) = 1 then sourceExportJobs.[EST. Approved DATE] else null end,
				sourceExportJobs.[FullWeight], 
				case when ISDate(sourceExportJobs.[PODDate]) = 1 then sourceExportJobs.[PODDate] else null end,
				sourceExportJobs.[Gallons], sourceExportJobs.[CarcassWeightLB],
				case when ISDate(sourceExportJobs.[TransDate]) = 1 then sourceExportJobs.[TransDate] else null end,
				sourceExportJobs.[PCBPPM], --targetUnitData.[LocID] column does not exist in UnitData table
				case when ISDate(sourceExportJobs.[RFSDate]) = 1 then sourceExportJobs.[RFSDate] else null end,
				sourceExportJobs.[CertNo], sourceExportJobs.[ServiceType], 

				/* Tank log*/
				sourceExportJobs.[TankNumber], sourceExportJobs.[JobTypeDescr], sourceExportJobs.[GallonsOilFlush],
				sourceExportJobs.[CarcassWeightKG],
				case when ISDate(sourceExportJobs.[OilManifestDate]) = 1 then sourceExportJobs.[OilManifestDate] else null end,
				sourceExportJobs.[OilManifestNo], 
				

				sourceExportJobs.[TransType], sourceExportJobs.[BatchId],
				case when ISDate(sourceExportJobs.[Startdate]) = 1 then sourceExportJobs.[Startdate] else null end,
				sourceExportJobs.[Is Warranty], sourceExportJobs.[FieldInventoryYn], 1, @Location,
				sourceExportJobs.[CHECK IN DATE]
			FROM @traverse_ExportJobs as sourceExportJobs 
			Left Outer Join UnitData as targetUnitData with(nolock) ON ltrim(rtrim(targetUnitData.Barcode)) = ltrim(rtrim(sourceExportJobs.[JOB NUMBER])) 
			and targetUnitData.Location=@Location
			Where targetUnitData.Barcode is null
		End Try
		Begin Catch
			Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Units Data Import Failed', error_message(), GetDate(),@Location)
		End Catch

	--=========================Update/Insert PCBBermACS=========================
	Begin Try
		--To process only those records whose PCBPPM>49.99 or ServiceType is 'PCB'
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('7', error_message(), GetDate(),@Location)
		Select * into #tmpTraverseExportJobsPCB from @traverse_ExportJobs where (PCBPPM > 49.99 or ServiceType = 'PCB') 
		UPDATE targetPCBBermACS
			SET	targetPCBBermACS.[SerialNumber] = sourceExportJobsPCB.[Serial Number], targetPCBBermACS.[KVA] = sourceExportJobsPCB.[KVA],
				targetPCBBermACS.[AMPS] = sourceExportJobsPCB.[AMPS], targetPCBBermACS.[Weight] = sourceExportJobsPCB.[LBS],
				targetPCBBermACS.[Impedance] = sourceExportJobsPCB.[IMP], targetPCBBermACS.[Job_Type] = sourceExportJobsPCB.[Job Type],
				targetPCBBermACS.[PrimaryVoltage] = sourceExportJobsPCB.[PRI_VOLT], targetPCBBermACS.[SecondaryVoltage] = sourceExportJobsPCB.[SEC_VOLT],
				targetPCBBermACS.[Manufacturer] = sourceExportJobsPCB.[MFGR], targetPCBBermACS.[TAPS] = sourceExportJobsPCB.[TAPS],
				targetPCBBermACS.[Type] = sourceExportJobsPCB.[TYPE], targetPCBBermACS.[Loop_Rad] = sourceExportJobsPCB.[Loop_Rad],
				targetPCBBermACS.[CustomerNumber] = sourceExportJobsPCB.[Customer Number], 
				targetPCBBermACS.[PickupDate] = case when ISDate(sourceExportJobsPCB.[Received Date]) = 1 then sourceExportJobsPCB.[Received Date] else null end,
				targetPCBBermACS.[Volts] = sourceExportJobsPCB.[Volts],
				/*Tank related*/
				targetPCBBermACS.[TankNumber] = sourceExportJobsPCB.[TankNumber],
				targetPCBBermACS.[JobTypeDescr] = sourceExportJobsPCB.[JobTypeDescr],
				targetPCBBermACS.[GallonsOilFlush] = sourceExportJobsPCB.[GallonsOilFlush],
				targetPCBBermACS.[CarcassWeightKG] = sourceExportJobsPCB.[CarcassWeightKG]--,
		FROM #tmpTraverseExportJobsPCB as sourceExportJobsPCB
		Inner Join PCBBermACS as targetPCBBermACS ON ltrim(rtrim(targetPCBBermACS.Barcode)) = ltrim(rtrim(sourceExportJobsPCB.[JOB NUMBER]))
						AND targetPCBBermACS.Location=@Location
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('PCBBermACS Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('8', error_message(), GetDate(),@Location)
		Insert Into PCBBermACS(
			[Barcode], [SerialNumber], [KVA], [AMPS], [Weight], 
			[Impedance], [Job_Type], [PrimaryVoltage], [SecondaryVoltage], [Manufacturer], 
			[Taps], [Type], [Loop_Rad], [CustomerNumber], 
			[PickupDate], 
			[Volts], [Description], 
			[rec_date], 
			[TankNumber], [JobTypeDescr], [GallonsOilFlush], [CarcassWeightKG],
			Location) 
		Select
			sourceExportJobsPCB.[Job Number], sourceExportJobsPCB.[Serial Number], sourceExportJobsPCB.[KVA], sourceExportJobsPCB.[AMPS], sourceExportJobsPCB.[LBS],
			sourceExportJobsPCB.[IMP], sourceExportJobsPCB.[Job Type], sourceExportJobsPCB.[PRI_VOLT], sourceExportJobsPCB.[SEC_VOLT], sourceExportJobsPCB.[MFGR],
			sourceExportJobsPCB.[Taps], sourceExportJobsPCB.[Type], sourceExportJobsPCB.[Loop_Rad], sourceExportJobsPCB.[Customer Number], 
			case when ISDate(sourceExportJobsPCB.[Received Date]) = 1 then sourceExportJobsPCB.[Received Date] else null end,
			sourceExportJobsPCB.[Volts], sourceExportJobsPCB.[Desc], 
			case when ISDate(sourceExportJobsPCB.[Received Date]) = 1 then sourceExportJobsPCB.[Received Date] else null end,
			/*Tank Changes*/
			sourceExportJobsPCB.[TankNumber], sourceExportJobsPCB.[JobTypeDescr], sourceExportJobsPCB.[GallonsOilFlush], sourceExportJobsPCB.[CarcassWeightKG],
			@Location
		FROM #tmpTraverseExportJobsPCB as sourceExportJobsPCB 
		Left Outer Join PCBBermACS as targetPCBBermACS ON ltrim(rtrim(targetPCBBermACS.Barcode)) = ltrim(rtrim(sourceExportJobsPCB.[JOB NUMBER])) 
		AND targetPCBBermACS.Location=@Location
		Where targetPCBBermACS.Barcode is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('PCBBermACS Import Failed', error_message(), GetDate(),@Location)
	End Catch

	--=========================Update/Insert PCBBermLog=========================
	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('9', error_message(), GetDate(),@Location)
		UPDATE targetPCBBermLog 
			SET	targetPCBBermLog.[SerialNumber] = sourceExportJobsPCBLog.[Serial Number], targetPCBBermLog.[KVA] = sourceExportJobsPCBLog.[KVA],
				targetPCBBermLog.[InitialWeight] = sourceExportJobsPCBLog.[LBS], targetPCBBermLog.[CustomerNumber] = sourceExportJobsPCBLog.[Customer Number], 
				targetPCBBermLog.[PickupDate] = case when ISDate(sourceExportJobsPCBLog.[Received Date]) = 1 then sourceExportJobsPCBLog.[Received Date] else null end,
				targetPCBBermLog.[ASD] = case when ISDate(sourceExportJobsPCBLog.[TestDate]) = 1 then sourceExportJobsPCBLog.[TestDate] else null end
		FROM #tmpTraverseExportJobsPCB as sourceExportJobsPCBLog
		Inner Join PCBBermLog as targetPCBBermLog ON ltrim(rtrim(targetPCBBermLog.Barcode)) = ltrim(rtrim(sourceExportJobsPCBLog.[JOB NUMBER]))
													and targetPCBBermLog.Location=@Location
	End Try
	Begin Catch 
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('PCBBermLog Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('10', error_message(), GetDate(),@Location)
		INSERT Into PCBBermLog (
			[Barcode], [SerialNumber], [PPM], [DateStamp], [CustomerNumber], 
			[InitialWeight], [ASD], [KVA],
			[PickUpDate],
			Location) 
		Select
			sourceExportJobsPCBLog.[Job Number], sourceExportJobsPCBLog.[Serial Number], sourceExportJobsPCBLog.[PCBPPM], getdate(), sourceExportJobsPCBLog.[Customer Number],
			sourceExportJobsPCBLog.[LBS], sourceExportJobsPCBLog.[TestDate], sourceExportJobsPCBLog.[KVA],
			case when ISDate(sourceExportJobsPCBLog.[Received Date]) = 1 then sourceExportJobsPCBLog.[Received Date] else null end,
			@Location
		FROM #tmpTraverseExportJobsPCB as sourceExportJobsPCBLog 
		Left Outer Join PCBBermLog as targetPCBBermLog ON ltrim(rtrim(targetPCBBermLog.Barcode)) = ltrim(rtrim(sourceExportJobsPCBLog.[JOB NUMBER])) 
		and targetPCBBermLog.Location=@Location
		Where targetPCBBermLog.Barcode is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('PCBBermLog Import Failed', error_message(), GetDate(),@Location)
	End Catch

	--=========================Update/Insert NonPCBBermACS=========================
	Begin Try
		--To process only those records whose PCBPPM < 49.99 or ServiceType is 'D'
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('11', error_message(), GetDate(),@Location)
		Select * into #tmpTraverseExportJobsNonPCB from @traverse_ExportJobs where (PCBPPM < 49.99 or ServiceType = 'D')
		
		UPDATE targetNonPCBBermACS
			SET	targetNonPCBBermACS.[SerialNumber] = sourceExportJobsNonPCB.[Serial Number], targetNonPCBBermACS.[KVA] = sourceExportJobsNonPCB.[KVA],
				targetNonPCBBermACS.[AMPS] = sourceExportJobsNonPCB.[AMPS], targetNonPCBBermACS.[Weight] = sourceExportJobsNonPCB.[LBS],
				targetNonPCBBermACS.[Impedance] = sourceExportJobsNonPCB.[IMP], targetNonPCBBermACS.[Job_Type] = sourceExportJobsNonPCB.[Job Type],
				targetNonPCBBermACS.[PrimaryVoltage] = sourceExportJobsNonPCB.[PRI_VOLT], targetNonPCBBermACS.[SecondaryVoltage] = sourceExportJobsNonPCB.[SEC_VOLT],
				targetNonPCBBermACS.[Manufacturer] = sourceExportJobsNonPCB.[MFGR], targetNonPCBBermACS.[TAPS] = sourceExportJobsNonPCB.[TAPS],
				targetNonPCBBermACS.[Type] = sourceExportJobsNonPCB.[TYPE], targetNonPCBBermACS.[Loop_Rad] = sourceExportJobsNonPCB.[Loop_Rad],
				targetNonPCBBermACS.[CustomerNumber] = sourceExportJobsNonPCB.[Customer Number], 
				targetNonPCBBermACS.[PickupDate] = case when ISDate(sourceExportJobsNonPCB.[Received Date]) = 1 then sourceExportJobsNonPCB.[Received Date] else null end,
				targetNonPCBBermACS.[Volts] = sourceExportJobsNonPCB.[Volts],
				targetNonPCBBermACS.[TankNumber] = sourceExportJobsNonPCB.[TankNumber],
				targetNonPCBBermACS.[JobTypeDescr] = sourceExportJobsNonPCB.[JobTypeDescr],
				targetNonPCBBermACS.[GallonsOilFlush] = sourceExportJobsNonPCB.[GallonsOilFlush],
				targetNonPCBBermACS.[CarcassWeightKG] = sourceExportJobsNonPCB.[CarcassWeightKG]
		FROM #tmpTraverseExportJobsNonPCB as sourceExportJobsNonPCB
		Inner Join NonPCBBermACS as targetNonPCBBermACS ON ltrim(rtrim(targetNonPCBBermACS.Barcode)) = ltrim(rtrim(sourceExportJobsNonPCB.[JOB NUMBER]))
														and targetNonPCBBermACS.Location=@Location
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('NonPCBBermACS Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('12', error_message(), GetDate(),@Location)
		Insert Into NonPCBBermACS(
			[Barcode], [SerialNumber], [KVA], [AMPS], [Weight], 
			[Impedance], [Job_Type], [PrimaryVoltage], [SecondaryVoltage], [Manufacturer], 
			[Taps], [Type], [Loop_Rad], [CustomerNumber], 
			[PickupDate], 
			[Volts], [Description], 
			[rec_date], 
			[TankNumber], [JobTypeDescr], [GallonsOilFlush], [CarcassWeightKG], 
			Location) 
		Select
			sourceExportJobsNonPCB.[Job Number], sourceExportJobsNonPCB.[Serial Number], sourceExportJobsNonPCB.[KVA], sourceExportJobsNonPCB.[AMPS], sourceExportJobsNonPCB.[LBS],
			sourceExportJobsNonPCB.[IMP], sourceExportJobsNonPCB.[Job Type], sourceExportJobsNonPCB.[PRI_VOLT], sourceExportJobsNonPCB.[SEC_VOLT], sourceExportJobsNonPCB.[MFGR],
			sourceExportJobsNonPCB.[Taps], sourceExportJobsNonPCB.[Type], sourceExportJobsNonPCB.[Loop_Rad], sourceExportJobsNonPCB.[Customer Number], 
			case when ISDate(sourceExportJobsNonPCB.[Received Date]) = 1 then sourceExportJobsNonPCB.[Received Date] else null end,
			sourceExportJobsNonPCB.[Volts], sourceExportJobsNonPCB.[Desc], 
			case when ISDate(sourceExportJobsNonPCB.[Received Date]) = 1 then sourceExportJobsNonPCB.[Received Date] else null end,
			sourceExportJobsNonPCB.[TankNumber], sourceExportJobsNonPCB.[JobTypeDescr], sourceExportJobsNonPCB.[GallonsOilFlush], sourceExportJobsNonPCB.[CarcassWeightKG],
			@Location
		FROM #tmpTraverseExportJobsNonPCB as sourceExportJobsNonPCB 
		Left Outer Join NonPCBBermACS as targetNonPCBBermACS ON ltrim(rtrim(targetNonPCBBermACS.Barcode)) = ltrim(rtrim(sourceExportJobsNonPCB.[JOB NUMBER])) 
		and targetNonPCBBermACS.Location=@Location
		Where targetNonPCBBermACS.Barcode is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('NonPCBBermACS Import Failed', error_message(), GetDate(),@Location)
	End Catch

	--=========================Update/Insert NonPCBBermLog=========================
	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('13', error_message(), GetDate(),@Location)
		UPDATE targetNonPCBBermLog 
			SET	targetNonPCBBermLog.[SerialNumber] = sourceExportJobsNonPCBLog.[Serial Number], targetNonPCBBermLog.[KVA] = sourceExportJobsNonPCBLog.[KVA],
				targetNonPCBBermLog.[InitialWeight] = sourceExportJobsNonPCBLog.[LBS], targetNonPCBBermLog.[CustomerNumber] = sourceExportJobsNonPCBLog.[Customer Number], 
				targetNonPCBBermLog.[PickupDate] = case when ISDate(sourceExportJobsNonPCBLog.[Received Date]) = 1 then sourceExportJobsNonPCBLog.[Received Date] else null end,
				targetNonPCBBermLog.[ASD] = case when ISDate(sourceExportJobsNonPCBLog.[TestDate]) = 1 then sourceExportJobsNonPCBLog.[TestDate] else null end
		FROM #tmpTraverseExportJobsNonPCB as sourceExportJobsNonPCBLog
		Inner Join NonPCBBermLog as targetNonPCBBermLog ON ltrim(rtrim(targetNonPCBBermLog.Barcode)) = ltrim(rtrim(sourceExportJobsNonPCBLog.[JOB NUMBER]))
														and targetNonPCBBermLog.Location=@Location
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('NonPCBBermLog Update Failed', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('14', error_message(), GetDate(),@Location)
		INSERT Into NonPCBBermLog (
			[Barcode], [SerialNumber], [PPM], [DateStamp], [CustomerNumber], 
			[InitialWeight], [ASD], [KVA],
			[PickUpDate],
			Location) 
		Select
			sourceExportJobsNonPCBLog.[Job Number], sourceExportJobsNonPCBLog.[Serial Number], sourceExportJobsNonPCBLog.[PCBPPM], getdate(), sourceExportJobsNonPCBLog.[Customer Number],
			sourceExportJobsNonPCBLog.[LBS], sourceExportJobsNonPCBLog.[TestDate], sourceExportJobsNonPCBLog.[KVA],
			case when ISDate(sourceExportJobsNonPCBLog.[Received Date]) = 1 then sourceExportJobsNonPCBLog.[Received Date] else null end,
			@Location
		FROM #tmpTraverseExportJobsNonPCB as sourceExportJobsNonPCBLog 
		Left Outer Join NonPCBBermLog as targetNonPCBBermLog ON ltrim(rtrim(targetNonPCBBermLog.Barcode)) = ltrim(rtrim(sourceExportJobsNonPCBLog.[JOB NUMBER])) 
													and targetNonPCBBermLog.Location=@Location
		Where targetNonPCBBermLog.Barcode is null
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('NonPCBBermLog Import Failed', error_message(), GetDate(),@Location)
	End Catch

	--=========================Insert Inventory=========================
	Begin Try
		--Process only those data whose ServiceType = 'R' and TransType = 'Approved' and location =1 and MovedToFI = 0. 
		--These condition are newly added by replacing earlier ones as mentioned below. The below condition are taken from MS location
		--	(MovedToFI = 0) AND ([Dept Code] = '00') AND (Barcode IS NOT NULL) AND ([Job Type] IS NOT NULL) AND (KVA IS NOT NULL) AND ([RECEIVED DATE] IS NOT NULL) AND 
		--	(PRI_VOLT IS NOT NULL) AND (SEC_VOLT IS NOT NULL) AND ([Serial Number] IS NOT NULL) AND ([Customer Number] IS NOT NULL) AND (Type IS NOT NULL) AND 
		--	(AMPS IS NOT NULL) AND ([Dept Code] IS NOT NULL) AND (MFGR IS NOT NULL) AND (TAPS IS NOT NULL) AND (LOOP_RAD IS NOT NULL) AND (IMP IS NOT NULL) AND 
		--	(Comments IS NOT NULL) AND (Front IS NOT NULL) AND (TankType IS NOT NULL) AND (EOK IS NOT NULL)

		-- It only Insert the data from UnitData table and after inserting it update MovedToFI flag to 1 to avoid reprocessing data from UnitData table.
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('15', error_message(), GetDate(),@Location)
		Select   * into #tmpInvSourceData from (	SELECT Barcode, [Job Type], case when KVA is null then '0' when KVA = '' then '0' else KVA end as KVA, [RECEIVED DATE],
												case when PRI_VOLT Is null then ' ' when PRI_VOLT = '' then ' ' else PRI_VOLT end as PRI_VOLT, case when SEC_VOLT is null
												then ' ' when SEC_VOLT ='' then ' '  else SEC_VOLT end as SEC_VOLT, [Serial Number], [Customer Number], Type, Volts, AMPS, [Dept Code],
												case when mfgr Is null then ' '  when mfgr='' then ' ' else mfgr end as MFGR, TAPS, LOOP_RAD, IMP, [DESC], Comments, Front, TankType,
												EOK, UnitId, ServiceType, TransType, BatchCode,FieldInventoryYn, Row_Number() over (order by Barcode) as RowNum 
												FROM UnitData with(nolock) WHERE ServiceType = 'R' and TransType = 'Approved'
												and location =@Location and ISNULL(MovedToFI,0) = 0 and UnitStatus = 1
											)a
		Declare @TotalRows as int = 0
		Declare @CurRecord as int = 1
		Declare @BarCode as varchar(100)
		Select @TotalRows = count(*) from #tmpInvSourceData

		--ForUseIn Fields from StoredValues table. 
		--The below variables is to hold ID returned from StoredValues table which can later be inserted into inventory table
		Declare @jobtype as int
		Declare @kva as int
		Declare @PrimaryVoltage as int
		Declare @SecondaryVoltage as int
		Declare @UnitType as int
		Declare @Amps as int
		Declare @MFGR as int
		Declare @Taps as int
		Declare @LoopRadial as int
		Declare @Front as int
		Declare @TankType as int
		Declare @EOK as int
		Declare @RecCount as int
		
		Select * into #tempStoredValues from StoredValues with(nolock) where Location=@Location
		and ForUseIn in ( 'JobType','kva','PrimaryVoltage','SecondaryVoltage','UnitType','Amps','Taps','LoopRadial','Front','TankType','EOK')

		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('16', error_message(), GetDate(),@Location)
		While @TotalRows >= @CurRecord
		Begin
			Select @Barcode = Barcode from #tmpInvSourceData where RowNum = @CurRecord

			--Select	@jobtype= svJobType.Id 
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svJobType on ltrim(rtrim(svJobType.Value)) = ltrim(rtrim(tsd.[Job Type])) and svJobType.ForUseIn = 'JobType' and svJobType.Location=@Location

			--Select	@PrimaryVoltage = svPrimaryVoltage.Id 
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svPrimaryVoltage on ltrim(rtrim(svPrimaryVoltage.[Description])) = ltrim(rtrim(tsd.[PRI_VOLT])) and svPrimaryVoltage.ForUseIn = 'PrimaryVoltage' and svPrimaryVoltage.Location=@Location

			--Select	@kva = svKva.Id 
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svKva on ltrim(rtrim(svKva.[Description])) = ltrim(rtrim(tsd.[KVA])) and svKva.ForUseIn = 'kva' and svKva.Location=@Location

			--Select	@SecondaryVoltage = svSecondaryVoltage.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svSecondaryVoltage on ltrim(rtrim(svSecondaryVoltage.[Description])) = ltrim(rtrim(tsd.[SEC_VOLT])) and svSecondaryVoltage.ForUseIn = 'SecondaryVoltage' and svSecondaryVoltage.Location=@Location

			--Select	@UnitType = svUnitType.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svUnitType on ltrim(rtrim(svUnitType.[Description])) = ltrim(rtrim(tsd.[Type])) and svUnitType.ForUseIn = 'UnitType' and svUnitType.Location=@Location

			--Select	@Amps = svAmps.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svAmps on ltrim(rtrim(svAmps.[Description])) = ltrim(rtrim(tsd.[Amps])) and svAmps.ForUseIn = 'Amps' and svAmps.Location=@Location

			--Select	@Taps = svTaps.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svTaps on ltrim(rtrim(svTaps.[Description])) = ltrim(rtrim(tsd.[Taps])) and svTaps.ForUseIn = 'Taps' and svTaps.Location=@Location

			--Select	@LoopRadial = svLoopRadial.Id 
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svLoopRadial on ltrim(rtrim(svLoopRadial.[Description])) = ltrim(rtrim(tsd.[Loop_Rad])) and svLoopRadial.ForUseIn = 'LoopRadial' and svLoopRadial.Location=@Location

			--Select	@Front = svFront.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svFront on ltrim(rtrim(svFront.[Description])) = ltrim(rtrim(tsd.[Front])) and svFront.ForUseIn = 'Front' and svFront.Location=@Location

			--Select	@TankType = svTankType.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svTankType on ltrim(rtrim(svTankType.[Description])) = ltrim(rtrim(tsd.[TankType])) and svTankType.ForUseIn = 'TankType' and svTankType.Location=@Location

			--Select	@EOK = svEOK.Id
			--from (Select * from #tmpInvSourceData where RowNum = @CurRecord)  tsd
			--left outer join #tempStoredValues svEOK on ltrim(rtrim(svEOK.[Description])) = ltrim(rtrim(tsd.[EOK])) and svEOK.ForUseIn = 'EOK' and svEOK.Location=@Location

			Select	@jobtype = svJobType.Id,
					@kva = svKva.Id,
					@PrimaryVoltage = svPrimaryVoltage.Id,
					@SecondaryVoltage = svSecondaryVoltage.Id,
					@UnitType = svUnitType.Id,
					@Amps = svAmps.Id,
					@Taps = svTaps.Id,
					@LoopRadial = svLoopRadial.Id,
					@Front = svFront.Id,
					@TankType = svTankType.Id,
					@EOK = svEOK.Id 
			from (Select * from #tmpInvSourceData where RowNum = @CurRecord) tsd
			left outer join #tempStoredValues svJobType on ltrim(rtrim(svJobType.Value)) = ltrim(rtrim(tsd.[Job Type])) and svJobType.ForUseIn = 'JobType' and svJobType.Location=@Location
			left outer join #tempStoredValues svKva on ltrim(rtrim(svKva.[Description])) = ltrim(rtrim(tsd.[KVA])) and svKva.ForUseIn = 'kva' and svKva.Location=@Location
			left outer join #tempStoredValues svPrimaryVoltage on ltrim(rtrim(svPrimaryVoltage.[Description])) = ltrim(rtrim(tsd.[PRI_VOLT])) and svPrimaryVoltage.ForUseIn = 'PrimaryVoltage' and svPrimaryVoltage.Location=@Location
			left outer join #tempStoredValues svSecondaryVoltage on ltrim(rtrim(svSecondaryVoltage.[Description])) = ltrim(rtrim(tsd.[SEC_VOLT])) and svSecondaryVoltage.ForUseIn = 'SecondaryVoltage' and svSecondaryVoltage.Location=@Location
			left outer join #tempStoredValues svUnitType on ltrim(rtrim(svUnitType.[Description])) = ltrim(rtrim(tsd.[Type])) and svUnitType.ForUseIn = 'UnitType' and svUnitType.Location=@Location
			left outer join #tempStoredValues svAmps on ltrim(rtrim(svAmps.[Description])) = ltrim(rtrim(tsd.[Amps])) and svAmps.ForUseIn = 'Amps' and svAmps.Location=@Location
			left outer join #tempStoredValues svTaps on ltrim(rtrim(svTaps.[Description])) = ltrim(rtrim(tsd.[Taps])) and svTaps.ForUseIn = 'Taps' and svTaps.Location=@Location
			left outer join #tempStoredValues svLoopRadial on ltrim(rtrim(svLoopRadial.[Description])) = ltrim(rtrim(tsd.[Loop_Rad])) and svLoopRadial.ForUseIn = 'LoopRadial' and svLoopRadial.Location=@Location
			left outer join #tempStoredValues svFront on ltrim(rtrim(svFront.[Description])) = ltrim(rtrim(tsd.[Front])) and svFront.ForUseIn = 'Front' and svFront.Location=@Location
			left outer join #tempStoredValues svTankType on ltrim(rtrim(svTankType.[Description])) = ltrim(rtrim(tsd.[TankType])) and svTankType.ForUseIn = 'TankType' and svTankType.Location=@Location
			left outer join #tempStoredValues svEOK on ltrim(rtrim(svEOK.[Description])) = ltrim(rtrim(tsd.[EOK])) and svEOK.ForUseIn = 'EOK' and svEOK.Location=@Location
			Where tsd.RowNum = @CurRecord
		
			Select @MFGR = id from Manufacturers mfg Inner Join  #tmpInvSourceData as tsd on ltrim(rtrim(mfg.Manufacturer)) = ltrim(rtrim(tsd.MFGR)) and mfg.Location=@Location

			Select @RecCount = count(1) from Inventory inv where ltrim(rtrim(inv.Barcode)) = ltrim(rtrim(@Barcode)) and inv.Location=@Location

			if @RecCount > 0 
			Begin
				Update i Set
					i.DateStamp = getDate(), i.InventoryLocation = @Location, i.SerialNumber = tmpi.[Serial Number],
					i.CustomerNumber = tmpi.[Customer Number], 
					i.Comments = tmpi.Comments, 
					i.PickUpDate = tmpi.[Received Date], 
					i.Impedance = case when ISNumeric(tmpi.imp) = 1 then cast (tmpi.imp as float(53)) else 0 end, 
					i.Job_Type = @jobtype, i.KVA = @kva, i.PrimaryVoltage = @PrimaryVoltage, i.SecondaryVoltage = @SecondaryVoltage, i.[Type] = @UnitType, i.Amps = @Amps, 
					i.Manufacturer = @MFGR, i.Taps = @Taps, i.Loop_Rad = @LoopRadial, i.Front = @Front, i.TankType = @TankType, 
					i.EOK = @EOK, i.ServiceType = tmpi.ServiceType, i.TransType = tmpi.TransType, i.BatchCode = tmpi.BatchCode, i.FieldInventoryYN = tmpi.FieldInventoryYN
				From #tmpInvSourceData tmpi
				inner join Inventory as i on ltrim(rtrim(i.Barcode)) = ltrim(rtrim(tmpi.Barcode))
				where tmpi.RowNum = @CurRecord and i.Location = @Location
			End
			Else
			Begin
			Insert Into Inventory (
				Barcode, DateStamp, [Status], InventoryLocation, SerialNumber,
				CustomerNumber, Comments, PickUpDate, Impedance, Job_Type, 
				KVA, PrimaryVoltage, SecondaryVoltage, [Type], Amps, 
				Manufacturer, Taps, Loop_Rad, Front, TankType, 
				EOK, ServiceType, TransType, BatchCode, FieldInventoryYN,Location) 
			Select 
				Barcode, getdate(), 'Inventory', @Location, [Serial Number],
				[Customer Number], Comments, [Received Date], case when ISNumeric(imp) = 1 then cast (imp as float(53)) else 0 end, @jobtype,
				@kva,  @PrimaryVoltage,  @SecondaryVoltage, @UnitType, @Amps,
				@MFGR, @Taps, @LoopRadial, @Front,  @TankType,
				@EOK, ServiceType, TransType, BatchCode, FieldInventoryYN,@Location  
			From #tmpInvSourceData where #tmpInvSourceData.RowNum = @CurRecord
			End

			Update UnitData set MovedToFI = 1 where ltrim(rtrim(Barcode)) = ltrim(rtrim(@Barcode)) and UnitData.Location=@Location
		
			Set @CurRecord += 1
		End
		--Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('17', error_message(), GetDate(),@Location)
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Inventory Update Failed', error_message(), GetDate(),@Location)
	End Catch

	---========== Tank Form Logic
	Begin Try
		SELECT [job number], tanknumber, PCBPPM,isnull(GallonsOilFlush,0) as GallonsOilFlush 
		INTO #TANK_TEMP
		from  @traverse_ExportJobs 
		where (tanknumber is not null and tanknumber <> '')
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Tanklog LogTankData', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		insert into tanklog (barcode, tanknumber, GallonsOilFlush, Location) 
		SELECT distinct [job number], tanknumber,   GallonsOilFlush,@Location  from #TANK_TEMP t
		WHERE  NOT exists (
							--Select 1 from tanklog WITH(NOLOCK)  
							--where ltrim(rtrim(tanklog.barcode))=ltrim(rtrim(t.[job number])) 
							--and convert(varchar, datestamp, 101) = convert(varchar, getdate(), 101) 
							--AND tanklog.Location=@Location

							Select 1 from tanklog WITH(NOLOCK)  
							where 
							ltrim(rtrim(tanklog.barcode))=ltrim(rtrim(t.[job number])) AND
							ltrim(rtrim(tanklog.[tanknumber]))=ltrim(rtrim(t.[tanknumber])) AND
							tanklog.[GallonsOilFlush]=t.[GallonsOilFlush] AND
							tanklog.Location=@Location
						)
				
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Tanklog CheckTankLog', error_message(), GetDate(),@Location)
	End Catch

	Begin Try
		insert into pcboiltanks ([description], inuse, PermanentAsset,Location) 
		Select distinct tanknumber,inuse=1,PermanentAsset=1,@Location
		from #TANK_TEMP t
		WHERE  NOT exists (Select 1 from pcboiltanks WITH(NOLOCK) where ltrim(rtrim([description]))=ltrim(rtrim(t.tanknumber)) AND Location=@Location)
		and t.PCBPPM>49.99
		

		insert into nonpcboiltanks ([description], inuse, PermanentAsset,Location) 
		Select distinct tanknumber,inuse=1,PermanentAsset=1,@Location  
		from #TANK_TEMP t
		WHERE  NOT exists (Select 1 from nonpcboiltanks WITH(NOLOCK)  where ltrim(rtrim([description]))=ltrim(rtrim(t.tanknumber)) AND Location=@Location)
		and t.PCBPPM<=49.99		
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Tanklog CheckTankLocation', error_message(), GetDate(),@Location)
	End Catch
	---========== Tank Form Logic

	---========== Insert Daily Test Log Summary Last Update 45 Days from current Date
	Begin Try
		delete from DailyTestLogSummary where UtestDate>= Getdate()-45  AND Location=@Location
		Insert into DailyTestLogSummary (UTestDate,PL1PDaily,PD1PDaily,RC1PDaily,RG1PDaily,PD3PDaily,RC3PDaily,CreatedOn,Location)
		select  UTestDate,
		PL1PDaily   =SUM(CASE  WHEN [Job Type]='PL1P' THEN 1 ELSE 0 END), 
		PD1PDaily   =SUM(CASE  WHEN [Job Type]='PD1P' THEN 1 ELSE 0 END),
		RC1PDaily   =SUM(CASE  WHEN [Job Type]='RC1P' THEN 1 ELSE 0 END),
		RG1PDaily   =SUM(CASE  WHEN [Job Type]='RG1P' THEN 1 ELSE 0 END),
		PD3PDaily   =SUM(CASE  WHEN [Job Type]='PD3P' THEN 1 ELSE 0 END),
		RC3PDaily   =SUM(CASE  WHEN [Job Type]='RC3P' THEN 1 ELSE 0 END),
		CreatedOn   =getdate(),
		Location	=@Location
		from unitdata
		where   UtestDate>= Getdate()-45   
				AND Location=@Location
		Group by [utestdate]
		order by 1 desc
	End Try
	Begin Catch
		Insert into ImportLog ([Action], [Description], [DateStamp]) Values ('Daily Test Log Summary Failed', error_message(), GetDate())
	End Catch
	Insert into ImportLog ([Action], [Description], [DateStamp],Location) Values ('Import', 'Ends Sql Process', GetDate(),@Location)
	Delete From Importlog Where Datestamp < cast(getdate()-7 as date) --Keep import log trail only for last 7 days 
END


