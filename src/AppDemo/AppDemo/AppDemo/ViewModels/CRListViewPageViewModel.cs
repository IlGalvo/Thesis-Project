using AppDemo.Models;
using AppDemo.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class CRListViewPageViewModel : BaseViewModel
    {
        private IEnumerable<ConfidenceRule> accountList;
        public IEnumerable<ConfidenceRule> AccountList
        {
            get { return accountList; }
            set
            {
                accountList = value;
                OnPropertyChanged();
            }
        }

        private ConfidenceRule selectedAccount;
        public ConfidenceRule SelectedAccount
        {
            get { return selectedAccount; }
            set
            {
                selectedAccount = value;
                OnPropertyChanged();

                if (selectedAccount != null)
                {
                    ManageSelectedConfidenceRule();
                }
            }
        }

        public ICommand SearchCommand { get; private set; }

        private IEnumerable<ConfidenceRule> mainAccountList;

        public CRListViewPageViewModel()
        {
            mainAccountList = new List<ConfidenceRule>();
            accountList = null;

            selectedAccount = null;

            SearchCommand = new Command<string>(Search);
        }

        public void Update(IEnumerable<ConfidenceRule> accountList)
        {
            AccountList = mainAccountList = accountList;
        }

        private void Search(string seachFilter)
        {
            AccountList = mainAccountList.Where(cr => cr.Name.StartsWith(seachFilter, StringComparison.InvariantCultureIgnoreCase));
        }

        protected override async void Action(object value)
        {
            await CurrentPage.Navigation.PushAsync(new AddPage());
        }

        private async void ManageSelectedConfidenceRule()
        {
            await CurrentPage.Navigation.PushAsync(new CRPage(SelectedAccount));

            SelectedAccount = null;
        }
    }
}