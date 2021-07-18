using SalesTaxes.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.ViewModels
{
    public class ReceiptViewModel
    {

        public List<ProductInfo> Items { set; get; }
        public double SalesTaxSum { get; set; }
        public double Total { get; set; }
        
    }
}
