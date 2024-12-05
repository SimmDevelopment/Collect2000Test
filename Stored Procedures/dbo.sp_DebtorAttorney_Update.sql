SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_DebtorAttorney_Update*/
CREATE Procedure [dbo].[sp_DebtorAttorney_Update]
@ID int,
@AccountID int,
@DebtorID int,
@Name varchar(50),
@Firm varchar(100),
@Addr1 varchar(50),
@Addr2 varchar(50),
@City varchar(50),
@State varchar(5),
@Zipcode varchar(20),
@Phone varchar(20),
@Fax varchar(20),
@Email varchar(50),
@Comments varchar(500)
AS

UPDATE DebtorAttorneys
SET
AccountID = @AccountID,
DebtorID = @DebtorID,
Name = @Name,
Firm = @Firm,
Addr1 = @Addr1,
Addr2 = @Addr2,
City = @City,
State = @State,
Zipcode = @Zipcode,
Phone = @Phone,
Fax = @Fax,
Email = @Email,
Comments = @Comments
WHERE ID = @ID

GO
