using AppDemo.Internal;
using AppDemo.Views;
using System.Collections.Generic;
using System.ComponentModel;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class AddPageViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private List<string> arteries;
        public List<string> Arteries
        {
            get { return arteries; }
            set
            {
                arteries = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Arteries)));
            }
        }

        public string EnteredId { get; set; }
        public string SelectedArtery { get; set; }

        public Command EdgeCommand { get; private set; }
        public Command ComparatorCommand { get; private set; }
        public Command GeneralCommand { get; private set; }

        public AddPageViewModel()
        {
            Arteries = new List<string>();

            EnteredId = string.Empty;
            SelectedArtery = string.Empty;

            EdgeCommand = new Command(Edge);
            ComparatorCommand = new Command(Comparator);
            GeneralCommand = new Command(General);
        }

        public void Update(List<string> arteries)
        {
            Arteries = arteries;
        }

        private bool Validate()
        {
            return ((!string.IsNullOrEmpty(EnteredId)) && (!string.IsNullOrEmpty(SelectedArtery)));
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
                CurrentPage.Navigation.PushAsync(new GeneralPage(EnteredId, SelectedArtery));
            }
            else
            {
                CurrentPage.DisplayAlert("Error", "Bhorobho", "Ok");
            }
        }
    }
}
