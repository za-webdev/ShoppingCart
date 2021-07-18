using Microsoft.AspNetCore.Mvc;
using SalesTaxes.DBAccess;
using SalesTaxes.Models;
using SalesTaxes.ViewModels;
using System.Collections.Generic;

namespace SalesTaxes.Controllers
{
    public class CategoryController : Controller
    {
        private readonly IDBAccessRepo _dBAccessRepo;

        public CategoryController(IDBAccessRepo dBAccessRepo)
        {
            _dBAccessRepo = dBAccessRepo;
        }

        [HttpPost]
        [Route("AddUpdateCategory")]
        public IActionResult AddUpdateCategory(CategoryViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var category = new Category()
                {
                    Category_Id = viewModel.Category_Id,
                    Category_Name = viewModel.Category_Name,
                    SalesTax = viewModel.SalesTax/100
                };
                var recordId = _dBAccessRepo.UpsertCategory(category);
                if (recordId <= 0)
                {
                    ModelState.AddModelError("isValid", "False");
                    viewModel.Messages.ErrorMessages.Add("Category name already exists.");
                }
            }

            return PartialView("_CategoryModelPopUp", viewModel);

        }

        [HttpGet]
        [Route("EditCategory/{Id?}")]
        public IActionResult EditCategory(int Id)
        {
            var model = _dBAccessRepo.GetCategoryById(Id);
            return PartialView("_CategoryModelPopUp", model);
        }

        public IActionResult OpenCategoryModel()
        {
            var model = new CategoryViewModel { };
            ViewData["isCategoryModel"] = true;
            return PartialView("_CategoryModelPopUp", model);
        }

        [Route("GetCategories")]
        public IActionResult GetCategories()
        {
            List<CategoryViewModel> categories = _dBAccessRepo.GetCategories();
            return View("../Category/Categories", categories);
        }

    }
}
