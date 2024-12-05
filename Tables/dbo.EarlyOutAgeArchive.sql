CREATE TABLE [dbo].[EarlyOutAgeArchive]
(
[Number] [int] NOT NULL,
[Bucket0_29] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__282F8F70] DEFAULT (0),
[Bucket30_59] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2923B3A9] DEFAULT (0),
[Bucket60_89] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2A17D7E2] DEFAULT (0),
[Bucket90_119] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2B0BFC1B] DEFAULT (0),
[Bucket120_149] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2C002054] DEFAULT (0),
[Bucket150_179] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2CF4448D] DEFAULT (0),
[Bucket180Plus] [money] NOT NULL CONSTRAINT [DF__EarlyOutA__Bucke__2DE868C6] DEFAULT (0),
[Cycle_Date] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__EarlyOutA__Cycle__2EDC8CFF] DEFAULT (''),
[Credit_Limit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__EarlyOutA__Credi__2FD0B138] DEFAULT (''),
[Contract_Date] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__EarlyOutA__Contr__30C4D571] DEFAULT (''),
[Loan_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__EarlyOutA__Loan___31B8F9AA] DEFAULT (''),
[Current_Due] [money] NULL,
[RunDate] [datetime] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EarlyOutAgeArchive] ADD CONSTRAINT [PK_UID] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NumberInd] ON [dbo].[EarlyOutAgeArchive] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RunDateInd] ON [dbo].[EarlyOutAgeArchive] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
