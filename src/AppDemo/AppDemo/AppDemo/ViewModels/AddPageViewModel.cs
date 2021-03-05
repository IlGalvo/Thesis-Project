using AppDemo.Internal;
using AppDemo.Views;
using System;

namespace AppDemo.ViewModels
{
    public class AddPageViewModel : BaseViewModel
    {
        protected override async void Action(object value)
        {
            try
            {
                var arteries = await HttpRequestClient.Instance.GetArteriesAsync();

                switch (value.ToString())
                {
                    case "Edge":
                        await CurrentPage.Navigation.PushAsync(new EdgePage(arteries));
                        break;
                    case "Comparator":
                        var types = await HttpRequestClient.Instance.GetComparatorTypesAsync();
                        var modes = await HttpRequestClient.Instance.GetComparatorModesAsync();

                        await CurrentPage.Navigation.PushAsync(new ComparatorPage(arteries));
                        break;
                    case "General":
                        var texts = await HttpRequestClient.Instance.GetGeneralTextsAsync();

                        await CurrentPage.Navigation.PushAsync(new GeneralPage(arteries, texts));
                        break;
                }
            }
            catch (Exception exception)
            {
                await CurrentPage.DisplayAlert("Error", exception.Message, "Close");
            }
        }
    }
}