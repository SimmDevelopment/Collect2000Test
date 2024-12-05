SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_StateRestriction_Add*/
CREATE Procedure [dbo].[sp_StateRestriction_Add]
@Abbreviation varchar(3),
@StateName varchar(50),
@Restricted bit,
@LicenseStatus varchar(20),
@Advisory text,
@Warning text = NULL
AS

INSERT INTO StateRestrictions
(
abbreviation,
StateName,
Restricted,
LicenseStatus,
Advisory,
Warning
)
VALUES
(
@Abbreviation,
@StateName,
@Restricted,
@LicenseStatus,
@Advisory,
@Warning
)

GO
