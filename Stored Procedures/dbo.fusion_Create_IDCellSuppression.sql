SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Create_IDCellSuppression]
AS
BEGIN
	SET NOCOUNT ON;

Declare @manifestId uniqueidentifier 
Set @manifestId='4265BD9C-BEB9-4521-AF9D-9B2B244164CB'

IF not exists (select * from Services where ManifestId=@manifestId)
	BEGIN
		INSERT INTO [Services]
		([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema],[Vendor],[Product])
		 VALUES
		 ('ID Cell Suppression Service',1,0,@manifestId,0,
		'<?xml version="1.0"?>
		<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
			<head>
				<title>ID Cell Suppression Data</title>
			</head>
			<body>
				<xsl:for-each select=".//DataRows/DataRow">
					<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
						<tr align="left" bgcolor="#b0c4de" width="98%">
							<th><xsl:text>ID Cell Suppression</xsl:text></th>
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
		</html>','ID','Cell Suppression'
		)

		DECLARE @ServiceID INTEGER
		SET @ServiceID = @@IDENTITY

		INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
		SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
		WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)

	END

If Not Exists(Select * From INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_ID_CellSuppression')
BEGIN
CREATE TABLE [dbo].[Services_ID_CellSuppression](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NOT NULL,
	[PhoneNumber] VARCHAR(50) NOT NULL,
	[IsCellPhone] bit NOT NULL
 CONSTRAINT [PK_Services_ID_CellSuppression] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]

END


-- Conditions Script File, exported on 8/19/2009 5:17 PM
-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\ID\CellSuppression', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_ID_CellSuppression].[ID]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_ID_CellSuppression]</expression>
<alias id="ref-18">Services_ID_CellSuppression</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_ID_CellSuppression].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- IsCellPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'IsCellPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'IsCellPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\ID\CellSuppression', 'IsCellPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:MultipleChoiceCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<question id="ref-3">Column IsCellPhone contains true or false?</question>
<choices href="#ref-4"/>
<selectedIndex>0</selectedIndex>
<ConditionBase_x002B_description id="ref-5">IsCellPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:MultipleChoiceCondition>
<a1:ChoiceCollection id="ref-4" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:ChoiceCollection>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-8"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-9"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<a3:ArrayList id="ref-8" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-10"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-9" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-11"/>
<item href="#ref-12"/>
<item href="#ref-13"/>
</SOAP-ENC:Array>
<SOAP-ENC:Array id="ref-10" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-14"/>
<item href="#ref-15"/>
<item href="#ref-16"/>
</SOAP-ENC:Array>
<a1:Choice id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<title id="ref-17">True</title>
<answer id="ref-18">Column IsCellPhone contains true</answer>
<condition id="ref-19">[Services_ID_CellSuppression].[IsCellPhone] = 1</condition>
</a1:Choice>
<a1:Choice id="ref-12" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<title id="ref-20">False</title>
<answer id="ref-21">Column IsCellPhone contains false</answer>
<condition id="ref-22">[Services_ID_CellSuppression].[IsCellPhone] = 0</condition>
</a1:Choice>
<a1:Choice id="ref-13" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<title id="ref-23">Null</title>
<answer id="ref-24">Column IsCellPhone contains no value</answer>
<condition id="ref-25">[Services_ID_CellSuppression].[IsCellPhone] IS NULL</condition>
</a1:Choice>
<a1:JoinTable id="ref-14" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-26">[dbo].[Debtors]</expression>
<alias id="ref-27">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-28">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-15" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-29">[dbo].[ServiceHistory]</expression>
<alias id="ref-30">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-31">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-16" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-32">[dbo].[Services_ID_CellSuppression]</expression>
<alias id="ref-33">Services_ID_CellSuppression</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-34">[ServiceHistory].[RequestID] = [Services_ID_CellSuppression].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'PhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'PhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\ID\CellSuppression', 'PhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_ID_CellSuppression].[PhoneNumber]</ColumnConditionBase_x002B_column>
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
<expression id="ref-18">[dbo].[Services_ID_CellSuppression]</expression>
<alias id="ref-19">Services_ID_CellSuppression</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_ID_CellSuppression].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'RequestID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\ID\CellSuppression' AND [Description] = 'RequestID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\ID\CellSuppression', 'RequestID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
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
<ColumnConditionBase_x002B_column id="ref-3">[Services_ID_CellSuppression].[RequestID]</ColumnConditionBase_x002B_column>
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
<expression id="ref-17">[dbo].[Services_ID_CellSuppression]</expression>
<alias id="ref-18">Services_ID_CellSuppression</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_ID_CellSuppression].[RequestID]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');



END
GO
