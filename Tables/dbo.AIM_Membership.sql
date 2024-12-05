CREATE TABLE [dbo].[AIM_Membership]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Membership] ADD CONSTRAINT [PK_AIM_Membership] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
