SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCallAttemptAndConversationPolicySettings]
(
 @AccountID int =NULL, 
 @CustomerCode VARCHAR(10)=NULL,
 @Configured BIT OUTPUT,
 @PolicySetting nvarchar(max) OUTPUT
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @PermissionID Int;

IF(@CustomerCode IS NULL)
SELECT @CustomerCode=customer from master where number= @AccountID

SELECT @PermissionID=ID from Permissions where PermissionName='Call Attempt and Conversation Limits';

DECLARE @Effective TABLE (
	[EffectiveID] INTEGER NOT NULL IDENTITY(1, 1),
	[ID] INTEGER NULL,
	[Scope] VARCHAR(25) NOT NULL,
	[AppliedTo] SQL_VARIANT NULL,
	[Description] VARCHAR(100) NULL,
	[Configured] BIT NOT NULL,
	[PolicyTemplate] VARCHAR(3500) NULL,
	[PolicySettings] ntext
);

insert into @Effective
		EXEC [dbo].[Policies_GetAppliedPermissions]
		@PermissionID = @PermissionID,
		@UserID = null,
		@CustomerCode = @CustomerCode,
		@Configured = @Configured OUTPUT
		
select @PolicySetting=PolicySettings from @Effective

END

GO
