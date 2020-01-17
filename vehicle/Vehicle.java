package vehicle;

class Vehicle{
    public static void main(String[] args) {
        Bicycle bici = new Bicycle(1);
        Car car = new Car();
        System.out.println("Hello Vehicles! "); // Display the string.
        bici.printStates();
        car.printStates();
    }
}
