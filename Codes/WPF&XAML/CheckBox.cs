using System; 
using System.Windows; 
using System.Windows.Controls; 
using System.Windows.Media;

namespace XAMLCheckBox {
   /// <summary> 
      /// Interaction logic for MainWindow.xaml 
   /// </summary>
	public partial class MainWindow : Window { 
      public MainWindow() { 
         InitializeComponent(); 
      }  
      private void HandleCheck(object sender, RoutedEventArgs e) {
         CheckBox cb = sender as CheckBox; 
			
         if (cb.Name == "cb1") {
            text1.Text = "2 state CheckBox is checked.";
         } else {
            text2.Text = "3 state CheckBox is checked."; 
         }	
      }
      private void HandleUnchecked(object sender, RoutedEventArgs e) {
         CheckBox cb = sender as CheckBox; 
			
         if (cb.Name == "cb1") {
            text1.Text = "2 state CheckBox is unchecked."; 
         } else {
            text2.Text = "3 state CheckBox is unchecked."; 
         }
      } 
      private void HandleThirdState(object sender, RoutedEventArgs e) {
         CheckBox cb = sender as CheckBox; 
         text2.Text = "3 state CheckBox is in indeterminate state."; 
      }
   } 
} 