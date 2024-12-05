SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*spGarnishment_Insert*/
CREATE  PROCEDURE [dbo].[spGarnishment_Insert]
	@AccountID int,
	@CaseNumber varchar(30),
	@Company varchar (50),
	@Addr1 varchar (50),
	@Addr2 varchar (50),
	@Addr3 varchar (50) ,
	@City varchar (50),
	@State varchar (5),
	@Zipcode varchar (10),
	@Contact varchar (50),
	@Fax varchar (30),
	@Phone varchar (30),
	@Email varchar (50),
	@DateFiled smalldatetime,
	@ServiceDate smalldatetime,
	@ExpireDate smalldatetime,
	@PrinAmt money,
	@PreJmtInt money ,
	@PostJmtInt money ,
	@Costs money ,
	@OtherAmt money ,
	@Active bit,
	@UserID int,
	@UpdateChecksum varchar(10) output,
	@ReturnID int output
AS
	SET @UpdateChecksum = Checksum(GetDate())

	INSERT INTO Garnishment(AccountID, CaseNumber, Company, Addr1, Addr2, Addr3, City, State, Zipcode,
				Contact, Fax, Phone, Email, DateFiled, ServiceDate, ExpireDate, PrinAmt, PreJmtInt,
				PostJmtInt, Costs, OtherAmt, Active, UpdatedBy, UpdateChecksum)
			Values (@AccountID, @CaseNumber, @Company, @Addr1, @Addr2, @Addr3, @City, @State, @Zipcode,
				@Contact, @Fax, @Phone, @Email, @DateFiled, @ServiceDate, @ExpireDate, @PrinAmt, @PreJmtInt,
				@PostJmtInt, @Costs, @OtherAmt, @Active, @UserID, @UpdateChecksum)

IF @@Error = 0 BEGIN
	Select @ReturnID = SCOPE_IDENTITY()
	Return 0
END
ELSE
	Return @@Error


GO
