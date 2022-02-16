using System; 
using System.Windows; 
using System.Windows.Controls;

namespace XAMLDialog {
   /// <summary> 
      /// Interaction logic for MainWindow.xaml 
   /// </summary> 
	
   public partial class MainWindow : Window {
      public MainWindow() { 
         InitializeComponent(); 
      } 
      private void ShowMessageBox_Click(object sender, RoutedEventArgs e) { 
         string msgtext = "Click any button"; 
         string txt = "My Title"; 
         MessageBoxButton button = MessageBoxButton.YesNoCancel;
         MessageBoxResult result = MessageBox.Show(msgtext, txt, button);

         switch (result) { 
            case MessageBoxResult.Yes: 
               textBox1.Text = "Yes"; 
               break;
            case MessageBoxResult.No: 
               textBox1.Text = "No"; 
               break; 
            case MessageBoxResult.Cancel: 
               textBox1.Text = "Cancel"; 
               break; 
         }
      }
   }
}