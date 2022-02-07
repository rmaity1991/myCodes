package Java.GUI;

import javax.swing.*;

class Example7 {
    public static void main(String args[]) {
        JFrame f = new JFrame("Label Example");
        JLabel l1, l2; // create two text labels
        l1 = new JLabel("First Label."); // construct the labes with values
        l1.setBounds(50, 50, 100, 30);
        l2 = new JLabel("Second Label."); // construct the labes with values
        l2.setBounds(50, 100, 100, 30);
        f.add(l1);
        f.add(l2);
        f.setSize(300, 300);
        f.setLayout(null);
        f.setVisible(true);
    }
}
