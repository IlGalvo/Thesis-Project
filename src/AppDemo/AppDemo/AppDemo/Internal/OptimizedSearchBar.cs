using Xamarin.Forms;

namespace AppDemo.Internal
{
    public class OptimizedSearchBar : SearchBar
    {
        public static readonly BindableProperty TextChangedCommandProperty =
            BindableProperty.Create(nameof(TextChangedCommand), typeof(Command<string>), typeof(OptimizedSearchBar), null);

        public Command<string> TextChangedCommand
        {
            get { return ((Command<string>)GetValue(TextChangedCommandProperty)); }
            set { SetValue(TextChangedCommandProperty, value); }
        }

        public OptimizedSearchBar()
        {
            Text = string.Empty;

            TextChanged += OptimizedSearchBar_TextChanged;
        }

        private void OptimizedSearchBar_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextChangedCommand?.Execute(e.NewTextValue);
        }
    }
}