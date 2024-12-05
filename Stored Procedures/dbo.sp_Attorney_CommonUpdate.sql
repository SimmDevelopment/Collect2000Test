SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Attorney_CommonUpdate*/
CREATE Procedure [dbo].[sp_Attorney_CommonUpdate]
@AttorneyID int,
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

UPDATE attorney
SET
code = @Code,
ctl = @Ctl,
Name = @Name,
Firm = @Firm,
Street1 = @Street1,
Street2 = @Street2,
City = @City,
State = @State,
Zipcode = @Zipcode,
phone = @Phone,
feerate = @Feerate,
distpct = @Distpct,
Contact = @Contact,
nextagency = @Nextagency,
Recalldays = @Recalldays,
Remarks = @Remarks,
Fax = @Fax,
Email = @Email
WHERE AttorneyID = @AttorneyID

GO
