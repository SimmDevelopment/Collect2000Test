SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Complaint_Process]
(
    @debtor_number   int
    ,@file_number int
	,@agencyId int
	,@source [varchar](20)
	,@id int
	,@receiver_complaint_id int
	,@against_code varchar(10)
	,@against varchar(50)
	,@against_entity varchar(255)
	,@category varchar(20)
	,@compensation_amount money
	,@conclusion varchar(500)
	,@date_closed datetime
	,@date_in_admin datetime
	,@date_received datetime
	,@deleted varchar(1)
	,@details varchar(500)
	,@dissatisfaction varchar(1)
	,@dissatisfaction_date datetime
	,@grievances varchar(500)
	,@Investigation_comments_to_date varchar(500)
	,@justified_code varchar(10)
	,@justified varchar(50)
	,@outcome_code varchar(10)
	,@outcome varchar(50)
	,@owner varchar(10)
	,@recourse_date datetime
	,@referred_by varchar(10)
	,@root_cause_code varchar(10)
	,@root_cause varchar(50)
	,@sla_days int
	,@status_code varchar(10)
	,@status varchar(50)
	,@type_code varchar(10)
	,@type varchar(50)
)
AS
BEGIN
	DECLARE @ComplaintId INT
	
	declare @masterNumber int,@currentAgencyId int
	declare @agencyTier int
	declare @agencyname varchar(50)
	select 	@masterNumber = referencenumber 
			,@currentagencyid = currentlyplacedagencyid
	from 	aim_accountreference 
	where 	referencenumber = @file_number

	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@masterNumber <> @file_number)
	begin
		RAISERROR ('15008',16,1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end

	select  
		@agencyname = a.name
	from AIM_AccountReference ar with (nolock)	
	inner join AIM_Agency a  with (nolock)
		on ar.currentlyplacedagencyid = a.agencyid
	where	ar.referencenumber = @file_number	
	
		-- run actions configured at agency level if agency does not keep deceased
	DECLARE @keepsComplaint BIT
	SELECT @keepsComplaint = ISNULL([KeepsComplaint],0) FROM [dbo].[AIM_Agency] WHERE [agencyid] = @agencyid
	
	-- We need to check if we have all lookup type codes. If we don't have them we need to add.
	IF (RTRIM(LTRIM(ISNULL(@against_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTAGST' AND [Code] = @against_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTAGST', @against_code, @against,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	IF (RTRIM(LTRIM(ISNULL(@justified_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTJST' AND [Code] = @justified_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTJST', @justified_code, @justified,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	IF (RTRIM(LTRIM(ISNULL(@outcome_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTOUT' AND [Code] = @outcome_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTOUT', @outcome_code, @outcome,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	IF (RTRIM(LTRIM(ISNULL(@root_cause_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTROOT' AND [Code] = @root_cause_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTROOT', @root_cause_code, @root_cause,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	
	IF (RTRIM(LTRIM(ISNULL(@status_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTSTAT' AND [Code] = @status_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTSTAT', @status_code, @status,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	IF (RTRIM(LTRIM(ISNULL(@type_code,''))) != '')
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[Custom_ListData] WHERE [ListCode] = 'COMPLTTYPE' AND [Code] = @type_code)
		BEGIN
			INSERT INTO [dbo].[Custom_ListData]
			([ListCode], [Code], [Description],
			[SysCode], [CreatedBy], [UpdatedBy],
			[CreatedWhen], [UpdatedWhen], [Enabled])
			SELECT 'COMPLTTYPE', @type_code, @type,
			1, 'AIM', 'AIM',
			GETDATE(),GETDATE(),1
		END
	END
	
	-- Was the source AIM?
	IF (RTRIM(LTRIM(@source)) = 'AIM')
	BEGIN
	
		IF EXISTS (SELECT * FROM [dbo].[AIM_Complaint] WHERE [ID] = @Id AND [AgencyId] = @agencyId AND [Source] = 'AIM')
		BEGIN
			SELECT @ComplaintId = [ComplaintId] FROM [dbo].[AIM_Complaint] WHERE [ID] = @Id AND [AgencyId] = @agencyId AND [Source] = 'AIM'
			
			UPDATE [dbo].[Complaint]
			SET 
				[DateInAdmin] = @date_in_admin,
				[DateReceived] = @date_received,
				[SLADays] = @sla_days,
				[Owner] = @Owner,
				[ReferredBy] = @referred_by,
				[Details] = @details,
				[Status] = @status_code,
				[Category] = @category,
				[Type] = @type_code,
				[AgainstType] = @against_code,
				[Against] = @against_entity,
				[InvestigationCommentsToDate] = @investigation_comments_to_date,
				[Conclusion] = @conclusion,
				[DateClosed] = @date_closed,
				[Outcome] = @outcome_code,
				[Justified] = @justified_code,
				[CompensationAmount] = @compensation_amount,
				[RootCause] = @root_cause_code,
				[RecourseDate] = @recourse_date,
				[Dissatisfaction] = CASE @dissatisfaction WHEN 'Y' THEN 1 ELSE 0 END,
				[DissatisfactionDate] = @dissatisfaction_date,
				[Grievances] = @grievances,
				[Deleted] = CASE @deleted WHEN 'Y' THEN 1 ELSE 0 END,
				[ModifiedWhen] = GETDATE(),
				[ModifiedBy] = 'AIM'
			WHERE [ComplaintId] = @ComplaintId;
		END
	END
	ELSE
	BEGIN
		
		---- Need to determine if we have an existing complaint using the id given.
		IF EXISTS (SELECT * FROM [dbo].[AIM_Complaint] WHERE [ReceiverComplaintID] = @receiver_complaint_id AND [AgencyId] = @agencyId AND [Source] = 'RECEIVER')
		BEGIN
			SELECT @ComplaintId = [ComplaintId] FROM [dbo].[AIM_Complaint] WHERE [ReceiverComplaintID] = @receiver_complaint_id AND [AgencyId] = @agencyId AND [Source] = 'RECEIVER'
			
			UPDATE [dbo].[Complaint]
			SET 
				[DateInAdmin] = @date_in_admin,
				[DateReceived] = @date_received,
				[SLADays] = @sla_days,
				[Owner] = @Owner,
				[ReferredBy] = @referred_by,
				[Details] = @details,
				[Status] = @status_code,
				[Category] = @category,
				[Type] = @type_code,
				[AgainstType] = @against_code,
				[Against] = @against_entity,
				[InvestigationCommentsToDate] = @investigation_comments_to_date,
				[Conclusion] = @conclusion,
				[DateClosed] = @date_closed,
				[Outcome] = @outcome_code,
				[Justified] = @justified_code,
				[CompensationAmount] = @compensation_amount,
				[RootCause] = @root_cause_code,
				[RecourseDate] = @recourse_date,
				[Dissatisfaction] = CASE @dissatisfaction WHEN 'Y' THEN 1 ELSE 0 END,
				[DissatisfactionDate] = @dissatisfaction_date,
				[Grievances] = @grievances,
				[Deleted] = CASE @deleted WHEN 'Y' THEN 1 ELSE 0 END,
				[ModifiedWhen] = GETDATE(),
				[ModifiedBy] = 'AIM'
			WHERE [ComplaintId] = @ComplaintId;
		END
		-- Otherwise a new record to insert.
		ELSE
		BEGIN
			DECLARE @debtorId INT
			DECLARE @newComplaintId INT
			SELECT @debtorId = [DebtorId] FROM [dbo].[Debtors] WHERE [Number] = @file_number AND [SEQ] = 0
			INSERT INTO [dbo].[Complaint]
			([AccountId],
			[DebtorId],
			[DocumentationId],
			[DateInAdmin],
			[DateReceived],
			[SLADays],
			[Owner],
			[ReferredBy],
			[Details],
			[Status],
			[Category],
			[Type],
			[AgainstType],
			[Against],
			[InvestigationCommentsToDate],
			[Conclusion],
			[DateClosed],
			[Outcome],
			[Justified],
			[CompensationAmount],
			[RootCause],
			[RecourseDate],
			[Dissatisfaction],
			[DissatisfactionDate],
			[Grievances],
			[Deleted],
			[CreatedWhen],
			[CreatedBy],
			[ModifiedWhen],
			[ModifiedBy])
			
			VALUES
			(@file_number,
			@debtorId,
			NULL,
			@date_in_admin,
			@date_received,
			@sla_days,
			@owner,
			@referred_by,
			@details,
			@status_code,
			@category,----???
			@type_code,
			@against_code,
			@against_entity,
			@investigation_comments_to_date,
			@conclusion,	
			@date_closed,
			@outcome_code,
			@justified_code,
			@compensation_amount,
			@root_cause_code,
			@recourse_date,	
			CASE WHEN @dissatisfaction IN ('Y') THEN 1 ELSE 0 END,
			@dissatisfaction_date,	
			@grievances,
			CASE WHEN @deleted IN ('Y') THEN 1 ELSE 0 END,
			GETDATE(),
			'RECEIVER',
			GETDATE(),
			'RECEIVER')
			SET @newComplaintId = SCOPE_IDENTITY()
			
			INSERT INTO [dbo].[AIM_Complaint]([Source], [AccountID], [AgencyId], [ComplaintID], [ReceiverComplaintID])
			SELECT 'RECEIVER', @masterNumber, @agencyId, @newComplaintId, @receiver_complaint_id
			
			IF (@keepsComplaint = 0)
			BEGIN
				-- recall account
				update  AIM_accountreference set 
						lastrecalldate = null,expectedpendingrecalldate = null,
						expectedfinalrecalldate = getdate(),numdaysplacedbeforepending = null,
						ObjectionFlag = 0
				from	AIM_accountreference ar with (nolock)
				where	referencenumber = @masterNumber

				-- flag master as recalled
				update	master
				set 	aimagency = null, aimassigned = null	,feecode = null
				where	number = @masterNumber
			END
		END
	END
END
GO
