SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EmailGetAll]
	@number INT
AS
BEGIN

SELECT e.[EmailId]
      ,e.[DebtorId]
      ,e.[Email]
      ,e.[TypeCd]
      ,e.[StatusCd]
      ,e.[Active]
      ,e.[Primary]
      ,e.[ConsentGiven]
      ,e.[WrittenConsent]
      ,e.[ConsentSource]
      ,e.[ConsentBy]
      ,e.[ConsentDate]
      ,e.[CreatedWhen]
      ,e.[CreatedBy]
      ,e.[ModifiedWhen]
      ,e.[ModifiedBy]
      ,e.[comment]
	  ,d.Name [DebtorName]
  FROM [dbo].[Email] e (NOLOCK)
  INNER JOIN dbo.Debtors d (NOLOCK)
  ON d.Number = @number
  AND d.DebtorID = e.DebtorId

END

GO
