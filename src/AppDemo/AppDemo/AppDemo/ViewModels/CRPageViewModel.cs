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
            try
            {
                await HttpRequestClient.Instance.DeleteAsync(ConfidenceRule.Id, ConfidenceRule.Name);
            }
            catch (Exception exception)
            {
                await CurrentPage.DisplayAlert("Error", exception.ToString(), "Close");
            }
        }
    }
}