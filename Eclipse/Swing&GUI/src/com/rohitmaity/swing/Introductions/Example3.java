package com.rohitmaity.swing.Introductions;
import javax.swing.*;

/*
 * We can also inherit the JFrame class, so there is no need to create the instance of JFrame class explicitly.
 */

public class Example3 extends JFrame {
	JFrame f;  
	Example3(){  
	JButton b=new JButton("click");//create button  
	b.setBounds(130,100,100, 40);  
	          
	add(b);//adding button on frame  
	setSize(400,500);  
	setLayout(null);  
	setVisible(true);  
	}  
	public static void main(String[] args) {  
	new Example3();  
	}

}
