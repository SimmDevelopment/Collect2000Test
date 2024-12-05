SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessInsurance]
@client_id int,
@file_number int,
@insurance_id int,
@InsuredName [varchar](50),
@InsuredStreet1 [varchar](50),
@InsuredStreet2 [varchar](50),
@InsuredCity [varchar](50),
@InsuredState [char](3),
@InsuredZip [char](10),
@InsuredPhone [char](20),
@InsuredBirthday [datetime],
@InsuredSex [char](1),
@InsuredEmployer [varchar](50),
@AuthPmtToProvidor [varchar](1),
@AcceptAssignment [varchar](1),
@EmployerHealthPlan [varchar](50),
@PolicyNumber [varchar](50),
@PatientRelationToInsured [varchar](50), 
@Program [varchar](50),
@GroupNumber [varchar](50),
@GroupName [varchar](50),
@CarrierName [varchar](100),
@CarrierStreet1 [varchar](50),
@CarrierStreet2 [varchar](50),
@CarrierCity [varchar](50),
@CarrierState [char](3),
@CarrierZip [char](10),
@CarrierDocProviderNumber [varchar](30),
@CarrierRefDocProviderNumber [varchar](30)
AS
BEGIN

	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	-- Determine if we have an insert or an update.
/*	IF EXISTS(SELECT * FROM [dbo].[Insurance] WITH (NOLOCK) WHERE [Number] = @receiverNumber) 
	BEGIN*/
	
		INSERT INTO [dbo].[Insurance]
		([Number],
		[InsuredName],
		[InsuredStreet1],
		[InsuredStreet2],
		[InsuredCity],
		[InsuredState],
		[InsuredZip],
		[InsuredPhone],
		[InsuredBirthday],
		[InsuredSex],
		[InsuredEmployer],
		[AuthPmtToProvidor],
		[AcceptAssignment],
		[EmployerHealthPlan],
		[PolicyNumber],
		[PatientRelationToInsured],
		[Program],
		[GroupNumber],
		[GroupName],
		[CarrierName],
		[CarrierStreet1],
		[CarrierStreet2],
		[CarrierCity],
		[CarrierState],
		[CarrierZip],
		[CarrierDocProviderNumber],
		[CarrierRefDocProviderNumber],
		[AdditionalInfo],
		[DateCreated],
		[DateUpdated],
		[UpdateChecksum],
		[UpdatedBy])
		VALUES
		(@receiverNumber,
		@InsuredName,
		@InsuredStreet1,
		@InsuredStreet2,
		@InsuredCity,
		@InsuredState,
		@InsuredZip,
		@InsuredPhone,
		@InsuredBirthday,
		@InsuredSex,
		@InsuredEmployer,
		CASE WHEN @AuthPmtToProvidor IN ('1') THEN 1 ELSE 0 END,
		CASE WHEN @AcceptAssignment IN ('1') THEN 1 ELSE 0 END,
		@EmployerHealthPlan,
		@PolicyNumber,
		@PatientRelationToInsured, 
		@Program,
		@GroupNumber,
		@GroupName,
		@CarrierName,
		@CarrierStreet1,
		@CarrierStreet2,
		@CarrierCity,
		@CarrierState,
		@CarrierZip,
		@CarrierDocProviderNumber,
		@CarrierRefDocProviderNumber,
		NULL,--[AdditionalInfo],
		getdate(),--[DateCreated],
		getdate(),--[DateUpdated],
		Checksum(GetDate()),--[UpdateChecksum],
		0--[UpdatedBy]
		)
	/*END
	-- Otherwise this is an update.
	ELSE
	BEGIN
		UPDATE [dbo].[Insurance]
		SET [InsuredName] = @InsuredName,
		[InsuredStreet1] = @InsuredStreet1,
		[InsuredStreet2] = @InsuredStreet2,
		[InsuredCity] = @InsuredCity,
		[InsuredState] = @InsuredState,
		[InsuredZip] = @InsuredZip,
		[InsuredPhone] = @InsuredPhone,
		[InsuredBirthday] = @InsuredBirthday,
		[InsuredSex] = @InsuredSex,
		[InsuredEmployer] = @InsuredEmployer,
		[AuthPmtToProvidor] = CASE WHEN @AuthPmtToProvidor IN ('1') THEN 1 ELSE 0 END,
		[AcceptAssignment] = CASE WHEN @AcceptAssignment IN ('1') THEN 1 ELSE 0 END,
		[EmployerHealthPlan] = @EmployerHealthPlan,
		[PolicyNumber] = @PolicyNumber,
		[PatientRelationToInsured] = @PatientRelationToInsured,
		[Program] = @Program,
		[GroupNumber] = @GroupNumber,
		[GroupName] = @GroupName,
		[CarrierName] = @CarrierName,
		[CarrierStreet1] = @CarrierStreet1,
		[CarrierStreet2] = @CarrierStreet2,
		[CarrierCity] = @CarrierCity,
		[CarrierState] = @CarrierState,
		[CarrierZip] = @CarrierZip,
		[CarrierDocProviderNumber] = @CarrierDocProviderNumber,
		[CarrierRefDocProviderNumber] = @CarrierRefDocProviderNumber,
		[DateUpdated]  = getdate(),
		[UpdateChecksum] = Checksum(GetDate())
		--,[UpdatedBy] [int] NOT NULL,	
		WHERE [Number] = @receiverNumber
	END*/
END

GO
