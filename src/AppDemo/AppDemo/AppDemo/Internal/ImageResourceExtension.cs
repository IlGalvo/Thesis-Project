using System;
using System.Reflection;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace AppDemo.Internal
{
    [ContentProperty(nameof(Source))]
    public class ImageResourceExtension : IMarkupExtension
    {
        private const string DefaultImagePath = ("AppDemo.Images.{0}.png");

        public string Source { get; set; }

        public object ProvideValue(IServiceProvider serviceProvider)
        {
            ImageSource imageSource = null;

            if (!string.IsNullOrEmpty(Source))
            {
                var assembly = typeof(ImageResourceExtension).GetTypeInfo().Assembly;

                imageSource = ImageSource.FromResource(string.Format(DefaultImagePath, Source), assembly);
            }

            return imageSource;
        }
    }
}