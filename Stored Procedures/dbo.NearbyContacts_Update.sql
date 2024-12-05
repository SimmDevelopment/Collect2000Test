SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NearbyContacts_Update]
	@ID INTEGER,
	@Type VARCHAR(30),
	@LName VARCHAR(35),
	@FName VARCHAR(25),
	@MI CHAR(1),
	@Addr1 VARCHAR(40),
	@Addr2 VARCHAR(40),
	@City VARCHAR(30),
	@State CHAR(2),
	@Zip VARCHAR(11)
AS
SET NOCOUNT ON;

UPDATE [dbo].[NearbyContacts]
SET [Type] = @Type,
	[LName] = @LName,
	[FName] = @FName,
	[MI] = @MI,
	[Addr1] = @Addr1,
	[Addr2] = @Addr2,
	[City] = @City,
	[State] = @State,
	[Zip] = @Zip
WHERE [NearbyContactID] = @ID;

RETURN 0;


GO
