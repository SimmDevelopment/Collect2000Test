SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessPatientInfo]
@client_id int,
@file_number int,
@Name  [varchar](75),
@Street1 [varchar](50),
@Street2 [varchar](50),
@City [varchar](35),
@State [varchar](5),
@ZipCode [varchar](15),
@Country [varchar](25),
@Phone [varchar](20),
@SSN [varchar](15),
@Sex [char](1),
@Age [tinyint],
@DOB [datetime],
@MaritalStatus [char](1),
@EmployerName [varchar](75),
@WorkPhone [varchar](20),
@PatientRecNumber [varchar](30),
@GuarantorRecNumber [varchar](30),
@AdmissionDate [datetime],
@ServiceDate [datetime],
@DischargeDate [datetime],
@FacilityName [varchar](75),
@FacilityStreet1 [varchar](50),
@FacilityStreet2 [varchar](50),
@FacilityCity [varchar](35),
@FacilityState [varchar](5),
@FacilityZipCode [varchar](15),
@FacilityCountry [varchar](25),
@FacilityPhone [varchar](20),
@FacilityFax [varchar](20),
@DoctorName [varchar](75),
@DoctorPhone [varchar](20),
@DoctorFax [varchar](20),
@KinName [varchar](75),
@KinStreet1 [varchar](50),
@KinStreet2 [varchar](50),
@KinCity [varchar](35),
@KinState [varchar](5),
@KinZipCode [varchar](15),
@KinCountry [varchar](25),
@KinPhone [varchar](20)
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
	IF NOT EXISTS(SELECT * FROM [dbo].[PatientInfo] WITH (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[PatientInfo]
		([AccountID],
		[Name],
		[Street1],
		[Street2],
		[City],
		[State],
		[ZipCode],
		[Country],
		[Phone],
		[SSN],
		[Sex],
		[Age],
		[DOB],
		[MaritalStatus],
		[EmployerName],
		[WorkPhone],
		[PatientRecNumber],
		[GuarantorRecNumber],
		[AdmissionDate],
		[ServiceDate],
		[DischargeDate],
		[FacilityName],
		[FacilityStreet1],
		[FacilityStreet2],
		[FacilityCity],
		[FacilityState],
		[FacilityZipCode],
		[FacilityCountry],
		[FacilityPhone],
		[FacilityFax],
		[DoctorName],
		[DoctorPhone],
		[DoctorFax],
		[KinName],
		[KinStreet1],
		[KinStreet2],
		[KinCity],
		[KinState],
		[KinZipCode],
		[KinCountry],
		[KinPhone],
		[HardCopy])
		VALUES
		(@receiverNumber,
		@Name,
		@Street1,
		@Street2,
		@City,
		@State,
		@ZipCode,
		@Country,
		@Phone,
		@SSN,
		@Sex,
		@Age,
		@DOB,
		@MaritalStatus,
		@EmployerName,
		@WorkPhone,
		@PatientRecNumber,
		@GuarantorRecNumber,
		@AdmissionDate,
		@ServiceDate,
		@DischargeDate,
		@FacilityName,
		@FacilityStreet1,
		@FacilityStreet2,
		@FacilityCity,
		@FacilityState,
		@FacilityZipCode,
		@FacilityCountry,
		@FacilityPhone,
		@FacilityFax,
		@DoctorName,
		@DoctorPhone,
		@DoctorFax,
		@KinName,
		@KinStreet1,
		@KinStreet2,
		@KinCity,
		@KinState,
		@KinZipCode,
		@KinCountry,
		@KinPhone,
		NULL)
	END
	-- Otherwise this is an update.
	ELSE
	BEGIN
		UPDATE [dbo].[PatientInfo]
		SET [Name] = @Name,
		[Street1] = @Street1,
		[Street2] = @Street2,
		[City] = @City,
		[State] = @State,
		[ZipCode] = @ZipCode,
		[Country] = @Country,
		[Phone] = @Phone,
		[SSN] = @SSN,
		[Sex] = @Sex,
		[Age] = @Age,
		[DOB] = @DOB,
		[MaritalStatus] = @MaritalStatus,
		[EmployerName] = @EmployerName,
		[WorkPhone] = @WorkPhone,
		[PatientRecNumber] = @PatientRecNumber,
		[GuarantorRecNumber] = @GuarantorRecNumber,
		[AdmissionDate] = @AdmissionDate,
		[ServiceDate] = @ServiceDate,
		[DischargeDate] = @DischargeDate,
		[FacilityName] = @FacilityName,
		[FacilityStreet1] = @FacilityStreet1,
		[FacilityStreet2] = @FacilityStreet2,
		[FacilityCity] = @FacilityCity,
		[FacilityState] = @FacilityState,
		[FacilityZipCode] = @FacilityZipCode,
		[FacilityCountry] = @FacilityCountry,
		[FacilityPhone] = @FacilityPhone,
		[FacilityFax] = @FacilityFax,
		[DoctorName] = @DoctorName,
		[DoctorPhone] = @DoctorPhone,
		[DoctorFax] = @DoctorFax,
		[KinName] = @KinName, 
		[KinStreet1] = @KinStreet1,
		[KinStreet2] = @KinStreet2,
		[KinCity] = @KinCity,
		[KinState] = @KinState,
		[KinZipCode] = @KinZipCode,
		[KinCountry] = @KinCountry,
		[KinPhone] = @KinPhone
		WHERE [AccountID] = @receiverNumber
	END

END

GO