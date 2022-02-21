package JavaProgramming.ObjectClass;

/*
 * The object cloning is a way to create exact copy of an object. The clone()
 * method of Object class is used to clone an object.
 * 
 * The java.lang.Cloneable interface must be implemented by the class whose
 * object clone we want to create. If we don't implement Cloneable interface,
 * clone() method generates CloneNotSupportedException.
 * 
 * The clone() method is defined in the Object class. Syntax of the clone()
 * method is as follows:
 */
class Student18 implements Cloneable {
    int rollno;
    String name;

    Student18(int rollno, String name) {
        this.rollno = rollno;
        this.name = name;
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    public static void main(String args[]) {
        try {
            Student18 s1 = new Student18(101, "amit");

            Student18 s2 = (Student18) s1.clone();

            System.out.println(s1.rollno + " " + s1.name);
            System.out.println(s2.rollno + " " + s2.name);

        } catch (CloneNotSupportedException c) {
        }

    }
}