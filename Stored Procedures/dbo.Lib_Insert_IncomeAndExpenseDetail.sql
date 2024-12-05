SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Insert_IncomeAndExpenseDetail]
(
      @IncomeAndExpenseDetailID   int output,
      @INCOMEANDEXPENSEID   int,
      @DESCRIPTION   varchar (50),
      @VALUE   money
)
as
begin


insert into dbo.IncomeAndExpenseDetail
(
    
      [INCOMEANDEXPENSEID],
      [DESCRIPTION],
      [VALUE]
)
values
(
      @INCOMEANDEXPENSEID,
      @DESCRIPTION,
      @VALUE
)

select @IncomeAndExpenseDetailID = SCOPE_IDENTITY()
end
GO
