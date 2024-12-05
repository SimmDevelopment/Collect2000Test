SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Target_Post_Maintenance]

@number as int

 AS

update debtors
set Pager = OtherPhone1, OtherPhone1 = ''
where number = @number and seq = 0
GO
