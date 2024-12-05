SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetCurrentMonthYear    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/27/2006
-- Description:	Gets currentmonth,currentyear
-- =============================================
CREATE PROCEDURE [dbo].[LionGetCurrentMonthYear]
	@currentMonth int output,
	@currentYear int output
AS
BEGIN
	SET NOCOUNT ON;

	Select @currentMonth = currentmonth, @currentYear = currentyear from ControlFile

    
END

GO
