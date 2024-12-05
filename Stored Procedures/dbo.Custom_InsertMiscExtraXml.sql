SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_InsertMiscExtraXml]
@data text,
@alwaysinsert bit = null
AS
-- SET @data = N'
-- <Root>
--     <Account Number="808080">        
--         <MiscExtra Title="Jason">this is the data</MiscExtra>
--         <MiscExtra Title="Jason1">this is the dataadf asdf</MiscExtra>
--     </Account>
-- </Root>
-- ';

DECLARE @xml INTEGER;
DECLARE @rundate datetime
SET @rundate = getdate()

EXEC sp_xml_preparedocument @xml OUTPUT, @data;

CREATE TABLE #Custom_MiscExtraHolding(number int,title varchar(30),thedata varchar(100))
CREATE INDEX [ix_Custom_MiscExtraHolding_Number] ON [dbo].[#Custom_MiscExtraHolding]([Number])
CREATE INDEX [ix_Custom_MiscExtraHolding_Title] ON [dbo].[#Custom_MiscExtraHolding]([Title])

insert into #Custom_MiscExtraHolding(number,title,thedata)
SELECT [Number], [Title], [TheData]
FROM OPENXML(@xml, '/Root/Account/MiscExtra', 8)
	WITH (
		[Number] INTEGER '../@Number',
		[Title] VARCHAR(30) '@Title',
		[TheData] VARCHAR(100) '.'
);

SET @alwaysinsert = ISNULL(@alwaysinsert,1)

-- Add a note to reflect the change of misc extra
INSERT INTO [dbo].[Notes]([Number],[User0],[Created],[Action],[Result],[Comment])
SELECT m.number,'EXG',@rundate,'+++++','+++++',
'Misc Extra Data Changed From |'  + RTRIM(LTRIM(m.title)) + ' | ' + RTRIM(LTRIM(m.thedata)) 
FROM [dbo].[MiscExtra] m WITH (NOLOCK)
INNER JOIN [dbo].[#Custom_MiscExtraHolding] m2
ON m2.[Number] = m.[Number] and m2.[Title] = m.[Title] AND RTRIM(LTRIM(m2.TheData)) <> RTRIM(LTRIM(m.TheData))
WHERE @alwaysinsert = 0 AND RTRIM(LTRIM(m2.[TheData])) != ''
AND m.[TheData] <> m2.[TheData]
AND m.ID IN(SELECT MAX([dbo].[MiscExtra].[ID]) -- We can Only Update here if there are duplicate misc extra records for this account
			FROM [dbo].[MiscExtra] WITH (NOLOCK)
			WHERE [dbo].[MiscExtra].[Number] = m.[Number] AND [dbo].[MiscExtra].[Title] = m.[Title]
			GROUP BY [dbo].[MiscExtra].[Number],[dbo].[MiscExtra].[Title] HAVING COUNT(*) = 1)

-- If alwaysinsert is false then update existing.
-- Update where needed
UPDATE [dbo].[MiscExtra]
SET [TheData] = m2.[TheData]
FROM [dbo].[MiscExtra] m WITH(NOLOCK)
INNER JOIN [dbo].[#Custom_MiscExtraHolding] m2
ON m2.[Number] = m.[Number] and m2.[Title] = m.[Title]
WHERE @alwaysinsert = 0 AND RTRIM(LTRIM(m2.[TheData])) != ''
AND m.ID IN(SELECT MAX([dbo].[MiscExtra].[ID]) -- We can Only Update here if there are duplicate misc extra records for this account
			FROM [dbo].[MiscExtra] WITH (NOLOCK)
			WHERE [dbo].[MiscExtra].[Number] = m.[Number] AND [dbo].[MiscExtra].[Title] = m.[Title] 
			GROUP BY [dbo].[MiscExtra].[Number],[dbo].[MiscExtra].[Title] HAVING COUNT(*) = 1)

--Do Inserts Now.
INSERT INTO [dbo].[MiscExtra]([Number],[Title],[TheData])
SELECT number,title,thedata
FROM #Custom_MiscExtraHolding m
WHERE ((NOT EXISTS(SELECT [ID] FROM [dbo].[MiscExtra] WITH (NOLOCK)
				   WHERE [Title] = m.[Title] AND [Number] = m.[Number] AND
	@alwaysinsert = 0)) OR
	@alwaysinsert = 1 OR
	(EXISTS(SELECT MAX([ID]) FROM [dbo].[MiscExtra] WITH (NOLOCK)
			WHERE [Title] = m.[Title] AND [Number] = m.[Number] 
			GROUP BY [dbo].[MiscExtra].[Number],[dbo].[MiscExtra].[Title] HAVING COUNT(*) > 1)))

EXEC sp_xml_removedocument @xml;



GO
