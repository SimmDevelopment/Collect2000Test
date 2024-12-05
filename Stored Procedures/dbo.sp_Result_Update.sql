SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_Result_Update*/
CREATE    PROCEDURE [dbo].[sp_Result_Update]
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
** Name:		sp_Result_Update
** Function:		This procedure will update a Result Code item in Result table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CResultCodeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE Result
		SET Description = @Description,
		worked = @worked,
		contacted = @contacted,
		ComplianceAttempt = @ComplianceAttempt,
		Note = @Note
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Result_Update: Cannot update Result table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
