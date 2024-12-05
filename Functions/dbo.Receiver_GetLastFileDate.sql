SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     FUNCTION [dbo].[Receiver_GetLastFileDate]
	(
		@fileTypeId int
		,@clientId int
	)
returns datetime
as
	begin
		declare @lastFileDate datetime
		select
			top 1
			@lastFileDate = transactiondate
		from
			receiver_history
		where
			filetypeid = @fileTypeId
			and clientid = @clientId
		order by
			transactiondate desc

		if(@lastFileDate IS NULL)
		BEGIN
		SET @lastFileDate = '1900-01-01 00:00:00.000'
		END

		return @lastFileDate
			
	end


GO
