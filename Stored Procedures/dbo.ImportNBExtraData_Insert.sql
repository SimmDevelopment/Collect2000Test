SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Object:  Stored Procedure dbo.ImportNBExtraData_Insert    Script Date: 2/5/2004 4:36:56 PM ******/
CREATE PROCEDURE [dbo].[ImportNBExtraData_Insert]
@AccountID varchar(30),
@ExtraCode varchar(30),
@Line1 varchar(30)=null,
@Line2 varchar(30)=null,
@Line3 varchar(30)=null,
@Line4 varchar(30)=null,
@Line5 varchar(30)=null

AS

Insert ImportNBExtraData (number, extracode, line1, line2, line3, line4, line5)
values (@AccountID, @extracode, @line1, @line2, @line3, @line4, @line5)

Return @@Error
GO
