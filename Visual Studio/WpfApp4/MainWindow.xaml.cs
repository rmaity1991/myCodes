using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApp4
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            textblock1.Text = "Hello From the Side of Code";
            textblock1.Foreground = Brushes.Red;
            textblock1.Background = Brushes.Green;

            TextBlock textblock2 = new TextBlock();

            textblock2.Text = "This is created from the code behind";
            textblock2.Foreground = Brushes.Green;
            textblock2.Background = Brushes.White;
            textblock2.FontSize = 50;
            textblock2.TextWrapping = TextWrapping.Wrap;

            textblock2.Inlines.Add("This is added Inline using Inlines Property");

            textblock2.Inlines.Add(new Run("This is added using Run Command")
            {
                FontSize = 30,
                Foreground = Brushes.Black
            }) ;
            this.Content = textblock2;
        }
    }
}
