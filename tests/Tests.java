import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.Before;
import org.junit.Rule;
import org.junit.rules.TestName;

import bicycle.Bicycle;

class Test2{
    @Test
    public void prueba(){
        assertEquals(true, true);
    }
}
public class Tests{
    class dummy{
        public int id;
        dummy(int id){
            this.id = id;
        }
        @Override
        public boolean equals(Object other){
            return other == this || 
                   this.getClass() == other.getClass() &&
                   this.id == ((dummy) other).id;
        }
    }

    @Rule
    public TestName name = new TestName();

    @Before
    public void printName(){
        System.out.println(name.getMethodName());
    }

    @Test
    public void true_object_equals_identic_object(){
        dummy d1 = new dummy(1);
        dummy d2 = new dummy(1);
        assertEquals(true, d1.equals(d2));
    }

    @Test
    public void simpleTest(){
        int[] subject = {1,2,3};
        int[] expect  = {1,2,3};
        assertArrayEquals( expect, subject);
    }
    @Test
    public void bicycle_with_10_speed(){
        Bicycle byc = new Bicycle(10);
        assertEquals("bicycle had a speed of 10", byc.speed, 10);
    }

    @Test
    public void false_object_igual_igual_identic_object(){
        Bicycle b1 = new Bicycle(1);
        Bicycle b2 = new Bicycle(1);
        assertEquals(false, b1 == b2);
    }

    @Test
    public void equals_subject_igual_igual_reference_to_subject(){
        int subject = 10;
        int expect  = subject;
        assertEquals(true, subject == expect);
    }

    @Test
    public void equals_ref_to_10_igual_igual_another_ref_to_10(){
        int subject = 10;
        int expect  = 10;
        assertEquals(true, subject == expect);
    }
}
