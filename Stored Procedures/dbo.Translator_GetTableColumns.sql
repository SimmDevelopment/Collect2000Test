SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Translator_GetTableColumns]
 as




select c.name from sysobjects s join syscolumns c on
s.id = c.id  where s.name = 'master'    

select c.name from sysobjects s join syscolumns c on
s.id = c.id  where s.name = 'debtors'

select c.name from sysobjects s join syscolumns c on
s.id = c.id  where s.name = 'miscextra'

GO
