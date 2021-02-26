using AppDemo.Internal;
using AppDemo.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel;
using System.Net.Http;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class GeneralPageViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private List<string> texts;
        public List<string> Texts
        {
            get { return texts; }
            set
            {
                texts = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Texts)));
            }
        }

        public string SelectedText { get; set; }

        public Command AddCommand { get; private set; }

        private readonly string id;
        private readonly string artery;

        public GeneralPageViewModel(string id, string artery)
        {
            this.id = id;
            this.artery = artery;

            Texts = new List<string>();
            SelectedText = string.Empty;

            AddCommand = new Command(Bhorobho);
        }

        public void Update(List<string> texts)
        {
            Texts = texts;
        }

        private async void Bhorobho()
        {
            using (var httpClient = new HttpClient())
            {
                var cde = new Dictionary<string, string>
                {
                    { "id", id },
                    { "artery", artery },
                    { "rule_type", "general" },
                    { "text", SelectedText }
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