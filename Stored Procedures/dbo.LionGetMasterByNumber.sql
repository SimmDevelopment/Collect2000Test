SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetMasterByNumber    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetMasterByNumber]
	@number int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	number, link, [Desk Code], Name, Street1, Street2, City, Zipcode, State, account, MR, homephone, workphone, specialnote, received, 
			closed, returned, lastpaid, lastpaidamt, lastinterest, interestrate, worked, userdate1, userdate2, userdate3, contacted, [Status Code], customer, original, 
			original1, original2, original3, original4, original5, original6, original7, original8, original9, original10, Accrued2, Accrued10, paid, paid1, paid2, paid3, 
			paid4, paid5, paid7, paid6, paid8, paid9, paid10, current0, current1, current2, current3, current4, current6, current7, current5, current8, current9, 
			current10, queue, qdate, qlevel, extracodes, feecode, clidlc, clidlp, seq, Pseq, Branch, TotalViewed, TotalWorked, TotalContacted, DOB, sysmonth, 
			SysYear, [Desk Description], [Status Description]
	FROM	LionMasterView with (nolock)
	where number=@number
END


GO
