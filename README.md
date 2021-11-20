# [오픈소스 과제 01]


김정현 3학년 20152993 컴퓨터공학과
---
#### 목차
1. [getopt 명령어](#getopt-명령어)
2. [getopts 명령어](#getopts-명령어)
4. [sed 명령어](#sed-명령어)
5. [awk 명령어](#awk-명령어)
- - -
### getopt 명령어

**getopt란 ?**

 설명에 앞서 getopt과 getopts는 비슷해보이지만 다른 특징들을 가지고 있습니다.그래서 두 가지를 혼돈하면 안되는 것입니다.

* 쉘에서 명령을 실할 할때 사용 되는 명령어 입니다. 

* Unix/POSIX 유틸리티 구문 안내서를 따르는 명령줄 인수를 처리가 되도록 설계가 되었습니다. 

* 쉘 스크립트에서 명령 줄 인수를 구문 분석하기위한 Unix 프로그램의 이름입니다.

* getopt은 외부 유틸리티 프로그램이며, 는 실제로자신의 옵션을 처리하지 않습니다.( _/usr/bin/getopt 에 위치해 있는 외부 명령어 입니다._)

* getopt은 전달되는 옵션을 표준화합니다. 
( _이 말은 즉 쉘 스크립트가보다 쉽게 처리 할 수 있도록 표준 형식으로 변환하는 것입니다._)

* opt 스펙을 시행 할 수 없고, 사용자가 잘못된 옵션을 제공하면 오류를 반환 할 수 없습니다. 또한, OPTARG를 파싱 할 때 자신의 오류 검사를 수행해야합니다.


**사용 방법**

 getopt는 짧은 옵션과 긴 옵션 두가지 방법을 사용할수 있습니다.

| 이름 | 옵션|예제
|:---|---:|---:|
| 긴옵션 | -l | getopt -l help,path:,name: -- "$@"
| 짧은옵션 | -o | getopt -o a:bc -- "$@" 

짧은옵션은 지정 옵션은 -o 이고, 옵션 인수를 가질 경우 : 문자를 사용해야 됩니다.
 
긴옵션은 지정 옵션은 -l 이고, 옵션명은 ',' 로 구분합니다. 짧은 옵션과 마찬가지로 옵션 인수를 가질 경우 : 문자를 사용해야 됩니다.

즉, 위의 표에는 path:,name:,a: 3개가 인수 옵션을 같습니다.

**예제1**

nano test.sh을 통해 만들어서 진행하였습니다.

```bash
 #!/bin/bash

options=$( getopt -o a:bc -l help,path:,name: -- "$@" )
echo "$options"

```

```
--------------- getopt -o a:bc -- "$@"-----------------


---1. 설정하지 않은 옵션이 사용되거나 옵션 인수가 빠질 경우 --

$ ./test.sh -n
getopt: invalid option -- 'n'


$ ./test.sh -a
getopt: option requires an argument -- 'a'



-----------2. 설정을 정확하게 하였을때 -----------

$ ./test.sh -a123 -bc hello
-a '123' -b -c -- 'hello'

```


```
--------------- getopt -l help,path:,name: -- "$@" -----------------



---1. 설정하지 않은 옵션이 사용되거나 옵션 인수가 빠질 경우 --

$ ./test.sh --nope
getopt: unrecognized option '--nope'

$ ./test.sh --name
getopt: option '--name' requires an argument


-----------2. 설정을 정확하게 하였을때 -----------


$ ./test.sh --name foo --path=/user/getopting
--name 'foo' --path '/user/getopting' --
```

_(실습 예제1)_

![image](https://user-images.githubusercontent.com/93643813/142731501-55676b13-20da-49c0-a8d6-8d9e63d30f7f.png)



1. ***설정하지 않은 옵션이 사용되거나 옵션 인수가 빠질 경우***

 위의 설정 처럼 옵션이 사용되지 않았으면, __invalid option , nrecognized option__ 와 같은 경고문이 나오고 되지 않는다. 또 욥선 인수를 빼고 입력하면  __requires an argument__ 와 같은 경고문이 나옵니다. 그래서 정확하게 입력을 해야 합니다.
 
2. ***설정을 정확하게 하였을때***

* 짧은옵션
 
 -a123 옵션이 -a '123'으로 불리가 되었고, -bc 옵션이 -b, -c로 분리가 되었는 것을 확인할수가 있다. 또 옵션에 해당하지 않는 hello는 '--' 뒤로 이동하는 것이 확인 할수 있습니다.
 
 * 긴옵션
 
 짧은 옵션과 다르게 띄어 쓰기를 통해서 옵션 인수를 설정해야 된다. 또 = 를 써도 된다. 그러면 결과 값이 name 'foo' , path '/user/getopting' 되는 것을 확인할수가 있습니다.
 
 
 **예제2**
 
getopt 명령문은 case 문에서 사용하면 더 좋은 효과를 가져 올수 있습니다. nano test2.sh 로 하였습니다.
 
 ```bash
 #!/bin/bash

if ! options=$(getopt -o hp:n: -l help,path:,name:,aaa -- "$@")
then
    echo "ERROR: print usage"
    exit 1
fi

eval set -- $options 

while true; do
    case "$1" in
        -h|--help) 
            echo >&2 "$1 was triggered!"
            shift ;;
        -p|--path)    
            echo >&2 "$1 was triggered!, OPTARG: $2"
            shift 2 ;;   
        -n|--name)
            echo >&2 "$1 was triggered!, OPTARG: $2"
            shift 2 ;;
        --aaa)     
            echo >&2 "$1 was triggered!"
            shift ;;
        --)           
            shift 
            break
    esac
done

echo --------------------
echo "$@"

```


```
-------------결과값------------
$ ./test2.sh -h hello.c -p //bin --name='foo bar' --aaa -- --bbb
-h was triggered!
-p was triggered!, OPTARG: //bin
--name was triggered!, OPTARG: foo bar
--aaa was triggered!
hello.c --bbb
 --name 'foo bar' -- 'hello.c' '/usr/bin' '--bbb'
```

_(실습 예제2)_

![image](https://user-images.githubusercontent.com/93643813/142732860-492e7f12-cc18-457e-93bf-9ecdd5c6abcd.png)


 여기서 __shift__ 는 옵션 인수를 가지므로 2를 하였습니다. 위의 결과들은 옵션 인수(_p:,n:,path:,name:_) 의 값들이 어떻게 들어가는지 확인할수 있는 예제 입니다. 또 이 예제는 getopt의 OPTARG부분을 잘 보여주고 있습니다.
 
 
### getopts 명령어

**getopt란 ?**

* getopts는 C를 기반으로 POSIX 유틸리티 구문 지침을 따르는 명령 줄 인수를 처리하도록 설계되었습니다.

* 매개변수 리스트에서 옵션 및 옵션 인수를 검색하는 Korn/POSIX __쉘 내장 명령__ 입니다. 

* 이중 대시 접두어가 붙은 긴 옵션 이름은 지원하지 않습니다. 단일 문자 옵션 만 지원합니다.

* 쉘 자체 변수를 현재와 인수 위치, OPTIND 및 OPTARG의 위치를 추적하기 위해 사용하고, 쉘 변수에서 옵션 이름을 반환할수 있습니다.

* getopts 명령은 짧은 옵션을 처리합니다. 

**사용법**

![image](https://user-images.githubusercontent.com/93643813/142733964-9296d0b8-db84-43a6-a735-e49a598ef79d.png)

 OptionString의 문자 뒤에는 :(콜론)이 오면 옵션에 인수가 있는 것으로 간주됩니다. 옵션에 옵션-인수가 필요한 경우 getopts 명령은 이를 변수 OPTARG에 배치합니다. 또, 사용하고 하는 옵션은 인수들을 $1, $2, ... positional parameters 형태로 전달되므로 스크립트 내에서 직접 옵션을 해석해서 사용해야 됩니다. 이것도 getopt와 마찬가지로 case문으로 사용하는것이 일반적 입니다. 또 사용할때 이 명령어는 짧은 옵션이라는 것을 인지해야 됩니다.
 
 쉽게 말해서, __(getopts "a :b :c" opt)__ 와 같은 형식으로 쓰면되는것이다. 여기서 :는 옵션 인수가 있다는 뜻이다.
 
 **예제**
 
 getopts 명령문은 case 문에서 사용하였습니다. nano test4.sh 로 하였습니다
 
 ```bash
 #!/bin/bash

while getopts "a:b:c" opt; do
  case $opt in
    a)
      echo >&2 "-a 동작!, OPTARG: $OPTARG"
      ;;
    b)
      echo >&2 "-b 동작!, OpOPTARG: $OPTARG"
      ;;
    c)
      echo >&2 "-c 동작!"
      ;;
  esac
done

shift $(( OPTIND - 1 ))
echo ------------------
echo "$@"

```

```
========= 설정옵션과 옵션 인수가 일치할경우========
$./test4.sh -a hellow -b /user/student c hello world
-a 동작!, OPTARG: hellow
-b 동작!, OpOPTARG: /user/student
------------------
c hello world



======== 설정하지 않은 옵션이 사용되었을때 ========
$./test4.sh -g d
./test4.sh: illegal option -- g
------------------
d


```

_(실습 예제3)_

![image](https://user-images.githubusercontent.com/93643813/142736981-c456d233-a5ec-42a6-a71b-f1a0f529614c.png)

 결과 값에서 알수 있듯이 getopt와 getopts의 공통점은 설정옵션과 옵션 인수가 일치 해야지 가능하다는 것이다. 그리고 이 getopts는 getopt 와 다르게 조금더 깔금하게 동작이 되는것을 볼수가 있다. 그래서 간단하게 사용되어질때 좋은 명령어이다.
 
 

### sed 명령어

**sed란?**

**사용법**

 **예제**

### awk 명령어

**awk란?**

**사용법**

 **예제**
