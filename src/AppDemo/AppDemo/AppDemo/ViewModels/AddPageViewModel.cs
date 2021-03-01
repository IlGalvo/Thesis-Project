using AppDemo.Views;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class AddPageViewModel : BaseViewModel
    {
        public string EnteredId { get; set; }

        public AddPageViewModel()
        {
            EnteredId = string.Empty;
        }

        protected override async void Action(object value)
        {
            if (int.TryParse(EnteredId, out int id) && id > 0)
            {
                Page page = null;

                switch (value.ToString())
                {
                    case "Edge":
                        page = new EdgePage(id);
                        break;
                    case "Comparator":
                        page = new ComparatorPage(id);
                        break;
                    case "General":
                        page = new GeneralPage(id);
                        break;
                }

                await CurrentPage.Navigation.PushAsync(page);
            }
            else
            {
                await CurrentPage.DisplayAlert("Error", "Enter a valid Id (natural number).", "Close");
            }
        }
    }
}