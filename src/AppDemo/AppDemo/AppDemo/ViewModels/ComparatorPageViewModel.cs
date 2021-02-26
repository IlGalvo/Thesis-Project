using AppDemo.Internal;
using AppDemo.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel;
using System.Net.Http;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class ComparatorPageViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private List<string> modes;
        public List<string> Modes
        {
            get { return modes; }
            set
            {
                modes = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Modes)));
            }
        }

        private List<string> types;
        public List<string> Types
        {
            get { return types; }
            set
            {
                types = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Types)));
            }
        }

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

        public string SelectedType { get; set; }
        public string SelectedMode { get; set; }

        public string SelectedArtery1 { get; set; }
        public string EnteredOffset1 { get; set; }

        public string SelectedArtery2 { get; set; }
        public string EnteredOffset2 { get; set; }

        public Command AddCommand { get; private set; }

        private readonly string id;

        public ComparatorPageViewModel(string id)
        {
            this.id = id;

            Modes = new List<string>() { "cog_x", "cog_z", "heigth" };
            Types = new List<string>() { "greater", "less" };

            Arteries = new List<string>();

            SelectedType = string.Empty;
            SelectedMode = string.Empty;

            SelectedArtery1 = string.Empty;
            EnteredOffset1 = string.Empty;

            SelectedArtery2 = string.Empty;
            EnteredOffset2 = string.Empty;

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
                    { "rule_type", "comparator" },
                    { "type", SelectedType },
                    { "mode", SelectedMode },
                    { "offset1", EnteredOffset1 },
                    { "artery2", SelectedArtery2 },
                    { "offset2", EnteredOffset2 },
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