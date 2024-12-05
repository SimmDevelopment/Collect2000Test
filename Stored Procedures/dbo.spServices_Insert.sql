SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spServices_Insert*/
CREATE   PROCEDURE [dbo].[spServices_Insert]
(
	@ServiceID int OUTPUT,
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
-- Name:		spServices_Insert
-- Function:		This procedure will insert a new Service in Services table
-- 			using input parameters.
-- Creation:		3/30/2004 jc
--			Used by class CServiceFactory. 
-- Change History:
    BEGIN TRAN
	INSERT INTO Services
		(Description,
		Enabled,
		Email,
		Street1,
		Street2,
		City,
		State,
		Zipcode,
		Phone,
		Fax,
		Contact,
		MinBalance,
		UpdateAccounts,
		ServiceBatch,
		TransformationSchema,
		RequestObject,
		AllowDays,
		DataSchema,
		ManifestID)
	VALUES(
		@Description,
		@Enabled,
		@Email,
		@Street1,
		@Street2,
		@City,
		@State,
		@Zipcode,
		@Phone,
		@Fax,
		@Contact,
		@MinBalance,
		@UpdateAccounts,
		@ServiceBatch,
		@TransformationSchema,
		@RequestObject,
		@AllowDays,
		@DataSchema,
		@ManifestID)

	SET @ServiceID = SCOPE_IDENTITY()

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'spServices_Insert: Cannot insert into Services table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
