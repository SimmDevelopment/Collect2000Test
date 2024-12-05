SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spExtraData_Select*/
CREATE PROCEDURE [dbo].[spExtraData_Select] 
	@AccountID int
AS

 /*
**Name            :spExtraData_Select
**Function        :Returns all ExtraData rows for a single account
**Creation        :8/19/2004 mr for version 4.0.29
**Used by         :
**Change History  :
*/


set Nocount on

SELECT * from ExtraData with(nolock) where number = @AccountID

Return @@Error
GO
