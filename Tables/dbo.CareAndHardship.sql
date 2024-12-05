CREATE TABLE [dbo].[CareAndHardship]
(
[CareAndHardshipId] [int] NOT NULL IDENTITY(1, 1),
[CareTypeCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinancialHardshipCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [int] NOT NULL,
[DebtorId] [int] NOT NULL,
[ContactLetter] [bit] NULL,
[ContactTelephone] [bit] NULL,
[ContactSMS] [bit] NULL,
[ContactEmail] [bit] NULL,
[ContactFax] [bit] NULL,
[Braille] [bit] NULL,
[LargePrint] [bit] NULL,
[AudioFiles] [bit] NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Consent] [bit] NULL,
[HoldDaysApproved] [bit] NULL,
[HoldExpirationDate] [datetime] NULL,
[HoldDays] [int] NULL,
[CareProofRequested] [bit] NULL,
[CareProofReceived] [bit] NULL,
[HardshipProofRequested] [bit] NULL,
[HardshipProofReceived] [bit] NULL,
[FinancialHardship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Confirmed] [bit] NULL,
[ClosedDate] [datetime] NULL,
[DDANote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrisonName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrisonNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrisonSentenceDate] [datetime] NULL,
[PrisonReleaseDate] [datetime] NULL,
[PrisonInformant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_CareAndHardship_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CareAndHardship_CreatedBy] DEFAULT ('UNK'),
[ModifiedWhen] [datetime] NULL CONSTRAINT [DF_CareAndHardship_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_CareAndHardship_WorkFlow_SystemEvents_Closed] ON [dbo].[CareAndHardship]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);
IF UPDATE([ClosedDate])
BEGIN
	DECLARE @DateClosed [DateTime];
	SELECT @DateClosed = [INSERTED].[ClosedDate]
	FROM [INSERTED];
	IF (@DateClosed IS NOT NULL)
	BEGIN
		INSERT INTO #EventAccounts ([AccountID])
		SELECT [INSERTED].[AccountId]
		FROM [INSERTED];

		EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Care and Hardship Closed', @CreateNew = 0;
	END;
END;
DROP TABLE #EventAccounts;

RETURN;
                                     
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_CareAndHardship_WorkFlow_SystemEvents_Entered]
ON [dbo].[CareAndHardship]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[AccountId]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Care and Hardship Entered', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_CareAndHardship_WorkFlow_SystemEvents_Updated] ON [dbo].[CareAndHardship]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[AccountId]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Care and Hardship Updated', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
                                     
GO
ALTER TABLE [dbo].[CareAndHardship] ADD CONSTRAINT [PK_CareAndHardship] PRIMARY KEY CLUSTERED ([CareAndHardshipId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CareAndHardship] ADD CONSTRAINT [FK_CareAndHardship_Debtors] FOREIGN KEY ([DebtorId]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[CareAndHardship] ADD CONSTRAINT [FK_CareAndHardship_Number] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manages the Care and Financial Hardship panel. ', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Master table.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not audio files is a special requirement.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'AudioFiles'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not braille is a special requirement.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'Braille'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for care and hardship records', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CareAndHardshipId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing if care proof has been received.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CareProofReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing if care proof has been requested.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CareProofRequested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code representing the care type, chosen from a configurable list. Relates to the CareType table.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CareTypeCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents the date a care case is closed. This should only be set if the status is Closed.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ClosedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field used to represent free form comments', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing whether or not the care is confirmed.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'Confirmed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not there is consent. This drives which care type records can be created.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'Consent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not an individual can be contacted by email.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ContactEmail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not an individual can be contacted by fax.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ContactFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not an individual can be contacted by letter.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ContactLetter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not an individual can be contacted by SMS.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ContactSMS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not an individual can be contacted by telephone.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ContactTelephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who created the initial record.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the record was created.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field used to represent free form DDA Notes', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'DDANote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Debtors table.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Configurable list of financial difficulties. Valid values include: Unemployment No Benefits, Unemployment Benefits, Overextended Credit, 3pdm, Relationship Breakdown, Short Term Illness, or Unwilling or Unable to Diclose Information', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'FinancialHardship'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code representing the financial hardship type, chosen from a configurable list.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'FinancialHardshipCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing if proof of hardship condition has been received.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'HardshipProofReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing if proof of hardship condition has been requested.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'HardshipProofRequested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Number of Days an Account will be on hold', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'HoldDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field representing whether or not the hold days are approved.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'HoldDaysApproved'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field that represents the expiration date of a hold', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'HoldExpirationDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents whether or not large print is a special requirement.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'LargePrint'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who last modified the record.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date field representing the last time a record was modified.', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Theoretically this field is only applicable if Care Type is "Prison"', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'PrisonInformant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Theoretically this field is only applicable if Care Type is "Prison"', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'PrisonName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Theoretically this field is only applicable if Care Type is "Prison"', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'PrisonNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Theoretically this field is only applicable if Care Type is "Prison"', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'PrisonReleaseDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Theoretically this field is only applicable if Care Type is "Prison"', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'PrisonSentenceDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of the Care and Hardship record. Valid values include: Proof Confirmed, Proof Un-Confirmed, Proof Not Required, and Closed', 'SCHEMA', N'dbo', 'TABLE', N'CareAndHardship', 'COLUMN', N'Status'
GO
