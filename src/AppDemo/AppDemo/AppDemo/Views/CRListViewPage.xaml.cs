using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRListViewPage : ContentPage
    {
        public CRListViewPage()
        {
            InitializeComponent();

            BindingContext = new CRListViewPageViewModel();
        }

        protected override void OnAppearing()
        {
            ((CRListViewPageViewModel)BindingContext).Refresh();

            base.OnAppearing();
        }
    }
}