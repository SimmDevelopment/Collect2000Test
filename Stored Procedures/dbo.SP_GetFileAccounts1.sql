SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SP_GetFileAccounts1]
	@FileNumber int

 AS

	SELECT M.*, C.Name as CustName from master as M left outer join Customer as C on M.Customer = C.Customer
	WHERE M.number in (SELECT AcctNumber from Files where FileNumber = @FileNumber)
GO
