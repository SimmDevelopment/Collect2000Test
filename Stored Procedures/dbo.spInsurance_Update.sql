SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Create Stored Procedure dbo.spInsurance_Update */
CREATE PROCEDURE [dbo].[spInsurance_Update]
	@InsuranceID int,
	@InsuredName varchar(50),
	@InsuredStreet1 varchar (50),
	@InsuredStreet2 varchar (50),
	@InsuredCity varchar (50),
	@InsuredState char (3) ,
	@InsuredZip char (10),
	@InsuredPhone char (20),
	@InsuredBirthday datetime,
	@InsuredSex char (1),
	@InsuredEmployer varchar (50),
	@AuthPmtToProvidor bit,
	@AcceptAssignment bit,
	@EmployerHealthPlan varchar (50),
	@PolicyNumber varchar (50),
	@PatientRelationToInsured varchar (50),
	@Program varchar (50),
	@GroupNumber varchar (50) ,
	@GroupName varchar (50) ,
	@CarrierName varchar (100) ,
	@CarrierStreet1 varchar (50) ,
	@CarrierStreet2 varchar (50),
	@CarrierCity varchar (50),
	@CarrierState char (3),
	@CarrierZip char (10),
	@CarrierDocProviderNumber varchar (30),
	@CarrierRefDocProviderNumber varchar (30),
	@AdditionalInfo varchar(5000),
	@UserID int,
	@UpdateChecksum varchar(10) output

AS
Declare @CurrentChecksum varchar(10)

SELECT @CurrentChecksum = UpdateChecksum from Insurance WHERE InsuranceID = @InsuranceID

IF @UpdateChecksum = @CurrentChecksum BEGIN
	SET @UpdateChecksum = Checksum(GetDate())
	UPDATE Insurance SET
		InsuredName = @InsuredName, 
		InsuredStreet1 = @InsuredStreet1, 
		InsuredStreet2 = @InsuredStreet2, 
		InsuredCity = @InsuredCity, 
		InsuredState = @InsuredState, 
		InsuredZip = @InsuredZip , 
		InsuredPhone = @InsuredPhone, 
		InsuredBirthday = @InsuredBirthday, 
		InsuredSex = @InsuredSex, 
		InsuredEmployer = @InsuredEmployer , 
		AuthPmtToProvidor = @AuthPmtToProvidor, 
		AcceptAssignment = @AcceptAssignment, 
		EmployerHealthPlan = @EmployerHealthPlan, 
		PolicyNumber = @PolicyNumber, 
		PatientRelationToInsured = @PatientRelationToInsured, 
		Program = @Program, 
		GroupNumber = @GroupNumber, 
		GroupName = @GroupName , 
		CarrierName = @CarrierName, 
		CarrierStreet1 = @CarrierStreet1, 
		CarrierStreet2 = @CarrierStreet2, 
		CarrierCity = @CarrierCity, 
		CarrierState = @CarrierState, 
		CarrierZip = @CarrierZip, 
		CarrierDocProviderNumber = @CarrierDocProviderNumber, 
		CarrierRefDocProviderNumber = @CarrierRefDocProviderNumber,
		AdditionalInfo = @AdditionalInfo,
		UpdateChecksum = @UpdateChecksum,
		UpdatedBy = @UserID,
		DateUpdated = getdate()
	WHERE InsuranceID = @InsuranceID
	Return @@Error
END
ELSE
	Return -1	--Which means another user has updated since we read record

GO
