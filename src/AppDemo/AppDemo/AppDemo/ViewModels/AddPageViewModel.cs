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
                        await Navigation.PushAsync(new EdgePage(arteries));
                        break;
                    case "Comparator":
                        var types = await HttpRequestClient.Instance.GetComparatorTypesAsync();
                        var modes = await HttpRequestClient.Instance.GetComparatorModesAsync();

                        await Navigation.PushAsync(new ComparatorPage(arteries, types, modes));
                        break;
                    case "General":
                        var texts = await HttpRequestClient.Instance.GetGeneralTextsAsync();

                        await Navigation.PushAsync(new GeneralPage(arteries, texts));
                        break;
                }
            }
            catch (Exception exception)
            {
                await DisplayDialogAsync("Error", exception.Message, "Close");
            }
        }
    }
}