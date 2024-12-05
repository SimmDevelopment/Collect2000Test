SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [collector].[fusion_Create_PropertyInfo]
AS
BEGIN
	SET NOCOUNT ON;

	Declare @manifestId uniqueidentifier
	set @manifestId='93CCAE4B-35D3-4d63-9535-9FEF464FF432'
	Declare @serviceName varchar(50)
	set @serviceName='LexisNexis PropertyInfo'

	/*********************************************************************
	* Create the table
	**********************************************************************/
	If not exists(select * from INFORMATION_SCHEMA.TABLES with (nolock) where TABLE_NAME='Services_LexisNexis_PropertyInfo')
	BEGIN 
/****** Object:  Table [dbo].[Services_LexisNexis_PropertyInfo]    Script Date: 01/29/2007 14:44:56 ******/
CREATE TABLE [dbo].[Services_LexisNexis_PropertyInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NULL,
	[LNID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACCTNUMIN] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FNAMEIN] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LNAMEIN] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SSNIN] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMATCH] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTAXF] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AROWN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARCITY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARSTATE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARZIP] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMCITY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMSTATE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMZIP] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARPRICE] [decimal](15, 5) NULL,
	[ARTVL] [decimal](15, 5) NULL,
	[ARAIV] [decimal](15, 5) NULL,
	[ARALV] [decimal](15, 5) NULL,
	[ARAYR] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARAPN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARBKPG] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARDOCNUM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARDOCTYP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARRCD] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AREXEMP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARUSE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARLGL] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMIV] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARMLV] [decimal](15, 5) NULL,
	[ARMVY] [decimal](15, 5) NULL,
	[ARCHR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARREC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARRECDT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTAPE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTAX] [decimal](15, 5) NULL,
	[ARTRC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTYR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTAV] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARTMV] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMATCH] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDBUYER] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMCITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMSTATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMZIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDCITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSTATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDZIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSELLER] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSCITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSSTATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSZIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDSALEDT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDPRICE] [decimal](15, 5) NULL,
	[DDTLV] [decimal](15, 5) NULL,
	[DDAPN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDBKPG] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDTYPE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDDOCNUM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDUSE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DDLGL] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDLENDER] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDLNAMT] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDLOT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMAD] [varchar](155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDPIT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDPBP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDPTR] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDRATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDRECDT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DDTERM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDTITLE] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DDMORT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMATCH] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTBRW] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMCITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMSTATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMZIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTADDR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTCITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTSTATE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTZIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTAMT] [decimal](15, 5) NULL,
	[MTINT] [decimal](15, 5) NULL,
	[MTIND] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTAPN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTCHI] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTDOCNUM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTDUEDT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTGDN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTLGL] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTLTP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTLENDER] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTLOANTP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMRF] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTTYPE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTMSA] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTUSE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTRTCH] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTRECDT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MTFIN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_Services_LexisNexis_PropertyInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]
		
	END

	/**************************************************************************
	*	Create the Service
	***************************************************************************/

	IF not exists (select * from Services where ManifestId=@manifestId)
	BEGIN
		INSERT INTO [Services]
		([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
		 VALUES
		 (@serviceName,1,0,@manifestId,0,
		'<?xml version="1.0"?>
		<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
			<head>
				<title>Lexis Nexis Property Info Data</title>
			</head>
			<body>
				<xsl:for-each select=".//DataRows/DataRow">
					<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
						<tr align="left" bgcolor="#b0c4de" width="98%">
							<th><xsl:text>L Type</xsl:text></th>
						</tr>
					</table>	
					<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
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

	DECLARE @ServiceID INTEGER
	SET @ServiceID = @@IDENTITY

	INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
	SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
	WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)


	/**************************************************************************************************************************
	*	Create Query Conditions
	***************************************************************************************************************************/
	-- Conditions Script File, exported on 12/14/2006 3:23 PM
	-- ACCTNUMIN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ACCTNUMIN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ACCTNUMIN'
	END

	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ACCTNUMIN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ACCTNUMIN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ACCTNUMIN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARAIV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAIV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAIV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARAIV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARAIV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARAIV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARALV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARALV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARALV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARALV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARALV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARALV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARAPN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAPN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAPN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARAPN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARAPN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARAPN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARAYR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAYR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARAYR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARAYR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARAYR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARAYR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARBKPG
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARBKPG') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARBKPG'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARBKPG', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARBKPG]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARBKPG</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARCHR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARCHR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARCHR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARCHR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARCHR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARCHR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARDOCNUM
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARDOCNUM') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARDOCNUM'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARDOCNUM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARDOCNUM]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARDOCNUM</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARDOCTYP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARDOCTYP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARDOCTYP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARDOCTYP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARDOCTYP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARDOCTYP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- AREXEMP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'AREXEMP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'AREXEMP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'AREXEMP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[AREXEMP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">AREXEMP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARLGL
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARLGL') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARLGL'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARLGL', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARLGL]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARLGL</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMATCH
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMATCH') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMATCH'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMATCH', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMATCH]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMATCH</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMIV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMIV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMIV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMIV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMIV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMIV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMLV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMLV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMLV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMLV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARMLV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARMLV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMVY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMVY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMVY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMVY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARMVY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARMVY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARMZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARMZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARMZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARMZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARMZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- AROWN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'AROWN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'AROWN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'AROWN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[AROWN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">AROWN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARPRICE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARPRICE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARPRICE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARPRICE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARPRICE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARPRICE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARRCD
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARRCD') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARRCD'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARRCD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<lowValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</lowValue>
	<highValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARRCD]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARRCD</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:DateCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARREC
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARREC') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARREC'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARREC', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARREC]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARREC</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARRECDT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARRECDT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARRECDT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARRECDT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<lowValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</lowValue>
	<highValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARRECDT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARRECDT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:DateCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTAPE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAPE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAPE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTAPE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTAPE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTAPE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTAV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTAV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTAV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTAV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTAX
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAX') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAX'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTAX', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARTAX]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARTAX</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTAXF
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAXF') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTAXF'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTAXF', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTAXF]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTAXF</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTMV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTMV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTMV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTMV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTMV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTMV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTRC
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTRC') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTRC'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTRC', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTRC]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTRC</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTVL
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTVL') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTVL'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTVL', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ARTVL]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ARTVL</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARTYR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTYR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARTYR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARTYR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARTYR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARTYR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARUSE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARUSE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARUSE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARUSE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARUSE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARUSE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ARZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ARZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ARZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[ARZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ARZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDAPN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDAPN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDAPN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDAPN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDAPN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDAPN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDBKPG
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDBKPG') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDBKPG'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDBKPG', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDBKPG]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDBKPG</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDBUYER
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDBUYER') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDBUYER'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDBUYER', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDBUYER]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDBUYER</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDDOCNUM
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDDOCNUM') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDDOCNUM'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDDOCNUM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDDOCNUM]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDDOCNUM</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDLENDER
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLENDER') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLENDER'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDLENDER', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDLENDER]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDLENDER</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDLGL
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLGL') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLGL'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDLGL', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDLGL]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDLGL</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDLNAMT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLNAMT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLNAMT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDLNAMT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[DDLNAMT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">DDLNAMT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDLOT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLOT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDLOT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDLOT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDLOT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDLOT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMAD
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMAD') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMAD'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMAD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMAD]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMAD</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMATCH
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMATCH') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMATCH'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMATCH', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMATCH]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMATCH</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMORT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMORT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMORT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMORT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMORT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMORT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDMZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDMZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDMZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDMZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDMZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDPBP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPBP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPBP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDPBP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDPBP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDPBP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDPIT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPIT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPIT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDPIT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDPIT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDPIT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDPRICE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPRICE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPRICE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDPRICE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[DDPRICE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">DDPRICE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDPTR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPTR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDPTR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDPTR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDPTR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDPTR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDRATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDRATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDRATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDRATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDRATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDRATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDRECDT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDRECDT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDRECDT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDRECDT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<lowValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</lowValue>
	<highValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[DDRECDT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">DDRECDT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:DateCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSALEDT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSALEDT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSALEDT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSALEDT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSALEDT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSALEDT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSELLER
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSELLER') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSELLER'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSELLER', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSELLER]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSELLER</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDSZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDSZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDSZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDSZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDSZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDTERM
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTERM') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTERM'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDTERM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDTERM]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDTERM</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDTITLE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTITLE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTITLE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDTITLE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDTITLE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDTITLE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDTLV
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTLV') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTLV'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDTLV', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[DDTLV]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">DDTLV</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDTYPE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTYPE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDTYPE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDTYPE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDTYPE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDTYPE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDUSE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDUSE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDUSE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDUSE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDUSE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDUSE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- DDZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'DDZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'DDZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[DDZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">DDZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- FNAMEIN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'FNAMEIN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'FNAMEIN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'FNAMEIN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[FNAMEIN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">FNAMEIN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- ID
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ID') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'ID'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[ID]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- LNAMEIN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'LNAMEIN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'LNAMEIN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'LNAMEIN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[LNAMEIN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">LNAMEIN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- LNID
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'LNID') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'LNID'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'LNID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[LNID]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">LNID</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTAMT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTAMT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTAMT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTAMT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[MTAMT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">MTAMT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTAPN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTAPN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTAPN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTAPN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTAPN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTAPN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTBRW
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTBRW') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTBRW'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTBRW', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTBRW]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTBRW</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTCHI
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTCHI') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTCHI'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTCHI', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTCHI]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTCHI</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTDOCNUM
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTDOCNUM') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTDOCNUM'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTDOCNUM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTDOCNUM]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTDOCNUM</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTDUEDT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTDUEDT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTDUEDT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTDUEDT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<lowValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</lowValue>
	<highValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[MTDUEDT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">MTDUEDT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:DateCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTFIN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTFIN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTFIN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTFIN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTFIN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTFIN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTGDN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTGDN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTGDN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTGDN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTGDN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTGDN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTIND
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTIND') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTIND'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTIND', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTIND]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTIND</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTINT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTINT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTINT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTINT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[MTINT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">MTINT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTLENDER
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLENDER') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLENDER'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTLENDER', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTLENDER]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTLENDER</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTLGL
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLGL') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLGL'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTLGL', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTLGL]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTLGL</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTLOANTP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLOANTP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLOANTP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTLOANTP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTLOANTP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTLOANTP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTLTP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLTP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTLTP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTLTP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTLTP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTLTP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMADDR
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMADDR') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMADDR'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMADDR', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMADDR]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMADDR</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMATCH
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMATCH') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMATCH'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMATCH', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMATCH]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMATCH</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMCITY
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMCITY') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMCITY'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMCITY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMCITY]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMCITY</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMRF
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMRF') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMRF'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMRF', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMRF]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMRF</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMSA
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMSA') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMSA'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMSA', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMSA]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMSA</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTMZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTMZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTMZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTMZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTMZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTRECDT
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTRECDT') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTRECDT'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTRECDT', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<lowValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</lowValue>
	<highValue>
	<condition xsi:null="1"/>
	<relative>false</relative>
	<value>0001-01-01T00:00:00.0000000-05:00</value>
	<relativeType>Days</relativeType>
	<amount>0</amount>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[MTRECDT]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">MTRECDT</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:DateCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTRTCH
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTRTCH') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTRTCH'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTRTCH', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTRTCH]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTRTCH</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTSTATE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTSTATE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTSTATE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTSTATE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTSTATE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTSTATE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTTYPE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTTYPE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTTYPE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTTYPE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTTYPE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTTYPE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTUSE
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTUSE') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTUSE'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTUSE', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTUSE]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTUSE</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- MTZIP
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTZIP') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'MTZIP'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'MTZIP', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[MTZIP]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">MTZIP</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- RequestId
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'RequestId') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'RequestId'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<format>None</format>
	<comparison>EqualTo</comparison>
	<lowValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</lowValue>
	<highValue>
	<value>0</value>
	<condition xsi:null="1"/>
	</highValue>
	<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_PropertyInfo].[RequestId]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-5"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:NumericCondition>
	<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-6"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-7"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-8"/>
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-11">[dbo].[Debtors]</expression>
	<alias id="ref-12">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-14">[dbo].[ServiceHistory]</expression>
	<alias id="ref-15">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-17">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-18">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')


	-- SSNIN
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'SSNIN') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo' AND [Description] = 'SSNIN'
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\LexisNexis\PropertyInfo\Services_LexisNexis_PropertyInfo', 'SSNIN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_PropertyInfo].[SSNIN]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">SSNIN</ConditionBase_x002B_description>
	<ConditionBase_x002B_caption xsi:null="1"/>
	<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
	<ConditionBase_x002B_joins href="#ref-6"/>
	<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
	</a1:TextCondition>
	<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<CollectionBase_x002B_list href="#ref-7"/>
	</a1:JoinTableCollection>
	<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
	<_items href="#ref-8"/>
	<_size>3</_size>
	<_version>3</_version>
	</a3:ArrayList>
	<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
	<item href="#ref-9"/>
	<item href="#ref-10"/>
	<item href="#ref-11"/>
	</SOAP-ENC:Array>
	<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-12">[dbo].[Debtors]</expression>
	<alias id="ref-13">Debtors</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-15">[dbo].[ServiceHistory]</expression>
	<alias id="ref-16">ServiceHistory</alias>
	<joinType>Inner</joinType>
	<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
	</a1:JoinTable>
	<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<expression id="ref-18">[dbo].[Services_LexisNexis_PropertyInfo]</expression>
	<alias id="ref-19">Services_LexisNexis_PropertyInfo</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_PropertyInfo].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	')

END
GO
