using System;  
using System.Collections.Generic;  
using System. Linq;  
using System. Text;  
using System.Threading.Tasks;  
  
namespace UserDefinedConversion  
{  
    class Program  
    {  
  
        public struct ImperialMeasurement  
        {  
            public float feet;  
            public ImperialMeasurement(float r)  
            {  
                this.feet = r;  
            }  
            public static explicit operator ImperialMeasurement(int m)  
            {  
                float ConversionResult = 3.28f * m;  
                ImperialMeasurement temp = new ImperialMeasurement(ConversionResult);  
                return temp;  
            }  
        }  
        static void Main(string[] args)  
        {  
            Console.WriteLine("Please enter a whole number measurement in meters");  
            int nm = Convert.ToInt32(Console.ReadLine());  
            ImperialMeasurement im = (ImperialMeasurement)nm;  
            Console.WriteLine($"The measument of {nm} in meters is {im.feet} in feet ");  
            Console.ReadKey();  
        }  
    }  
      
      
}  