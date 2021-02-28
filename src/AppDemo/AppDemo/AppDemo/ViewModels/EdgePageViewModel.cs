using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class EdgePageViewModel : AddBaseViewModel
    {
        public string SelectedArtery { get; set; }

        public bool IsTransitive { get; set; }

        public EdgePageViewModel(int id) : base(id)
        {
            SelectedArtery = string.Empty;

            IsTransitive = false;
        }

        public void Update(List<string> arteries)
        {
            Arteries = arteries;
        }

        protected override async void Action(object value)
        {
            if ((!string.IsNullOrEmpty(SelectedMainArtery)) &&
                (!string.IsNullOrEmpty(SelectedArtery)) &&
                (SelectedMainArtery != SelectedArtery))
            {
                var dictionary = new Dictionary<string, string>
                {
                    { "id", id.ToString() },
                    { "artery", SelectedMainArtery },
                    { "rule_type", "edge" },
                    { "artery2", SelectedArtery },
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