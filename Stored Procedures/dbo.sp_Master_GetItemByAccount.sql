SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Master_GetItemByAccount*/
CREATE Procedure [dbo].[sp_Master_GetItemByAccount]
	@Account varchar(30)
AS

select * from master where account = @Account

GO
