SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[Custom_InsertNotesXml]
@data text
AS


-- SET @data = N'
-- <Root>
--     <Account Number="1234">        
--         <Notes ctl="" created="" user0="" action="" result="" comment="" utccreated="" />
--     </Account>
-- </Root>
-- ';

DECLARE @xml INTEGER;

EXEC sp_xml_preparedocument @xml OUTPUT, @data;

insert into notes (number,ctl,created,user0,action,result,comment,utccreated)
SELECT [Number], [ctl], [created], [user0], [action], [result],[comment],[utccreated]
FROM OPENXML(@xml, '/Root/Account/Notes', 8)
	WITH (
		[Number] INTEGER '../@Number',
		[ctl] VARCHAR(3) '@ctl',
		[created] datetime '@created',
		[user0] VARCHAR(10) '@user0',
		[action] VARCHAR(6) '@action',
		[result] varchar(6) '@result',
		[comment] text '@comment',
		[utccreated] datetime '@utccreated'
);

EXEC sp_xml_removedocument @xml;

GO
