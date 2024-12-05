SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Update_IncomeAndExpense]
(
      @INCOMEANDEXPENSEID   int,
      @LASTUPDATED   datetime,
      @ACCOUNTID   int,
      @MONTHLYDISPOSABLEINCOME   money
)
as
begin


update dbo.IncomeAndExpense set
      [LASTUPDATED] = @LASTUPDATED,
      [ACCOUNTID] = @ACCOUNTID,
      [MONTHLYDISPOSABLEINCOME] = @MONTHLYDISPOSABLEINCOME
where [INCOMEANDEXPENSEID] = @INCOMEANDEXPENSEID

end
GO
