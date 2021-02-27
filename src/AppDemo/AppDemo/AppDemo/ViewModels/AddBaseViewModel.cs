using AppDemo.Internal;
using AppDemo.Views;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public abstract class AddBaseViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

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
        public ICommand AddCommand { get; private set; }

        protected readonly int id;

        public AddBaseViewModel(int id)
        {
            this.id = id;

            Arteries = new List<string>();

            SelectedMainArtery = string.Empty;
            AddCommand = new Command(Add);
        }

        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        protected abstract void Add();

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