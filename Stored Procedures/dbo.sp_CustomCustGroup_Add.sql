SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_CustomCustGroup_Add*/
CREATE  Procedure [dbo].[sp_CustomCustGroup_Add]
@ID int OUTPUT,
@Name varchar(30),
@Description varchar(100),
@DisplayOnInvoices bit,
@DisplayOnStats bit,
@LetterGroup bit
AS

INSERT INTO CustomCustGroups
(
Name,
Description,
DisplayOnInvoices,
DisplayOnStats,
LetterGroup
)
VALUES
(
@Name,
@Description,
@DisplayOnInvoices,
@DisplayOnStats,
@LetterGroup
)

SET @ID = SCOPE_IDENTITY()



GO
