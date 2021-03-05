using AppDemo.Internal;
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
        private bool isRefreshing;
        public bool IsRefreshing
        {
            get { return isRefreshing; }
            set
            {
                isRefreshing = value;
                OnPropertyChanged();
            }
        }

        private IEnumerable<ConfidenceRule> confidenceRules;
        public IEnumerable<ConfidenceRule> ConfidenceRules
        {
            get { return confidenceRules; }
            set
            {
                confidenceRules = value;
                OnPropertyChanged();
            }
        }

        private ConfidenceRule selectedConfidenceRule;
        public ConfidenceRule SelectedConfidenceRule
        {
            get { return selectedConfidenceRule; }
            set
            {
                selectedConfidenceRule = value;
                OnPropertyChanged();

                if (selectedConfidenceRule != null)
                {
                    ManageSelectedConfidenceRule();
                }
            }
        }

        public ICommand SearchCommand { get; private set; }
        public ICommand RefreshCommand { get; private set; }

        private IEnumerable<ConfidenceRule> mainConfidenceRules;

        public CRListViewPageViewModel()
        {
            mainConfidenceRules = new List<ConfidenceRule>();
            confidenceRules = null;

            selectedConfidenceRule = null;

            SearchCommand = new Command<string>(Search);
            RefreshCommand = new Command(Refresh);
        }

        private void Search(string seachFilter)
        {
            ConfidenceRules = mainConfidenceRules.Where(confidenceRule => confidenceRule.Name.StartsWith(seachFilter,
                StringComparison.InvariantCultureIgnoreCase));
        }

        public async void Refresh()
        {
            IsRefreshing = true;

            try
            {
                var confidenceRules = await HttpRequestClient.Instance.GetConfidenceRulesAsync();

                ConfidenceRules = mainConfidenceRules = confidenceRules;
            }
            catch (Exception exception)
            {
                await CurrentPage.DisplayAlert("Error", exception.Message, "Close");
            }

            IsRefreshing = false;
        }

        protected override async void Action(object value)
        {
            await CurrentPage.Navigation.PushAsync(new AddPage());
        }

        private async void ManageSelectedConfidenceRule()
        {
            await CurrentPage.Navigation.PushAsync(new CRPage(SelectedConfidenceRule));

            SelectedConfidenceRule = null;
        }
    }
}