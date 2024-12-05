CREATE TABLE [dbo].[HCS_Special_Returns]
(
[Number] [int] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Closed] [datetime] NOT NULL,
[Qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReturnCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDate] [datetime] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NumberInd] ON [dbo].[HCS_Special_Returns] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReturnCodeInd] ON [dbo].[HCS_Special_Returns] ([ReturnCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RunDateInd] ON [dbo].[HCS_Special_Returns] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
