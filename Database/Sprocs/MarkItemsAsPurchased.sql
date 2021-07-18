USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetItemsInCart]    Script Date: 7/14/2021 11:20:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[MarkItemsAsPurchased]

AS
Begin
SET NOCOUNT ON;
Update Shopping_Cart set Purchased = 1 where Purchased = 0
End