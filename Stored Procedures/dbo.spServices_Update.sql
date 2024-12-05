SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spServices_Update*/
CREATE  PROCEDURE [dbo].[spServices_Update]
(
      @ServiceID int,
      @Description varchar(50),
      @Enabled bit,
      @Email varchar(50),
      @Street1 varchar(30),
      @Street2 varchar(30),
      @City varchar(20),
      @State varchar(2),
      @Zipcode varchar(10),
      @Phone varchar(15),
      @Fax varchar(15),
      @Contact varchar(30),
      @MinBalance money,
      @UpdateAccounts bit,
      @ServiceBatch int,
      @TransformationSchema text,
      @RequestObject varchar(50),
      @AllowDays int,
      @DataSchema text,
      @ManifestID uniqueidentifier
)
AS

-- Name:          spServices_Update
-- Function:            This procedure will update a Service in Services table
--                using input parameters.
-- Creation:            3/30/2004 jc
--                Used by class CServiceFactory. 
-- Change History:
--2/25/2009 KMG
--This stored procedure is used from the Services Maintenance Form and updates data incorrectly
--I have modified it to only update fields the user can and should modify from said form
	BEGIN TRAN

      UPDATE Services
            SET 
            --Description = @Description,
            [Enabled] = @Enabled,
            Email = @Email,
            Street1 = @Street1,
            Street2 = @Street2,
            City = @City,
            State = @State,
            Zipcode = @Zipcode,
            Phone = @Phone,
            Fax = @Fax,
            Contact = @Contact,
            MinBalance = @MinBalance,
            --UpdateAccounts = @UpdateAccounts,
            --ServiceBatch = @ServiceBatch,
            --TransformationSchema = @TransformationSchema,
            --RequestObject = @RequestObject,
            AllowDays = @AllowDays
            --DataSchema = @DataSchema,
            --ManifestID = @ManifestID
      WHERE ServiceID = @ServiceID

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'spServices_Update: Cannot update Services table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
