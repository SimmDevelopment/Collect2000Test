SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Email_GetConsentByDebtorID]  
 @DebtorID int  
AS  
  
SELECT   
 Email.[EmailId],  
 Email.[Email],  
 Email.[DebtorID],  
 Email.[TypeCd],   
 Email.[ConsentGiven],  
 ISNULL(Email.[ConsentSource], '') AS ConsentSource,  
 Email.[WrittenConsent],  
 ISNULL(Email.[Comment], '') AS Comment,  
 Email.[DebtorAssociationId],  
 ISNULL(Debtors.contactmethod, 'None') AS contactmethod
FROM Email    
LEFT OUTER JOIN Debtors   
ON Email.DebtorId = Debtors.DebtorID Where Email.DebtorId = @DebtorID 
GO
