SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetPDCByUid    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetPDCByUid]
(
	@UID int
)
AS
	SET NOCOUNT ON;
SELECT UID, number, entered, [On Hold], amount, [Check Number], [Deposit Date], Desk, [Nitd Sent], customer, Processed FROM dbo.LionPDC with (nolock) where UID=@UID
GO
