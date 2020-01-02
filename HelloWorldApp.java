class HelloWorldApp {
    public static void main(String[] args) {
        Bicycle bici = new Bicycle(1);
        Car car = new Car();
        System.out.println("Hello World! "); // Display the string.
        bici.printStates();
        car.printStates();
    }
}
