CREATE TABLE [dbo].[csusercustomers]
(
[userid] [int] NOT NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csusercustomers] ADD CONSTRAINT [FK_csusercustomers_csusers] FOREIGN KEY ([userid]) REFERENCES [dbo].[csusers] ([userid]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[csusercustomers] ADD CONSTRAINT [FK_csusercustomers_Customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[Customer] ([customer])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude.CS', 'SCHEMA', N'dbo', 'TABLE', N'csusercustomers', NULL, NULL
GO
