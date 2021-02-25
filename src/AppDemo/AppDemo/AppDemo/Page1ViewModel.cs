namespace AppDemo
{
    public class Page1ViewModel
    {
        public string Text1 { get; }
        public string Text2 { get; }

        public Page1ViewModel(string text)
        {
            Text1 = Text2 = text;
        }
    }
}