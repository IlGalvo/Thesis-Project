using System.Collections.Generic;

namespace AppDemo.ViewModels
{
    public class GeneralPageViewModel : AddBaseViewModel
    {
        public List<string> Texts { get; }

        public string SelectedText { get; set; }

        public GeneralPageViewModel(List<string> arteries, List<string> texts) : base(arteries)
        {
            Texts = texts;

            SelectedText = texts[0];
        }

        protected override void Action(object value)
        {
            var dictionary = new Dictionary<string, string>
            {
                { "main_artery", SelectedMainArtery },
                { "rule_type", "general" },
                { "text", SelectedText }
            };

            Add(dictionary);
        }
    }
}