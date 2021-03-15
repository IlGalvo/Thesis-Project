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

        private List<ConfidenceRule> confidenceRules;
        public List<ConfidenceRule> ConfidenceRules
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
                    HandleSelectedConfidenceRule();
                }
            }
        }

        public ICommand SearchCommand { get; private set; }
        public ICommand RefreshCommand { get; private set; }

        private List<ConfidenceRule> mainConfidenceRules;

        public CRListViewPageViewModel()
        {
            isRefreshing = false;

            mainConfidenceRules = new List<ConfidenceRule>();
            confidenceRules = null;

            selectedConfidenceRule = null;

            SearchCommand = new Command<string>(Search);
            RefreshCommand = new Command(Refresh);
        }

        private void Search(string seachFilter)
        {
            ConfidenceRules = mainConfidenceRules.Where(confidenceRule => confidenceRule.Name.StartsWith(seachFilter,
                StringComparison.InvariantCultureIgnoreCase)).ToList();
        }

        public async void Refresh()
        {
            IsRefreshing = true;

            try
            {
                var confidenceRules = await HttpRequestClient.Instance.GetConfidenceRulesAsync();

                if (!mainConfidenceRules.SequenceEqual(confidenceRules))
                {
                    ConfidenceRules = mainConfidenceRules = confidenceRules;
                }
            }
            catch (Exception exception)
            {
                IsRefreshing = false;

                await DisplayDialogAsync("Error", exception.Message, "Close");

                Refresh();
            }

            IsRefreshing = false;
        }

        protected override async void Action(object value)
        {
            await Navigation.PushAsync(new AddPage());
        }

        private async void HandleSelectedConfidenceRule()
        {
            await Navigation.PushAsync(new CRPage(SelectedConfidenceRule));

            SelectedConfidenceRule = null;
        }
    }
}