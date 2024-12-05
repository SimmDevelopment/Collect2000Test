SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE        procedure [dbo].[AIM_AddToSoldPortfolio]
(
	@number int
	,@portfolioId int
)

AS
	declare @portfolioTypeid int
	select
		@portfolioTypeid = portfoliotypeid
	from
		aim_portfolio
	where
		portfolioid = @portfolioId
	
	

	if(@portfolioTypeId = 1)
	begin
		update 
			master
		set 
			status = 'SLD'
			,qlevel = '999'
			,qdate = getdate()
			,restrictedaccess = 1
			,shouldqueue = 0
		where
			number = @number
		declare @portfolioCode varchar(50)
		select
			@portfolioCode = code
		from
			aim_portfolio
		where
			portfolioid = @portfolioid
	
		exec AIM_AddAimNote 1012, @number, @portfolioCode
	
		declare @currentlyplacedagencyid int
		select
			currentlyplacedagencyid
		from
			aim_accountreference
		where
			referencenumber = @number
	
		if(@currentlyplacedagencyid > 0)
			exec AIM_Recall_InsertTransaction @number, 'Y', 2
	end



GO
