SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ====================================================
-- Author:		Custodian 
-- Create date: 08/18/2009
-- Description:	Validate Account Qlevel and ShouldQueue
-- ====================================================
CREATE PROCEDURE [dbo].[spEvaluateQlevelShouldQueue] 
AS
BEGIN

	BEGIN TRY
	
	SET NOCOUNT ON;

	--Correct orphan reminder accounts 

	update [dbo].[master] set [master].[qlevel] = '599' 
	from [dbo].[master] 
	where [master].[qlevel] = '000' and [number] not in (select [reminders].[accountid] from [dbo].[reminders]) 

	--Correct non-synced master.shouldqueue to qlevel.shouldqueue 

	update [dbo].[master] 
	set [master].[shouldqueue] = [qlevel].[shouldqueue]
	from [dbo].[master] with(nolock) 
	join [dbo].[qlevel]  with(nolock) 
	on [master].[qlevel] = [qlevel].[code] 
	where [master].[shouldqueue] <> [qlevel].[shouldqueue] 

	--Correct Incorrectly sync'd support queue items shouldqueue to master.shouldqueue 


	update [dbo].[master] 
	set [master].[shouldqueue] = [supportqueueitems].[shouldqueue] 
	from [dbo].[master] with(nolock) 
	join [dbo].[supportqueueitems]  with(nolock) 
	on [master].[number] = [supportqueueitems].[accountid] 
	where [master].[shouldqueue] <> [supportqueueitems].[shouldqueue]

	END TRY
	BEGIN CATCH
		SELECT * FROM [dbo].[fnGetErrorInfo]()
		RETURN 1
	END CATCH

END

GO
