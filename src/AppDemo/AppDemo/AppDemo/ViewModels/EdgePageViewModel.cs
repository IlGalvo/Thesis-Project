using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class EdgePageViewModel : AddBaseViewModel
    {
        public string SelectedArtery { get; set; }

        public bool IsTransitive { get; set; }

        public EdgePageViewModel(List<string> arteries) : base(arteries)
        {
            SelectedArtery = string.Empty;

            IsTransitive = false;
        }

        protected override async void Action(object value)
        {
            if ((!string.IsNullOrEmpty(SelectedMainArtery)) &&
                (!string.IsNullOrEmpty(SelectedArtery)) &&
                (SelectedMainArtery != SelectedArtery))
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
                await CurrentPage.DisplayAlert("Error", "Arteries cannot be empty or equal.", "Close");
            }
        }
    }
}