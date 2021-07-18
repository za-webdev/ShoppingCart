using SalesTaxes.Models;
using SalesTaxes.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.DBAccess
{
    public interface IDBAccessRepo
    {
        int UpsertCategory(Category category);
        CategoryViewModel GetCategoryById(int categoryId);
        List<CategoryViewModel> GetCategories();
        int UpsertProduct(Product product);
        List<ProductViewModel> GetProducts();
        void AddItemsToCart(string listOfItemIds);
        List<ProductViewModel> GetItemsInCart(string selectedItems);
        List<ProductInfo> GetItemsInfoForReceipt();
        void MarkItemsAsPurchased();
    }
}
