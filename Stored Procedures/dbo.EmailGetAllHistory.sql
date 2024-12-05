SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EmailGetAllHistory]
	@EmailId INT
AS
BEGIN

SELECT e.[ModifiedWhen]
	  ,e.[EmailId]
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
      ,e.[ModifiedBy]
      ,e.[comment]
	  ,d.Name [DebtorName]
  FROM [dbo].[EmailDebtorsHistory] e (NOLOCK)
  INNER JOIN dbo.Debtors d (NOLOCK)
  ON d.DebtorID = e.DebtorId
  WHERE e.EmailId = @EmailId
  ORDER BY e.ModifiedWhen DESC

END

GO
