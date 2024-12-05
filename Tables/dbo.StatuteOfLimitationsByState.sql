CREATE TABLE [dbo].[StatuteOfLimitationsByState]
(
[StateCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Oral] [tinyint] NOT NULL,
[Written] [tinyint] NOT NULL,
[Promissory] [tinyint] NOT NULL,
[Open] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatuteOfLimitationsByState] ADD CONSTRAINT [pk_StatuteOfLimitationsByState] PRIMARY KEY NONCLUSTERED ([StateCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
