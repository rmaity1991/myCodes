using System; 
using System.Windows; 
using System.Windows.Controls; 
 
namespace XAMLDockPanel { 
   /// <summary> 
      /// Interaction logic for Window1.xaml 
   /// </summary> 
	
   public partial class Window1 : Window { 
      public Window1() { 
         InitializeComponent(); 
      }
      private void Click_Me(object sender, RoutedEventArgs e) { 
         Button btn = sender as Button; 
         string str = btn.Content.ToString() + " button clicked" ; 
         MessageBox.Show(str); 
      } 
   }
}
