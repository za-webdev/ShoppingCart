USE [MarketPlace]
GO

/****** Object:  Table [dbo].[Shopping_Cart]    Script Date: 7/15/2021 1:10:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Shopping_Cart](
	[Item_Id] [int] NOT NULL,
	[Purchased] [bit] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Shopping_Cart] ADD  CONSTRAINT [DF_Shopping_Cart_Purchased]  DEFAULT ((0)) FOR [Purchased]
GO

ALTER TABLE [dbo].[Shopping_Cart]  WITH CHECK ADD  CONSTRAINT [FK_Shopping_Cart_Products] FOREIGN KEY([Item_Id])
REFERENCES [dbo].[Products] ([Item_Id])
GO

ALTER TABLE [dbo].[Shopping_Cart] CHECK CONSTRAINT [FK_Shopping_Cart_Products]
GO


