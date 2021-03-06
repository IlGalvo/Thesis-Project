using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class EdgePageViewModel : AddBaseViewModel
    {
        public List<string> EdgeArteries { get; }

        public string SelectedArtery { get; set; }
        public bool IsTransitive { get; set; }

        public EdgePageViewModel(List<string> arteries) : base(arteries)
        {
            EdgeArteries = new List<string>(arteries);
            EdgeArteries.Insert(0, "aorta");

            SelectedArtery = EdgeArteries[0];
            IsTransitive = false;
        }

        protected override async void Action(object value)
        {
            if (SelectedMainArtery != SelectedArtery)
            {
                var dictionary = new Dictionary<string, string>
                {
                    { "main_artery", SelectedMainArtery },
                    { "rule_type", "edge" },
                    { "artery", SelectedArtery },
                    { "is_transitive", IsTransitive.ToString() }
                };

                Add(dictionary);
            }
            else
            {
                await CurrentPage.DisplayAlert("Error", "Arteries cannot be equal.", "Close");
            }
        }
    }
}