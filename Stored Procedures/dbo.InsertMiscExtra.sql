SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[InsertMiscExtra] AS
insert MiscExtra select number,title,thedata from NewBizBMiscExtra
GO
