import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

public class Example1 {

    public static void main(String[] args){
        String str;

        try{
            BufferedReader br= new BufferedReader(new InputStreamReader(System.in));

            str=br.readLine();

            File f;
            f=new File((str));

            if(f.exists()){
                String dname=f.getParent();
            }
        }
    }

}
