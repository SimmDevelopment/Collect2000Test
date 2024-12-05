CREATE TABLE [dbo].[Debtors]
(
[Number] [int] NOT NULL,
[Seq] [int] NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [datetime] NULL,
[JobName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jobaddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobCSZ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Relationship] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spouse] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobCSZ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseHomePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseWorkPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseResponsible] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pager] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone2Type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone3Type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[language] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DLNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorID] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Debtors_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Debtors_DateUpdated] DEFAULT (getdate()),
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isBusiness] [bit] NOT NULL CONSTRAINT [DF_Debtors_isBusiness] DEFAULT (0),
[isParsed] [bit] NOT NULL CONSTRAINT [DF_Debtors_isParsed] DEFAULT (0),
[cbrException] [smallint] NOT NULL CONSTRAINT [DF_Debtors_cbrException] DEFAULT (0),
[cbrExclude] [bit] NOT NULL CONSTRAINT [DF_Debtors_cbrExclude] DEFAULT (0),
[Responsible] [bit] NOT NULL CONSTRAINT [def_Debtors_Responsible] DEFAULT (1),
[USPSKeyLine] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EarlyTimeZone] [int] NULL,
[LateTimeZone] [int] NULL,
[businessName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prefix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [def_Debtors_gender] DEFAULT ('U'),
[ObservesDST] [bit] NOT NULL CONSTRAINT [def_Debtors_ObservesDST] DEFAULT (1),
[RegionCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZoneOverride] [bit] NOT NULL CONSTRAINT [def_Debtors_TimeZoneOverride] DEFAULT (0),
[ISHOMEOWNER] [bit] NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF_payhistory_DateTimeEntered] DEFAULT (getdate()),
[PhoneSyncFlag] [bit] NULL,
[IsAuthorizedAccountUser] [bit] NULL CONSTRAINT [DF__Debtors__IsAuthorizedAccountUser] DEFAULT ((0)),
[cbrException32] [int] NOT NULL CONSTRAINT [DF_Debtors_cbrException32] DEFAULT ((0)),
[cbrECOACode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactmethod] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastCallAttemptDate] [date] NULL,
[TotalCallAttempts] [int] NULL,
[NextAllowableCallAttemptDate] [date] NULL,
[NextAllowableCallReason] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Debtors_SyncPhones]
ON [dbo].[Debtors]
FOR UPDATE, INSERT
AS
SET NOCOUNT ON;

-- Determine if any of the phone fields have been updated.
IF NOT (UPDATE([HomePhone]) OR UPDATE([WorkPhone]) OR UPDATE([Pager]) OR UPDATE([Fax]) OR UPDATE([SpouseHomePhone]) OR UPDATE([SpouseWorkPhone])) BEGIN
	RETURN;
END;

DECLARE @Debtors TABLE (
	[DebtorID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
);

-- The PhoneSyncFlag field signifies whether or not this trigger should synchronize any updates
-- to the Debtors phone fields with the Phones_Master table.  If the value has been updated and

-- The PhoneSyncFlag field has been updated, check to see which Debtor records have a different
-- value than the previous value
IF UPDATE([PhoneSyncFlag]) BEGIN
	INSERT INTO @Debtors ([DebtorID])
	SELECT [INSERTED].[DebtorID]
	FROM [INSERTED]
	LEFT OUTER JOIN [DELETED]
	ON [INSERTED].[DebtorID] = [DELETED].[DebtorID]
	WHERE [DELETED].[DebtorID] IS NULL
	OR ([INSERTED].[PhoneSyncFlag] IS NOT NULL
		AND [DELETED].[PhoneSyncFlag] IS NULL)
	OR ([INSERTED].[PhoneSyncFlag] <> [DELETED].[PhoneSyncFlag]);
END;
-- The PhoneSyncFlag field was not updated.
ELSE BEGIN
	INSERT INTO @Debtors ([DebtorID])
	SELECT [INSERTED].[DebtorID]
	FROM [INSERTED];
END;

-- No eligable debtor records have been identified.
IF NOT EXISTS (SELECT * FROM @Debtors) BEGIN
	RETURN;
END;

DECLARE @BadStatus INTEGER;
DECLARE @HomeType INTEGER;
DECLARE @WorkType INTEGER;
DECLARE @CellType INTEGER;
DECLARE @FaxType INTEGER;
DECLARE @SpouseHomeType INTEGER;
DECLARE @SpouseWorkType INTEGER;

SELECT TOP 1 @HomeType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 0;

SELECT TOP 1 @WorkType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 1;

SELECT TOP 1 @CellType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 2;

SELECT TOP 1 @FaxType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 3;

SELECT TOP 1 @SpouseHomeType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 4;

SELECT TOP 1 @SpouseWorkType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 5;

DECLARE @Phones TABLE (
	[AccountID] INTEGER NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[Type] INTEGER NOT NULL,
	[PhoneNumber] VARCHAR(30) NOT NULL,
	[Extension] VARCHAR(10) NOT NULL
);

IF @HomeType IS NOT NULL AND UPDATE([HomePhone]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @HomeType, [dbo].[StripNonDigits]([Debtors].[homephone]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[homephone])) >= 7;
END;

IF @WorkType IS NOT NULL AND UPDATE([WorkPhone]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @WorkType, [dbo].[StripNonDigits]([Debtors].[workphone]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[workphone])) >= 7;
END;

IF @CellType IS NOT NULL AND UPDATE([Pager]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @CellType, [dbo].[StripNonDigits]([Debtors].[Pager]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[Pager])) >= 7;
END;

IF @FaxType IS NOT NULL AND UPDATE([Fax]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @FaxType, [dbo].[StripNonDigits]([Debtors].[Fax]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[Fax])) >= 7;
END;

IF @SpouseHomeType IS NOT NULL AND UPDATE([SpouseHomePhone]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @SpouseHomeType, [dbo].[StripNonDigits]([Debtors].[SpouseHomePhone]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[SpouseHomePhone])) >= 7;
END;

IF @SpouseWorkType IS NOT NULL AND UPDATE([SpouseWorkPhone]) BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @SpouseWorkType, [dbo].[StripNonDigits]([Debtors].[SpouseWorkPhone]), ''
	FROM [INSERTED] AS [Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[SpouseWorkPhone])) >= 7;
END;

-- If the phone number is at least 11 digits and the first digit is 1 remove that first digit
UPDATE @Phones
SET [PhoneNumber] = SUBSTRING([PhoneNumber], 2, 30)
WHERE [PhoneNumber] LIKE '1%'
AND LEN([PhoneNumber]) > 10;

---- If the phone number is greater than 10 digits move the extra digits to the extension field
--UPDATE @Phones
--SET [Extension] = SUBSTRING([PhoneNumber], 11, 10),
--	[PhoneNumber] = SUBSTRING([PhoneNumber], 1, 10)
--WHERE LEN([PhoneNumber]) > 10;

-- Insert phone numbers into the Phones_Master table if they don't already exist on that account
--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
INSERT INTO [dbo].[Phones_Master] ([Number], [PhoneTypeID], [Relationship], [PhoneStatusID], [OnHold], [PhoneNumber], [PhoneExt], [DebtorID], [DateAdded], [RequestID], [PhoneName], [LoginName],[LastUpdated],[UpdatedBy])
SELECT DISTINCT [Phones].[AccountID], [Phones].[Type], '', NULL, 0, [Phones].[PhoneNumber], [Phones].[Extension], [Phones].[DebtorID], GETDATE(), NULL, '', 'SYNC',NULL,NULL
FROM @Phones AS [Phones]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[Phones_Master]
	WHERE [Phones_Master].[Number] = [Phones].[AccountID]
	AND [Phones_Master].[PhoneNumber] = [Phones].[PhoneNumber]
	AND [Phones_Master].[DebtorID] = [Phones].[DebtorID]
);

RETURN;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Debtors_UpdateLinkData] ON [dbo].[Debtors]
    FOR UPDATE
AS
    IF UPDATE([Name])
        OR UPDATE([SSN])
        OR UPDATE([HomePhone])
        OR UPDATE([Street1])
        OR UPDATE([City])
        OR UPDATE([ZipCode])
        OR UPDATE([lastName])
        OR UPDATE([DLNUM])
        OR UPDATE([DOB]) 
        INSERT  INTO dbo.Linking_DataUpdateEvent ( [DebtorID] )
                SELECT DISTINCT
                        INSERTED.DebtorID
                FROM    [INSERTED]
                        INNER JOIN [DELETED] ON INSERTED.DebtorID = DELETED.DebtorID
                WHERE   ( NOT ISNULL(INSERTED.Name, '') = ISNULL(DELETED.Name, '')
                          OR NOT ISNULL(INSERTED.SSN, '') = ISNULL(DELETED.SSN, '')
                          OR NOT ISNULL(INSERTED.homephone, '') = ISNULL(DELETED.homephone, '')
                          OR NOT ISNULL(INSERTED.Street1, '') = ISNULL(DELETED.Street1, '')
                          OR NOT ISNULL(INSERTED.City, '') = ISNULL(DELETED.City, '')
                          OR NOT ISNULL(INSERTED.ZipCode, '') = ISNULL(DELETED.ZipCode, '')
                          OR NOT ISNULL(INSERTED.lastName, '') = ISNULL(DELETED.lastName, '')
                          OR NOT ISNULL(INSERTED.DLNUM, '') = ISNULL(DELETED.DLNUM, '')
                          OR NOT ISNULL(INSERTED.DOB, '') = ISNULL(DELETED.DOB, '')
                        )
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.Linking_DataUpdateEvent
                                         WHERE  Linking_DataUpdateEvent.DebtorID = INSERTED.DebtorID ) ;

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  TRIGGER [dbo].[trg_Debtors_UpdateTimeZones]
ON [dbo].[Debtors]
FOR INSERT, UPDATE
AS
IF UPDATE([State]) OR UPDATE([ZipCode]) OR UPDATE([HomePhone]) OR UPDATE([WorkPhone])
	UPDATE [dbo].[Debtors]
	SET [EarlyTimeZone] = [dbo].[fnGetTimeZoneEx]([INSERTED].[State], [INSERTED].[ZipCode], ISNULL([INSERTED].[HomePhone], [INSERTED].[WorkPhone]), '8:00 AM'),
		[LateTimeZone] = [dbo].[fnGetTimeZoneEx]([INSERTED].[State], [INSERTED].[ZipCode], ISNULL([INSERTED].[HomePhone], [INSERTED].[WorkPhone]), '8:00 PM'),
		[ObservesDST] = [dbo].[ObservesDaylightSavingTime]([INSERTED].[State], [INSERTED].[ZipCode])
	FROM [dbo].[Debtors]
	INNER JOIN [INSERTED]
	ON [Debtors].[DebtorID] = [INSERTED].[DebtorID]
	WHERE [Debtors].[TimeZoneOverride] = 0
	OR [Debtors].[EarlyTimeZone] IS NULL
	OR [Debtors].[LateTimeZone] IS NULL;




GO
ALTER TABLE [dbo].[Debtors] ADD CONSTRAINT [chk_Debtors_Seq] CHECK (([Seq]>=(0)))
GO
ALTER TABLE [dbo].[Debtors] ADD CONSTRAINT [PK_Debtors] PRIMARY KEY CLUSTERED ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_debtors_cbrException] ON [dbo].[Debtors] ([cbrException32]) INCLUDE ([cbrException]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_Debtors_DebtorID] ON [dbo].[Debtors] ([DebtorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_DLNum] ON [dbo].[Debtors] ([DLNum]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Debtors_FirstName] ON [dbo].[Debtors] ([firstName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_HomePhone] ON [dbo].[Debtors] ([HomePhone]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_debtors_isParsed] ON [dbo].[Debtors] ([isParsed]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Debtors_LastName] ON [dbo].[Debtors] ([lastName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_Name] ON [dbo].[Debtors] ([Name]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_Number] ON [dbo].[Debtors] ([Number]) INCLUDE ([DebtorID], [IsAuthorizedAccountUser], [Seq]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Debtors] ADD CONSTRAINT [uq_Debtors_Number_Seq] UNIQUE NONCLUSTERED ([Number], [Seq]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_OtherName] ON [dbo].[Debtors] ([OtherName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_SSN] ON [dbo].[Debtors] ([SSN]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_Street1] ON [dbo].[Debtors] ([Street1]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtors_WorkPhone] ON [dbo].[Debtors] ([WorkPhone]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary and Secondary Debtors on respective account', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of business If debtor is classdified as a business ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'businessName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the proposed ECOA code for the next cbr evaluation. Valid values are:  Z and T. This set may be expanded to include others as well. ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'cbrECOACode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This field is deprecated.  This column superseeded by cbrexception32 ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'cbrException'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This field represents all exceptions on the debtor(s) during credit bureau reporting. ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'cbrException32'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator which excludes debtor from credit bureau reporting', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'cbrExclude'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors City', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Country', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors County', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'County'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this Debtor row was created', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this debtor was last updated', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique number assigned to each debtor row', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Generic Comment', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DebtorMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Drivers License number', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DLNum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors email Address', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Fax Number', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor first name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'firstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Gender Male,Female or Unknown', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'gender'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'HomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates debtor is an authorised user of the account.  This flag is for use in credit reporting and will be used to determine the correct compliance condition code to be applied', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'IsAuthorizedAccountUser'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business Flag (0- Account not a business 1-Account is a business)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'isBusiness'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates debtor is homeowner when set', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'ISHOMEOWNER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name parsed flag (0 - Account has not been processed with name parse routine, 1 - Account has beed processed)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'isParsed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'JobAddr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Jobaddr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers City,State And Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'JobCSZ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers generic comment', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'JobMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Employer Name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'JobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Language, relates to Langcodes table', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'language'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the date when last call attempts to debtor. ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'LastCallAttemptDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor last name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'lastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Middle Name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'middleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors mail Return Flag (''Y'' - Bad Address ''N''- Good Address)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'MR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the next allowable date when agent can call to debtor. ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'NextAllowableCallAttemptDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is reason for next allowable date. Possible values: CONTACTED=contact made; EXPLICIT_PERMISSION=permission given to call them back on the date; ATTEMPT_LIMIT=limit of number of attempts within time window met; REQUIRES_RECALC=indicates the NextAllowableCallAttemptDate may not be accurate and needs to be recalculated.', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'NextAllowableCallReason'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Other name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhone1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhone2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhone2Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhone3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhone3Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'OtherPhoneType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors pager number', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Pager'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relationship of Debtor to the account', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Relationship'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Responsible flag ( 0 - Debtor not responsible for the debt, 1 - Is responsible)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Responsible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'indicates debtor responsibility.  0 = primary responsible party', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Spouse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseHomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseJobAddr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseJobAddr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer City,State and Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseJobCSZ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseJobMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer name', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseJobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that debtors spouse is responsible for the debt as well (1- Responsible 0-Not responsible)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseResponsible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse work Phone', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SpouseWorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Social Security Number (SSN)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors State', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Suffix (Jr, Sr, III etc...)', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the total number of calls agent attempts a call to debtor. ', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'TotalCallAttempts'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'WorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Debtors', 'COLUMN', N'Zipcode'
GO
