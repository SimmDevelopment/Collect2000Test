SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*spAccount_HasNSF*/
CREATE  PROCEDURE [dbo].[spAccount_HasNSF]
	@AccountID int
AS

Select count(number) as TheCount from payhistory with(nolock) where number = @AccountID and Batchtype LIKE 'P_R'

Return @@Error



GO
