using AppDemo.Internal;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Xamarin.Forms;

namespace AppDemo.ViewModels
{
    public abstract class BaseViewModel : PageHelper, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public ICommand ActionCommand { get; private set; }

        public BaseViewModel()
        {
            ActionCommand = new Command(Action);
        }

        protected abstract void Action(object value);

        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}