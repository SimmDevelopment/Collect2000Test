SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_SelectAppliedPermissions]
AS
SET NOCOUNT ON;

SELECT [ID],
	CASE
		WHEN [RoleID] IS NOT NULL THEN 'Role'
		WHEN [UserID] IS NOT NULL THEN 'User'
		WHEN [BranchCode] IS NOT NULL THEN 'Branch'
		WHEN [DepartmentID] IS NOT NULL THEN 'Department'
		WHEN [TeamID] IS NOT NULL THEN 'Team'
		WHEN [DeskCode] IS NOT NULL THEN 'Desk'
		WHEN [ClassCode] IS NOT NULL THEN 'Business Class'
		WHEN [CustomGroupID] IS NOT NULL THEN 'Customer Group'
		WHEN [CustomerCode] IS NOT NULL THEN 'Customer'
		ELSE 'System'
	END AS [Scope],
	CASE
		WHEN [RoleID] IS NOT NULL THEN CAST([RoleID] AS SQL_VARIANT)
		WHEN [UserID] IS NOT NULL THEN CAST([UserID] AS SQL_VARIANT)
		WHEN [BranchCode] IS NOT NULL THEN CAST([BranchCode] AS SQL_VARIANT)
		WHEN [DepartmentID] IS NOT NULL THEN CAST([DepartmentID] AS SQL_VARIANT)
		WHEN [TeamID] IS NOT NULL THEN CAST([TeamID] AS SQL_VARIANT)
		WHEN [DeskCode] IS NOT NULL THEN CAST([DeskCode] AS SQL_VARIANT)
		WHEN [ClassCode] IS NOT NULL THEN CAST([ClassCode] AS SQL_VARIANT)
		WHEN [CustomGroupID] IS NOT NULL THEN CAST([CustomGroupID] AS SQL_VARIANT)
		WHEN [CustomerCode] IS NOT NULL THEN CAST([CustomerCode] AS SQL_VARIANT)
		ELSE CAST(NULL AS SQL_VARIANT)
	END AS [AppliesTo],
	[PermissionID],
	[Configured],
	[PolicySettings],
	[ModifiedBy],
	[ModifiedDate]
FROM [dbo].[AppliedPermissions];

RETURN 0;

GO
