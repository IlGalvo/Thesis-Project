using AppDemo.Views;
using Xamarin.Forms;

namespace AppDemo
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            MainPage = new NavigationPage(new CRListViewPage());
        }
    }
}