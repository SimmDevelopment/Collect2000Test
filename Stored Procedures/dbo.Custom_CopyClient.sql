SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Custom_CopyClient]
@customerReferenceId int
as

INSERT INTO Custom_CustomerReference (Name,Configuration,TreePath,Hidden)
SELECT
'Copy of ' + [Name],
Configuration,
replace(treepath,[Name],'Copy of ' + [Name]),0
FROM Custom_CustomerReference
WHERE CustomerReferenceId = @customerReferenceId

SELECT Scope_Identity()

GO
