SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneContactPreferenceChoiceHistory_GetAll]
	@MasterPhoneID INT
AS
BEGIN

SELECT cpc.Code [When], pcpc.CanCall [Can Call], pcpc.CreatedWhen [Created When], pcpc.CreatedBy [Created By]
FROM dbo.PhoneContactPreferenceChoiceHistory pcpc (NOLOCK)
INNER JOIN dbo.Custom_ListData cpc (NOLOCK)
ON cpc.ListCode = 'CONTPREF'
AND cpc.Code = pcpc.ContactPreferenceChoiceCode
WHERE pcpc.MasterPhoneId = @MasterPhoneID
ORDER BY pcpc.CreatedWhen DESC, cpc.ID ASC

END

GO
