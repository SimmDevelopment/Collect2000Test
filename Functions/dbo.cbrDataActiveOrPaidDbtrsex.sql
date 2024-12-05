SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataActiveOrPaidDbtrsex] ( @accountid int, @debtorid int, @accountstatus char(2) , @nextaccountstatus char (2), @CanReportActive bit, 
						@nextcompliancecondition char(2), @compliancecondition char(2), @lastcompliancecondition char(2))
RETURNS TABLE
AS 
    RETURN

						select @accountid as number,
							@debtorid as debtorid
							
								where @CanReportActive = 'True'
GO
