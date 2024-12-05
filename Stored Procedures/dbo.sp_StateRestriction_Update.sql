SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_StateRestriction_Update*/
CREATE Procedure [dbo].[sp_StateRestriction_Update]
@Abbreviation varchar(3),
@StateName varchar(50),
@Restricted bit,
@LicenseStatus varchar(20),
@Advisory text,
@Warning text = NULL
AS

UPDATE StateRestrictions
SET
StateName = @StateName,
Restricted = @Restricted,
LicenseStatus = @LicenseStatus,
Advisory = @Advisory,
Warning = @Warning
WHERE abbreviation = @Abbreviation

GO
