SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Insert_DeskHistory]
@number int,
@oldDesk varchar(20),
@newDesk varchar(20)

AS

INSERT INTO DeskChangeHistory
(number,jobnumber,olddesk,newdesk,oldqlevel,newqlevel,
oldqdate,newqdate,oldbranch,newbranch,[user],dmdatestamp)
SELECT
@number,'',@oldDesk,@newDesk,m.qlevel,m.qlevel,m.qdate,m.qdate,m.branch,m.branch,'EXG',getdate()
FROM master m with (nolock) WHERE m.number = @number

GO
