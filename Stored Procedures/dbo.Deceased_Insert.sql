SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Deceased_Insert]
	@AccountID int,
	@DebtorID int,
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
	@CourtPhone VARCHAR(50),
	@ReturnID int OutPut
 AS

Insert Into Deceased (AccountID, DebtorID, SSN, FirstName, LastName, State, PostalCode, DOB, DOD, MatchCode, [TransmittedDate], [ClaimDeadline], [DateFiled], [CaseNumber], [Executor], [ExecutorPhone], [ExecutorFax], [ExecutorStreet1], [ExecutorStreet2], [ExecutorCity], [ExecutorState], [ExecutorZipCode], [CourtCity], [CourtDistrict], [CourtDivision], [CourtPhone], [CourtStreet1], [CourtStreet2], [CourtState], [CourtZipCode])
            Values   (@AccountID,@DebtorID,@SSN,@FirstName,@LastName,@State,@PostalCode,@DOB,@DOD,@MatchCode, @TransmittedDate, @ClaimDeadline, @DateFiled, @CaseNumber, @Executor, @ExecutorPhone, @ExecutorFax, @ExecutorStreet1, @ExecutorStreet2, @ExecutorCity, @ExecutorState, @ExecutorZipCode, @CourtCity, @CourtDistrict, @CourtDivision, @CourtPhone, @CourtStreet1, @CourtStreet2, @CourtState, @CourtZipCode)

If @@Error = 0 BEGIN
	Select @ReturnID = SCOPE_IDENTITY()
	Return 0
End
Else
	Return @@Error


GO
