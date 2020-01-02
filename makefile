.SUFFIXES: .java .class

sources = Bicycle.java HelloWorldApp.java

HelloWorldApp.class : HelloWorldApp.java Bicycle.class
	javac HelloWorldApp.java

%.class : %.java
	javac $<

clean:
	rm *.class

#.class: Bicycle.java HelloWorldApp.java  
