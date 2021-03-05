using AppDemo.Internal;
using AppDemo.Views;
using System;
using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public abstract class AddBaseViewModel : BaseViewModel
    {
        private List<string> arteries;
        public List<string> Arteries
        {
            get { return arteries; }
            set
            {
                arteries = value;
                OnPropertyChanged();
            }
        }

        public string SelectedMainArtery { get; set; }

        protected AddBaseViewModel(List<string> arteries)
        {
            Arteries = arteries;

            SelectedMainArtery = string.Empty;
        }

        protected async void Add(Dictionary<string, string> dictionary)
        {
            try
            {
                var confidenceRule = await HttpRequestClient.Instance.InsertAsync(dictionary);

                if (await CurrentPage.DisplayAlert("Info", "Added correctly, wanna show?", "Ok", "Close"))
                {
                    CurrentPage.Navigation.InsertPageBefore(new CRPage(confidenceRule), CurrentPage);
                    await CurrentPage.Navigation.PopAsync();
                }
            }
            catch (Exception exception)
            {
                await CurrentPage.DisplayAlert("Error", exception.Message, "Close");
            }
        }
    }
}