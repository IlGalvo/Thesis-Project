using AppDemo.ViewModels;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class EdgePage : ContentPage
    {
        private readonly EdgePageViewModel edgePageViewModel;

        public EdgePage(string id)
        {
            InitializeComponent();

            BindingContext = edgePageViewModel = new EdgePageViewModel(id);
        }

        protected override async void OnAppearing()
        {
            var tmpList = new List<string>();

            using (var httpClient = new HttpClient())
            {
                var result = await httpClient.GetAsync("http://localhost:8000?q=arteries");

                var text = await result.Content.ReadAsStringAsync();

                tmpList = JsonConvert.DeserializeObject<List<string>>(text);
            }

            edgePageViewModel.Update(tmpList);

            base.OnAppearing();
        }
    }
}