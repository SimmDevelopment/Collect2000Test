SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NearbyContacts_Insert]
	@number INTEGER,
	@Type VARCHAR(30) = 'Nearby',
	@LName VARCHAR(35),
	@FName VARCHAR(25),
	@MI CHAR(1),
	@Addr1 VARCHAR(40),
	@Addr2 VARCHAR(40),
	@City VARCHAR(30),
	@State CHAR(2),
	@Zip VARCHAR(11),
	@LoginName VARCHAR(10) = NULL,
	@RequestID INTEGER = NULL,
	@ID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF @LoginName IS NULL BEGIN
	SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();
END;

INSERT INTO [dbo].[NearbyContacts] ([number], [Type], [LName], [FName], [MI], [Addr1], [Addr2], [City], [State], [Zip], [LoginName], [RequestID])
VALUES (@number, @Type, @LName, @FName, @MI, @Addr1, @Addr2, @City, @State, @Zip, @LoginName, @RequestID);

SET @ID = SCOPE_IDENTITY();

RETURN 0;

GO
