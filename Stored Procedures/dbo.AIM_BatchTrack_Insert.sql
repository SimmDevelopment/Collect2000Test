SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_BatchTrack_Insert]
	@name VARCHAR(50),
	@description VARCHAR(256),
	@startDate DATETIME,
	@endDate DATETIME,
	@months	SMALLINT,
	@percentages BIT,
	@cumulativeTotals BIT,
	@summaries  BIT,
	@cardView BIT,
	@aggregation TINYINT,
	@groupPortfolio BIT,
	@groupAgency BIT
AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO [AIM_BatchTrack]
           ([Name]
           ,[Description]
           ,[StartDate]
           ,[EndDate]
           ,[Months]
           ,[Percentages]
           ,[CumulativeTotals]
           ,[Summaries]
           ,[CardView]
           ,[Aggregation]
           ,[GroupPortfolio]
           ,[GroupAgency])
     VALUES
           (@name
           ,@description
           ,@startDate
           ,@endDate
           ,@months
           ,@percentages
           ,@cumulativeTotals
           ,@summaries
           ,@cardView
           ,@aggregation
           ,@groupPortfolio
           ,@groupAgency)

	SELECT @@IDENTITY
	
	SET NOCOUNT OFF
END

GO
