CREATE TABLE [dbo].[Custom_Equabli_Maint_Email_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[record_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_account_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_consumer_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consumer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_work] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_opt_out] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_valid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_consent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dtm_consent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_primary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Maint_Email_Info] ADD CONSTRAINT [PK_Custom_Equabli_Maint_Email_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
