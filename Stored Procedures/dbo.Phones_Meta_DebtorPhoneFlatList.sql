SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_Meta_DebtorPhoneFlatList]
AS

SET NOCOUNT ON

DECLARE @Outputs TABLE (Ordering INT NOT NULL IDENTITY(1,1), Textual varchar(200) NOT NULL, PRIMARY KEY (Ordering))

INSERT INTO @Outputs (Textual)
          SELECT ' '
UNION ALL SELECT 'IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Type = ''V'' AND ID = OBJECT_ID(N''[dbo].[Phones_DebtorPhoneFlatList]''))'
UNION ALL SELECT 'BEGIN'
UNION ALL SELECT '	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE Type = ''V'' AND ID = OBJECT_ID(N''[dbo].[Phones_DebtorPhoneFlatList_BackUp]''))'
UNION ALL SELECT '		DROP VIEW [dbo].[Phones_DebtorPhoneFlatList_BackUp]'
UNION ALL SELECT '	PRINT ''Creating back-up of View Phones_DebtorPhoneFlatList as Phones_DebtorPhoneFlatList_BackUp'''
UNION ALL SELECT '	EXEC sp_rename ''dbo.Phones_DebtorPhoneFlatList'', ''Phones_DebtorPhoneFlatList_BackUp'''
UNION ALL SELECT 'END'
UNION ALL SELECT 'GO'
UNION ALL SELECT ' '
UNION ALL SELECT 'SET ANSI_NULLS ON'
UNION ALL SELECT 'GO'
UNION ALL SELECT 'SET QUOTED_IDENTIFIER ON'
UNION ALL SELECT 'GO'
UNION ALL SELECT 'CREATE VIEW Phones_DebtorPhoneFlatList'
UNION ALL SELECT 'AS'
UNION ALL SELECT ' '
UNION ALL SELECT 'SELECT'
UNION ALL SELECT '    Phone_Raw_One.*,'
UNION ALL SELECT '    '
UNION ALL SELECT '    HomePhone =       CASE WHEN DialerSlot1Type = ''H''  THEN DialerSlot1 ELSE '''' END,'
UNION ALL SELECT '    WorkPhone =       CASE WHEN DialerSlot2Type = ''W''  THEN DialerSlot2 ELSE '''' END,'
UNION ALL SELECT '    Pager =           CASE WHEN DialerSlot3Type = ''C''  THEN DialerSlot3 ELSE '''' END,'
UNION ALL SELECT '    Fax =             CASE WHEN DialerSlot4Type = ''FX'' THEN DialerSlot4 ELSE '''' END,'
UNION ALL SELECT '    SpouseHomePhone = CASE WHEN DialerSlot5Type = ''SH'' THEN DialerSlot5 ELSE '''' END,'
UNION ALL SELECT '    SpouseWorkPhone = CASE WHEN DialerSlot6Type = ''SW'' THEN DialerSlot6 ELSE '''' END,'
UNION ALL SELECT '    '
UNION ALL SELECT '    OtherPhone1 =     CASE WHEN DialerSlot4Type = ''FX'' THEN DialerSlot4 ELSE '''' END,'
UNION ALL SELECT '    OtherPhone2 =     CASE WHEN DialerSlot5Type = ''SH'' THEN DialerSlot5 ELSE '''' END,'
UNION ALL SELECT '    OtherPhone3 =     CASE WHEN DialerSlot6Type = ''SW'' THEN DialerSlot6 ELSE '''' END,'
UNION ALL SELECT '    OtherPhone1Type = CASE WHEN DialerSlot4Type = ''FX'' THEN DialerSlot4Type ELSE '''' END,'
UNION ALL SELECT '    OtherPhone2Type = CASE WHEN DialerSlot5Type = ''SH'' THEN DialerSlot5Type ELSE '''' END,'
UNION ALL SELECT '    OtherPhone3Type = CASE WHEN DialerSlot6Type = ''SW'' THEN DialerSlot6Type ELSE '''' END'
UNION ALL SELECT '    '
UNION ALL SELECT 'FROM '
UNION ALL SELECT '('

DECLARE @Code VARCHAR(10), @Description VARCHAR(252), @SubViewName VARCHAR(252)
DECLARE @First int

SET @First = 1
DECLARE the_view_cursor CURSOR FORWARD_ONLY FOR 
SELECT Code, Description, SubViewName FROM ListBuilderOptionSelectList
FOR READ ONLY
OPEN the_view_cursor

    FETCH NEXT FROM the_view_cursor INTO @Code, @Description, @SubViewName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @First = 1
            INSERT INTO @Outputs (Textual) SELECT '          SELECT ListBuilderCondition = ''' + @Code + ''', * FROM ' + @SubViewName + ''
        ELSE
            INSERT INTO @Outputs (Textual) SELECT 'UNION ALL SELECT ListBuilderCondition = ''' + @Code + ''', * FROM ' + @SubViewName + ''
        SET @First = 0
        FETCH NEXT FROM the_view_cursor INTO @Code, @Description, @SubViewName
    END

CLOSE the_view_cursor
DEALLOCATE the_view_cursor

IF @First = 1
	INSERT INTO @Outputs (Textual) SELECT '          SELECT ListBuilderCondition = ''DEFAULT'', * FROM Phones_DebtorPhoneFlatList_Default'

INSERT INTO @Outputs (Textual)
          SELECT ') AS Phone_Raw_One'
UNION ALL SELECT 'GO'
--UNION ALL SELECT ' '
--UNION ALL SELECT '-- EXEC sp_whateverwhatever stuff to set extended property goes here'
--UNION ALL SELECT 'GO'


SET NOCOUNT OFF
SELECT Textual FROM @Outputs

GO
