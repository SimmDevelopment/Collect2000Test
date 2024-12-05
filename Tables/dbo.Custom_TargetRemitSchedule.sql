CREATE TABLE [dbo].[Custom_TargetRemitSchedule]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Month] [datetime] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_TargetRemitSchedule] ADD CONSTRAINT [PK_Custom_TargetRemitSchedule] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
