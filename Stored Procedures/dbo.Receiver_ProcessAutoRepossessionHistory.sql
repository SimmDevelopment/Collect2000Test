SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoRepossessionHistory]
@client_id int,
@file_number int,
@ID int,
@LoginName [varchar](30),
@Status [varchar](30),
@AgencyName  [varchar](30),
@DateTimeStamp [datetime],
@Comment [text]
AS
BEGIN
	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receivernumber

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_RepossessionHistory] (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[Auto_RepossessionHistory](
		[AccountID],
		[LoginName],
		[Status],
		[AgencyName],
		[DateTimeStamp],
		[Comment])
		
		SELECT 
		@receiverNumber,--[AccountID] [int] NULL,
		@LoginName,--[LoginName] [varchar](30) NULL,
		@Status,--[Status] [varchar](30) NULL,
		@AgencyName,--[AgencyName] [varchar](30) NULL,
		@DateTimeStamp,--[DateTimeStamp] [datetime] NULL,
		@Comment--[Comment] [text] NULL

	END
END

GO
