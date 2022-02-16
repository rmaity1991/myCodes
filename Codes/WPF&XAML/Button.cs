using System; 
using System.Windows; 
using System.Windows.Controls; 
using System.Windows.Media;  

namespace XAMLButton { 
   /// <summary> 
      /// Interaction logic for MainWindow.xaml 
   /// </summary>
	public partial class MainWindow : Window {
      public MainWindow() { 
         InitializeComponent(); 
      }  
      void OnClick1(object sender, RoutedEventArgs e) { 
         button1.Foreground = new SolidColorBrush(Colors.Blue); 
         MessageBox.Show("On Hover click event occurs."); 
      } 
      void OnClick2(object sender, RoutedEventArgs e) { 
         button2.Foreground = new SolidColorBrush(Colors.Green); 
         MessageBox.Show("On Press click event occurs."); 
      } 
      void OnClick3(object sender, RoutedEventArgs e) { 
         button1.Foreground = new SolidColorBrush(Colors.Green); 
         button2.Foreground = new SolidColorBrush(Colors.Blue); 
         MessageBox.Show("On Release click event occurs."); 
      }
   } 
}