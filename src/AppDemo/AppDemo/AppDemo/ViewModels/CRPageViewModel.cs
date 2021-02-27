using AppDemo.Internal;
using AppDemo.Models;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class CRPageViewModel : PageHelper
    {
        public ConfidenceRule ConfidenceRule { get; }

        public ICommand DeleteCommand { get; private set; }

        public CRPageViewModel(ConfidenceRule confidenceRule)
        {
            ConfidenceRule = confidenceRule;

            DeleteCommand = new Command(Delete);
        }

        private async void Delete()
        {
            var result = await HttpRequestClient.Instance.DeleteAsync(ConfidenceRule.Id, ConfidenceRule.Name);

            if (result == "ok")
            {
                await CurrentPage.DisplayAlert("Info", "Deleted", "Ok");
            }
            else
            {
                await CurrentPage.DisplayAlert("Info", "Not Deleted", "Ok");
            }
        }
    }
}