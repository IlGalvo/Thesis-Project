using Xamarin.Forms;

namespace AppDemo.Internal
{
    public abstract class PageHelper
    {
        public Page CurrentPage { get; private set; }

        public PageHelper()
        {
            Application.Current.PageAppearing += Current_PageAppearing;
        }

        private void Current_PageAppearing(object sender, Page e)
        {
            CurrentPage = e;

            Application.Current.PageAppearing -= Current_PageAppearing;
        }
    }
}