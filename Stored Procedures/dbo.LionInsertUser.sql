SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInsertUser    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionInsertUser]
(
	@UserID int,
	@CustomerGroupID int,
	@SupervisiorEmail varchar(255),
	@NotifyEmail varchar(255),
	@FirstName varchar(50),
	@LastName varchar(50),
	@Enabled bit,
	@LionPassword varchar(255)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[LionUsers] ([UserID], [CustomerGroupID], [SupervisiorEmail], [NotifyEmail], [FirstName], [LastName], [Enabled], [LionPassword]) VALUES (@UserID, @CustomerGroupID, @SupervisiorEmail, @NotifyEmail, @FirstName, @LastName, @Enabled, @LionPassword);
	
SELECT ID, UserID, CustomerGroupID, SupervisiorEmail, NotifyEmail, FirstName, LastName, Enabled, LionPassword FROM LionUsers WHERE (ID = SCOPE_IDENTITY())
GO
