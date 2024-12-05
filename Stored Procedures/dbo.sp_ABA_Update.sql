SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE  PROCEDURE sp_ABA_Update*/
CREATE  PROCEDURE [dbo].[sp_ABA_Update]
(
	@MICR varchar (9),
	@Bank varchar (50),
	@Addr varchar (36),
	@City varchar (30),
	@State varchar (2),
	@Zip varchar (9),
	@Aba varchar (9),
	@Phone varchar (10),
	@Fax varchar (10)
)
AS

/*
** Name:		sp_ABA_Update
** Function:		This procedure will update a ABA Routing in ABA table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CABARoutingFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE ABA
		SET Bank = @Bank,
		Addr = @Addr,
		City = @City,
		State = @State,
		Zip = @Zip,
		Aba = @Aba,
		Phone = @Phone,
		fax = @Fax
	WHERE MICR = @MICR

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_ABA_Update: Cannot update ABA table.')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
