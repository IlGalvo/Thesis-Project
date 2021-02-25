using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ListViewPage1 : ContentPage
    {
        private readonly ListViewPage1ViewModel listViewPage1ViewModel;

        public ListViewPage1()
        {
            InitializeComponent();

            BindingContext = listViewPage1ViewModel = new ListViewPage1ViewModel();
        }

        protected override async void OnAppearing()
        {
            var tmpList = new List<ConfidenceRule>();
            tmpList.Add(new ConfidenceRule(0, "1", "2"));

            /*using (var httpClient = new HttpClient())
            {
                var result = await httpClient.GetAsync("http://localhost:8000");

                var text = await result.Content.ReadAsStringAsync();

                tmpList = JsonConvert.DeserializeObject<List<ConfidenceRule>>(text);
            }*/

            listViewPage1ViewModel.Update(tmpList);

            base.OnAppearing();
        }
    }

    public class ConfidenceRule
    {
        public int Id { get; }
        public string Name { get; }

        public string Text { get; }

        public ConfidenceRule(int id, string name, string text)
        {
            Id = id;
            Name = name;

            Text = text;
        }
    }
}