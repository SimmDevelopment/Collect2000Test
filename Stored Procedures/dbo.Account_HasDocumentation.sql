SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_HasDocumentation] @AccountID INTEGER, @HasDocumentation BIT OUTPUT
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM [dbo].[Documentation_Attachments] WHERE [AccountID] = @AccountID)
	SET @HasDocumentation = 1;
ELSE
	SET @HasDocumentation = 0;

RETURN 0;

GO
