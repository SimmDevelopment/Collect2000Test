SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Insert_IncomeAndExpense]
(
      @IncomeAndExpenseID   int output,
      @LASTUPDATED   datetime,
      @ACCOUNTID   int,
      @MONTHLYDISPOSABLEINCOME   money
)
as
begin


insert into dbo.IncomeAndExpense
(
    
      [LASTUPDATED],
      [ACCOUNTID],
      [MONTHLYDISPOSABLEINCOME]
)
values
(
      @LASTUPDATED,
      @ACCOUNTID,
      @MONTHLYDISPOSABLEINCOME
)

select @IncomeAndExpenseID = SCOPE_IDENTITY()
end
GO
