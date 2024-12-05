SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spDebtorAttorney_Update*/
CREATE PROCEDURE [dbo].[spDebtorAttorney_Update]
	@ID int,
	@Name varchar (50),
	@Firm varchar (100),
	@Addr1 varchar (50),
	@Addr2 varchar (50),
	@City varchar (50),
	@State varchar (5),
	@Zipcode varchar (20),
	@Phone varchar (20),
	@Fax varchar (20),
	@Email varchar (50),
	@Comments varchar (500)
AS

	UPDATE DebtorAttorneys SET Name=@Name,Firm=@Firm,Addr1=@Addr1,Addr2=@Addr2,City=@City,State=@State,
	Zipcode=@Zipcode,Phone=@Phone,Fax=@Fax,Email=@Email,Comments=@Comments 
	WHERE ID = @ID

	Return @@Error
GO
