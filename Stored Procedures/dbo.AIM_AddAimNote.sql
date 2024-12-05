SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/****** Object:  Stored procedure AIM_dbo.AIM_AddAimNote    Script Date: 10/25/2004 5:28:39 PM ******/
CREATE   procedure [dbo].[AIM_AddAimNote]
	(
		 @logmessageid int
		,@filenumber int
		,@param0 sql_variant = null
		,@param1 sql_variant = null
		,@param2 sql_variant = null
		,@param3 sql_variant = null
		,@param4 sql_variant = null
		,@param5 sql_variant = null
	)
as
	begin
		-- Setup the defaults
		declare @user0 varchar(10), @action varchar(6), @result varchar(6), @created datetime
		select @user0 = 'AIM', @action = '+++++', @result = @action, @created = getdate()
		
		-- Define the Aim Message
		declare @aimmessage varchar(4096)
		select @aimmessage = dbo.AIM_GetLogMessage(@logmessageid, @param0, @param1, @param2, @param3, @param4, @param5)
						
		
		insert into
			dbo.Notes
			(
				number
				,created
				,user0
				,action
				,result
				,comment
			)
			values
			(
				@filenumber
				,@created
				,@user0
				,@action
				,@result
				,@aimmessage
			)
		
		
		return 
	end





GO
