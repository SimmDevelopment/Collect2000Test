SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  Procedure [dbo].[get_Toyota_NewBiz_Placements]
@BeginningReceived datetime,
@EndingReceived datetime,
@Customer varchar(7)
as
SELECT Received = convert(varchar(8), m.Received, 112), m.Account, 
       TransCode = 'AP', NewValue = 'ACCOUNT ACKNOWLEDGED', 
       INTERN_EXTERN_FLAG = 'X',
       c.customtext1 AS DPS_ID,
       c.customtext1 AS Recoverer_ID,
       c.customtext2 AS Loan_Code,
       NOT_USED = '   '
FROM Master m WITH(NOLOCK)
INNER JOIN customer c WITH(NOLOCK)
on c.customer = m.customer
where m.Received between @BeginningReceived and @EndingReceived and 
      m.Customer = @customer
GO
