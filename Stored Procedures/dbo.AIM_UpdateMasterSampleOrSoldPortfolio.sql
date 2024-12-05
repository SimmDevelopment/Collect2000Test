SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateMasterSampleOrSoldPortfolio]
@portfolioid int

AS


BEGIN

declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'


while @@rowcount>0
begin
	set rowcount @sqlbatchsize
	UPDATE Master  with (rowlock) SET SoldPortfolio = @portfolioid 
	from AIM_TempSampleAccounts t 
	join master m on t.number = m.number
	where m.SoldPortfolio <> @portfolioid or m.SoldPortfolio is null
end
set rowcount 0
END

GO
