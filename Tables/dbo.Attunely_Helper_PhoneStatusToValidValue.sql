CREATE TABLE [dbo].[Attunely_Helper_PhoneStatusToValidValue]
(
[PhoneStatusId] [int] NOT NULL,
[ValidStatus] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneStatusToValidValue] ADD CONSTRAINT [PK_Attunely_Helper_PhoneStatusToValidValue] PRIMARY KEY CLUSTERED ([PhoneStatusId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneStatusToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_PhoneStatusToValidValue_Attunely_ValidFieldStringValues] FOREIGN KEY ([ValidStatus]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
