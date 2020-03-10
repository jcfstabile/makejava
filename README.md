# makejava (valetudo)
Include a _makefile_ and a very little java project to test it. *makejava.mk* (and generated *makefile*) search for a _src_ directory for java files and *"java project dirs"*, auto configure internals of the _makefile_, if needed, (handled with a shebang to make utility) that permit to build the project classes, run the project and test it (JUnit5 Jupiter).

#### makejava.mk
A makefile that generate a _makefile_ in the current directory, to build a little java project with a work tree similar to eclipse's (_bin_, _src_, _tests_). Handle packages as needed. Also, using _tips_ or _imports_ rules (last one to redirect the output), print *imports* headers needed on test classes files to use junit jupiter platform. If nedded, download and install _junit jupiter platform standalone jar_ in local project tree.  

### Usage.
#### Generate _makefile_ by configuring it in current directoy.

`$ make -f /path/to/makejava/makejava.mk configure`

#### Build and test the project using the generated _makefile_.

Now use _make_ to: build, clear, run and test the project.

`$ make build`  
  or  
`$ make test`  
  or  
`$ make run`  

#### See tips to easily code junit jupiter platform test classes.

`$ make tips`

#### Dependencies.

_makejava valetuto_ depends on make and jdk (8). You can install thoses packages if needed, i.e.:

`# apt install make`  
`# apt install openjdk-8*`
