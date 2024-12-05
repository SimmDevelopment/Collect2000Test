SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Object:  Stored Procedure dbo.ImportNBMiscExtra_Insert    Script Date: 2/5/2004 4:36:56 PM ******/
CREATE PROCEDURE [dbo].[ImportNBMiscExtra_Insert] 
	@AccountID int,
	@TheData varchar(100),
	@Title varchar(30)

AS

INSERT INTO ImportNBMiscExtra(Number, Title, TheData)VALUES(@AccountID, @Title, @TheData)

Return @@Error
GO
