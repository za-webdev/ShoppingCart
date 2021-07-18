using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using SalesTaxes.CodeHelpers;
using SalesTaxes.DBAccess;
using SalesTaxes.Models;
using SalesTaxes.ViewModels;

namespace SalesTaxes.Controllers
{
    public class ShoppingCartController : Controller
    {
        private readonly IDBAccessRepo _dBAccessRepo;
        private const string CartSessionKey = "ProductCart";

        public ShoppingCartController(IDBAccessRepo dBAccessRepo)
        {
            _dBAccessRepo = dBAccessRepo;
        }

        public IActionResult SubmitCart()
        {
            List<int> cart = HttpContext.Session.GetObjectFromJson<List<int>>(CartSessionKey) ?? new List<int>();
            var itemIds = string.Join(",", cart);
           
            _dBAccessRepo.AddItemsToCart(itemIds.ToString());
           

            return RedirectToAction("ViewReceipt");
        }

        public IActionResult GetItemsInCart()
        {
           
            List<int> cart = HttpContext.Session.GetObjectFromJson<List<int>>(CartSessionKey) ?? new List<int>();
            
            var itemIds = string.Join(",", cart);
            var products = _dBAccessRepo.GetItemsInCart(itemIds.ToString());

            return View("Cart", products);
        }


        [Route("ViewReceipt")]
        public IActionResult ViewReceipt()
        {

            var items = _dBAccessRepo.GetItemsInfoForReceipt();
            var receiptViewModel = new ReceiptViewModel { };
            receiptViewModel.Items = new List<ProductInfo>();

            foreach (var item in items)
            {
                
                var taxAmount = (item.SalesTax * item.Price);
                item.PriceWithTax = (item.Price + taxAmount) * item.Count;
                item.PriceWithTax = TruncKeepDecimalPlaces(item.PriceWithTax,2);
                receiptViewModel.SalesTaxSum += taxAmount;
                if(item.Count > 1)
                {
                    item.Description = string.Format("{0} : {1} ( {2} @ {3} )",item.Item_Name,item.PriceWithTax,item.Count,item.Price);
                }
                else
                {
                    item.Description = string.Format("{0} : {1}", item.Item_Name, item.PriceWithTax);
                }
                receiptViewModel.Total += item.PriceWithTax;
                receiptViewModel.Items.Add(item);
            }

            receiptViewModel.Total = TruncKeepDecimalPlaces(receiptViewModel.Total,2);
            receiptViewModel.SalesTaxSum = TruncKeepDecimalPlaces(receiptViewModel.SalesTaxSum,2);

            _dBAccessRepo.MarkItemsAsPurchased();
            //clear the cart session
            HttpContext.Session.Clear();

            return View("Receipt", receiptViewModel);
        }

        public double TruncKeepDecimalPlaces(double numberToTruncate, int decimalPlaces)
        {
            double power = (Math.Pow(10.0, decimalPlaces));

            return Math.Truncate(power * numberToTruncate) / power;
        }

    }
}