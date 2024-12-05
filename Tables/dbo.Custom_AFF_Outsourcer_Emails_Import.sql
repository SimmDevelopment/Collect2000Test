CREATE TABLE [dbo].[Custom_AFF_Outsourcer_Emails_Import]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ACCOUNTHOLDER_EMAILS_PLACEMENT_ACCOUNTHOLDER_EMAILS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_EMAILS_OUTSOURCERACCOUNTID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_EMAILS_ACCOUNTREF] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_EMAILS_EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_EMAILS_HASCONSENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_EMAILS_EMAILTYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_AFF_Outsourcer_Emails_Import] ADD CONSTRAINT [PK_Custom_AFF_Outsourcer_Emails_Import] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
