SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetDebtorViewByDebtorId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetDebtorViewByDebtorId]
(
	@DebtorID int
)
AS
	SET NOCOUNT ON;
SELECT DebtorID, number, account, Name, [Desk Code], [Desk Description], received, [Status Code], [Status Description], [Debtor Seq], HomePhone, WorkPhone, Street1, Street2, City, State, MR, closed, returned, lastpaid, lastpaidamt, lastinterest, SSN, Zipcode, DOB FROM dbo.LionDebtorView
where DebtorID=@DebtorID
GO
