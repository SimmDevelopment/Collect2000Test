SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Bankruptcy_Update*/
CREATE Procedure [dbo].[sp_Bankruptcy_Update]
@BankruptcyID int,
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

UPDATE Bankruptcy
SET
AccountID = @AccountID,
DebtorID = @DebtorID,
Chapter = @Chapter,
DateFiled = @DateFiled,
CaseNumber = @CaseNumber,
CourtCity = @CourtCity,
CourtDistrict = @CourtDistrict,
CourtDivision = @CourtDivision,
CourtPhone = @CourtPhone,
CourtStreet1 = @CourtStreet1,
CourtStreet2 = @CourtStreet2,
CourtState = @CourtState,
CourtZipcode = @CourtZipcode,
Trustee = @Trustee,
TrusteeStreet1 = @TrusteeStreet1,
TrusteeStreet2 = @TrusteeStreet2,
TrusteeCity = @TrusteeCity,
TrusteeState = @TrusteeState,
TrusteeZipcode = @TrusteeZipcode,
TrusteePhone = @TrusteePhone,
Has341Info = @Has341Info,
DateTime341 = @DateTime341,
Location341 = @Location341,
Comments = @Comments,
Status = @Status
WHERE BankruptcyID = @BankruptcyID
GO
