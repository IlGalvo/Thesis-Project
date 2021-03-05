using AppDemo.ViewModels;
using System.Collections.Generic;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ComparatorPage : ContentPage
    {
        public ComparatorPage(List<string> arteries)
        {
            InitializeComponent();

            BindingContext = new ComparatorPageViewModel(arteries);
        }
    }
}