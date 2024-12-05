SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[HasComplianceConditionExists]
@DebtorID int
AS

Begin
SET NOCOUNT ON;
DECLARE @Configured BIT;
DECLARE @AccountID INT;
DECLARE @PolicySetting NVARCHAR(MAX);
SELECT @AccountID= AccountID FROM ValidationNotice WHERE DebtorID = @DebtorID
EXEC [dbo].[GetValidationnoticePolicysettings]
		@AccountID = @AccountID,
		@Configured = @Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT

DECLARE @CallAttemptConversation_Configured BIT ;
EXEC [dbo].[GetCallAttemptAndConversationPolicySettings]
		@AccountID = @AccountID,
		@Configured = @CallAttemptConversation_Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT;

DECLARE @hasCondition BIT;

if(@Configured=1)
Begin

	if((select top(1)accountid from validationnotice where debtorid=@DebtorID) is not null)

		Select @hasCondition= case when DebtorID =@DebtorID and (CAST(GetDate() as Date) <= ValidationPeriodExpiration ) or [status] ='Returned' 
		then 1 else 0 end from ValidationNotice where DebtorID =@DebtorID

end
if(@CallAttemptConversation_Configured=1)
Begin
SELECT @hasCondition=
	(SELECT DISTINCT case when Number = @accountid AND [When] = 'Today' AND DoNotCall <> 1 AND AllowedNow <> 0
	then 1 
	when Number = @accountid then ( select
	case when Number=@accountid and  ([NextAllowableCallReason] is not null and ([NextAllowableCallReason] <>'CONTACTED' or 
	[NextAllowableCallReason] <> 'EXPLICIT_PERMISSION' OR [NextAllowableCallReason] <> 'ATTEMPT_LIMIT'))
	then 1 else 0 end as hasCondition
	FROM dbo.Debtors WHERE Number=@accountid )
	else 0 end as hasCondition
	FROM CallPreferences cp
	WHERE Number = @accountid AND [When] = 'Today' AND DoNotCall <> 1 AND AllowedNow <> 0
	)

end

select ISNULL(@hasCondition,0) as hasCondition
End

GO
