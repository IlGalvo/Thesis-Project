using AppDemo.Internal;
using AppDemo.Models;
using System;

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
            if (await DisplayDialogAsync("Question", "Are you sure you want to delete this confidence rule?", "Yes", "No"))
            {
                try
                {
                    await HttpRequestClient.Instance.DeleteAsync(ConfidenceRule.Id, ConfidenceRule.Name);

                    await Navigation.PopToRootAsync();
                }
                catch (Exception exception)
                {
                    await DisplayDialogAsync("Error", exception.Message, "Close");
                }
            }
        }
    }
}