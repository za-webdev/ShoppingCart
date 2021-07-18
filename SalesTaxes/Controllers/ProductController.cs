using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SalesTaxes.CodeHelpers;
using SalesTaxes.DBAccess;
using SalesTaxes.Models;
using SalesTaxes.ViewModels;
using System.Collections.Generic;

namespace SalesTaxes.Controllers
{
    public class ProductController : Controller
    {
        private readonly IDBAccessRepo _dBAccessRepo;
        public SelectList CategorList;
        private const string CartSessionKey = "ProductCart";
       
        public ProductController(IDBAccessRepo dBAccessRepo)
        {
            _dBAccessRepo = dBAccessRepo;
            CategorList = new SelectList(_dBAccessRepo.GetCategories(), nameof(CategoryViewModel.Category_Id), nameof(CategoryViewModel.Category_Name));
        }

        public IActionResult OpenProductModel()
        {
            var model = new ProductViewModel
            {
                ProductCategories = CategorList
            };

            return PartialView("_ProductModelPopUp", model);
        }
        [HttpPost]
        [Route("AddUpdateProduct")]
        public IActionResult AddUpdateProduct(ProductViewModel viewModel)

        {
            if (ModelState.IsValid)
            {
                var product = new Product()
                {
                    Item_Id = viewModel.Item_Id,
                    Item_Name = viewModel.Item_Name,
                    Price = viewModel.Price,
                    Item_Category_Id = viewModel.Item_Category_Id

                };
                var recordId = _dBAccessRepo.UpsertProduct(product);
            }
            viewModel.ProductCategories = CategorList;
            return PartialView("_ProductModelPopUp", viewModel);

        }
        [Route("GetProducts")]
        public IActionResult GetProducts()
        {
            List<ProductViewModel> products = _dBAccessRepo.GetProducts();

            return View("../Product/Products", products);
        }

        [Route("AddToCart/{Id?}")]
        public void AddToCart(int Id)

        {
            List<int> cart = HttpContext.Session.GetObjectFromJson<List<int>>(CartSessionKey) ?? new List<int>();
            HttpContext.Session.GetObjectFromJson<List<int>>(CartSessionKey);
            cart.Add(Id);
            HttpContext.Session.SetObjectAsJson(CartSessionKey, cart);
        }
    }
}
