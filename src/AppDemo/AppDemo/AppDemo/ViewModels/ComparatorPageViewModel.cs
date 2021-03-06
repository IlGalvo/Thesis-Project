using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class ComparatorPageViewModel : AddBaseViewModel
    {
        public List<string> Types { get; }
        public List<string> Modes { get; }

        public string SelectedType { get; set; }
        public string SelectedMode { get; set; }

        public string SelectedArtery { get; set; }

        public string EnteredOffset1 { get; set; }
        public string EnteredOffset2 { get; set; }

        public ComparatorPageViewModel(List<string> arteries, List<string> types, List<string> modes) : base(arteries)
        {
            Types = types;
            Modes = modes;

            SelectedType = types[0];
            SelectedMode = modes[0];

            SelectedArtery = arteries[1];

            EnteredOffset1 = string.Empty;
            EnteredOffset2 = string.Empty;
        }

        private bool TryParseOffset(string offset, out string result)
        {
            result = string.Empty;
            var success = true;

            if (!string.IsNullOrEmpty(offset))
            {
                success = (int.TryParse(offset, out int intOfsset) && intOfsset != 0);

                if (success)
                {
                    offset = intOfsset.ToString();

                    result = ((intOfsset > 0) ? ("+" + offset) : offset);
                }
            }

            return success;
        }

        protected override async void Action(object value)
        {
            if (SelectedMainArtery != SelectedArtery)
            {
                if (TryParseOffset(EnteredOffset1, out string offset1) &&
                    TryParseOffset(EnteredOffset2, out string offset2))
                {
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
                    await CurrentPage.DisplayAlert("Error", "Enter valid offsets (empty or non-zero whole number).", "Close");
                }
            }
            else
            {
                await CurrentPage.DisplayAlert("Error", "Arteries cannot be equal.", "Close");
            }
        }
    }
}