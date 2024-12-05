SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemizationBalance] 
	@AccountID int
AS

SELECT TOP 1 [ItemizationID]
      ,[AccountID]
      ,[ItemizationDateType]
      ,[ItemizationDate]
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance0],0)) As ItemizationBalance0
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance1],0)) As ItemizationBalance1
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance2],0)) As ItemizationBalance2
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance3],0)) As ItemizationBalance3
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance4],0)) As ItemizationBalance4
      ,dbo.FormatCurrency(ISNULL([ItemizationBalance5],0)) As ItemizationBalance5
  FROM [dbo].[ItemizationBalance]
WHERE AccountID = @AccountID ORDER BY ItemizationID DESC;

Return @@Error
GO
