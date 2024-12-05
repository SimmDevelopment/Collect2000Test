CREATE TABLE [dbo].[Custom_HSBC_Vegas_Maint]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TransDate] [datetime] NULL,
[acct] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fieldcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[newvalue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[intextflag] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[agencycode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[miocode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_HSBC_Vegas_Maint] ADD CONSTRAINT [PK_Custom_HSBC_Vegas_Maint] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
