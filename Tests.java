import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class Tests{
    @Test
    public void simpleTest(){
        int[] subject = {1,2,3};
        int[] expect  = {1,2,3};
        assertArrayEquals(expect, subject);
    }
    @Test
    public void failNotSoTest(){
        int[] subject = {1,2,3};
        int[] expect  = {1,2,3};
        assertArrayEquals(expect, subject);
    }

    @Test
    public void equals(){
        int subject = 10;
        int expect  = 10;
        assertEquals(subject, expect);
    }
}
