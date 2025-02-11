-- =============================================
-- Author:		Mustanshir Ghadiali
-- Create date: 12-Dec-2018
-- Description:	This SP Imports data from Traverse Server which has either Received Date OR Ship Date OR TransDate, into EO system (ShipLogDataTraverse table). 
--				Data inserted into this table will be later used to send Shipping Log mail and the values gets aggregate from this table.
--				ShipLogSummary table is created to stored aggregated value. 
--							--The idea to create this table is to have aggregate value calculated from ShipLogDataTraverse table 
--							  so that system dont require to calculate every time and can read data directly from this table
--				Shipping Email Task Scheduler read value from "ShipLogDataTraverse" table
--				Shipping Log under Log Report screen read value from "ShipLogSummary" table 
--				The data recieved from the Traverse server are passed to Table Datatype from front end as below
--				traverse_ExportJobsView : Holds result set of ExportsJobs_View view return from Traverse
/******************
NOTE: Functional logic remains the same as was written in legacy system by other vendor. 
	  This SP was created to improve performance issue which was exist in legacy system.
*******************/
-- =============================================


ALTER PROCEDURE [dbo].[spImportShippingLogData]
	@traverse_ExportJobs traverse_ExportJobsView READONLY,
	@Location INT
AS
BEGIN
	INSERT INTO ImportLog
	  (
	    [Action],
	    [Description],
	    [DateStamp],
	    Location
	  )
	VALUES
	  (
	    'Import Shipping Log',
	    'Begins Sql Process',
	    GETDATE(),
	    @Location
	  )
	--=========================Update/Insert Job Types=========================
	BEGIN TRY
		--Below query Insert fetched Traverse data into ShipLogDataTraverse table
		--System fetches 45 days back dated record so as to get complete updated record from last 45 days
		--This query will fire through Task Scheduler which is set every day in the morning
		--BEGIN TRANSACTION
		DELETE 
		FROM   ShipLogDataTraverse
		WHERE  (Cast(convert(varchar(10),[ReceivedDate],101) as DateTime) >= Cast(convert(varchar(10),getdate()-45,101) as DateTime) OR
			   Cast(convert(varchar(10),[ShipDate],101) as DateTime) >= Cast(convert(varchar(10),getdate()-45,101) as DateTime)
			   OR Cast(convert(varchar(10),[TransDate],101) as DateTime) >= Cast(convert(varchar(10),getdate()-45,101) as DateTime)
			   ) AND
			   Location=@Location
		
		INSERT INTO [ShipLogDataTraverse]
		  (
		    Barcode,
		    JobType,
		    ReceivedDate,
		    ShipDate,
		    KVADelivered,
		    AMPDelivered,
		    CreatedOn,
			ServiceType,
			[Dept Code],
			TransDate,
		    Location
		  )
		SELECT [Job Number],
		       [Job Type],
		       [Received Date],
		       [Ship Date],
		       case when ISNumeric(KVA) = 1 then cast (KVA as float(53)) else 0 end, --Numeric check is applied for KVA to ignore varchar value received from Traverse
			   case when ISNumeric(AMPS) = 1 then cast (AMPS as float(53)) else 0 end, --Numeric check is applied for AMPS to ignore varchar value received from Traverse
		       GETDATE(),
			   ServiceType,
			   [Dept Code],
			   TransDate,
		       @Location
		FROM   @traverse_ExportJobs AS sourceExportJobs
		
		--==============================Shipping Log Summary (Begin)
		DECLARE @firstDayofMonth    AS date
		
		DECLARE @KVA                AS FLOAT,
		        @Deliveries         AS FLOAT,
		        @Pickups            AS FLOAT,
		        @AMPS               AS FLOAT
		
		DECLARE @KVAWeekly          AS FLOAT,
		        @DeliveriesWeekly   AS FLOAT,
		        @PickupsWeekly      AS FLOAT,
		        @AMPSWeekly         AS FLOAT
		
		DECLARE @KVAMonthly         AS FLOAT,
		        @DeliveriesMonthly  AS FLOAT,
		        @PickupsMonthly     AS FLOAT,
		        @AMPSMonthly        AS FLOAT
		
		DECLARE @KVAYearly          AS FLOAT,
		        @DeliveriesYearly   AS FLOAT,
		        @PickupsYearly      AS FLOAT,
		        @AMPSYearly         AS FLOAT
		
		DECLARE @PL1PMonthly        AS FLOAT,
		        @PD1PMonthly        AS FLOAT,
		        @PD3PMonthly        AS FLOAT,
		        @RG1PMonthly        AS FLOAT,
		        @RC1PMonthly        AS FLOAT,
		        @RC3PMonthly        AS FLOAT,
		        @SB3PMonthly        AS FLOAT
		
		DECLARE @PL1PYearly         AS FLOAT,
		        @PD1PYearly         AS FLOAT,
		        @PD3PYearly         AS FLOAT,
		        @RG1PYearly         AS FLOAT,
		        @RC1PYearly         AS FLOAT,
		        @RC3PYearly         AS FLOAT,
		        @SB3PYearly         AS FLOAT
		
		 
		SELECT @firstDayofMonth=CONVERT(VARCHAR(10), GETDATE() -45, 101)
		  
		--set @firstDayofMonth = (SELECT convert(varchar(10),cast('2010-01-01' as date),101))
		
		DELETE 
		FROM   ShipLogSummary
		WHERE  Location = @Location
		       AND Cast(convert(varchar(10),LogForDate,101) as DateTime) >= Cast(convert(varchar(10),@firstDayofMonth,101) as DateTime) 
		
		WHILE @firstDayofMonth < Cast(convert(varchar(10),getdate(), 101) as DateTime)
		BEGIN
			--Day Wise
		    SELECT @KVA = SUM(KVADelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')   
		           AND CONVERT(VARCHAR(10), ShipDate, 101) = CONVERT(VARCHAR(10), @firstDayofMonth, 101) -- KVADelivered daywise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @Deliveries = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')
		           AND CONVERT(VARCHAR(10), ShipDate, 101) = CONVERT(VARCHAR(10), @firstDayofMonth, 101) -- Deliveries daywise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @Pickups = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R'  and [DEPT CODE] not in ('OR SFS','PD SFS','PL SFS','RC SFS','RG SFS','SB SFS','FG Boxes', 'FD Decom', 'FD Service') 
		           AND CONVERT(VARCHAR(10), TransDate, 101) = CONVERT(VARCHAR(10), @firstDayofMonth, 101) -- Pickup daywise
				   and cast(convert(varchar(10),TransDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @AMPS = SUM(AMPDelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service') 
		           AND CONVERT(VARCHAR(10), ShipDate, 101) = CONVERT(VARCHAR(10), @firstDayofMonth, 101) -- AMP Delivered daywise
	               and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
			--Weekly
		    SELECT @KVAWeekly = SUM(KVADelivered)
		    FROM   ShiplogdataTraverse 
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND DATEPART(wk, ShipDate) = DATEPART(wk, @firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- KVADelivered weekly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @DeliveriesWeekly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND DATEPART(wk, ShipDate) = DATEPART(wk, @firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- Deliveries weekly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PickupsWeekly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and  [ServiceType] = 'R'  and [DEPT CODE] not in ('OR SFS','PD SFS','PL SFS','RC SFS','RG SFS','SB SFS','FG Boxes', 'FD Decom', 'FD Service')
		           AND DATEPART(wk, TransDate) = DATEPART(wk, @firstDayofMonth)
		           AND YEAR(TransDate) = YEAR(@firstDayofMonth) -- Pickup weekly
				   and cast(convert(varchar(10),TransDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @AMPSWeekly = SUM(AMPDelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service') 
		           AND DATEPART(wk, ShipDate) = DATEPART(wk, @firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- AMP Delivered weekly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
			--MonthWise
		    SELECT @KVAMonthly = SUM(KVADelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- KVADelivered monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @DeliveriesMonthly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- Deliveries monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PickupsMonthly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and  [ServiceType] = 'R'  and [DEPT CODE] not in ('OR SFS','PD SFS','PL SFS','RC SFS','RG SFS','SB SFS','FG Boxes', 'FD Decom', 'FD Service')
		           AND MONTH(TransDate) = MONTH(@firstDayofMonth)
		           AND YEAR(TransDate) = YEAR(@firstDayofMonth) -- Pickup monthly
				   and cast(convert(varchar(10),TransDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @AMPSMonthly = SUM(AMPDelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- AMP Delivered monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
			--Yearly
		    SELECT @KVAYearly = SUM(KVADelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- KVADelivered Yearly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @DeliveriesYearly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- Deliveries Yearly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PickupsYearly = COUNT(Barcode)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and  [ServiceType] = 'R'  and [DEPT CODE] not in ('OR SFS','PD SFS','PL SFS','RC SFS','RG SFS','SB SFS','FG Boxes', 'FD Decom', 'FD Service')
		           AND YEAR(TransDate) = YEAR(@firstDayofMonth)-- Pickup Yearly
				   and cast(convert(varchar(10),TransDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @AMPSYearly = SUM(AMPDelivered)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' and [Dept Code] not in ('FG Boxes', 'FD Decom', 'FD Service')  
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth) -- AMP Delivered Yearly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
			--Job Type MonthWise
		    SELECT @PL1PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PL1P' -- Pole monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PD1PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PD1P' -- PD1P monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PD3PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PD3P' -- PD3P monthly
		    SELECT @RG1PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RG1P' -- RG1P monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @RC1PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RC1P' -- RC1P monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @RC3PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RC3P' -- RC3P monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @SB3PMonthly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND MONTH(ShipDate) = MONTH(@firstDayofMonth)
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'SG3P' -- SG3P monthly
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    --Job Type Yearwise
		    SELECT @PL1PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PL1P' -- Pole Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    SELECT @PD1PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PD1P' -- PD1P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)

		    SELECT @PD3PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'PD3P'-- PD3P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)

		    SELECT @RG1PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RG1P' -- RG1P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)

		    SELECT @RC1PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RC1P' -- RC1P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)

		    SELECT @RC3PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'RC3P' -- RC3P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)

		    SELECT @SB3PYearly = COUNT(JobType)
		    FROM   ShiplogdataTraverse
		    WHERE  Location = @Location and [ServiceType] = 'R' 
		           AND YEAR(ShipDate) = YEAR(@firstDayofMonth)
		           AND JobType = 'SB3P' -- SB3P Yearwise
				   and cast(convert(varchar(10),ShipDate,101) as datetime) <= cast(convert(varchar(10),getdate()-1,101) as datetime)
		    
		    IF (
		           ISNULL(@KVA, 0) <> 0
		           OR ISNULL(@Deliveries, 0) <> 0
		           OR ISNULL(@Pickups, 0) <> 0
		           OR ISNULL(@AMPS, 0) <> 0
		           OR ISNULL(@KVAWeekly, 0) <> 0
		           OR ISNULL(@DeliveriesWeekly, 0) <> 0
		           OR ISNULL(@PickupsWeekly, 0) <> 0
		           OR ISNULL(@AMPSWeekly, 0) <> 0
		           OR ISNULL(@KVAMonthly, 0) <> 0
		           OR ISNULL(@DeliveriesMonthly, 0) <> 0
		           OR ISNULL(@PickupsMonthly, 0) <> 0
		           OR ISNULL(@AMPSMonthly, 0) <> 0
		           OR ISNULL(@KVAYearly, 0) <> 0
		           OR ISNULL(@DeliveriesYearly, 0) <> 0
		           OR ISNULL(@PickupsYearly, 0) <> 0
		           OR ISNULL(@AMPSYearly, 0) <> 0
		           OR ISNULL(@PL1PMonthly, 0) <> 0
		           OR ISNULL(@PD1PMonthly, 0) <> 0
		           OR ISNULL(@PD3PMonthly, 0) <> 0
		           OR ISNULL(@RG1PMonthly, 0) <> 0
		           OR ISNULL(@RC1PMonthly, 0) <> 0
		           OR ISNULL(@RC3PMonthly, 0) <> 0
		           OR ISNULL(@SB3PMonthly, 0) <> 0
		           OR ISNULL(@PL1PYearly, 0) <> 0
		           OR ISNULL(@PD1PYearly, 0) <> 0
		           OR ISNULL(@PD3PYearly, 0) <> 0
		           OR ISNULL(@RG1PYearly, 0) <> 0
		           OR ISNULL(@RC1PYearly, 0) <> 0
		           OR ISNULL(@RC3PYearly, 0) <> 0
		           OR ISNULL(@SB3PYearly, 0) <> 0
		       )
		    BEGIN
		        INSERT INTO ShipLogSummary
		          (
		            LogForDate,
		            KVA,
		            Deliveries,
		            Pickups,
		            AMPS,
		            KVAWeekly,
		            DeliveriesWeekly,
		            PickupsWeekly,
		            AMPSWeekly,
		            KVAMonthly,
		            DeliveriesMonthly,
		            PickupsMonthly,
		            AMPSMonthly,
		            KVAYearly,
		            DeliveriesYearly,
		            PickupsYearly,
		            AMPSYearly,
		            PL1PMonthly,
		            PD1PMonthly,
		            PD3PMonthly,
		            RG1PMonthly,
		            RC1PMonthly,
		            RC3PMonthly,
		            SB3PMonthly,
		            PL1PYearly,
		            PD1PYearly,
		            PD3PYearly,
		            RG1PYearly,
		            RC1PYearly,
		            RC3PYearly,
		            SB3PYearly,
		            CreatedOn,
		            Location
		          )
		        VALUES
		          (
		            @firstDayofMonth,
		            ISNULL(@KVA, 0),
		            ISNULL(@Deliveries, 0),
		            ISNULL(@Pickups, 0),
		            ISNULL(@AMPS, 0),
		            ISNULL(@KVAWeekly, 0),
		            ISNULL(@DeliveriesWeekly, 0),
		            ISNULL(@PickupsWeekly, 0),
		            ISNULL(@AMPSWeekly, 0),
		            ISNULL(@KVAMonthly, 0),
		            ISNULL(@DeliveriesMonthly, 0),
		            ISNULL(@PickupsMonthly, 0),
		            ISNULL(@AMPSMonthly, 0),
		            ISNULL(@KVAYearly, 0),
		            ISNULL(@DeliveriesYearly, 0),
		            ISNULL(@PickupsYearly, 0),
		            ISNULL(@AMPSYearly, 0),
		            ISNULL(@PL1PMonthly, 0),
		            ISNULL(@PD1PMonthly, 0),
		            ISNULL(@PD3PMonthly, 0),
		            ISNULL(@RG1PMonthly, 0),
		            ISNULL(@RC1PMonthly, 0),
		            ISNULL(@RC3PMonthly, 0),
		            ISNULL(@SB3PMonthly, 0),
		            ISNULL(@PL1PYearly, 0),
		            ISNULL(@PD1PYearly, 0),
		            ISNULL(@PD3PYearly, 0),
		            ISNULL(@RG1PYearly, 0),
		            ISNULL(@RC1PYearly, 0),
		            ISNULL(@RC3PYearly, 0),
		            ISNULL(@SB3PYearly, 0),
		            GETDATE(),
		            @Location
		          )		       
		    END
			 SET @firstDayofMonth = DATEADD(d, 1, @firstDayOfMonth)
		END

		--==============================Shipping Log Summary (End)
		--COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		INSERT INTO ImportLog
		  (
		    [Action],
		    [Description],
		    [DateStamp],
		    Location
		  )
		VALUES
		  (
		    'Shipping Log Failed',
		    ERROR_MESSAGE(),
		    GETDATE(),
		    @Location
		  )
		--ROLLBACK TRANSACTION
	END CATCH
	INSERT INTO ImportLog
	  (
	    [Action],
	    [Description],
	    [DateStamp],
	    Location
	  )
	VALUES
	  (
	    'Shipping Log',
	    'Ends Sql Process',
	    GETDATE(),
	    @Location
	  )
END

