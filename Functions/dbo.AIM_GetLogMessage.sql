SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE   FUNCTION [dbo].[AIM_GetLogMessage]
	(
		@logmessageid int
		,@param0 sql_variant
		,@param1 sql_variant
		,@param2 sql_variant
		,@param3 sql_variant
		,@param4 sql_variant
		,@param5 sql_variant
	)
RETURNS varchar(4096)
AS
	BEGIN
		declare @logmessage varchar(4096)
		select @logmessage = '' -- Default the message to nothing
		declare @logmessagetemplate varchar(3400)
		select
			@logmessagetemplate = lm.logmessage
		from
			AIM_LogMessage lm
		where
			lm.logmessageid = @logmessageid
			
		if(@logmessageid > 0)
			begin
				if(@param0 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{0}', convert(varchar(100), @param0))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{0}', '_')
				if(@param1 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{1}', convert(varchar(100), @param1))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{1}', '_')
				if(@param2 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{2}', convert(varchar(100), @param2))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{2}', '_')
				if(@param3 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{3}', convert(varchar(100), @param3))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{3}', '_')
				if(@param4 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{4}', convert(varchar(100), @param4))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{4}', '_')
				if(@param5 is not null)
					select @logmessagetemplate = replace(@logmessagetemplate, '{5}', convert(varchar(100), @param5))
				else
					select @logmessagetemplate = replace(@logmessagetemplate, '{5}', '_')

				select @logmessage = @logmessagetemplate				
			end
	RETURN @logmessage
	END




GO
