SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_insOSSRequest*/
CREATE  procedure [dbo].[sp_insOSSRequest](
@DebtorID varchar(20),
@AccountID varchar(20),
@RequestDate DateTime,
@UserID varchar(5),
@RequestParameter varchar(100),
@ServiceID varchar(10),
@ReturnData text,
@OSSReqID int OUTPUT )

AS

BEGIN
	Insert into OSSRequests(DebtorID, 
	AccountID, RequestDate, UserID, RequestParameter, ServiceID, ReturnData)
	values (@DebtorID, @AccountID, @RequestDate, 
	@UserID, @RequestParameter, @ServiceID, @ReturnData);Select 
	@OSSReqID = SCOPE_IDENTITY()

END


GO
