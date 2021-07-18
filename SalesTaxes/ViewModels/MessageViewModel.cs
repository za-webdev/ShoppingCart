using System.Collections.Generic;

namespace SalesTaxes.ViewModels
{
    public class MessageViewModel
    {
        public List<string> SuccessMessages { get; set; } = new List<string>();
        public List<string> ErrorMessages { get; set; } = new List<string>();
    }
}