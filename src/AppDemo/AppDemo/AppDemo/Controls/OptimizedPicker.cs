using AppDemo.Internal;
using System;
using Xamarin.Forms;

namespace AppDemo.Controls
{
    public class OptimizedPicker : Picker
    {
        public static readonly BindableProperty DefaultItemProperty =
            BindableProperty.Create(nameof(DefaultItem), typeof(object), typeof(OptimizedPicker), null, propertyChanged: OnDefaultItemChanged);

        public object DefaultItem
        {
            get { return GetValue(DefaultItemProperty); }
            set { SetValue(DefaultItemProperty, value); }
        }

        public static readonly BindableProperty ReturnTypeProperty =
            BindableProperty.Create(nameof(ReturnType), typeof(ReturnType), typeof(OptimizedPicker), ReturnType.Default);

        public ReturnType ReturnType
        {
            get { return ((ReturnType)GetValue(ReturnTypeProperty)); }
            set { SetValue(ReturnTypeProperty, value); }
        }

        public OptimizedPicker()
        {
            SelectedIndexChanged += OptimizedPicker_SelectedIndexChanged;
        }

        protected override void OnPropertyChanged(string propertyName)
        {
            if (propertyName == ItemsSourceProperty.PropertyName)
            {
                OnDefaultItemChanged(this, DefaultItem, DefaultItem);
            }

            base.OnPropertyChanged(propertyName);
        }

        private void OptimizedPicker_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (SelectedItem != null)
            {
                if (SelectedItem == DefaultItem)
                {
                    SelectedItem = null;
                }

                if (ReturnType == ReturnType.Next)
                {
                    PageHelper.FocusNextView(this);
                }
            }
        }

        private static void OnDefaultItemChanged(BindableObject bindable, object oldValue, object newValue)
        {
            var optimizedPicker = ((OptimizedPicker)bindable);

            if (optimizedPicker.ItemsSource != null)
            {
                if (oldValue != null)
                {
                    optimizedPicker.ItemsSource.Remove(oldValue);
                }

                if ((newValue != null) && (optimizedPicker.ItemsSource.Count == 0))
                {
                    optimizedPicker.ItemsSource.Add(newValue);
                }
            }
        }
    }
}