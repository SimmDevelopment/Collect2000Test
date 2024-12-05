CREATE TABLE [dbo].[Phones_TimeZoneInfo]
(
[AreaCode] [smallint] NOT NULL,
[Exchange] [smallint] NOT NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeZone] [tinyint] NOT NULL,
[ObservesDST] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_TimeZoneInfo] ADD CONSTRAINT [pk_Phones_TimeZoneInfo] PRIMARY KEY CLUSTERED ([AreaCode], [Exchange]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
