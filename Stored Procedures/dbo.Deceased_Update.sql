SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Deceased_Update]
	@ID int,
	@SSN varchar(15),
	@FirstName varchar(30),
	@LastName varchar(30),
	@State varchar(3),
	@PostalCode varchar(15),
	@DOB DATETIME,
	@DOD DATETIME,
	@MatchCode varchar(5),
	@TransmittedDate SMALLDATETIME,
	@ClaimDeadline DATETIME,
	@DateFiled DATETIME,
	@CaseNumber VARCHAR(20),
	@Executor VARCHAR(50),
	@ExecutorPhone VARCHAR(50),
	@ExecutorFax VARCHAR(50),
	@ExecutorStreet1 VARCHAR(50),
	@ExecutorStreet2 VARCHAR(50),
	@ExecutorCity VARCHAR(100),
	@ExecutorState VARCHAR(3),
	@ExecutorZipCode VARCHAR(10),
	@CourtCity VARCHAR(50),
	@CourtDistrict VARCHAR(200),
	@CourtDivision VARCHAR(100),
	@CourtStreet1 VARCHAR(50),
	@CourtStreet2 VARCHAR(50),
	@CourtState VARCHAR(3),
	@CourtZipCode VARCHAR(15),
	@CourtPhone VARCHAR(50)
 AS

Update Deceased Set
	SSN = @SSN,
	FirstName = @FirstName,
	LastName = @LastName,
	State = @State,
	PostalCode = @PostalCode,
	DOB = @DOB,
	DOD = @DOD,
	MatchCode = @MatchCode,
	[TransmittedDate] = @TransmittedDate,
	[ClaimDeadline] = @ClaimDeadline,
	[DateFiled] = @DateFiled,
	[CaseNumber] = @CaseNumber,
	[Executor] = @Executor,
	[ExecutorPhone] = @ExecutorPhone,
	[ExecutorFax] = @ExecutorFax,
	[ExecutorStreet1] = @ExecutorStreet1,
	[ExecutorStreet2] = @ExecutorStreet2,
	[ExecutorCity] = @ExecutorCity,
	[ExecutorState] = @ExecutorState,
	[ExecutorZipCode] = @ExecutorZipCode,
	[CourtCity] = @CourtCity,
	[CourtDistrict] = @CourtDistrict,
	[CourtDivision] = @CourtDivision,
	[CourtPhone] = @CourtPhone,
	[CourtStreet1] = @CourtStreet1,
	[CourtStreet2] = @CourtStreet2,
	[CourtState] = @CourtState,
	[CourtZipCode] = @CourtZipCode
Where ID = @ID

Return @@Error


GO
