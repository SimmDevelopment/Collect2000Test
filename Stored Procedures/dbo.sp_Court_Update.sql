SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Court_Update*/
CREATE Procedure [dbo].[sp_Court_Update]
@CourtID int,
@CourtName varchar(50),
@Address1 varchar(50),
@Address2 varchar(50),
@City varchar(50),
@State varchar(5),
@Zipcode varchar(10),
@County varchar(50),
@Phone varchar(50),
@Fax varchar(50),
@Salutation varchar(50),
@ClerkLastName varchar(50),
@ClerkFirstName varchar(50),
@ClerkMiddleName varchar(50),
@Notes varchar(1000)
AS

UPDATE Courts
SET
CourtName = @CourtName,
Address1 = @Address1,
Address2 = @Address2,
City = @City,
State = @State,
Zipcode = @Zipcode,
County = @County,
Phone = @Phone,
Fax = @Fax,
Salutation = @Salutation,
ClerkLastName = @ClerkLastName,
ClerkFirstName = @ClerkFirstName,
ClerkMiddleName = @ClerkMiddleName,
Notes = @Notes
WHERE CourtID = @CourtID

GO
