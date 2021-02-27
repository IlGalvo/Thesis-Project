using AppDemo.Models;
using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRPage : ContentPage
    {
        public CRPage(ConfidenceRule confidenceRule)
        {
            InitializeComponent();

            BindingContext = new CRPageViewModel(confidenceRule);
        }
    }
}