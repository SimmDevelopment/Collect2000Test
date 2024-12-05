SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*spGarnishment_Update*/
CREATE PROCEDURE [dbo].[spGarnishment_Update]
	@GarnishmentID int,
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
	@UpdateChecksum varchar(10) output

AS
Declare @CurrentChecksum varchar(10)

SELECT @CurrentChecksum = UpdateChecksum from Garnishment WHERE GarnishmentID = @GarnishmentID

IF @UpdateChecksum = @CurrentChecksum BEGIN
	SET @UpdateChecksum = Checksum(GetDate())
	UPDATE Garnishment SET
		CaseNumber = @CaseNumber,
		Company = @Company,
		Addr1 = @Addr1,
		Addr2 = @Addr2,
		Addr3 = @Addr3,
		City = @City,
		State = @State,
		Zipcode =@Zipcode,
		Contact = @Contact,
		Fax = @Fax,
		Phone = @Phone,
		Email = @Email,
		DateFiled = @DateFiled,
		ServiceDate = @ServiceDate,
		ExpireDate = @ExpireDate,
		PrinAmt = @PrinAmt,
		PreJmtInt =@PreJmtInt,
		PostJmtInt = @PostJmtInt,
		Costs = @Costs,
		OtherAmt = @OtherAmt,
		Active = @Active,
		DateUpdated = GetDate(),
		UpdateChecksum = @UpdateChecksum,
		UpdatedBy = @UserID
	WHERE GarnishmentID = @GarnishmentID
	Return @@Error
END
ELSE
	Return -1	--Which means another user has updated since we read record
GO
