SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Create_InnovisRPC]
AS
BEGIN
	SET NOCOUNT ON;

Declare @manifestId uniqueidentifier 
Set @manifestId='f68b0e84-880e-4ed1-8755-deba6a25a0ea'

IF not exists (select * from Services where ManifestId=@manifestId)
	BEGIN
		INSERT INTO [Services]
		([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema],[Vendor],[Product])
		 VALUES
		 ('Innovis RPC Service',1,0,@manifestId,0,
		'<?xml version="1.0"?>
		<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
			<head>
				<title>Innovis RPC Data</title>
			</head>
			<body>
				<xsl:for-each select=".//DataRows/DataRow">
					<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
						<tr align="left" bgcolor="#b0c4de" width="98%">
							<th><xsl:text>Innovis RPC</xsl:text></th>
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
		</html>','Innovis','RPC'
		)

		DECLARE @ServiceID INTEGER
		SET @ServiceID = SCOPE_IDENTITY()

		INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
		SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
		WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)

	END
	
	If Not Exists(Select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_Innovis_RPCMain')
BEGIN
CREATE TABLE [dbo].[Services_Innovis_RPCMain](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NOT NULL,
	[LoanNumber] [varchar](50) NULL,
	[ClientKey] [varchar] (50) NULL,
	[InnovisReportedAccountNbr] [varchar](50) NULL,
	[FirstName1] [varchar](50) NULL,
	[MiddleName1] [varchar](50) NULL,
	[LastName1] [varchar](50) NULL,
	[SocialSecurityNumber] [varchar](11) NULL,
	[StreetOne1] [varchar](50) NULL,
	[StreetTwo1] [varchar](50) NULL,
	[City1] [varchar](50) NULL,
	[State1] [varchar](50) NULL,
	[Zip1] [varchar](10) NULL,
	[StreetOne2] [varchar](50) NULL,
	[StreetTwo2] [varchar](50) NULL,
	[City2] [varchar](50) NULL,
	[State2] [varchar](50) NULL,
	[Zip2] [varchar](10) NULL,
	[StreetOne3] [varchar](50) NULL,
	[StreetTwo3] [varchar](50) NULL,
	[City3] [varchar](50) NULL,
	[State3] [varchar](50) NULL,
	[Zip3] [varchar](10) NULL,
	[StreetOne4] [varchar](50) NULL,
	[StreetTwo4] [varchar](50) NULL,
	[City4] [varchar](50) NULL,
	[State4] [varchar](50) NULL,
	[Zip4] [varchar](10) NULL,
	[StreetOne5] [varchar](50) NULL,
	[StreetTwo5] [varchar](50) NULL,
	[City5] [varchar](50) NULL,
	[State5] [varchar](50) NULL,
	[Zip5] [varchar](10) NULL,
	[Phone01] [varchar](25) NULL,
	[Phone02] [varchar](25) NULL,
	[Phone03] [varchar](25) NULL,
	[Phone04] [varchar](25) NULL,
	[Phone05] [varchar](25) NULL,
	[Phone06] [varchar](25) NULL,
	[Phone07] [varchar](25) NULL,
	[Phone08] [varchar](25) NULL,
	[Phone09] [varchar](25) NULL,
	[Phone10] [varchar](25) NULL,
	[Phone11] [varchar](25) NULL,
	[Phone12] [varchar](25) NULL,
	[Phone13] [varchar](25) NULL,
	[Phone14] [varchar](25) NULL,
	[Phone15] [varchar](25) NULL,
	[Phone16] [varchar](25) NULL,
	[Phone17] [varchar](25) NULL,
	[Phone18] [varchar](25) NULL,
	[Phone19] [varchar](25) NULL,
	[Phone20] [varchar](25) NULL,
	[Phone21] [varchar](25) NULL,
	[Phone22] [varchar](25) NULL,
	[Phone23] [varchar](25) NULL,
	[Phone24] [varchar](25) NULL,
	[Phone25] [varchar](25) NULL,
	[Phone26] [varchar](25) NULL,
	[Phone27] [varchar](25) NULL,
	[Phone28] [varchar](25) NULL,
	[Phone29] [varchar](25) NULL,
	[Phone30] [varchar](25) NULL,
	[Phone31] [varchar](25) NULL,
	[Phone32] [varchar](25) NULL,
	[FirstName2] [varchar](50) NULL,
	[MiddleName2] [varchar](50) NULL,
	[LastName2] [varchar](50) NULL,
	[ActiveCount][varchar](50) NULL,
	[TotalCount][varchar](50) NULL,
	[FirstReportedDate][varchar](50)NULL,
	[LastReportedDate][varchar](50) NULL
 CONSTRAINT [PK_Services_Innovis_RPCMain] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]
END

If Not Exists(Select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_Innovis_RPCAddress')
BEGIN
CREATE TABLE [dbo].[Services_Innovis_RPCAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NOT NULL,
	[ActiveCount][int] NULL,
	[TotalCount][int] NULL,
	[FirstReportedDate][varchar](10)NULL,
	[LastReportedDate][varchar](10) NULL,
	[Street1][varchar](50) NULL,
	[Street2][varchar](50) NULL,
	[City][varchar](50) NULL,
	[State][varchar](50) NULL,
	[Zip][varchar](10) NULL
CONSTRAINT [PK_Services_Innovis_RPCAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]
END
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_Innovis_RPCPhone')
BEGIN
CREATE TABLE [dbo].[Services_Innovis_RPCPhone](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NOT NULL,
	[ActiveCount][int] NULL,
	[TotalCount][int] NULL,
	[FirstReportedDate][varchar](10)NULL,
	[LastReportedDate][varchar](10) NULL,
	[PhoneNumber][varchar](50) NULL,
	[PhoneType][varchar](50) NULL,
	[ContactIndex][varchar](50) NULL

CONSTRAINT [PK_Services_Innovis_RPCPhone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]
END
-- Conditions Script File, exported on 6/5/2009 1:59 PM
-- ActiveCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'ActiveCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'ActiveCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'ActiveCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCAddress].[ActiveCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ActiveCount</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-18">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[City]</ColumnConditionBase_x002B_column>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstReportedDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'FirstReportedDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'FirstReportedDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'FirstReportedDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[FirstReportedDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstReportedDate</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Id
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Id') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Id';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'Id', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCAddress].[Id]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-18">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastReportedDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'LastReportedDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'LastReportedDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'LastReportedDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[LastReportedDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastReportedDate</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'RequestID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'RequestID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'RequestID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCAddress].[RequestID]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-18">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[State]</ColumnConditionBase_x002B_column>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Street1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Street1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Street1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'Street1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[Street1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Street1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Street2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Street2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Street2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'Street2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[Street2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Street2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TotalCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'TotalCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'TotalCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'TotalCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCAddress].[TotalCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">TotalCount</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-18">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCAddress', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCAddress].[Zip]</ColumnConditionBase_x002B_column>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCAddress]</expression>
<alias id="ref-19">Services_Innovis_RPCAddress</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCAddress].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'City1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[City1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'City2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[City2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'City3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[City3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City3</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'City4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[City4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City4</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'City5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'City5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[City5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City5</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstName1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'FirstName1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'FirstName1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'FirstName1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[FirstName1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstName1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstName2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'FirstName2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'FirstName2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'FirstName2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[FirstName2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstName2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Id
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Id') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Id';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Id', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCMain].[Id]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-18">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InnovisReportedAccountNbr
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'InnovisReportedAccountNbr') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'InnovisReportedAccountNbr';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'InnovisReportedAccountNbr', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[InnovisReportedAccountNbr]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InnovisReportedAccountNbr</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastName1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LastName1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LastName1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'LastName1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[LastName1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastName1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastName2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LastName2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LastName2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'LastName2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[LastName2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastName2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LoanNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LoanNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'LoanNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'LoanNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[LoanNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LoanNumber</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MiddleName1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'MiddleName1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'MiddleName1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'MiddleName1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[MiddleName1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MiddleName1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MiddleName2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'MiddleName2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'MiddleName2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'MiddleName2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[MiddleName2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MiddleName2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone01
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone01') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone01';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone01', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone01]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone01</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone02
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone02') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone02';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone02', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone02]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone02</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone03
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone03') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone03';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone03', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone03]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone03</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone04
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone04') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone04';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone04', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone04]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone04</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone05
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone05') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone05';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone05', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone05]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone05</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone06
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone06') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone06';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone06', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone06]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone06</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone07
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone07') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone07';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone07', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone07]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone07</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone08
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone08') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone08';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone08', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone08]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone08</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone09
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone09') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone09';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone09', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone09]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone09</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone10
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone10') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone10';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone10', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone10]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone10</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone11
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone11') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone11';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone11', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone11]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone11</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone12
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone12') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone12';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone12', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone12]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone12</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone13
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone13') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone13';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone13', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone13]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone13</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone14
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone14') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone14';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone14', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone14]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone14</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone15
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone15') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone15';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone15', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone15]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone15</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone16
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone16') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone16';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone16', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone16]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone16</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone17
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone17') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone17';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone17', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone17]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone17</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone18
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone18') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone18';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone18', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone18]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone18</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone19
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone19') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone19';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone19', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone19]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone19</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone20
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone20') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone20';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone20', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone20]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone20</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone21
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone21') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone21';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone21', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone21]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone21</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone22
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone22') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone22';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone22', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone22]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone22</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone23
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone23') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone23';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone23', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone23]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone23</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone24
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone24') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone24';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone24', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone24]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone24</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone25
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone25') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone25';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone25', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone25]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone25</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone26
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone26') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone26';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone26', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone26]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone26</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone27
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone27') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone27';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone27', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone27]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone27</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone28
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone28') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone28';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone28', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone28]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone28</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone29
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone29') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone29';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone29', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone29]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone29</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone30
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone30') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone30';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone30', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone30]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone30</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone31
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone31') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone31';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone31', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone31]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone31</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone32
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone32') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Phone32';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Phone32', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Phone32]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone32</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'RequestID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'RequestID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'RequestID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCMain].[RequestID]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-18">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SocialSecurityNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'SocialSecurityNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'SocialSecurityNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'SocialSecurityNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[SocialSecurityNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SocialSecurityNumber</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'State1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[State1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'State2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[State2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'State3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[State3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State3</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'State4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[State4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State4</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'State5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'State5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[State5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State5</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetOne1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetOne1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetOne1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetOne1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetOne2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetOne2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetOne2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetOne2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetOne3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetOne3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetOne3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetOne3</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetOne4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetOne4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetOne4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetOne4</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetOne5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetOne5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetOne5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetOne5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetOne5</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetTwo1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetTwo1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetTwo1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetTwo1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetTwo2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetTwo2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetTwo2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetTwo2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetTwo3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetTwo3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetTwo3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetTwo3</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetTwo4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetTwo4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetTwo4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetTwo4</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StreetTwo5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'StreetTwo5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'StreetTwo5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[StreetTwo5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StreetTwo5</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Zip1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Zip1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip1</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Zip2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Zip2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip2</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Zip3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Zip3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip3</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Zip4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Zip4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip4</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain' AND [Description] = 'Zip5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCMain', 'Zip5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCMain].[Zip5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip5</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCMain]</expression>
<alias id="ref-19">Services_Innovis_RPCMain</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCMain].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ActiveCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'ActiveCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'ActiveCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'ActiveCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCPhone].[ActiveCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ActiveCount</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-18">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ContactIndex
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'ContactIndex') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'ContactIndex';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'ContactIndex', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCPhone].[ContactIndex]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ContactIndex</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-19">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstReportedDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'FirstReportedDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'FirstReportedDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'FirstReportedDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCPhone].[FirstReportedDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstReportedDate</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-19">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Id
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'Id') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'Id';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'Id', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCPhone].[Id]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-18">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastReportedDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'LastReportedDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'LastReportedDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'LastReportedDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCPhone].[LastReportedDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastReportedDate</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-19">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'PhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'PhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'PhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCPhone].[PhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PhoneNumber</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-19">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PhoneType
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'PhoneType') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'PhoneType';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'PhoneType', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_Innovis_RPCPhone].[PhoneType]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PhoneType</ConditionBase_x002B_description>
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
<expression id="ref-18">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-19">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'RequestID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'RequestID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'RequestID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCPhone].[RequestID]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-18">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TotalCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'TotalCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone' AND [Description] = 'TotalCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\Innovis\RPC\Services_Innovis_RPCPhone', 'TotalCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_Innovis_RPCPhone].[TotalCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">TotalCount</ConditionBase_x002B_description>
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
<expression id="ref-17">[dbo].[Services_Innovis_RPCPhone]</expression>
<alias id="ref-18">Services_Innovis_RPCPhone</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_Innovis_RPCPhone].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');



	
	END
GO
