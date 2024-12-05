SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[renameColumn]
  @tablename varchar(50), @columnname varchar(50), @newcolumnname varchar(50)
as
  if exists(select 1 from information_schema.columns where table_name=@tablename and column_name=@columnname)
    BEGIN
      DECLARE @fullname varchar(200)
      SET @fullname= @tablename+'.'+@columnname
      EXEC sp_rename @fullname, @newcolumnname, 'COLUMN'    
    END
GO
