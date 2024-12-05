SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_Create_LexisNexisDeceased*/
CREATE  PROCEDURE [dbo].[fusion_Create_LexisNexisDeceased]
AS
-- Name:		fusion_Create_LexisNexisDeceased
-- Function:		This procedure will create required database objects to
--			implement LexisNexis Deceased
-- Creation:		05/11/2006 jc
--			LexisNexis Deceased
-- Change History:	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if not exists( select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_LexisNexis_Deceased' )
	CREATE TABLE [dbo].[Services_LexisNexis_Deceased] (
		[Id] [int] IDENTITY (1, 1) NOT NULL ,
		[RequestID] [int] NOT NULL ,
		[FirstName] [varchar] (15) NULL ,
		[LastName] [varchar] (25) NULL ,
		[SSN] [varchar] (9) NULL ,
		[DecdFirstName] [varchar] (15) NULL ,
		[DecdLastName] [varchar] (25) NULL ,
		[Address] [varchar] (35) NULL ,
		[City] [varchar] (35) NULL ,
		[State] [varchar] (2) NULL ,
		[Zip] [varchar] (10) NULL ,
		[DateofBirth] [datetime] NULL ,
		[DateofDeath] [datetime] NULL ,
		[MatchCode] [varchar] (5) NULL ,
		[ClientCode] [varchar] (8) NULL ,
	 CONSTRAINT [PK_Services_LexisNexis_Deceased] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
	) ON [PRIMARY]
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

IF not exists (select * from Services where ManifestId='465E9424-AC3E-4D8B-9D2D-F233DB40CEDC')
	INSERT INTO [Services]
	([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
	 VALUES
	 ('LexisNexis Deceased',1,0,'465E9424-AC3E-4D8B-9D2D-F233DB40CEDC',0,
	'<?xml version="1.0"?>
	<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
		<head>
			<title>LexisNexis Deceased Data</title>
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
-----------------------------------------------------------------------------------------------------------------------------
-- Conditions Script File, exported on 10/12/2006 3:41 PM
-- Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Address</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'ClientCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'ClientCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'ClientCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[ClientCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientCode</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DateofBirth
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DateofBirth') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DateofBirth';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'DateofBirth', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_Deceased].[DateofBirth]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DateofBirth</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DateofDeath
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DateofDeath') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DateofDeath';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'DateofDeath', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_Deceased].[DateofDeath]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DateofDeath</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DecdFirstName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DecdFirstName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DecdFirstName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'DecdFirstName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[DecdFirstName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DecdFirstName</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DecdLastName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DecdLastName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'DecdLastName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'DecdLastName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[DecdLastName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DecdLastName</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'FirstName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'FirstName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'FirstName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[FirstName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstName</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Id
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Id') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Id';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'Id', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_Deceased].[Id]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Id</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'LastName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'LastName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'LastName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[LastName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastName</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'MatchCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'MatchCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'MatchCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[MatchCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MatchCode</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'RequestID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'RequestID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'RequestID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_Deceased].[RequestID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestID</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'SSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'SSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'SSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[SSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SSN</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[State]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\Deceased\Services_LexisNexis_Deceased', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_Deceased].[Zip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_LexisNexis_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_Deceased].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');
END
GO
