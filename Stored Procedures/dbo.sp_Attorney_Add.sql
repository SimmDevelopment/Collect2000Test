SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*sp_Attorney_Add*/
CREATE  Procedure [dbo].[sp_Attorney_Add]
@AttorneyID int OUTPUT,
@Code varchar(5),
@Ctl varchar(3),
@Name varchar(30),
@Firm varchar(100),
@Street1 varchar(60),
@Street2 varchar(60),
@City varchar(20),
@State varchar(3),
@Zipcode varchar(10),
@Phone varchar(20),
@Feerate money,
@Distpct money,
@Contact varchar(30),
@Nextagency varchar(50),
@Recalldays int,
@Remarks varchar(500),
@Fax varchar(50),
@Email varchar(50)
AS

INSERT INTO attorney
(
code,
ctl,
Name,
Firm,
Street1,
Street2,
City,
State,
Zipcode,
phone,
feerate,
distpct,
Contact,
nextagency,
Recalldays,
Remarks,
Fax,
Email
)
VALUES
(
@Code,
@Ctl,
@Name,
@Firm,
@Street1,
@Street2,
@City,
@State,
@Zipcode,
@Phone,
@Feerate,
@Distpct,
@Contact,
@Nextagency,
@Recalldays,
@Remarks,
@Fax,
@Email
)

SET @AttorneyID = SCOPE_IDENTITY()


GO
