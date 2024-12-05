SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spServicesCustomers_Update*/
CREATE  PROCEDURE [dbo].[spServicesCustomers_Update]
(
	@ID int,
	@ProfileID uniqueidentifier,
	@MinBalance money
)
AS
-- Name:		spServicesCustomers_Update
-- Function:		This procedure will update ServicesCustomers table
-- 			using input parameters.
-- Creation:		5/12/2004 jc
--			Used by class CSvcCustFactory. 
-- Change History:	6/24/2004 jc added support for column ProfileID
    BEGIN TRAN
	
	UPDATE ServicesCustomers
		SET ProfileID = @ProfileID,
		Minbalance = @MinBalance
	WHERE ID = @ID

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'spServicesCustomers_Update: Cannot update ServicesCustomers table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
