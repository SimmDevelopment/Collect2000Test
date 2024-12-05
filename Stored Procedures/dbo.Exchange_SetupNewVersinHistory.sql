SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 06/16/2006
-- Description:	The stored procedure to be called before the Exchange client def is pushed into version history table
-- =============================================
CREATE PROCEDURE [dbo].[Exchange_SetupNewVersinHistory]
	@UserID varchar(100),
	@Treepath varchar(500),
	@Comment text,
	@Id int output
AS
BEGIN
	SET NOCOUNT ON;
	Declare @altered datetime
	set @altered=GETDATE()

	Declare @exClientId int
	select @exClientId = CustomerReferenceId from Custom_CustomerReference where Treepath=@treepath

	INSERT INTO Exchange_VersionHistory([Altered],[UserID],[ClientId],[Treepath],[Comment])
	Values(@altered,@UserID,@exClientId,@treepath,@comment)

	SET @id=SCOPE_IDENTITY()
	
END
GO
