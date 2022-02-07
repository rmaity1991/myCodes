package Java.GUI;

import java.awt.event.*;
import javax.swing.*;

public class Example5 {
    public static void main(String[] args) {
        JFrame f = new JFrame("Button Example"); // Here we create a Jframe and name it as button example
        final JTextField tf = new JTextField(); // Here we create a text field
        tf.setBounds(50, 50, 150, 20); // we set the bounds of the text field
        JButton b = new JButton("Click Here"); // creating abutton called chick here
        b.setBounds(50, 100, 95, 30); // setting its bounds
        b.addActionListener(new ActionListener() { // using button to create a action listener so that on click
            public void actionPerformed(ActionEvent e) {
                tf.setText("Welcome to Javatpoint."); // it sets the text field to a value
            }
        });
        f.add(b); // add button to frame
        f.add(tf); // add text field to frame
        f.setSize(400, 400); // set the size of the frame
        f.setLayout(null); // no layouts
        f.setVisible(true); // make it visible
    }
}
