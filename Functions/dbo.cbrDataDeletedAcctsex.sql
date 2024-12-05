SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataDeletedAcctsex] ( @accountid int, @debtorid int, @CbrOutofStatute bit, @statusisfraud bit, @CanReportActive bit, 
						@specialnote char(2), @statuscbrdelete bit )
RETURNS TABLE
AS 
    RETURN
		
					select @accountid as  number,
					@debtorid as debtorid,
					CASE 
						WHEN @CbrOutofStatute = 1 THEN 'DA'
						WHEN @statusisfraud = 1 THEN 'DF' 
						WHEN @statuscbrdelete = 1 THEN 'DA' 
						WHEN @specialnote IN ('DI') THEN 'DA'
						WHEN @specialnote IN ('DA','DF') THEN @specialnote
						ELSE NULL END
						as nextaccountstatus

					


GO
