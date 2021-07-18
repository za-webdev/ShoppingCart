USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetItemsInCart]    Script Date: 7/15/2021 1:06:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetItemsInCart]

AS
Begin
SET NOCOUNT ON;
select prod.Item_Id,prod.Item_Name,prod.Price from Products prod
inner join Shopping_Cart sc on sc.Item_Id = prod.Item_id
End