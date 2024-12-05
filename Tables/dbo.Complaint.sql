CREATE TABLE [dbo].[Complaint]
(
[ComplaintId] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[DebtorId] [int] NOT NULL,
[DocumentationId] [uniqueidentifier] NULL,
[DateInAdmin] [datetime] NOT NULL CONSTRAINT [DF_Complaint_DateInAdmin] DEFAULT (getutcdate()),
[DateReceived] [datetime] NOT NULL CONSTRAINT [DF_Complaint_DateReceived] DEFAULT (getutcdate()),
[SLADays] [int] NOT NULL CONSTRAINT [DF_Complaint_SLADays] DEFAULT ((0)),
[Owner] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferredBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_Referredby] DEFAULT ('UNK'),
[Details] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_Status] DEFAULT ('UNK'),
[Category] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_Category] DEFAULT ('UNK'),
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_Type] DEFAULT ('UNK'),
[AgainstType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Against] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvestigationCommentsToDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conclusion] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateClosed] [datetime] NULL,
[Outcome] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Justified] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompensationAmount] [money] NULL CONSTRAINT [DF_Complaint_CompensationAmount] DEFAULT ((0)),
[RootCause] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Complaint_RootCause] DEFAULT ('UNK'),
[RecourseDate] [datetime] NULL,
[Dissatisfaction] [bit] NOT NULL CONSTRAINT [DF_Complaint_Dissatisfaction] DEFAULT ((0)),
[DissatisfactionDate] [datetime] NULL,
[Grievances] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [bit] NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_Complaint_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_CreatedBy] DEFAULT ('UNK'),
[ModifiedWhen] [datetime] NOT NULL CONSTRAINT [DF_Complaint_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Complaint_ModifiedBy] DEFAULT ('UNK')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Complaint_WorkFlow_SystemEvents_Closed] ON [dbo].[Complaint]
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
	FROM [Inserted];
	IF (@DateClosed IS NOT NULL)
	BEGIN
		INSERT INTO #EventAccounts ([AccountID])
		SELECT [INSERTED].[AccountId]
		FROM [INSERTED];

		EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Complaint Closed', @CreateNew = 0;
	END;
END;
DROP TABLE #EventAccounts;

RETURN;
                                     
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Complaint_WorkFlow_SystemEvents_Entered]
ON [dbo].[Complaint]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[AccountId]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Complaint Entered', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Complaint_WorkFlow_SystemEvents_Updated] ON [dbo].[Complaint]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[AccountId]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Complaint Updated', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
                                     
GO
ALTER TABLE [dbo].[Complaint] ADD CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED ([ComplaintId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Complaint] ADD CONSTRAINT [FK_Complaint_Debtors] FOREIGN KEY ([DebtorId]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[Complaint] ADD CONSTRAINT [FK_Complaint_Master] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Capquest Custom complaint table used to manage complaints for the Complaints Panel.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to master table.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TODO: Against configurable list of dependant on ComplaintAgainstType items. Valid Values are.: User - list of users; Branch - list of branches; Dept - list of Depts; 3rd Party- free form text. See requirements', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Against'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dropdown of hardcoded items. Drives list of against options. Valid Values are: User, 3rd Party, Branch, Department.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'AgainstType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Code in ComplaintCategory table. Defaults to UNK.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Category'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field to hold any compensation amount related to the complaint. Defaults to 0.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'CompensationAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System Generated Number.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'ComplaintId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field that represents the conclusion of the complaint in free form text', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Conclusion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Created by user.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Created date time.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display only system date of when Complaint outcome is entered', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DateClosed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Document Scanned or manually entered via complaints panel. Defaults to getUTCdate().', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DateInAdmin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The official date the complaint was received by Capquest. Manually keyed or Scanned via ECMS', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DateReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Debtors table.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the complaint has been marked as deleted, which will result in it not showing in the UI. ', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Deleted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complaint detail notes and comments. Freeform textbox.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Details'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field to indicate the customer expressed dissatisfaction of handling of the complaint on the account. Defaults to 0.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Dissatisfaction'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field to indicate date of dissatisfaction.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DissatisfactionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Documentation table. When the dispute is initiated by a document, this will associate the document with the dispute.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'DocumentationId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field to record reason for dissatisfaction', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Grievances'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Investigation notes and comments ', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'InvestigationCommentsToDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Justification drop down list. E.g. Yes, No, In Part.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Justified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Modified by user.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Modification date time.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TODO: List name COMPLTOUT. A field to represent the Complaint Outcome from a configurable drop down list, Valid Values are: Non-Conformity, Training Required, Disciplinary, Process Change.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Outcome'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Owners represent a configurable list of Users within the complaint department. Values come from users.loginname.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Owner'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Recourse Date provided for display only. Field supplied by the data warehouse', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'RecourseDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TODO: get values. List name COMPLTREFR. Configurable ReferredBy drop down list. Defaults to UNK.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'ReferredBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TODO: Create the list. Listname is COMPLTROOT. Configurable list of Root Causes.  User will select a root cause from the drop down list. Defaults to UNK.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'RootCause'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complaint SLA days are display only set at complaint type configuration list level. SLADaysRemaning (client side calculation) = SLADays - (Current System date - DateReceived)', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'SLADays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TODO: get list of status codes. List name COMPLTSTAT. Complaint Status configurable list of items. Defaults to UNK.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complaint Type populated from selection from a configurable list. Possible values are Process, System, Human Error, Client.', 'SCHEMA', N'dbo', 'TABLE', N'Complaint', 'COLUMN', N'Type'
GO
