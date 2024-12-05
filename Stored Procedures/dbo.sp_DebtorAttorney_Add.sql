SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_DebtorAttorney_Add*/
CREATE  Procedure [dbo].[sp_DebtorAttorney_Add]
@ID int OUTPUT,
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

INSERT INTO DebtorAttorneys
(
AccountID,
DebtorID,
Name,
Firm,
Addr1,
Addr2,
City,
State,
Zipcode,
Phone,
Fax,
Email,
Comments
)
VALUES
(
@AccountID,
@DebtorID,
@Name,
@Firm,
@Addr1,
@Addr2,
@City,
@State,
@Zipcode,
@Phone,
@Fax,
@Email,
@Comments
)

SET @ID = SCOPE_IDENTITY()



GO
