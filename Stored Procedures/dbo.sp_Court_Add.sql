SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_Court_Add*/
CREATE  Procedure [dbo].[sp_Court_Add]
@CourtID int OUTPUT,
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

INSERT INTO Courts
(
CourtName,
Address1,
Address2,
City,
State,
Zipcode,
County,
Phone,
Fax,
Salutation,
ClerkLastName,
ClerkFirstName,
ClerkMiddleName,
Notes
)
VALUES
(
@CourtName,
@Address1,
@Address2,
@City,
@State,
@Zipcode,
@County,
@Phone,
@Fax,
@Salutation,
@ClerkLastName,
@ClerkFirstName,
@ClerkMiddleName,
@Notes
)

SET @CourtID = SCOPE_IDENTITY();



GO
