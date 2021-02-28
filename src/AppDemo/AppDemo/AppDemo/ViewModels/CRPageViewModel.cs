using AppDemo.Internal;
using AppDemo.Models;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class CRPageViewModel : BaseViewModel
    {
        public ConfidenceRule ConfidenceRule { get; }

        public CRPageViewModel(ConfidenceRule confidenceRule)
        {
            ConfidenceRule = confidenceRule;
        }

        protected override async void Action(object value)
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