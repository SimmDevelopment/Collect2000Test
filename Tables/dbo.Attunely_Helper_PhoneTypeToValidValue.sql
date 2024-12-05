CREATE TABLE [dbo].[Attunely_Helper_PhoneTypeToValidValue]
(
[PhoneTypeId] [int] NOT NULL,
[ValidParty] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPartyDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidEndpointType] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidSource] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneTypeToValidValue] ADD CONSTRAINT [PK_Attunely_Helper_PhoneTypeToValidValue] PRIMARY KEY CLUSTERED ([PhoneTypeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneTypeToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_PhoneTypeToValidValue_Attunely_ValidFieldStringValues] FOREIGN KEY ([ValidEndpointType]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneTypeToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_PhoneTypeToValidValue_Attunely_ValidFieldStringValues1] FOREIGN KEY ([ValidParty]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
ALTER TABLE [dbo].[Attunely_Helper_PhoneTypeToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_PhoneTypeToValidValue_Attunely_ValidFieldStringValues2] FOREIGN KEY ([ValidSource]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
