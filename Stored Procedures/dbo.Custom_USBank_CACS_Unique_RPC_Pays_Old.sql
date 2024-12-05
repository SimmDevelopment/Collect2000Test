SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
--		07/03/2023 Updated to customer group 382
--		10/13/2023 BGM Setup for Language Preference Update
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Unique_RPC_Pays_Old]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = @CustGroupID --Production
SET @CustGroupID = 113 --Test	

    -- Insert statements for procedure here
	IF EXISTS ( SELECT  *
	FROM    tempdb.sys.tables
	WHERE   name LIKE '#tmpusbankrpcnotes%' ) 
		BEGIN
			DROP TABLE #tmpusbankrpcnotes
		END
CREATE TABLE #tmpusbankrpcnotes
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [FileNumber] INT NULL ,
  [DateCreated] DATETIME NULL
)


--DECLARE @startDate DATETIME
--DECLARE @endDate DATETIME
--DECLARE @date DATETIME

--SET @startDate = '20200201'
--SET @endDate = '20200229'

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

INSERT INTO #tmpusbankrpcnotes ( FileNumber, DateCreated )

SELECT number, MIN(created)
FROM notes n WITH (NOLOCK)
WHERE number IN (
SELECT number 
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID))
AND result IN (SELECT code FROM result WITH (NOLOCK) WHERE contacted = 1)
GROUP BY n.number


SELECT (SELECT COUNT(*) AS firstRPC FROM #tmpusbankrpcnotes t
WHERE DateCreated BETWEEN @startDate AND @endDate) AS UniqueFirstRPC,

--Payments on same day as RPC
(SELECT COUNT(*)
FROM payhistory p WITH (NOLOCK) INNER JOIN #tmpusbankrpcnotes t WITH (NOLOCK) ON number = FileNumber AND DateCreated BETWEEN @startDate AND @endDate
WHERE entered = CAST(DateCreated AS DATE)) AS PayonFirstRPC

DROP TABLE #tmpusbankrpcnotes
END
GO
