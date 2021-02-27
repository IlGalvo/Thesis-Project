using AppDemo.Internal;
using AppDemo.Views;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class AddPageViewModel : PageHelper
    {
        public string EnteredId { get; set; }

        public Command EdgeCommand { get; private set; }
        public Command ComparatorCommand { get; private set; }
        public Command GeneralCommand { get; private set; }

        public AddPageViewModel()
        {
            EnteredId = string.Empty;

            EdgeCommand = new Command(Edge);
            ComparatorCommand = new Command(Comparator);
            GeneralCommand = new Command(General);
        }

        private bool Validate()
        {
            return (!string.IsNullOrEmpty(EnteredId));
        }

        private void Edge()
        {
            if (Validate())
            {
                CurrentPage.Navigation.PushAsync(new EdgePage(EnteredId));
            }
            else
            {
                CurrentPage.DisplayAlert("Error", "Bhorobho", "Ok");
            }
        }

        private void Comparator(object obj)
        {
            if (Validate())
            {
                CurrentPage.Navigation.PushAsync(new ComparatorPage(EnteredId));
            }
            else
            {
                CurrentPage.DisplayAlert("Error", "Bhorobho", "Ok");
            }
        }

        private void General()
        {
            if (Validate())
            {
                CurrentPage.Navigation.PushAsync(new GeneralPage(EnteredId));
            }
            else
            {
                CurrentPage.DisplayAlert("Error", "Bhorobho", "Ok");
            }
        }
    }
}