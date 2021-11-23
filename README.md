# Evooq DevOps Code Challenge (DOCC)

The days of manually-configured infrastructure systems are over. Infrastructure needs to be provisioned and configured with code, or you will drown in support.
The root of this attitude is that a lot of manual tasks can be automated using dedicated tools like Terraform, Helm, Ansible and Chef or with languages like Python, Ruby, Go and Bash.

## Requirements

### Development Tools

It is worth pointing out that this coding challenge will be deployed on your computer. You may find the following tools helpful (or not):

- [Docker](https://www.docker.com/)
- [VSCode](https://code.visualstudio.com/)

## Topics Covered

The main topics covered during the DOCC and the following open discussion (and quiz) are:

- Fundamentals of scripting
- Containerization

Depending on your experience, the list of subtasks can be rather long.
While we have no direct way to measure it, we'd suggest you don't spend
more than 3-4 hours on this. Prioritise parts of the work as seems
reasonable to you.

## Main Tasks

1. Shell Challenge
1. Configuration Transformation

Please provide a README file along your project containing the following information:
* a sample invocation of your tool and the result it displays
* a list of required dependencies and an explanation on how to build your tool
* a list of assumptions you have made during this exercise



## Shell Challenge

Business asked us to develop a quick shell script in order to test the output of an API request.
This API should return an integer.

### First test

We need to perform the following tests:

* If the given integer is divisible by 5, return "ACT"
* If the given integer is divisible by 7, add "BND"
* If the given integer is divisible by 9, add "CRYPT"
* For each digit 1,4,8 add "PTF","ACC","BANK" in the digit order

> 1 ==> PTF
> 2 ==> [nothing]
> 5 ==> ACT
> 7 ==> BND
> 9 ==> CRYPT
> 10 ==> ACTPTF
> 14 ==> BNDPTFACC
> 1114 ==> PTFPTFPTFACC

Please provide in the root folder of your repo a shell script called `sh_1.sh` that is called as such:

```sh
sh_1.sh 1114
```

### Second test

For each successful test (ACT, BND, CRYPT, PTF, ACC or BANK), we need to have a file containing the amount of iteration of this test.
If the file already contains a value, the new one should be added to it.

> 1114 sould generate 1 file PTF containing "3" + 1 file ACC containing "1"
> If 1114 is tested again the PTF file should contain "6" and the file ACC should contain "2"

Please provide in the root folder of your repo a shell script called `sh_2.sh` that is called as such:

```sh
sh_2.sh 1114
sh_2.sh 30
```

The test files (ACT, BND, etc.) should be located inside the working directory.


## Configuration Transformation

The new version of the internal application Foo got its config format
changed. You'll need to write a tool to translate tons of the old form
configs into new ones.

You can find an example of the old format config in `sample-input.yaml`

The key changes are:

* old uses yaml, new uses json
* old has nested parameter names, new flattens them to a single level,
with `.` as a separator
* the word 'client' is now undesirable - replace all occurences with 'visitor'
* likewise replace the word 'clientele' with 'fans'
* in `ranches` don't include those which do not have at least `2 cows`
and `4 hectares`

You can take the incomplete solution in `config_reshape.py` as a starting
point or write your own tool in the language of your choosing

### Subtasks

1. Prepare a script taking the old format on stdin and
giving the result on stdout
1. Reuse that code in a simple webserver, taking POST on /transform endpoint
1. Deploy this server on your computer in a way easily reproducible
in other environments
