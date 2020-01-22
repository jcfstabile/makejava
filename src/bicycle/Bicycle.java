package bicycle;

public class Bicycle {
 
    int cadence = 0;
    public int speed = 0;
    int gear = 1;

    public Bicycle(int seed){
        this.speed = seed;
    }
 
    void changeCadence(int newValue) {
         cadence = newValue;
    }
 
    void changeGear(int newValue) {
         gear = newValue;
    }
 
    void speedUp(int increment) {
         speed = speed + increment;   
    }
 
    void applyBrakes(int decrement) {
         speed = speed - decrement;
    }
 
    public void printStates() {
         System.out.println("cadence:" +
             cadence + " speed:" + 
             speed + " gear:" + gear);
    }
}

