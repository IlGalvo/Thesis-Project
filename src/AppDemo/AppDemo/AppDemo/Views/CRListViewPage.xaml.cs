using AppDemo.Models;
using AppDemo.ViewModels;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CRListViewPage : ContentPage
    {
        private readonly CRListViewPageViewModel listViewPage1ViewModel;

        public CRListViewPage()
        {
            InitializeComponent();

            BindingContext = listViewPage1ViewModel = new CRListViewPageViewModel();
        }

        protected override async void OnAppearing()
        {
            var tmpList = new List<ConfidenceRule>();

            using (var httpClient = new HttpClient())
            {
                var result = await httpClient.GetAsync("http://localhost:8000?q=confidence_rules");

                var text = await result.Content.ReadAsStringAsync();

                tmpList = JsonConvert.DeserializeObject<List<ConfidenceRule>>(text);
            }

            listViewPage1ViewModel.Update(tmpList);

            base.OnAppearing();
        }
    }
}