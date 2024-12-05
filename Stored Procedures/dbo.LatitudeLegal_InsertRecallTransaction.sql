SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_InsertRecallTransaction]
(
@number int,
@attyid int,
@attylawlist varchar(5)
)
AS

BEGIN
INSERT INTO LatitudeLegal_RecallTransactions
(number,AttyID,AttyLawList,RecalledDateTime)
VALUES
(@number,@attyid,@attylawlist,getdate())
END

GO
