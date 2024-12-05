CREATE TABLE [dbo].[AIM_Schedule]
(
[scheduleid] [int] NOT NULL IDENTITY(1, 1),
[scheduletypeid] [int] NULL,
[startdate] [datetime] NULL,
[enddate] [datetime] NULL,
[runtime] [datetime] NULL,
[everyday] [bit] NULL,
[weekdays] [bit] NULL,
[everynumminutes] [int] NULL,
[everynumdays] [int] NULL,
[everynumweeks] [int] NULL,
[sunday] [bit] NULL,
[monday] [bit] NULL,
[tuesday] [bit] NULL,
[wednesday] [bit] NULL,
[thursday] [bit] NULL,
[friday] [bit] NULL,
[saturday] [bit] NULL,
[dayofmonth] [int] NULL,
[january] [bit] NULL,
[february] [bit] NULL,
[march] [bit] NULL,
[april] [bit] NULL,
[may] [bit] NULL,
[june] [bit] NULL,
[july] [bit] NULL,
[august] [bit] NULL,
[september] [bit] NULL,
[october] [bit] NULL,
[november] [bit] NULL,
[december] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Schedule] ADD CONSTRAINT [pk_schedule] PRIMARY KEY CLUSTERED ([scheduleid]) ON [PRIMARY]
GO
