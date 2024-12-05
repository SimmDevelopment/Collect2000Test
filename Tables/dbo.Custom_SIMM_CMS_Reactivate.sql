CREATE TABLE [dbo].[Custom_SIMM_CMS_Reactivate]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[current1] [money] NULL,
[current2] [money] NULL,
[current4] [money] NULL,
[received] [datetime] NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SIMM_CMS_Reactivate] ADD CONSTRAINT [PK_Custom_SIMM_CMS_Reactivate] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
