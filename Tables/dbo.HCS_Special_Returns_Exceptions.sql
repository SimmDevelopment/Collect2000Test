CREATE TABLE [dbo].[HCS_Special_Returns_Exceptions]
(
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDate] [datetime] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AccountInd] ON [dbo].[HCS_Special_Returns_Exceptions] ([Account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReturnCodeInd] ON [dbo].[HCS_Special_Returns_Exceptions] ([ReturnCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RunDateInd] ON [dbo].[HCS_Special_Returns_Exceptions] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
