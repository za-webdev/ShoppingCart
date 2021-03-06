USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetItemsInfoForReceipt]    Script Date: 7/15/2021 1:06:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetItemsInfoForReceipt]

AS
Begin
SET NOCOUNT ON;

SELECT DISTINCT
     p.Item_Id,
     p.Item_Name,
     p.Price,
     c.SalesTax,
     (
          SELECT 
              COUNT(s.Item_Id) 
          FROM 
              Shopping_Cart s
          WHERE 
              p.Item_Id = s.Item_Id and s.Purchased =0
     ) AS Count
FROM 
     Products p
	 inner join Categories c on p.Category_Id = c.Category_Id
	 inner join Shopping_Cart s on p.Item_Id = s.Item_Id
where p.IsDeleted = 0 and c.IsDeleted = 0 and s.Purchased = 0

End

