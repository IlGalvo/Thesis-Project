using AppDemo.ViewModels;
using System.Collections.Generic;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class EdgePage : ContentPage
    {
        public EdgePage(List<string> arteries)
        {
            InitializeComponent();

            BindingContext = new EdgePageViewModel(arteries);
        }
    }
}