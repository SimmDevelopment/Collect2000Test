SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_RemoveReviewFlag] @ArrangementId INTEGER
AS

UPDATE dbo.Arrangements SET ReviewFlag = NULL WHERE Id = @ArrangementId;

RETURN 0
GO
