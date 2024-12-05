CREATE TABLE [dbo].[Attunely_Helper_CobToValidValue]
(
[ClassOfBusiness] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValidCreditorType] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValidPortfolioType] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_CobToValidValue] ADD CONSTRAINT [PK_Attunely_Helper_CobToValidValue] PRIMARY KEY CLUSTERED ([ClassOfBusiness]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_CobToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_CobToValidValue_Attunely_Helper_CobToValidValue] FOREIGN KEY ([ValidCreditorType]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
ALTER TABLE [dbo].[Attunely_Helper_CobToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_CobToValidValue_Attunely_ValidFieldStringValues] FOREIGN KEY ([ValidPortfolioType]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
