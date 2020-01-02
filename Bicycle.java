public class Bicycle {
 
    int cadence = 0;
    int speed = 0;
    int gear = 1;

    Bicycle(int speed){
        this.speed = speed;
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
 
    void printStates() {
         System.out.println("cadence:" +
             cadence + " speed:" + 
             speed + " gear:" + gear);
    }
}

