SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spMaster_Select*/
CREATE     PROCEDURE [dbo].[spMaster_Select] 
	@AccountID int,
	@IncludeCoDebtors BIT = 0
AS

 /*
**Name            :spMaster_Select
**Function        :Returns a single master record
**Creation        :8/19/2004 mr for version 4.0.29
**Used by         :
**Change History  :
*/


set Nocount on

SELECT [master].*,
	[HotNotes].[HotNote] AS [HotNote],
	[PatientInfo].[ServiceDate] AS [ServiceDate]
FROM [dbo].[master] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[HotNotes] WITH (NOLOCK)
ON [master].[number] = [HotNotes].[number]
LEFT OUTER JOIN [dbo].[PatientInfo] AS [PatientInfo]
ON [master].[number] = [PatientInfo].[AccountID]
WHERE [master].[number] = @AccountID;

IF @@ROWCOUNT = 1 AND @IncludeCoDebtors = 1
	EXEC [dbo].[spDebtors_Select] @AccountID;
Return @@Error






GO
