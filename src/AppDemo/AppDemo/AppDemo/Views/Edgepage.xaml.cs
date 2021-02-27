using AppDemo.Internal;
using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class EdgePage : ContentPage
    {
        private readonly EdgePageViewModel edgePageViewModel;

        public EdgePage(int id)
        {
            InitializeComponent();

            BindingContext = edgePageViewModel = new EdgePageViewModel(id);
        }

        protected override async void OnAppearing()
        {
            edgePageViewModel.Update(await HttpRequestClient.Instance.GetArteriesAsync());

            base.OnAppearing();
        }
    }
}