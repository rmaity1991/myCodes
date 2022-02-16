using System; 
using System.Windows; 
using System.Windows.Controls;  

namespace XAMLEventHandling {
   /// <summary> 
      /// Interaction logic for MainWindow.xaml 
   /// </summary> 
	
   public partial class MainWindow : Window {
      public MainWindow() { 
         InitializeComponent(); 
      }
      private void OnClick(object sender, RoutedEventArgs e) { 
         MessageBox.Show("Button is clicked!"); 
      } 


      private void Bold_Checked(object sender, RoutedEventArgs e) { 
         textBox1.FontWeight = FontWeights.Bold; 
      }
      private void Bold_Unchecked(object sender, RoutedEventArgs e) { 
         textBox1.FontWeight = FontWeights.Normal; 
      }
      private void Italic_Checked(object sender, RoutedEventArgs e) { 
         textBox1.FontStyle = FontStyles.Italic; 
      }
      private void Italic_Unchecked(object sender, RoutedEventArgs e) { 
         textBox1.FontStyle = FontStyles.Normal; 
      }
      private void IncreaseFont_Click(object sender, RoutedEventArgs e) { 
         if (textBox1.FontSize < 18) { 
            textBox1.FontSize += 2; 
         } 
      }
      private void DecreaseFont_Click(object sender, RoutedEventArgs e) { 
         if (textBox1.FontSize > 10) { 
            textBox1.FontSize -= 2; 
         } 
   }
   }
}
