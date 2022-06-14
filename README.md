# makejava (valetudo)
Include a _makefile_ and a very little java project to test it. *makejava.mk* (and generated *makefile*) search for a _src_ directory for java files and *"java project dirs"*, auto configure internals of the _makefile_, if needed, (handled with a shebang to make utility) that permit to build the project classes, run the project and test it (JUnit5 Jupiter).

#### makejava.mk
A makefile that generate a _makefile_ in the current directory, included, build a little java project with a work tree similar to eclipse's (_bin_, _src_, _test_). Handle packages as needed. Also, using _tips_ or _imports_ rules (last one to redirect the output), print *imports* headers needed on test classes files to use junit jupiter platform. If nedded, download and install _junit jupiter platform standalone jar_ in local project tree.  

### Usage.
#### Generate raw autoconfigured _makefile_ on current directory.

`$ make -f /path/to/makejava/makejava.mk raw`

#### Or by configuring test and mock resources in current directory.

`$ make -f /path/to/makejava/makejava.mk configure`


#### Build and test the project using the generated _makefile_.

Now use _make_ to: build, clear, run and test the project.

`$ make build`  
  or  
`$ make test`  
  or  
`$ make run`  


### Handy Features.

#### See tips to easily code junit jupiter platform test classes.

`$ make tips`

##### Create class esqueletons. Interface and JUnit test classes.

Observe that arguments go before call _make_ but (i.e.) _class_ command go after.

`$ classname=Dog packagename=ar.edu.unq.animals make class`

will create `src/ar/edu/unq/animals/Dog.java` file.

`$ classname=CatTest packagename=ar.edu.unq.animals make testclass`

will create `test/ar/edu/unq/animals/CatTest.java` file.

`$ interfacename=IMammal packagename=ar.edu.unq.animals make interface`

will create `src/ar/edu/unq/animals/IMammal.java` file.

#### Dependencies.

_makejava valetuto_ depends on make and jdk (ie 8/14). You can install thoses packages if needed, i.e.:

`# apt install make`  
`# apt install openjdk-8*` or `# apt install openjdk-14*`
