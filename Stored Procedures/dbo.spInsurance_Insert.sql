SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spInsurance_Insert]
	@AccountID int,
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
	@UpdateChecksum varchar(10) output,
	@ReturnID int output
AS

	SET @UpdateChecksum = Checksum(GetDate())

	INSERT INTO Insurance(
		Number, 
		InsuredName, 
		InsuredStreet1, 
		InsuredStreet2, 
		InsuredCity, 
		InsuredState, 
		InsuredZip , 
		InsuredPhone, 
		InsuredBirthday, 
		InsuredSex, 
		InsuredEmployer , 
		AuthPmtToProvidor, 
		AcceptAssignment, 
		EmployerHealthPlan, 
		PolicyNumber, 
		PatientRelationToInsured, 
		Program, 
		GroupNumber, 
		GroupName , 
		CarrierName, 
		CarrierStreet1, 
		CarrierStreet2, 
		CarrierCity, 
		CarrierState, 
		CarrierZip, 
		CarrierDocProviderNumber, 
		CarrierRefDocProviderNumber, AdditionalInfo, DateCreated, DateUpdated, UpdatedBy, UpdateChecksum
		) Values (
		@AccountID, 
		@InsuredName, 
		@InsuredStreet1, 
		@InsuredStreet2, 
		@InsuredCity, 
		@InsuredState, 
		@InsuredZip , 
		@InsuredPhone, 
		@InsuredBirthday, 
		@InsuredSex, 
		@InsuredEmployer , 
		@AuthPmtToProvidor, 
		@AcceptAssignment, 
		@EmployerHealthPlan, 
		@PolicyNumber, 
		@PatientRelationToInsured, 
		@Program, 
		@GroupNumber, 
		@GroupName , 
		@CarrierName, 
		@CarrierStreet1, 
		@CarrierStreet2, 
		@CarrierCity, 
		@CarrierState, 
		@CarrierZip, 
		@CarrierDocProviderNumber, 
		@CarrierRefDocProviderNumber, @AdditionalInfo, getdate(), getdate(), @UserID, @UpdateChecksum
		)

IF @@Error = 0 BEGIN
	Select @ReturnID = SCOPE_IDENTITY()
	Return 0
END
ELSE
	Return @@Error



GO
