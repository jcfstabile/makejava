import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.Before;
import org.junit.Rule;
import org.junit.rules.TestName;

import bicycle.Bicycle;

public class Tests{
    @Rule
    public TestName name = new TestName();

    @Before
    public void printName(){
        System.out.println(name.getMethodName());
    }
    @Test
    public void simpleTest(){
        int[] subject = {1,2,3};
        int[] expect  = {1,2,3};
        assertArrayEquals(expect, subject);
    }
    @Test
    public void bicycle_with_10_speed(){
        Bicycle byc = new Bicycle(10);
        assertEquals("bicycle had a speed of 10", byc.speed, 10);
    }

    @Test
    public void equals(){
        int subject = 10;
        int expect  = 10;
        assertEquals(subject, expect);
    }
}
