using AppDemo.Internal;
using AppDemo.Views;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class AddPageViewModel : PageHelper
    {
        public string EnteredId { get; set; }

        public ICommand ActionCommand { get; private set; }

        public AddPageViewModel()
        {
            EnteredId = string.Empty;

            ActionCommand = new Command<string>(Action);
        }

        private async void Action(string type)
        {
            if (int.TryParse(EnteredId, out int id) && id > 0)
            {
                Page page = null;

                switch (type)
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