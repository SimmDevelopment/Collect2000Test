CREATE TABLE [dbo].[CourtCases]
(
[CourtCaseID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[CourtID] [int] NOT NULL CONSTRAINT [DF_CourtCases_CourtID] DEFAULT (0),
[Judge] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CaseNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateFiled] [datetime] NULL,
[Judgement] [bit] NOT NULL,
[JudgementAmt] [money] NOT NULL CONSTRAINT [DF_CourtCases_JudgementAmt] DEFAULT (0),
[JudgementIntRate] [real] NOT NULL CONSTRAINT [DF_CourtCases_JudgementIntRate] DEFAULT (0),
[JudgementDate] [datetime] NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiscInfo1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiscInfo2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Plaintiff] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Defendant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAnswered] [smalldatetime] NULL,
[StatuteDeadline] [smalldatetime] NULL,
[CourtDate] [datetime] NULL,
[DiscoveryCutoff] [smalldatetime] NULL,
[MotionCutoff] [smalldatetime] NULL,
[ArbitrationDate] [datetime] NULL,
[LastSummaryJudgementDate] [smalldatetime] NULL,
[JudgementIntAward] [money] NOT NULL CONSTRAINT [DF_CourtCases_JudgementIntAward] DEFAULT (0),
[JudgementCostAward] [money] NOT NULL CONSTRAINT [DF_CourtCases_JudgementCostAward] DEFAULT (0),
[JudgementOtherAward] [money] NOT NULL CONSTRAINT [DF_CourtCases_JudgementOtherAward] DEFAULT (0),
[IntFromDate] [smalldatetime] NULL,
[AccruedInt] [money] NOT NULL CONSTRAINT [DF_CourtCases_AccruedInt] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_CourtCases_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_CourtCases_DateUpdated] DEFAULT (getdate()),
[UpdatedBy] [int] NOT NULL CONSTRAINT [DF_CourtCases_UpdatedBy] DEFAULT (0),
[UpdateChecksum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CourtCases_UpdateChecksum] DEFAULT (checksum(getdate())),
[CourtRoom] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceDate] [datetime] NULL,
[ServiceType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscoveryReplyDate] [datetime] NULL,
[JudgementAttorneyCostAward] [money] NOT NULL CONSTRAINT [DF__CourtCase__Judge__5E0C7D34] DEFAULT (0),
[GarnishmentCourtID] [int] NULL,
[JudgementCourtID] [int] NULL,
[JudgementBook] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JudgementPage] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAccountID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JudgementPreviousInterestRate] [money] NULL,
[JudgementPreviousInterestDate] [datetime] NULL,
[JudgementPayhistoryUID] [int] NULL,
[JudgementPreviousInterestAmt] [money] NULL,
[AttorneyAckDate] [datetime] NULL,
[JudgmentAttorneyCostAward] [money] NULL,
[JudgementRecordedDate] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[tr_LatitudeLegalAdjustFeeSchedulePostSuit] ON [dbo].[CourtCases]
   FOR   INSERT,UPDATE
AS 
BEGIN
	IF EXISTS(select * from dbo.sysobjects where id = object_id(N'[dbo].[LatitudeLegal_FeeScheduleReference]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	UPDATE MASTER
	SET FEECODE = PostSuitFeeSchedule
	FROM Master m WITH (NOLOCK) JOIN INSERTED i on m.number = i.accountid
	JOIN LatitudeLegal_FeeScheduleReference fsr on fsr.number = m.number
	WHERE fsr.number is not null and fsr.postsuitfeeschedule is not null
	AND fsr.modified is null or fsr.modified = 0
	
	INSERT INTO NOTES (number,created,action,result,user0,comment)
	SELECT i.accountid,getdate(),'+++++','+++++','YGC','Fee Schedule has been adjusted as a result of filing suit.' FROM INSERTED i
	JOIN LatitudeLegal_FeeScheduleReference fsr on fsr.number = i.accountid
	WHERE fsr.number is not null and fsr.postsuitfeeschedule is not null
	AND fsr.modified is null or fsr.modified = 0

	UPDATE LatitudeLegal_FeeScheduleReference
	SET Modified = 1
	FROM Inserted i JOIN LatitudeLegal_FeeScheduleReference fsr on fsr.number = i.accountid
	WHERE fsr.number is not null and fsr.postsuitfeeschedule is not null
	AND fsr.modified is null or fsr.modified = 0 
	END
END

GO
ALTER TABLE [dbo].[CourtCases] ADD CONSTRAINT [PK_CourtCase] PRIMARY KEY CLUSTERED ([CourtCaseID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CourtCase_AccountID] ON [dbo].[CourtCases] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CourtCases_AttorneyAccountID] ON [dbo].[CourtCases] ([AttorneyAccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CourtCases] ADD CONSTRAINT [FK_CourtCases_CourtCaseStatus] FOREIGN KEY ([Status]) REFERENCES [dbo].[CourtCaseStatus] ([Code])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber - Master.Number ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of court case arbitration ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'ArbitrationDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Case number assigned to the debtor account ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'CaseNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'CourtCaseID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Trial date & time  ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'CourtDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Courts Identity Value', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'CourtID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Assigned court room for hearing ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'CourtRoom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Answer Filed ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'DateAnswered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date entered into system ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date complaint was filed with the court ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'DateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last updated in system ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the defendant as entered un legal info ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'Defendant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discovery cut off date  ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'DiscoveryCutoff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date interest begins accruing from judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'IntFromDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of judge assigned to court case ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'Judge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates whether a judgment has been made on a case (True or False) ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'Judgement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Principal award for case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Cost award for case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementAttorneyCostAward'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost award for case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementCostAward'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date court case judgment was proclaimed ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interest awarded for court case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementIntAward'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percent of interest allowed for court case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementIntRate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Other award for case judgment ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'JudgementOtherAward'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Summary judgment deadline date  ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'LastSummaryJudgementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Miscellaneous field 1 of legal info ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'MiscInfo1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Miscellaneous field 2 of legal info ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'MiscInfo2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Motion cut off date  ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'MotionCutoff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plaintiff as entered into legal info ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'Plaintiff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current state of case (attorney retained, etc.) ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Statutory deadline to try case  ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'StatuteDeadline'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Update Control, Checksum(@updatedate) ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'UpdateChecksum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LoginName of User ', 'SCHEMA', N'dbo', 'TABLE', N'CourtCases', 'COLUMN', N'UpdatedBy'
GO
