# Evooq DevOps Code Challenge (DOCC) SOLUTION

The exercise consists of two parts.
  1. Shell challenge implementation
  2. Implementation of the configuration transformation challenge.

## 1 - Shell Challenge

### Abstract
The following solution was implemented as "BASHy" as possible in order to maintain best practices for the given language. According to the guidelines it implements two scripts that take the same input. 
- Script number 1 prints the output to the screen. 
- Script number 2 increments numbers inside files.  

### Assumptions
The following assumptions where made when designing the solution:
- Only one argument will be taken in as a flag.
- Only a value of type integer is allowed as an input and is checked accordingly
- For script number 2 a results directory is created to host the files. This was done to have a more tidy working/testing environment.


### Running Script number 1:

The shell challenge does not require any special extras to run.     
From the project root directory of the project execute the below command:
```
$: ./sh_1.sh <INTEGER_VALUE>
```
Below are example scenarios of a specific input that yield a respective output.

* Normal Input 1:
```sh
$: ./sh_1.sh 1114
PTFPTFPTFACC
```

* Normal Input 2:
```sh
$: ./sh_1.sh 1113574
BNDPTFPTFPTFACC
```

* Improper input 1: It will spot the first non-number char and exit the script
```sh
$: ./sh_1.sh 111y4
Given argument contains illegal char 'y'
Argument must contains integer only
usage: sh_1.sh 1113574
```

* Improper input 2: In case we provide more than one command line arguments the script will fail
```sh
$: ./sh_1.sh 1113574 879 5757
Expected only 1 argument but 3 given
usage: sh_1.sh 1113574
```



### Running Script number 2:
From the project root directory of the project.
* Normal input 1:
```sh
$: ./sh_2.sh 1114
$: ll results/
total 8
-rw-rw-r--. 1 user user 2 Nov 28 22:28 ACC
-rw-rw-r--. 1 user user 2 Nov 28 22:28 PTF
$: find results/ -type f -print -exec cat {} \;
results/ACC
1
results/PTF
3
```

* Normal input 2:
```sh
$: ./sh_2.sh 555
$: ll results/
total 12
-rw-rw-r--. 1 user user 2 Nov 28 22:28 ACC
-rw-rw-r--. 1 user user 2 Nov 28 22:31 ACT
-rw-rw-r--. 1 user user 2 Nov 28 22:28 PTF
$: find results/ -type f -print -exec cat {} \;
results/ACT
1
results/ACC
1
results/PTF
3
```

* Normal input 3:
```sh
$: ./sh_2.sh 777
$: ./sh_2.sh 9999
$: ./sh_2.sh 1113574
$ ll results/
total 20
-rw-rw-r--. 1 user user 2 Nov 28 22:32 ACC
-rw-rw-r--. 1 user user 2 Nov 28 22:31 ACT
-rw-rw-r--. 1 user user 2 Nov 28 22:32 BND
-rw-rw-r--. 1 user user 2 Nov 28 22:32 CRYPT
-rw-rw-r--. 1 user user 2 Nov 28 22:32 PTF
$ find results/ -type f -print -exec cat {} \;
results/CRYPT
1
results/BND
2
results/ACT
1
results/ACC
2
results/PTF
6
```

* Improper input 1: It will spot the first non-number char and exit the script
```sh
$: ./sh_2.sh 178u4
Given argument contains illegal char 'u'
Argument must contains integer onlyusage: sh_2.sh 1113574
```

* Improper input 2: In case we provide more than one command line arguments the script will fail
```sh
$: ./sh_2.sh 1784 93029 47 23
Expected only 1 argument but 4 given
usage: sh_2.sh 1113574
```





## 2 - Configuration Transformation

### Abstract
The configuration transformation is based on the given incomplete script.  
It was modified to be standalone script to solve the first subtask.   
For the second subtask it was converted to a helper file.  
This provide a cleaner implementaion of the webserver. The webserver is based on Python's Bottle server pip package.     
The third subtask focuses on re-usability and distribution, and utilizes Docker to create an image that can be easily deployed and execute the code with minimal environment configurations.

### Assumptions
- The Bottle server was used because it is very light weight and easy to setup.     
- The server has not been tested how efficiently it can process large files or high bandwidth of requests.    
- A python virtualenv was used to run both subtasks. `jq` utility is used to format properly the `json` output.     
- The scripts were not tested with faulty `yaml` files.     
- Regarding subtask number three we assume that Docker is already installed to the machine.   

### Subtask 1 environment setup   
#### Virtualenv
At a directory of your choice you have to run the following commands. These commands will make it possible to run both subtasks.

* Creating the venv:
```sh
$: pwd
/tmp/

$: virtualenv venv
created virtual environment CPython3.10.0.final.0-64 in 183ms
  creator CPython3Posix(dest=/tmp/venv, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(extra_search_dir=/usr/share/python-wheels,download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=/home/thanosgkara/.local/share/virtualenv)
    added seed packages: pip==21.2.3, setuptools==57.4.0, wheel==0.36.2
  activators BashActivator,CShellActivator,FishActivator,NushellActivator,PowerShellActivator,PythonActivator

$: # Activate the env
$: source /tmp/venv/bin/activate

$: # Intall the packages
$: pip install bottle PyYaml                                                              
Collecting bottle
  Using cached bottle-0.12.19-py3-none-any.whl (89 kB)
Collecting PyYaml
  Using cached PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (682 kB)
Installing collected packages: PyYaml, bottle
Successfully installed PyYaml-6.0 bottle-0.12.19
```

### Running subtask 1
By having activated the previous venv now we can feed the script of subtask 1 a yaml file via stdin ( using a pipe | ).      
Following we show how it works. We will use the provided yaml file a small change.

```sh
$: cat sample-input.yaml| python config_transformation_1/config_reshape.py | jq 
{
  "foo.host": "example.com",
  "foo.visitor.compatibility": 4.2,
  "foo.visitor.timeout[s]": 180,
  "foo.visitor.enforce_strict": true,
  "foo.target.system": "plan9",
  "foo.target.fans": "huge",
  "foo.ranches.oldmacdonald.hectares": 9,
  "foo.ranches.oldmacdonald.chickens": 21,
  "foo.ranches.oldmacdonald.pigs": 1,
  "foo.ranches.oldmacdonald.cows": 7,
  "foo.ranches.animalfarm.hectares": 20,
  "foo.ranches.animalfarm.pigs": 49,
  "foo.ranches.animalfarm.rats": 2,
  "foo.ranches.animalfarm.humans": -1,
  "foo.ranches.animalfarm.cows": 2,
  "connector.baz.mode": "visitor",
  "connector.baz.rate": "full"
}
```

### Running subtask 2
To run subtask 2 again the `venv` must be activated as it uses the bottle server as well as the PyYaml libs to operate.      
We start by first starting the server, and then wait for incoming requests.         
The `yaml` file is provided as a `POST` request's binary payload according the subtasks instructions.

* First we run our server
```sh
$: python config_transformation_2/transform_server.py
Bottle v0.12.19 server starting up (using WSGIRefServer())...
Listening on http://0.0.0.0:8000/
Hit Ctrl-C to quit.

```

* Next ( from another terminal window ) we send our `POST` request ( here we use `curl` ) to the server and get the output.
```sh
$: curl -s -X POST http://localhost:8000/transform -H 'cache-control: no-cache' -H "Content-type: text/x-yaml" --data-binary @sample-input.yaml | jq
{
  "foo.host": "example.com",
  "foo.visitor.compatibility": 4.2,
  "foo.visitor.timeout[s]": 180,
  "foo.visitor.enforce_strict": true,
  "foo.target.system": "plan9",
  "foo.target.fans": "huge",
  "foo.ranches.oldmacdonald.hectares": 9,
  "foo.ranches.oldmacdonald.chickens": 21,
  "foo.ranches.oldmacdonald.pigs": 1,
  "foo.ranches.oldmacdonald.cows": 7,
  "foo.ranches.animalfarm.hectares": 20,
  "foo.ranches.animalfarm.pigs": 49,
  "foo.ranches.animalfarm.rats": 2,
  "foo.ranches.animalfarm.humans": -1,
  "foo.ranches.animalfarm.cows": 2,
  "connector.baz.mode": "visitor",
  "connector.baz.rate": "full"
}
```

* Servers output shows us the request
```sh
$: python config_transformation_2/transform_server.py
Bottle v0.12.19 server starting up (using WSGIRefServer())...
Listening on http://0.0.0.0:8000/
Hit Ctrl-C to quit.

127.0.0.1 - - [28/Nov/2021 23:17:49] "POST /transform HTTP/1.1" 200 580

```

### Running subtask 3
Using Docker a container image can be build utilizing the Dockerfile under the project root.                 
Once the image is ready we can create a container from this image that will run our small server application.        
Using the same ( `curl` ) command as the previous subtask we can verify that out application behaves the same.      

#### Building the docker image
The following command creates a container image which includes transformation application.      
From the project root run the following command:

```sh
$: docker build -t transformserver:v0.0.1 .

Sending build context to Docker daemon  245.2kB
Step 1/6 : FROM docker.io/library/alpine:3.15
3.15: Pulling from library/alpine
59bf1c3509f3: Pull complete 
Digest: sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300
Status: Downloaded newer image for alpine:3.15
 ---> c059bfaa849c
Step 2/6 : RUN apk --no-progress update && apk --no-progress upgrade --available && sync &&     apk add python3 &&     /usr/bin/python3 -m ensurepip --upgrade &&     /usr/bin/python3 -m pip install --upgrade pip &&     /usr/bin/pip3 install bottle PyYaml &&     mkdir -p /opt/transform &&     adduser -h /opt/transform -D -u 1001 transform &&     chmod -R u+rwx /opt/transform
 ---> Running in 9067ea83cb79
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/community/x86_64/APKINDEX.tar.gz
v3.15.0-30-gc02a1463bb [https://dl-cdn.alpinelinux.org/alpine/v3.15/main]
v3.15.0-31-g71f3611df9 [https://dl-cdn.alpinelinux.org/alpine/v3.15/community]
OK: 15829 distinct packages available
OK: 6 MiB in 14 packages
(1/13) Installing libbz2 (1.0.8-r1)
(2/13) Installing expat (2.4.1-r0)
(3/13) Installing libffi (3.4.2-r1)
(4/13) Installing gdbm (1.22-r0)
(5/13) Installing xz-libs (5.2.5-r0)
(6/13) Installing libgcc (10.3.1_git20211027-r0)
(7/13) Installing libstdc++ (10.3.1_git20211027-r0)
(8/13) Installing mpdecimal (2.5.1-r1)
(9/13) Installing ncurses-terminfo-base (6.3_p20211120-r0)
(10/13) Installing ncurses-libs (6.3_p20211120-r0)
(11/13) Installing readline (8.1.1-r0)
(12/13) Installing sqlite-libs (3.36.0-r0)
(13/13) Installing python3 (3.9.7-r4)
Executing busybox-1.34.1-r3.trigger
OK: 56 MiB in 27 packages
Looking in links: /tmp/tmpt1wl4pwd
Processing /tmp/tmpt1wl4pwd/setuptools-57.4.0-py3-none-any.whl
Processing /tmp/tmpt1wl4pwd/pip-21.2.3-py3-none-any.whl
Installing collected packages: setuptools, pip
Successfully installed pip-21.2.3 setuptools-57.4.0
Requirement already satisfied: pip in /usr/lib/python3.9/site-packages (21.2.3)
Collecting pip
  Downloading pip-21.3.1-py3-none-any.whl (1.7 MB)
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 21.2.3
    Uninstalling pip-21.2.3:
      Successfully uninstalled pip-21.2.3
Successfully installed pip-21.3.1
Collecting bottle
  Downloading bottle-0.12.19-py3-none-any.whl (89 kB)
Collecting PyYaml
  Downloading PyYAML-6.0.tar.gz (124 kB)
  Installing build dependencies: started
  Installing build dependencies: finished with status 'done'
  Getting requirements to build wheel: started
  Getting requirements to build wheel: finished with status 'done'
  Preparing metadata (pyproject.toml): started
  Preparing metadata (pyproject.toml): finished with status 'done'
Building wheels for collected packages: PyYaml
  Building wheel for PyYaml (pyproject.toml): started
  Building wheel for PyYaml (pyproject.toml): finished with status 'done'
  Created wheel for PyYaml: filename=PyYAML-6.0-cp39-cp39-linux_x86_64.whl size=45331 sha256=f2f1db0dcb479446e832e07712440666f0f95a787ed929549dc9b80be19f4e47
  Stored in directory: /root/.cache/pip/wheels/b4/0f/9a/d6af48581dda678920fccfb734f5d9f827c6ed5b4074c7eda8
Successfully built PyYaml
Installing collected packages: PyYaml, bottle
Successfully installed PyYaml-6.0 bottle-0.12.19
Removing intermediate container 9067ea83cb79
 ---> 4e878ff8aaab
Step 3/6 : COPY config_transformation_2/*.py /opt/transform/
 ---> c68f353750b0
Step 4/6 : EXPOSE 8000
 ---> Running in 5f46983dca9e
Removing intermediate container 5f46983dca9e
 ---> 6ceb8663ccf9
Step 5/6 : USER transform
 ---> Running in 0dcd80e655cd
Removing intermediate container 0dcd80e655cd
 ---> 087634bc40e0
Step 6/6 : ENTRYPOINT ["/usr/bin/python3", "-u", "/opt/transform/transform_server.py"]
 ---> Running in 177a825d2283
Removing intermediate container 177a825d2283
 ---> 77799d2cc22d
Successfully built 77799d2cc22d
Successfully tagged transformserver:v0.0.1
```

#### Verifying the image build
We can verify the image is successfully created by checking the local docker images.         
The `transformserver` image should there after the build completion with a tag of `v0.0.1`. 
Note that the base image of `alpine` tag `3.15` is also there. This was the base Linux image that was used in order to build ours.     
```sh
$: docker images
REPOSITORY        TAG                 IMAGE ID       CREATED         SIZE
transformserver   v0.0.1              77799d2cc22d   2 minutes ago   72.9MB
alpine            3.15                c059bfaa849c   4 minutes ago   5.59MB
```

#### Starting the webserver container
Next the container will be started in order to proccess incoming requests.
We do this using the following command:
```sh
$: docker run --rm -d -p 8000:8000 --name transformserver transformserver:v0.0.1
7aa3091121753274a7426dc7a9881e74cdf7f83efb924c0a4d6cc89980d132d3
```
It will expose the containers port 8000 to ours machines port 8000.     
This way is like we run the application as previously with no change.       

#### Webserver health check
Now we verify that our server actually runs. 
We first check for a running container.     
As we can see machines port 8000 is passed ( `->` ) to the container's port 8000.
```sh
$: docker ps -a
CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS         PORTS                                       NAMES
7aa309112175   transformserver:v0.0.1   "/usr/bin/python3 -u…"   7 seconds ago   Up 6 seconds   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   transformserver
```

#### Sending a request to the Webserver
At this point we can send our ( `curl` ) request again. We will use the exact same as in subtask number 2.
```sh
$: curl -s -X POST http://localhost:8000/transform -H 'cache-control: no-cache' -H "Content-type: text/x-yaml" --data-binary @sample-input.yaml | jq
{
  "foo.host": "example.com",
  "foo.visitor.compatibility": 4.2,
  "foo.visitor.timeout[s]": 180,
  "foo.visitor.enforce_strict": true,
  "foo.target.system": "plan9",
  "foo.target.fans": "huge",
  "foo.ranches.oldmacdonald.hectares": 9,
  "foo.ranches.oldmacdonald.chickens": 21,
  "foo.ranches.oldmacdonald.pigs": 1,
  "foo.ranches.oldmacdonald.cows": 7,
  "foo.ranches.animalfarm.hectares": 20,
  "foo.ranches.animalfarm.pigs": 49,
  "foo.ranches.animalfarm.rats": 2,
  "foo.ranches.animalfarm.humans": -1,
  "foo.ranches.animalfarm.cows": 2,
  "connector.baz.mode": "visitor",
  "connector.baz.rate": "full"
}
```

#### Logging the container output
Afterwards we print the log output from this running container which is the log output of the server application.
```sh
$: docker logs transformserver
Bottle v0.12.19 server starting up (using WSGIRefServer())...
Listening on http://0.0.0.0:8000/
Hit Ctrl-C to quit.

172.17.0.1 - - [28/Nov/2021 22:41:40] "POST /transform HTTP/1.1" 200 580
```

#### Cleanup 
Ending the tasks we can now stop the container.     
We do not have to delete the container as we provided the argument `--rm` Docker will delete once its stopped.
```sh
$: docker stop transformserver
transformserver

$: docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
