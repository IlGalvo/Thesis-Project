using AppDemo.ViewModels;
using System.Collections.Generic;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class GeneralPage : ContentPage
    {
        public GeneralPage(List<string> arteries, List<string> texts)
        {
            InitializeComponent();

            BindingContext = new GeneralPageViewModel(arteries, texts);
        }
    }
}