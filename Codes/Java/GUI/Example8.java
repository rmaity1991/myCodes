package Java.GUI;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Example8 extends Frame implements ActionListener {
    JTextField tf;
    JLabel l;
    JButton b;

    Example8() {
        tf = new JTextField(); // creating a text fild
        tf.setBounds(50, 50, 150, 20);
        l = new JLabel(); // create a label
        l.setBounds(50, 100, 250, 20);
        b = new JButton("Find IP"); // creating a button
        b.setBounds(50, 150, 95, 30);
        b.addActionListener(this);
        add(b);
        add(tf);
        add(l);
        setSize(400, 400);
        setLayout(null);
        setVisible(true);
    }

    public void actionPerformed(ActionEvent e) {
        try {
            String host = tf.getText();
            String ip = java.net.InetAddress.getByName(host).getHostAddress();
            l.setText("IP of " + host + " is: " + ip);
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public static void main(String[] args) {
        new Example8();
    }
}
