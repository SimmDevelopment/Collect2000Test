SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_Create_AccurintProgressivePhones*/
CREATE  PROCEDURE [dbo].[fusion_Create_AccurintProgressivePhones]
AS
-- Name:		fusion_Create_AccurintProgressivePhones
-- Function:		This procedure will create required database objects to
--			implement Accurint Progressive Phones
-- Creation:		05/13/2006 jc
--			Accurint Progressive Phones
-- Change History:	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if not exists( select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_AccurintProgressive' )
	CREATE TABLE [dbo].[Services_AccurintProgressive](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[RequestId] [int] NULL,
		[name-last] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[name-first] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[name-middle] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[address-1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[city] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[state] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[zip] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[phoneno] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[ssn] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_first_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_middle_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_last_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_suffix_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_phone10_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_name-dial_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_phone_type_1] [varchar](255)	COLLATE	SQL_Latin1_General_CP1_CI_AS	NULL,
		[subj_date_first_1] [datetime]	NULL,
		[subj_date_last_1] [datetime]	NULL,
	 CONSTRAINT [PK_Services_AccurintProgressive] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
	) ON [PRIMARY]


IF not exists (select * from Services where ManifestId='F05711D2-F760-446C-8BAD-D13F4713806B')
	INSERT INTO [Services]
	([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
	 VALUES
	 ('Accurint Progressive',1,0,'F05711D2-F760-446C-8BAD-D13F4713806B',0,
	'<?xml version="1.0"?>
	<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
		<head>
			<title>Accurint Progressive Data</title>
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

	DECLARE @ServiceID INTEGER
	SET @ServiceID = @@IDENTITY

	INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
	SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
	WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)
	
--------------------------------------------------------------------------------------------------
	-- Conditions Script File, exported on 9/6/2006 2:30 PM
	-- address-1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'address-1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'address-1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'address-1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[address-1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">address-1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- city
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'city') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'city';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'city', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[city]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">city</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- ID
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'ID') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'ID';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
	<ColumnConditionBase_x002B_column id="ref-3">[Services_AccurintProgressive].[ID]</ColumnConditionBase_x002B_column>
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
	<expression id="ref-17">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-18">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- name-first
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-first') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-first';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'name-first', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[name-first]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">name-first</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- name-last
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-last') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-last';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'name-last', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[name-last]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">name-last</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- name-middle
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-middle') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'name-middle';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'name-middle', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[name-middle]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">name-middle</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- phoneno
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'phoneno') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'phoneno';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'phoneno', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[phoneno]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">phoneno</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- RequestId
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'RequestId') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'RequestId';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
	<ColumnConditionBase_x002B_column id="ref-3">[Services_AccurintProgressive].[RequestId]</ColumnConditionBase_x002B_column>
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
	<expression id="ref-17">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-18">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- ssn
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'ssn') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'ssn';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'ssn', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[ssn]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">ssn</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- state
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'state') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'state';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'state', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[state]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">state</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_date_first_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_date_first_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_date_first_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_date_first_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
	<ColumnConditionBase_x002B_column id="ref-3">[Services_AccurintProgressive].[subj_date_first_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">subj_date_first_1</ConditionBase_x002B_description>
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
	<expression id="ref-17">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-18">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_date_last_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_date_last_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_date_last_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_date_last_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
	<ColumnConditionBase_x002B_column id="ref-3">[Services_AccurintProgressive].[subj_date_last_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-4">subj_date_last_1</ConditionBase_x002B_description>
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
	<expression id="ref-17">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-18">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_first_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_first_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_first_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_first_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_first_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_first_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_last_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_last_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_last_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_last_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_last_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_last_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_middle_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_middle_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_middle_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_middle_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_middle_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_middle_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_name-dial_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_name-dial_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_name-dial_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_name-dial_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_name-dial_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_name-dial_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_phone_type_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_phone_type_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_phone_type_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_phone_type_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_phone_type_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_phone_type_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_phone10_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_phone10_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_phone10_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_phone10_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_phone10_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_phone10_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- subj_suffix_1
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_suffix_1') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'subj_suffix_1';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'subj_suffix_1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[subj_suffix_1]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">subj_suffix_1</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');


	-- zip
	IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'zip') BEGIN
		DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive' AND [Description] = 'zip';
	END


	INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
	VALUES ('Latitude Fusion\Accurint\Progressive Phones\Services_AccurintProgressive', 'zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
	<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
	<comparison>EqualTo</comparison>
	<value id="ref-3"></value>
	<ColumnConditionBase_x002B_column id="ref-4">[Services_AccurintProgressive].[zip]</ColumnConditionBase_x002B_column>
	<ConditionBase_x002B_description id="ref-5">zip</ConditionBase_x002B_description>
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
	<expression id="ref-18">[dbo].[Services_AccurintProgressive]</expression>
	<alias id="ref-19">Services_AccurintProgressive</alias>
	<joinType>LeftOuter</joinType>
	<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_AccurintProgressive].[RequestId]</conditions>
	</a1:JoinTable>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	');
END
GO
