namespace AppDemo.ViewModels
{
    public class CRPageViewModel
    {
        public string Text { get; }
        public string Rule { get; }

        public CRPageViewModel(string text, string rule)
        {
            Text = text;
            Rule = rule;
        }
    }
}