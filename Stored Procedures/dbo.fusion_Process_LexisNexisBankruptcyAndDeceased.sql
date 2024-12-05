SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Process_LexisNexisBankruptcyAndDeceased]
	@RequestID int
AS
BEGIN
	
	-- Need to determine which specific LexisNexis stored proc we call
	IF EXISTS(	SELECT * FROM [dbo].[Services_LexisNexis_Deceased] WITH (NOLOCK)
				WHERE [RequestID] = @RequestID)
	BEGIN
		exec [dbo].[fusion_Process_LexisNexisDeceased] @RequestID
	END
	ELSE 
	BEGIN
		IF EXISTS(	SELECT * FROM [dbo].[Services_LexisNexis_Bankruptcy] WITH (NOLOCK)
					WHERE [RequestID] = @RequestID)
		BEGIN
			exec [dbo].[fusion_Process_LexisNexisBankruptcy] @RequestID
		END
	END
END
GO
