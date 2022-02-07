package Java.GUI;

import javax.swing.*;
import java.awt.event.*;

public class Example10 implements ActionListener {
    JTextField tf1, tf2, tf3;
    JButton b1, b2;

    Example10() {
        JFrame f = new JFrame(); // create a frame
        tf1 = new JTextField(); // create a text field
        tf1.setBounds(50, 50, 150, 20);
        tf2 = new JTextField();// create a text field
        tf2.setBounds(50, 100, 150, 20);
        tf3 = new JTextField();// create a text field
        tf3.setBounds(50, 150, 150, 20);
        tf3.setEditable(false);
        b1 = new JButton("+"); // create a button
        b1.setBounds(50, 200, 50, 50);
        b2 = new JButton("-");// create a button
        b2.setBounds(120, 200, 50, 50);
        b1.addActionListener(this); // adds a action listener to the "this" button.
        b2.addActionListener(this);
        f.add(tf1);
        f.add(tf2);
        f.add(tf3);
        f.add(b1);
        f.add(b2);
        f.setSize(300, 300);
        f.setLayout(null);
        f.setVisible(true);
    }

    public void actionPerformed(ActionEvent e) {
        String s1 = tf1.getText();
        String s2 = tf2.getText();
        int a = Integer.parseInt(s1);
        int b = Integer.parseInt(s2);
        int c = 0;
        if (e.getSource() == b1) {
            c = a + b;
        } else if (e.getSource() == b2) {
            c = a - b;
        }
        String result = String.valueOf(c);
        tf3.setText(result);
    }

    public static void main(String[] args) {
        new Example10();
    }
}
