SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessPlacementComplaint]
@client_id int,
@file_number int,
@debtor_number int,
@id int,
@against_code varchar(10),
@against varchar(50),
@against_entity varchar(255),
@category varchar(20), 
@compensation_amount money,
@conclusion varchar(500),
@date_closed datetime,
@date_in_admin datetime,
@date_received datetime,
@deleted varchar(1),
@details varchar(500),
@dissatisfaction varchar(1),
@dissatisfaction_date datetime,
@grievances varchar(500),
@investigation_comments_to_date varchar(500),
@justified_code varchar(10),
@justified varchar(50),
@outcome_code varchar(10),
@outcome varchar(50),
@owner varchar(10),
@recourse_date datetime,
@Referred_by varchar(10),
@root_cause_code varchar(10),
@root_cause varchar(50),
@sla_days int,
@status_code varchar(10),
@status varchar(50),
@type_code varchar(10),
@type varchar(50)
AS
BEGIN

	DECLARE @receiverNumber INT
	DECLARE @newComplaintId INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	join master m with (nolock) on d.number = m.number
	where senderdebtorid = @debtor_number
	and clientid = @client_id

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END	
	
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
			1, 'RECEIVER', 'RECEIVER',
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
			1, 'RECEIVER', 'RECEIVER',
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
			1, 'RECEIVER', 'RECEIVER',
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
			1, 'RECEIVER', 'RECEIVER',
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
			1, 'RECEIVER', 'RECEIVER',
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
			1, 'RECEIVER', 'RECEIVER',
			GETDATE(),GETDATE(),1
		END
	END
	
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
	(@receiverNumber,
	@dnumber,
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
		
	INSERT INTO [dbo].[Receiver_Complaint]([Source], [AccountID], [ClientId], [ComplaintID], [AIMComplaintID])
	SELECT 'AIM', @receiverNumber, @client_id, @newComplaintId, @ID

END
GO
