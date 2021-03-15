using AppDemo.Internal;
using AppDemo.Views;
using System;
using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public abstract class AddBaseViewModel : BaseViewModel
    {
        public List<string> Arteries { get; }

        public string SelectedMainArtery { get; set; }

        protected AddBaseViewModel(List<string> arteries)
        {
            Arteries = arteries;

            SelectedMainArtery = arteries[0];
        }

        protected async void Add(Dictionary<string, string> dictionary)
        {
            try
            {
                var confidenceRule = await HttpRequestClient.Instance.InsertAsync(dictionary);

                if (await DisplayDialogAsync("Information", "Confidence rule added correctly, want to show?", "Yes", "No"))
                {
                    await Navigation.PushAsync(new CRPage(confidenceRule, true));
                }
                else
                {
                    await Navigation.PopToRootAsync();
                }
            }
            catch (Exception exception)
            {
                await DisplayDialogAsync("Error", exception.Message, "Close");
            }
        }
    }
}