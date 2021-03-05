using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class GeneralPageViewModel : AddBaseViewModel
    {
        private List<string> texts;
        public List<string> Texts
        {
            get { return texts; }
            set
            {
                texts = value;
                OnPropertyChanged();
            }
        }

        public string SelectedText { get; set; }

        public GeneralPageViewModel(List<string> arteries, List<string> texts) : base(arteries)
        {
            Texts = texts;

            SelectedText = string.Empty;
        }

        public void Update(List<string> arteries, List<string> texts)
        {
            Arteries = arteries;

            Texts = texts;
        }

        protected override async void Action(object value)
        {
            if ((!string.IsNullOrEmpty(SelectedMainArtery)) && (!string.IsNullOrEmpty(SelectedText)))
            {
                var dictionary = new Dictionary<string, string>
                {
                    { "main_artery", SelectedMainArtery },
                    { "rule_type", "general" },
                    { "text", SelectedText }
                };

                Add(dictionary);
            }
            else
            {
                await CurrentPage.DisplayAlert("Error", "Artery and text cannot be empty.", "Close");
            }
        }
    }
}