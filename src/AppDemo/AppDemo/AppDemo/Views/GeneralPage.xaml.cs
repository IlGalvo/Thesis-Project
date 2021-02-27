using AppDemo.Internal;
using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class GeneralPage : ContentPage
    {
        private readonly GeneralPageViewModel generalPageViewModel;

        public GeneralPage(int id)
        {
            InitializeComponent();

            BindingContext = generalPageViewModel = new GeneralPageViewModel(id);
        }

        protected override async void OnAppearing()
        {
            var arteries = await HttpRequestClient.Instance.GetArteriesAsync();
            var texts = await HttpRequestClient.Instance.GetGeneralTextsAsync();

            generalPageViewModel.Update(arteries, texts);

            base.OnAppearing();
        }
    }
}