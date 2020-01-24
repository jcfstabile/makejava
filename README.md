# makejava
Include a script to generate a _makefile_ and a very little java project to test it. *makejava* search for a _src_ directory for java files and project dirs and generate a _makefile_ (later handled with make utility) that permit to build the project classes, run the project and test it (JUnit4) 

#### makejava.mk  
make script to generate a _makefile_ that build a little java prj  with work tree similar to eclipse's .

### Usage:
#### Generate _makefile_ running:

- Run   
`$ ./makejava.mk auto`

- Now use _make_ to: build, clear, run and test the project. ie  
`$ make build`  
  or  
`$ make test`  

- If you added _java_ files to your project, to generate a new _makefile_, just:  
`$ make auto` 
- So on, keep working your project with _build_ (default),  _test_ or _run_.
