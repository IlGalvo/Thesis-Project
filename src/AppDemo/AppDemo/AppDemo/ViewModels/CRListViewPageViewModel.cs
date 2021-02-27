using AppDemo.Internal;
using AppDemo.Models;
using AppDemo.Views;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public class CRListViewPageViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private IEnumerable<ConfidenceRule> accountList;
        public IEnumerable<ConfidenceRule> AccountList
        {
            get { return accountList; }
            set
            {
                accountList = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(AccountList)));
            }
        }

        private ConfidenceRule selectedAccount;
        public ConfidenceRule SelectedAccount
        {
            get { return selectedAccount; }
            set
            {
                selectedAccount = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedAccount)));

                if (selectedAccount != null)
                {
                    ManageSelectedConfidenceRule();
                }
            }
        }

        public ICommand SearchCommand { get; private set; }
        public ICommand AddCommand { get; private set; }

        private IEnumerable<ConfidenceRule> mainAccountList;

        public CRListViewPageViewModel()
        {
            mainAccountList = new List<ConfidenceRule>();
            accountList = null;

            selectedAccount = null;

            SearchCommand = new Command<string>(Search);
            AddCommand = new Command(Add);
        }

        public void Update(IEnumerable<ConfidenceRule> accountList)
        {
            AccountList = mainAccountList = accountList;
        }

        private void Search(string seachFilter)
        {
            AccountList = mainAccountList.Where(cr => cr.Name.StartsWith(seachFilter, StringComparison.InvariantCultureIgnoreCase));
        }

        private async void Add()
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