SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE  PROCEDURE sp_Salesman_Update*/
CREATE  PROCEDURE [dbo].[sp_Salesman_Update]
(
	@Code varchar(5),
	@SalesmanName varchar(30),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar(20),
	@State varchar(3),
	@ZipCode varchar(10),
	@Phone varchar(20)
)
AS

/*
** Name:		sp_Salesman_Update
** Function:		This procedure will update a salesman in Salesman table
** 			using input parameters.
** Creation:		6/18/2002 jc
**			Used by class CSalesmanFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE Salesman
		SET Name = @SalesmanName,
		Street1 = @Street1,
		Street2 = @Street2,
		City = @City,
		State = @State,
		Zipcode = @ZipCode,
		phone = @Phone
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Salesman_Update: Cannot update Salesman table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
