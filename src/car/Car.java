package car;

public class Car{
   int wheels = 4; 

   public void printStates() {
       System.out.println("Wheels: " + wheels);
   }

   public int getWheels(){
       return this.wheels;
   }
}
