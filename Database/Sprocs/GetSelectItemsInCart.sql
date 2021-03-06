USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetSelectItemsInCart]    Script Date: 7/15/2021 1:07:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSelectItemsInCart]
    @Item_Ids	nvarchar(max) = null

AS

Begin
SET NOCOUNT ON;

DECLARE @xml as xml,
@delimiter as varchar(10)

SET @delimiter =','

-- Convert it to an XML document
SET @xml = cast(('<X>'+replace(@Item_Ids,@delimiter ,'</X><X>')+'</X>') as xml)

SELECT Item_Id,Item_Name,Price FROM Products WHERE Item_Id IN
(SELECT N.value('.', 'varchar(10)') as value FROM @xml.nodes('X') as T(N))


End