SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spServicesCustomers_Insert*/
CREATE   PROCEDURE [dbo].[spServicesCustomers_Insert]
(
	@ID int OUTPUT,
	@ServiceID int,
	@CustomerID int,
	@ProfileID uniqueidentifier,
	@MinBalance money
)
AS
-- Name:		spServicesCustomers_Insert
-- Function:		This procedure will insert in ServicesCustomers table
-- 			using input parameters.
-- Creation:		5/12/2004 jc
--			Used by class CSvcCustFactory. 
-- Change History:	6/24/2004 jc added support for column ProfileID
    BEGIN TRAN
	INSERT INTO ServicesCustomers (ServiceID, CustomerID, ProfileID, MinBalance)
	VALUES (@ServiceID, @CustomerID, @ProfileID, @MinBalance)

	SET @ID = SCOPE_IDENTITY()

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'spServicesCustomers_Insert: Cannot insert into ServicesCustomers table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
