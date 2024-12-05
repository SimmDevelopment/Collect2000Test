SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*AcctMoverJob_Insert*/
CREATE  PROCEDURE [dbo].[AcctMoverJob_Insert]
	@DateCreated SmallDateTime,
	@UserName varchar(10),
	@JobDefXML varchar(4000),
	@JobID int output
AS

INSERT INTO AcctMoverJob(DateCreated, UserName, JobDefXML)
VALUES(@DateCreated, @UserName, @JobDefXML)

IF @@Error = 0 BEGIN
	SELECT @JobID = SCOPE_IDENTITY()
	Return 0
END
ELSE
	Return @@Error

GO
