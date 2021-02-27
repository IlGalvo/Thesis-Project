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

        public string SelectedArtery { get; set; }
        public string SelectedText { get; set; }

        public Command AddCommand { get; private set; }

        private readonly string id;

        public GeneralPageViewModel(string id)
        {
            this.id = id;

            Arteries = new List<string>();
            Texts = new List<string>();

            SelectedArtery = string.Empty;
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
                    { "artery", SelectedArtery },
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