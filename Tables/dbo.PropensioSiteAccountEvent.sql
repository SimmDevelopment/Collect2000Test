CREATE TABLE [dbo].[PropensioSiteAccountEvent]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[NoteUID] [int] NOT NULL,
[EventID] [int] NOT NULL,
[Occurred] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PropensioSiteAccountEvent] ADD CONSTRAINT [PK_PropensioSiteAccountEvent] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
