using AppDemo.Models;
using AppDemo.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRPage : ContentPage
    {
        private readonly bool isPostInsert;

        public CRPage(ConfidenceRule confidenceRule, bool isPostInsert = false)
        {
            InitializeComponent();

            this.isPostInsert = isPostInsert;

            BindingContext = new CRPageViewModel(confidenceRule);
        }

        protected override bool OnBackButtonPressed()
        {
            HandleBackButtonPressed();

            return isPostInsert;
        }

        private async void HandleBackButtonPressed()
        {
            if (isPostInsert)
            {
                await Navigation.PopToRootAsync();
            }
        }
    }
}