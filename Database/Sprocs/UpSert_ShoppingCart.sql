USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[UpSert_ShoppingCart]    Script Date: 7/15/2021 1:08:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpSert_ShoppingCart]
@Item_Ids	nvarchar(max) = null
AS

Begin
SET NOCOUNT ON;

DECLARE @xml as xml,
@delimiter as varchar(10)

SET @delimiter =','

-- Convert it to an XML document
SET @xml = cast(('<X>'+replace(@Item_Ids,@delimiter ,'</X><X>')+'</X>') as xml)

-- Select back from the XML
INSERT INTO Shopping_Cart (Item_Id)
SELECT N.value('.', 'varchar(10)') as value FROM @xml.nodes('X') as T(N)

End