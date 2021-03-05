using System.Collections.Generic;
using System.Threading.Tasks;

namespace AppDemo.ViewModels
{
    public class ComparatorPageViewModel : AddBaseViewModel
    {
        private List<string> modes;
        public List<string> Modes
        {
            get { return modes; }
            set
            {
                modes = value;
                OnPropertyChanged();
            }
        }

        private List<string> types;
        public List<string> Types
        {
            get { return types; }
            set
            {
                types = value;
                OnPropertyChanged();
            }
        }

        public string SelectedType { get; set; }
        public string SelectedMode { get; set; }

        public string EnteredOffset1 { get; set; }

        public string SelectedArtery { get; set; }
        public string EnteredOffset2 { get; set; }

        public ComparatorPageViewModel(List<string> arteries) : base(arteries)
        {
            SelectedType = string.Empty;
            SelectedMode = string.Empty;

            EnteredOffset1 = string.Empty;

            SelectedArtery = string.Empty;
            EnteredOffset2 = string.Empty;
        }

        public void Update(List<string> arteries)
        {
            Arteries = arteries;
        }

        private async Task<string> ValidateOffsetAsync(string offset)
        {
            if (!string.IsNullOrEmpty(offset))
            {
                if (int.TryParse(offset, out int tmpOffset) && tmpOffset != 0)
                {
                    offset = ((tmpOffset > 0) ? ("+" + offset) : offset);
                }
                else
                {
                    await CurrentPage.DisplayAlert("Error", "Enter valid offsets (empty or non-zero whole number).", "Close");
                }
            }

            return offset;
        }

        protected override async void Action(object value)
        {
            if ((!string.IsNullOrEmpty(SelectedMainArtery)) &&
                (!string.IsNullOrEmpty(SelectedArtery)) &&
                (SelectedMainArtery != SelectedArtery))
            {
                string offset1 = await ValidateOffsetAsync(EnteredOffset1);
                string offset2 = await ValidateOffsetAsync(EnteredOffset2);

                var dictionary = new Dictionary<string, string>
                {
                    { "main_artery", SelectedMainArtery },
                    { "rule_type", "comparator" },
                    { "type", SelectedType },
                    { "mode", SelectedMode },
                    { "offset1", offset1 },
                    { "artery", SelectedArtery },
                    { "offset2", offset2 }
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