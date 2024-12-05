SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetValidationWarnings]
 @accountid INT
 AS
BEGIN

DECLARE @PolicySetting nvarchar(max);
DECLARE @ValidationNotice_Configured BIT ;

EXEC [dbo].[GetValidationnoticePolicySettings]
		@AccountID = @accountid,
		@Configured = @ValidationNotice_Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT;

DECLARE @CallAttemptConversation_Configured BIT ;

EXEC [dbo].[GetCallAttemptAndConversationPolicySettings]
		@AccountID = @accountid,
		@Configured = @CallAttemptConversation_Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT;

WITH TempCTE as (SELECT v.noticeid,
				v.AccountID,
                v.validationnoticesentdate,
                v.validationperiodcompleted,
                v.validationperiodexpiration,
                v.validationnoticetype,
                v.status,
				v.DebtorID,
                d.NAME AS debtorName,
				CASE When v.noticeid is null  
				then  CONVERT(VARCHAR(1000) , 'Validation notice has not been sent for '+
				CONVERT(VARCHAR(300) ,d.name ))+' on this account'
				when v.validationperiodexpiration  >= CAST(GETDATE() AS DATE)
				THEN  CONVERT(VARCHAR(1000) ,'Validation period for '+CONVERT(VARCHAR(300) ,d.name )+
				' on this account has not been completed, Validation period completes on '+ 
				CONVERT(VARCHAR(10),v.validationperiodexpiration))
				END AS WarningMessage
				FROM   validationnotice v
				       RIGHT JOIN debtors d
				               ON d.debtorid = v.debtorid
				WHERE  d.number = @accountid) 

,CTETBL2 AS (SELECT DISTINCT
'Person on this account, '+d.Name+' is not callable today on '+dbo.FormatAsPhoneNumber(cp.PhoneNumber, cp.PhoneExt)+' due to call preference/restrictions, see Compliance Panel for additional information' AS WarningMessage
FROM CallPreferences cp
INNER JOIN Debtors d ON d.DebtorID = cp.DebtorID
WHERE d.Number = @accountid AND [When] = 'Today' AND DoNotCall = 1
UNION ALL
SELECT DISTINCT
'Person on this account, '+d.Name+' is not callable now on '+dbo.FormatAsPhoneNumber(cp.PhoneNumber,cp.PhoneExt)+' due to call preference/restrictions, see Compliance Panel for additional information' AS WarningMessage
FROM CallPreferences cp
INNER JOIN Debtors d ON d.DebtorID = cp.DebtorID
WHERE d.Number = @accountid AND [When] = 'Today' AND DoNotCall = 0 AND AllowedNow = 0
UNION
Select 'Person on account '  + Name + ', is not callable due to ' + 
		CASE WHEN [NextAllowableCallReason] = 'CONTACTED' then 'previous conversation'
			 WHEN [NextAllowableCallReason] = 'EXPLICIT_PERMISSION' OR [NextAllowableCallReason] = 'ATTEMPT_LIMIT' then 'attempt restrictions'				
			ELSE 'Compliance issues'
			
		END
		+ ', next permitted attempt date is ' 
+ CONVERT(VARCHAR(10) ,NextAllowableCallAttemptDate,101) As WarningMessage   from  dbo.Debtors
WHERE Number = @accountId
and NextAllowableCallAttemptDate > getdate())

SELECT DISTINCT WarningMessage FROM TempCTE where WarningMessage is not null and @ValidationNotice_Configured=1
UNION ALL
SELECT DISTINCT WarningMessage FROM CTETBL2 where WarningMessage is not null and  @CallAttemptConversation_Configured=1
END

GO
