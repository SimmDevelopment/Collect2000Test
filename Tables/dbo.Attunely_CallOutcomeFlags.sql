CREATE TABLE [dbo].[Attunely_CallOutcomeFlags]
(
[Id] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CallDispositionCallAccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CallDispositionCallKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_CallOutcomeFlags] ADD CONSTRAINT [PK_Attunely_CallOutcomeFlags] PRIMARY KEY CLUSTERED ([CallDispositionCallAccountKey], [CallDispositionCallKey], [Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_CallOutcomeFlags] ADD CONSTRAINT [FK_Attunely_CallOutcomeFlags_Attunely_Calls_CallDispositionCallAccountKey_CallDispositionCallKey] FOREIGN KEY ([CallDispositionCallAccountKey], [CallDispositionCallKey]) REFERENCES [dbo].[Attunely_Calls] ([AccountKey], [CallKey]) ON DELETE CASCADE
GO
