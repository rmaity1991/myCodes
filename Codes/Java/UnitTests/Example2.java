package Java.UnitTests;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

import org.junit.Assert;

public class Example2 {

    @Test
    public static void main() {
        Example1 x = new Example1();

        assertEquals(4, x.add(2, 3));

    }

}
