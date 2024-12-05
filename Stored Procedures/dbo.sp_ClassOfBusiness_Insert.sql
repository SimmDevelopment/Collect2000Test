SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_ClassOfBusiness_Insert*/
CREATE   PROCEDURE [dbo].[sp_ClassOfBusiness_Insert]
(
	@Code varchar(5),
	@Description varchar(30)
)
AS

/*
** Name:		sp_ClassOfBusiness_Insert
** Function:		This procedure will insert a new Class of Business in cob table
** 			using input parameters.
** Creation:		6/27/2002 jc
**			Used by class CClassOfBusinessFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO cob
		(code,
		Description)
	VALUES(
		@Code,
		@Description)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_ClassOfBusiness_Insert: Cannot insert into cob table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
