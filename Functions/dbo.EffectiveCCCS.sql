SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[EffectiveCCCS]
    (
      @DebtorID INTEGER
    )
RETURNS TABLE
AS
RETURN
			( SELECT TOP ( 1 )
						c.*
			  FROM      CCCS c
			  WHERE     c.DebtorID = @DebtorID
			  ORDER BY  c.DateCreated DESC)
		
GO
