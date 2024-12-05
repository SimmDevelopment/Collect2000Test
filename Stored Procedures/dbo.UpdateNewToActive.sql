SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================

-- Author:        Mike Devlin

-- Create date: 11/14/2007

-- Description:   Update the master.status to Active if it is New

--                      and update other related information...


--UPDATED 4/7/2010 | EMW | Added code to insert a record into statushistory for change
-- =============================================

CREATE PROCEDURE [dbo].[UpdateNewToActive] 

      @FileNumber int, 

      @WasNew bit OUTPUT

AS

BEGIN

      -- SET NOCOUNT ON added to prevent extra result sets from

      -- interfering with SELECT statements.

      SET NOCOUNT ON;

 

      DECLARE @FirstWorkDate datetime

 

      -- Default a few variables...

      SET @WasNew = 0

      SET @FirstWorkDate = CAST(CONVERT(varchar, GETDATE(), 107)as datetime)

      
	insert into statushistory(Accountid, datechanged, username, oldstatus, newstatus)
	select @filenumber, getdate(), 'GLOBAL', 'NEW', 'ACT' from master with(nolock) where number = @filenumber and status ='NEW'


      UPDATE master 

      SET Status = 'ACT', Complete1 = ISNULL(Complete1,@FirstWorkDate)  

      WHERE number = @FileNumber AND status = 'NEW'



      

      IF (@@ERROR <> 0) 

            RETURN @@ERROR

 

      IF (@@ROWCOUNT > 0) 

      BEGIN

            PRINT 'UpdateNewToActive updated ' + CONVERT(varchar, @@ROWCOUNT) + ' records for filenumber: ' + CONVERT(varchar, @FileNumber)

            SET @WasNew = 1

      END

      ELSE 

      BEGIN

            PRINT 'UpdateNewToActive updated 0 records for filenumber: ' + CONVERT(varchar, @FileNumber)

            SET @WasNew = 0

      END

 

      RETURN @@ERROR

END

GO
