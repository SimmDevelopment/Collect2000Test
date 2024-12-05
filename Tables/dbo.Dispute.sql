CREATE TABLE [dbo].[Dispute]
(
[DisputeId] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[DebtorId] [int] NOT NULL,
[DocumentationId] [uniqueidentifier] NULL,
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateReceived] [datetime] NOT NULL CONSTRAINT [DF_Dispute_DateReceived] DEFAULT (getutcdate()),
[ReferredBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Details] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dispute_Category] DEFAULT ('UNK'),
[Against] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateClosed] [datetime] NULL,
[RecourseDate] [datetime] NULL,
[Justified] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Outcome] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [bit] NULL,
[ProofRequired] [bit] NULL,
[ProofRequested] [bit] NULL,
[InsufficientProofReceived] [bit] NULL,
[ProofReceived] [bit] NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_Dispute_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dispute_CreatedBy] DEFAULT ('UNK'),
[ModifiedWhen] [datetime] NOT NULL CONSTRAINT [DF_Dispute_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dispute_ModifiedBy] DEFAULT ('UNK')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Dispute_WorkFlow_SystemEvents_Closed] ON [dbo].[Dispute]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);
IF UPDATE([DateClosed])
BEGIN
	DECLARE @DateClosed [DateTime];
	SELECT @DateClosed = [INSERTED].[DateClosed]
	FROM [INSERTED];
	IF (@DateClosed IS NOT NULL)
	BEGIN
		INSERT INTO #EventAccounts ([AccountID])
		SELECT [INSERTED].[Number]
		FROM [INSERTED];

		EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Dispute Closed', @CreateNew = 0;
	END;
END;
DROP TABLE #EventAccounts;

RETURN;
                                     
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Dispute_WorkFlow_SystemEvents_Entered]
ON [dbo].[Dispute]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[Number]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Dispute Entered', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Dispute_WorkFlow_SystemEvents_Updated] ON [dbo].[Dispute]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[number]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Dispute Updated', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
                                     
GO
ALTER TABLE [dbo].[Dispute] ADD CONSTRAINT [PK_Dispute] PRIMARY KEY CLUSTERED ([DisputeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dispute] ADD CONSTRAINT [FK_Dispute_Debtors] FOREIGN KEY ([DebtorId]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[Dispute] ADD CONSTRAINT [FK_Dispute_Master] FOREIGN KEY ([Number]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Liquid panel dispute table', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dispute relates to drop down list. List code is DISPUTEAGT. E.g. 3rd Party, or Client.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Against'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dispute Categories drop down list. List code is DISPUTECAT. E.g. Claims Paid, Fraud, Interest & Charges, PPI, Process, Wrong Trace.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Category'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record created by.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record creation date', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System generated when status is changed to close.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'DateClosed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Official date the Dispute was created either by a user clicking Save after the Create New Dispute button or ECMS generates a Dispute.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'DateReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the dispute has been marked as deleted to prevent it showing in the Disputes grid', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Deleted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reason for the dispute', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Details'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System generated number', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'DisputeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attached Document ID, FK to Documentation table. ', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'DocumentationId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the current dispute has received insufficient proof ', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'InsufficientProofReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Justification drop down list. E.g. Yes, No, In Part.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Justified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record modified by.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record modification date.k', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dispute Outcomes drop down list. List code is DISPUTEOUT Configurable drop down list describing dispute outcome. E.g. Account on Hold, Begin Put Process, Close Contingency Account, Resolved - Continue', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Outcome'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the current dispute has received valid proof', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ProofReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if proof has been requested on the current dispute', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ProofRequested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the current dispute requires proof', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ProofRequired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Recourse Date supplied by the data warehouse.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'RecourseDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dispute Referred By drop down list. List code is DISPUTEREF. E.g. 3rd Party, Client', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'ReferredBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dispute Type drop down list. List code is DISPUTETYP. E.g. Full Balance, Part Balance, Possible Fraud, Incorrect Trace.', 'SCHEMA', N'dbo', 'TABLE', N'Dispute', 'COLUMN', N'Type'
GO
