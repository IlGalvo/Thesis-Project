using AppDemo.Internal;
using AppDemo.ViewModels;
using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRListViewPage : ContentPage
    {
        private readonly CRListViewPageViewModel crListViewPageViewModel;

        public CRListViewPage()
        {
            InitializeComponent();

            BindingContext = crListViewPageViewModel = new CRListViewPageViewModel();
        }

        protected override async void OnAppearing()
        {
            try
            {
                crListViewPageViewModel.Update(await HttpRequestClient.Instance.GetConfidenceRulesAsync());
            }
            catch(Exception ex)
            {

            }

            base.OnAppearing();
        }
    }
}