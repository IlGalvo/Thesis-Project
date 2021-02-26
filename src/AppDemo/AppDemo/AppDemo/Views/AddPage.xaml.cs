using AppDemo.ViewModels;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class AddPage : ContentPage
    {
        private readonly AddPageViewModel page1ViewModel;

        public AddPage()
        {
            InitializeComponent();

            BindingContext = page1ViewModel = new AddPageViewModel();
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

            page1ViewModel.Update(tmpList);

            base.OnAppearing();
        }
    }
}