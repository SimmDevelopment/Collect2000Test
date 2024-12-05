SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[Job_InsertHistory]

@JobID int,
@JobCategoryID int,
@FKID varchar(50)

AS

INSERT INTO Job_History
(JobID,JobCategoryID,ForeignKeyID,StartedDateTime)
VALUES
(@JobID,@JobCategoryID,@FKID,getdate())

SELECT SCOPE_IDENTITY()




GO
