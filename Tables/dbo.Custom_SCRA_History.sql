CREATE TABLE [dbo].[Custom_SCRA_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateSent] [datetime] NULL,
[Number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActiveDuty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NotifiedOfActiveDuty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActiveDutyEndDate] [datetime] NULL,
[ActiveDutyBeginDate] [datetime] NULL,
[EIDbeginDate] [datetime] NULL,
[EIDEndDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SCRA_History] ADD CONSTRAINT [PK_Custom_SCRA_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
