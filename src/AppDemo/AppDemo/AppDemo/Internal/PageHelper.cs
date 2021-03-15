using System.Threading.Tasks;
using Xamarin.Forms;

namespace AppDemo.Internal
{
    /// <summary>
    /// Helper class to access to INavigation system and DisplayAlert methods from page.
    /// Not default mode: programmer choise.
    /// </summary>
    public abstract class PageHelper
    {
        protected INavigation Navigation { get { return currentPage.Navigation; } }

        private Page currentPage;

        protected PageHelper()
        {
            // Sintactic sugar to get the page without propagate it from VMs.
            Application.Current.PageAppearing += Current_PageAppearing;
        }

        // Save just added page, once.
        private void Current_PageAppearing(object sender, Page e)
        {
            currentPage = e;

            Application.Current.PageAppearing -= Current_PageAppearing;
        }

        protected async Task DisplayDialogAsync(string title, string message, string cancel)
        {
            await currentPage.DisplayAlert(title, message, cancel);
        }

        protected async Task<bool> DisplayDialogAsync(string title, string message, string accept, string cancel)
        {
            return await currentPage.DisplayAlert(title, message, accept, cancel);
        }
    }
}