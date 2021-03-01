using AppDemo.Internal;
using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ComparatorPage : ContentPage
    {
        private readonly ComparatorPageViewModel comparatorPageViewModel;

        public ComparatorPage(int id)
        {
            InitializeComponent();

            BindingContext = comparatorPageViewModel = new ComparatorPageViewModel(id);
        }

        protected override async void OnAppearing()
        {
            comparatorPageViewModel.Update(await HttpRequestClient.Instance.GetArteriesAsync());

            base.OnAppearing();
        }
    }
}