SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroup_Update*/
CREATE Procedure [dbo].[sp_CustomCustGroup_Update]
@ID int,
@Name varchar(30),
@Description varchar(100),
@DisplayOnInvoices bit,
@DisplayOnStats bit,
@LetterGroup bit
AS

UPDATE CustomCustGroups
SET
Name = @Name,
Description = @Description,
DisplayOnInvoices = @DisplayOnInvoices,
DisplayOnStats = @DisplayOnStats,
LetterGroup = @LetterGroup
WHERE ID = @ID

GO
