SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_Bankruptcy_Add*/
CREATE  PROCEDURE [dbo].[sp_Bankruptcy_Add]
@BankruptcyID int OUTPUT,
@AccountID int,
@DebtorID int,
@Chapter tinyint,
@DateFiled datetime,
@CaseNumber varchar(20),
@CourtCity varchar(50),
@CourtDistrict varchar(200),
@CourtDivision varchar(100),
@CourtPhone varchar(50),
@CourtStreet1 varchar(50),
@CourtStreet2 varchar(50),
@CourtState varchar(3),
@CourtZipcode varchar(15),
@Trustee varchar(50),
@TrusteeStreet1 varchar(50),
@TrusteeStreet2 varchar(50),
@TrusteeCity varchar(100),
@TrusteeState varchar(3),
@TrusteeZipcode varchar(10),
@TrusteePhone varchar(30),
@Has341Info bit,
@DateTime341 datetime,
@Location341 varchar(200),
@Comments varchar(500),
@Status varchar(100)
AS

INSERT INTO Bankruptcy
(
AccountID,
DebtorID,
Chapter,
DateFiled,
CaseNumber,
CourtCity,
CourtDistrict,
CourtDivision,
CourtPhone,
CourtStreet1,
CourtStreet2,
CourtState,
CourtZipcode,
Trustee,
TrusteeStreet1,
TrusteeStreet2,
TrusteeCity,
TrusteeState,
TrusteeZipcode,
TrusteePhone,
Has341Info,
DateTime341,
Location341,
Comments,
Status
)
VALUES
(
@AccountID,
@DebtorID,
@Chapter,
@DateFiled,
@CaseNumber,
@CourtCity,
@CourtDistrict,
@CourtDivision,
@CourtPhone,
@CourtStreet1,
@CourtStreet2,
@CourtState,
@CourtZipcode,
@Trustee,
@TrusteeStreet1,
@TrusteeStreet2,
@TrusteeCity,
@TrusteeState,
@TrusteeZipcode,
@TrusteePhone,
@Has341Info,
@DateTime341,
@Location341,
@Comments,
@Status
)

SET @BankruptcyID = SCOPE_IDENTITY()


GO
