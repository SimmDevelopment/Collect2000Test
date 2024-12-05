CREATE TABLE [dbo].[Users]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordDate] [datetime] NULL,
[Alias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleID] [int] NULL,
[BranchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptID] [int] NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeskCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeClock] [bit] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__Users__Active__48076225] DEFAULT (1),
[WindowsSID] [varbinary] (85) NULL,
[WindowsUserName] AS (suser_sname([WindowsSid])),
[Attempts] [int] NOT NULL CONSTRAINT [def_Users_Attempts] DEFAULT (0),
[LockoutDate] [datetime] NULL,
[PasswordSalt] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerUser] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Users__DialerUse__6029CFD0] DEFAULT (''),
[DialerPassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Users__DialerPas__611DF409] DEFAULT (''),
[windowsssid] [varchar] (85) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Users_DeskCode] ON [dbo].[Users] ([DeskCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_LoginName] ON [dbo].[Users] ([LoginName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Users_UserName] ON [dbo].[Users] ([UserName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
