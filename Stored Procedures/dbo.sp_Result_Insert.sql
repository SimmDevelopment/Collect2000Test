SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE     PROCEDURE sp_Result_Insert*/
CREATE     PROCEDURE [dbo].[sp_Result_Insert]
(
	@Code varchar(5),
	@Description varchar(30),
	@worked smallint,
	@contacted smallint,
	@ComplianceAttempt smallint,
	@Note text
)
AS

/*
** Name:		sp_Result_Insert
** Function:		This procedure will insert a new Result Code in Result table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CResultCodeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO Result
		(code,
		Description,
		worked,
		contacted,
		ComplianceAttempt,
		note)
	VALUES(
		@Code,
		@Description,
		@worked,
		@contacted,
		@ComplianceAttempt,
		@Note)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Result_Insert: Cannot insert into Result table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
