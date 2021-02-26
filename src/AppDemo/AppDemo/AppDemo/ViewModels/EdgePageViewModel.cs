using AppDemo.Internal;
using AppDemo.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel;
using System.Net.Http;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class EdgePageViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private List<string> arteries;
        public List<string> Arteries
        {
            get { return arteries; }
            set
            {
                arteries = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Arteries)));
            }
        }

        public string SelectedArtery1 { get; set; }
        public string SelectedArtery2 { get; set; }

        public bool IsTransitive { get; set; }

        public Command AddCommand { get; private set; }

        private readonly string id;

        public EdgePageViewModel(string id)
        {
            this.id = id;

            Arteries = new List<string>();

            SelectedArtery1 = string.Empty;
            SelectedArtery2 = string.Empty;

            IsTransitive = false;

            AddCommand = new Command(Bhorobho);
        }

        public void Update(List<string> arteries)
        {
            Arteries = arteries;
        }

        private async void Bhorobho()
        {
            if (SelectedArtery1 == SelectedArtery2)
                return;

            using (var httpClient = new HttpClient())
            {
                var cde = new Dictionary<string, string>
                {
                    { "id", id },
                    { "artery", SelectedArtery1 },
                    { "rule_type", "edge" },
                    { "artery2", SelectedArtery2 },
                    { "is_transitive", IsTransitive ? "true" : "false" },
                };

                using (var abc = new FormUrlEncodedContent(cde))
                {
                    var result = await httpClient.PostAsync("http://localhost:8000", abc);

                    var text = await result.Content.ReadAsStringAsync();

                    var cr = JsonConvert.DeserializeObject<ConfidenceRule>(text);

                    await CurrentPage.DisplayAlert("Added", cr.Text, "Ok");
                }
            }
        }
    }
}