SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*DebtorView*/
CREATE VIEW [dbo].[DebtorView]
AS
SELECT     dbo.Debtors.DebtorID, dbo.Debtors.Number, dbo.Debtors.Seq, dbo.Debtors.Name, dbo.Debtors.Street1, dbo.Debtors.Street2, dbo.Debtors.City, 
                      dbo.Debtors.State, dbo.Debtors.Zipcode, dbo.Debtors.HomePhone, dbo.Debtors.WorkPhone, dbo.Debtors.SSN, dbo.Debtors.MR, 
                      dbo.Debtors.OtherName, dbo.Debtors.DOB, dbo.Debtors.JobName, dbo.Debtors.JobAddr1, dbo.Debtors.Jobaddr2, dbo.Debtors.JobCSZ, 
                      dbo.Debtors.JobMemo, dbo.Debtors.Relationship, dbo.Debtors.Spouse, dbo.Debtors.SpouseJobName, dbo.Debtors.SpouseJobAddr1, 
                      dbo.Debtors.SpouseJobAddr2, dbo.Debtors.SpouseJobCSZ, dbo.Debtors.SpouseJobMemo, dbo.Debtors.SpouseHomePhone, 
                      dbo.Debtors.SpouseWorkPhone, dbo.Debtors.SpouseResponsible, dbo.Debtors.Pager, dbo.Debtors.OtherPhone1, dbo.Debtors.OtherPhoneType, 
                      dbo.Debtors.OtherPhone2, dbo.Debtors.OtherPhone2Type, dbo.Debtors.OtherPhone3, dbo.Debtors.OtherPhone3Type, dbo.Debtors.DebtorMemo, 
                      dbo.Debtors.[language], dbo.Debtors.DLNum, dbo.Debtors.Fax, dbo.Debtors.Email, dbo.restrictions.home AS NoHomeCalls, 
                      dbo.restrictions.job AS NoWorkCalls, dbo.restrictions.calls AS NoCalls, dbo.restrictions.comment AS RestrictionComment, 
                      dbo.restrictions.suppressletters AS SuppressLetters, dbo.restrictions.RestrictionID AS RestrictionsID, dbo.DebtorAttorneys.ID AS AttorneyID, 
                      dbo.Bankruptcy.BankruptcyID AS BankruptcyID
FROM         dbo.Debtors LEFT OUTER JOIN
                      dbo.restrictions ON dbo.Debtors.DebtorID = dbo.restrictions.DebtorID LEFT OUTER JOIN
                      dbo.DebtorAttorneys ON dbo.Debtors.DebtorID = dbo.DebtorAttorneys.DebtorID LEFT OUTER JOIN
                      dbo.Bankruptcy ON dbo.Debtors.DebtorID = dbo.Bankruptcy.DebtorID
GO
