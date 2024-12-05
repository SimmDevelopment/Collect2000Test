SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_ABA_Insert*/
CREATE   PROCEDURE [dbo].[sp_ABA_Insert]
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
** Name:		sp_ABA_Insert
** Function:		This procedure will insert a new ABA Routing in ABA table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CABARoutingFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO ABA
		(MICR, 
		Bank, 
		Addr, 
		City, 
		State, 
		Zip, 
		Aba, 
		Phone, 
		Fax)
	VALUES(
		@MICR, 
		@Bank, 
		@Addr, 
		@City, 
		@State, 
		@Zip, 
		@Aba, 
		@Phone, 
		@Fax)

    IF (@@error!=0)
    BEGIN
        RAISERROR ('20001',16,1,'sp_ABA_Insert: Cannot insert into ABA table.')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
