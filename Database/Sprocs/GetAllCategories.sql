USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCategories]    Script Date: 7/15/2021 1:05:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetAllCategories]

AS
Begin
SET NOCOUNT ON;
select * from Categories where IsDeleted = 0

End