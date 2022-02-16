
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;  
import org.openqa.selenium.chrome.ChromeDriver;

class Selenium{
	
}

public class SeleniumTesting {
	
	public static void main(String args[]) {
		
		// First set the property of System to find the chrome webdriver
		System.setProperty("webdriver.chrome.driver","D://chromedriver_win32//chromedriver.exe");
		
       // Create a new webdriver for application
		WebDriver driver=new ChromeDriver();
		
		// navigate to Web Page
		driver.navigate().to("http://127.0.0.1:5500/WebDevelopment/CSS/Example20.html");
		// Find Element of the search bar and send apple in it
		
		driver.findElement(By.id("london")).sendKeys("Rohit Maity");

				
		
	}

}
