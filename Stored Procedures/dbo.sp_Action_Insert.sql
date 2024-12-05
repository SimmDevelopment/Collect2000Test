SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Action_Insert*/
CREATE   PROCEDURE [dbo].[sp_Action_Insert]
(
	@Code varchar(5),
	@Description varchar(30),
	@WasAttempt bit,
	@WasWorked bit
)
AS
-- Name:		sp_Action_Insert
-- Function:		This procedure will insert a new action in Action table
-- 			using input parameters.
-- Creation:		6/25/2002 jc
--			Used by class CActionCodeFactory. 
-- Change History:	7/1/2004 jc added suppport for new columns WasAttempt, WasWorked
    BEGIN TRAN
	INSERT INTO Action
		(code, Description, WasAttempt, WasWorked)
	VALUES(
		@Code, @Description, @WasAttempt, @WasWorked)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Action_Insert: Cannot insert into Action table.')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
