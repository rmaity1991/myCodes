using System; 
using System.Windows; 
using System.Windows.Controls; 
using System.Windows.Media;

namespace XAMLCalendar { 
   /// <summary> 
      /// Interaction logic for MainWindow.xaml 
   /// </summary> 
   public partial class MainWindow : Window { 
      public MainWindow() { 
         InitializeComponent(); 
      } 
      private void Calendar_SelectedDatesChanged(object sender, SelectionChangedEventArgs e) { 
         var calendar = sender as Calendar;  
			
         // ... See if a date is selected.
         if (calendar.SelectedDate.HasValue) { 
            // ... Display SelectedDate in Title. 
            DateTime date = calendar.SelectedDate.Value; 
            this.Title = date.ToShortDateString(); 
         } 
      }  
   } 
}