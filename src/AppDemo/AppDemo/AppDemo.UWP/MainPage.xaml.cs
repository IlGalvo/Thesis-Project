namespace AppDemo.UWP
{
    public sealed partial class MainPage
    {
        public MainPage()
        {
            this.InitializeComponent();

            LoadApplication(new AppDemo.App());
        }
    }
}
