CREATE TABLE [dbo].[Link]
(
[Number] [int] NULL,
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
[homephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[TotalViewed] [int] NULL,
[TotalWorked] [int] NULL,
[TotalContacted] [int] NULL,
[nsf] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasBigNote] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReceived] [datetime] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'assignedattorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'attorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'clidlc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'clidlp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'closed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'COMPLETE1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Complete2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'contacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'current9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'DESK1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'DESK2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'extracodes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'feecode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Finders'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'firstDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'FirstReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Full0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'HasBigNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'homephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'interestrate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'lastinterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'lastpaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'lastpaidamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'link'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'MR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'nsf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'original9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'other'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'promamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'promdue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Pseq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'qdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'qflag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'qlevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'qtime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'queue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'returned'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Salary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'sifpct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'specialnote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'TotalContacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'TotalViewed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'TotalWorked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'userdate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'userdate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'userdate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'worked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'workphone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Link', 'COLUMN', N'Zipcode'
GO
