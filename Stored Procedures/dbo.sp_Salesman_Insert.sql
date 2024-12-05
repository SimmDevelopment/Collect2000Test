SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE  PROCEDURE sp_Salesman_Insert*/
CREATE  PROCEDURE [dbo].[sp_Salesman_Insert]
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
** Name:		sp_Salesman_Insert
** Function:		This procedure will insert a new salesman in salesman table
** 			using input parameters.
** Creation:		6/18/2002 jc
**			Used by class CSalesmanFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO Salesman
		(code,
		Name,
		Street1,
		Street2,
		City,
		State,
		Zipcode,
		phone)
	VALUES(
		@Code,
		@SalesmanName,
		@Street1,
		@Street2,
		@City,
		@State,
		@ZipCode,
		@Phone)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Salesman_Insert: Cannot insert into Salesman table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
