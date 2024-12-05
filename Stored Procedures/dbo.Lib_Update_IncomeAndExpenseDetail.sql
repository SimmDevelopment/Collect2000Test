SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Update_IncomeAndExpenseDetail]
(
      @INCOMEANDEXPENSEDETAILID   int,
      @INCOMEANDEXPENSEID   int,
      @DESCRIPTION   varchar (50),
      @VALUE   money
)
as
begin


update dbo.IncomeAndExpenseDetail set
      [INCOMEANDEXPENSEID] = @INCOMEANDEXPENSEID,
      [DESCRIPTION] = @DESCRIPTION,
      [VALUE] = @VALUE
where [INCOMEANDEXPENSEDETAILID] = @INCOMEANDEXPENSEDETAILID

end
GO
