SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/21/2005
-- Description:	This proc will create the service required by TU CPE
-- =============================================
/*
exec Custom_CreateTUServiceRecord
*/
CREATE PROCEDURE [dbo].[Custom_CreateTUServiceRecord]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF not exists (select * from Services where ManifestId='D816C19B-53F6-42db-94E3-7D4CE4FFBBF8')
	INSERT INTO [Services]
	([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
	 VALUES
	 ('TU CPE Service',1,0,'D816C19B-53F6-42db-94E3-7D4CE4FFBBF8',0,
	'<?xml version="1.0"?>
	<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
		<head>
			<title>Accurint Data</title>
		</head>
		<body>
			<xsl:for-each select=".//DataRows/DataRow">
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%;FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial; FONT-SIZE: 10pt;">
					<tr align="left" bgcolor="#b0c4de" width="98%">
						<th><xsl:text>L Type</xsl:text></th>
					</tr>
				</table>	
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%;FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial; FONT-SIZE: 10pt;">
					<tbody>
							<xsl:for-each select="node()">
								<tr>
									<td align="left" bgcolor="eee8aa" width="30%">
										<xsl:value-of select="translate(name(), ''_'', '' '')"/>
									</td>
									<td align="left" bgcolor="eee8aa" width="70%">
										<xsl:value-of select="text()"/>
									</td>							
								</tr>
							</xsl:for-each>			
					</tbody>
				</table>
				<br></br>			
			</xsl:for-each>													
		</body>
	</html>'
	)

END


GO
