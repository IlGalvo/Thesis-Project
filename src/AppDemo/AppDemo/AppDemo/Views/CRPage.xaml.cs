using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRPage : ContentPage
    {
        public CRPage(string text, string rule)
        {
            InitializeComponent();

            BindingContext = new CRPageViewModel(text, rule);
        }
    }
}