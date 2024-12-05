CREATE TABLE [dbo].[nbmaster]
(
[number] [int] NOT NULL,
[link] [int] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homephone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[specialnote] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL,
[closed] [datetime] NULL,
[returned] [datetime] NULL,
[lastpaid] [datetime] NULL,
[lastpaidamt] [money] NULL,
[lastinterest] [datetime] NULL,
[interestrate] [money] NULL,
[worked] [datetime] NULL,
[userdate1] [datetime] NULL,
[userdate2] [datetime] NULL,
[userdate3] [datetime] NULL,
[contacted] [datetime] NULL,
[status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original] [money] NULL,
[original1] [money] NULL,
[original2] [money] NULL,
[original3] [money] NULL,
[original4] [money] NULL,
[original5] [money] NULL,
[original6] [money] NULL,
[original7] [money] NULL,
[original8] [money] NULL,
[original9] [money] NULL,
[original10] [money] NULL,
[paid] [money] NULL,
[paid1] [money] NULL,
[paid2] [money] NULL,
[paid3] [money] NULL,
[paid4] [money] NULL,
[paid5] [money] NULL,
[paid6] [money] NULL,
[paid7] [money] NULL,
[paid8] [money] NULL,
[paid9] [money] NULL,
[paid10] [money] NULL,
[current0] [money] NULL,
[current1] [money] NULL,
[current2] [money] NULL,
[current3] [money] NULL,
[current4] [money] NULL,
[current5] [money] NULL,
[current6] [money] NULL,
[current7] [money] NULL,
[current8] [money] NULL,
[current9] [money] NULL,
[current10] [money] NULL,
[attorney] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assignedattorney] [datetime] NULL,
[promamt] [money] NULL,
[promdue] [datetime] NULL,
[sifpct] [money] NULL,
[queue] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qflag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qtime] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracodes] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salary] [money] NULL,
[feecode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clidlc] [datetime] NULL,
[clidlp] [datetime] NULL,
[seq] [int] NULL,
[Pseq] [int] NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Finders] [datetime] NULL,
[COMPLETE1] [datetime] NULL,
[Complete2] [datetime] NULL,
[DESK1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESK2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full0] [datetime] NULL,
[Totalviewed] [int] NOT NULL,
[TotalWorked] [int] NOT NULL,
[TotalContacted] [int] NOT NULL,
[nsf] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hasbignote] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'city from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'link'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street1 from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street2 from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbmaster', 'COLUMN', N'Zipcode'
GO
