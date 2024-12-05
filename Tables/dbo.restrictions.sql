CREATE TABLE [dbo].[restrictions]
(
[number] [int] NULL,
[home] [smallint] NULL,
[job] [smallint] NULL,
[calls] [smallint] NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttyName] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attyaddr1] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attyaddr2] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttyCity] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttyState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttyZip] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttyPhone] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attynotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BkyCase] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BkyChap11] [smallint] NULL,
[BkyChap13] [smallint] NULL,
[BkyChap7] [smallint] NULL,
[BkyCourt] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BkyDateFiled] [datetime] NULL,
[BkyDistrict] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BkyNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suppressletters] [smallint] NULL,
[DebtorID] [int] NULL,
[RestrictionID] [int] NOT NULL IDENTITY(1, 1),
[UpdatedBy] [int] NOT NULL CONSTRAINT [DF__Restricti__Updat__34749F6D] DEFAULT (0),
[Disputed] [bit] NULL CONSTRAINT [DF__Restricti__Dispu__3568C3A6] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Restrictions_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Restrictions_DateUpdated] DEFAULT (getdate()),
[letterstoatty] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[restrictions] ADD CONSTRAINT [PK_restrictions] PRIMARY KEY CLUSTERED ([RestrictionID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Restrictions_DebtorID] ON [dbo].[restrictions] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Restrictions_Number] ON [dbo].[restrictions] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
