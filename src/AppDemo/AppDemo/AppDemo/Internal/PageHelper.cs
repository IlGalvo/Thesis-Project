using System;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.Internal
{
    public class PageHelper
    {
        public Page CurrentPage { get; private set; }

        public ICommand FocusNextCommand { get; private set; }

        public PageHelper()
        {
            Application.Current.PageAppearing += Current_PageAppearing;

            FocusNextCommand = new Command<View>(FocusNext);
        }

        private void Current_PageAppearing(object sender, Page e)
        {
            CurrentPage = e;

            Application.Current.PageAppearing -= Current_PageAppearing;
        }

        private void FocusNext(View view)
        {
            FocusNextView(view);
        }

        public static void FocusNextView(View currentView)
        {
            currentView = NextView(currentView);

            if ((!(currentView is Entry)) && (!(currentView is Button)))
            {
                FocusNextView(currentView);
            }
            else
            {
                currentView.Focus();
            }
        }

        private static View NextView(View currentView)
        {
            if (currentView == null)
                throw (new ArgumentNullException(nameof(currentView)));

            View initialView = currentView;

            while (currentView is Layout)
            {
                if ((currentView as Layout).Children.Count == 0)
                    return NextView(currentView, initialView);

                currentView = ((currentView as Layout).Children[0] as View);
            }

            if (currentView == initialView)
                return NextView(currentView, initialView);

            return currentView;
        }

        private static View NextView(View currentView, View initialView)
        {
            var parent = (currentView.Parent as Layout);

            if (parent != null)
            {
                int count = parent.Children.Count;

                int i;
                for (i = 0; i != count; i++)
                    if (parent.Children[i] == currentView)
                        break;
                i++;

                if (i == count)
                    return NextView(parent, initialView);

                currentView = (parent.Children[i] as View);

                if (currentView == initialView)
                {
                    if (initialView is Layout)
                        throw (new ArgumentException(string.Empty, nameof(initialView)));
                    else
                        return currentView;
                }
            }

            while (currentView is Layout)
            {
                if ((currentView as Layout).Children.Count == 0)
                    return NextView(currentView, initialView);

                currentView = ((currentView as Layout).Children[0] as View);

                if (currentView == initialView)
                {
                    if (initialView is Layout)
                        throw (new ArgumentException(string.Empty, nameof(initialView)));
                    else
                        return currentView;
                }
            }

            return currentView;
        }
    }
}