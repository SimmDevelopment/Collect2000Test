SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetComplianceCallAttemptandConversation]
(
@AccountID int,
@DebtorID int ,
@Status bit OUTPUT
)
AS
BEGIN

SET NOCOUNT ON;
DECLARE @Responsible Bit;
DECLARE @PermissionStatus Bit;
DECLARE @AttemptConversation Bit;

Select @Responsible= d.Responsible FROM debtors d WHERE d.DebtorID = @DebtorID 

DECLARE @CustomerCode varchar(7);
DECLARE @PermissionID Int;
DECLARE @Configured BIT;
SELECT @CustomerCode=customer from master where number=@AccountID
SELECT @PermissionID=ID from Permissions where PermissionName='Call Attempt and Conversation Limits'

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
				
		;with XMLNAMESPACES (DEFAULT 'http://www.debtsoftware.com/Latitude/Policies')
		,policy as (
		select
		CAST(PolicySettings as xml) pxml,Configured
		from
		@Effective
		)select 
		@AttemptConversation= x.v.value('.','bit'),
		@PermissionStatus=policy.Configured
		from
		policy cross apply policy.pxml.nodes('Policy/Setting[@id="AttemptConversation"]') x(v);

If (@PermissionStatus=1 and (@AttemptConversation=1 or @Responsible=1))
		select @Status=1
		else
		select @Status=0
END
GO
