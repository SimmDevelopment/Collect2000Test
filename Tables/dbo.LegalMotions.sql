CREATE TABLE [dbo].[LegalMotions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NULL CONSTRAINT [DF_LegalMotions_AccountID] DEFAULT (0),
[IsOurMotion] [bit] NULL,
[MotionTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MotionDate] [smalldatetime] NULL,
[MotionSummary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseDate] [smalldatetime] NULL,
[ResponseSummary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecisionDate] [smalldatetime] NULL,
[DecisionSummary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HearingDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LegalMotions] ADD CONSTRAINT [PK_LegalMotions] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
