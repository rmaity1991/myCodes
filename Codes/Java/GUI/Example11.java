package Java.GUI;

import javax.swing.*;

public class Example11 {
    Example11() {
        JFrame f = new JFrame();
        JTextArea area = new JTextArea("Welcome to javatpoint");
        area.setBounds(10, 30, 200, 200);
        f.add(area);
        f.setSize(300, 300);
        f.setLayout(null);
        f.setVisible(true);
    }

    public static void main(String args[]) {
        new Example11();
    }
}