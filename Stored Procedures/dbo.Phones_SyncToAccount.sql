SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_SyncToAccount]
	@AccountID INTEGER,
	@DebtorID INTEGER,
	@HomePhone VARCHAR(30),
	@WorkPhone VARCHAR(30),
	@CellPhone VARCHAR(20),
	@Fax VARCHAR(50),
	@SpouseHomePhone VARCHAR(20),
	@SpouseWorkPhone VARCHAR(20)
AS
SET NOCOUNT ON;

DECLARE @Seq INTEGER;

BEGIN TRANSACTION;

UPDATE [dbo].[Debtors]
SET @AccountID = [number],
	@Seq = [Seq],
	[homephone] = COALESCE(@HomePhone, ''),
	[workphone] = COALESCE(@WorkPhone, ''),
	[Pager] = COALESCE(@CellPhone, ''),
	[Fax] = COALESCE(@Fax, ''),
	[SpouseHomePhone] = COALESCE(@SpouseHomePhone, ''),
	[SpouseWorkPhone] = COALESCE(@SpouseWorkPhone, ''),
	[PhoneSyncFlag] = CASE
		WHEN [PhoneSyncFlag] IS NULL THEN 0
		WHEN [PhoneSyncFlag] = 0 THEN 1
		ELSE 0
	END
WHERE [DebtorID] = @DebtorID;

UPDATE [dbo].[master]
SET [homephone] = COALESCE(@HomePhone, ''),
	[workphone] = COALESCE(@WorkPhone, '')
WHERE [number] = @AccountID
AND [pseq] = @Seq;

COMMIT TRANSACTION;

RETURN 0;

GO
