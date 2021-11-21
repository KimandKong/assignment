# [오픈소스 과제 01]


김정현 3학년 20152993 컴퓨터공학과
---
#### 목차
1. [getopt 명령어](#getopt-명령어)
2. [getopts 명령어](#getopts-명령어)
4. [sed 명령어](#sed-명령어)
5. [awk 명령어](#awk-명령어)
6. [Reference](#Reference)
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
 
 - - -
 
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
 
 - - -

### sed 명령어

**sed란?**

* vi편집기처럼 편집에 특화된 명령어 입니다. 그래서 수정 치환 삭제 글추가등 편집기 기능들은 대부분 사용할수 있습니다.

* sed는 명령행에서 파일을 인자로 받아 명령어를 통해 작업한후 화면으로 확인하는 방식을 가지고 있습니다.

* sed의 특징은 sed로 파일을 변경했을 경우, 원본을 손상시키지 않는 것입니다. 그래서 명령을 수행후 화면으로 출력되는데 출력된 결과가 원본과 다르다라도 원본은 손상이 없다는 것입니다. 결론적으로, 표준 입력으로 입력받아,원하는 처리를 해서, 표준 출력으로 그 결과를 보는 일 밖에 하지 않습니다.

* sed의 또다른 특징은 동작시 내부적으로 두개의 워크스페이스를 사용하고, 이 두가지 버퍼를  __패턴스페이스, 홀드 스페이스라고 합니다.__ 아래에 그림으로 설명하겠습니다.


![image](https://user-images.githubusercontent.com/93643813/142754228-84c13729-255f-4a34-af7c-9330b413575b.png)


* __패턴스페이스__

패턴 버퍼는 sed가 파일을 라인단위로 읽을 때 그 읽힌 라인이 저장되는 임시공간 입니다. 즉, 이 버퍼는 현재 파일이 담고 있는 정보를 갖고 있습니다. 그리고 이것을 조작을 하면 저장되어 있는 내용을 저장하는 것입니다. 그런데 여기서 생각해야될점은  조작을 한다고 원본이 건드는 것이 아닙니다.

* __홀드 스페이스__

홀드 버퍼와 다르게 짧은 순간 임시 버퍼가 아니라 더 길게 가지고 있는 저장소 입니다. 즉, 내가 어떤 내용을 홀드 스페이스에서 저장하면 sed가 다음을 읽더라도 내가 원할때 불러와서 재사용할수 있는 버퍼가 홀드가 됩니다.

**사용법**

기본적인 형태 : __sed -n -e 'command' [input file]__

* ___-n___ : 여기서 -n를 사용하는 이유가 눈에 안보이는 데이터들이 많이 나타나기 때문입니다.그래서 -n을 사용해서 -n옵션을 붙여 패턴 버퍼의 자동출력을 하지 않게 해서 지저분하지 않고 깔금하게 출력 시킬수 있습니다.

*  ___-e___ : 이 옵션 다음으로는 우리가 사용할 command를 가지고 텍스트 파일을 가공해줍니다.

sed -n -e '1,$p' sed_test_file.txt

| 이름 | 특징 |방벙예제
|:---|:---|---:|
| - p  | 특정 행을 출력| sed -n -e '1,$p' sed_test_file.txt
| - d | 특정 행 삭제 | sed -n -e '2,6d' -e '1,$p'  sed_test_file.txt
| - s |단어 치환 | sed -n -e 's/reakwon/reak/g' -e '2p' sed_test_file.txt
|- a, i|문자열 추가|sed -n -e '/go/a\end' -e '1,$p' let_it_go.txt
| - c |특정 행의 내용을 전부 교체| sed -n -e '/^Let/c\Let it go X2' -e '1,$p' let_it_go.txt
| - r |특정 행에 파일의 내용을 추가|  sed -n -e '/100$/r perfect.txt' -e '1,$p' sed_test_file.txt


 **예제**
 
 먼저 sed_test_file.txt 에 값을 넣어서 실행을 하였습니다.
 
 ```text
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90
 
 
 ```
 
1. __특정 행을 출력__
 
 ```
 $ sed -n -e '/$/p' sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90
 
=====================================================
 
 $  sed -n -e '1p' ./sed_test_file.txt
name    phone           birth           sex     score
kim@DESKTOP-8BRLTAA:/mnt/c/Users/user/wak$ sed -n -e '2p' sed_test_file.txt

=====================================================

$ sed -n -e '1,5p' sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20

====================================================

$ sed -n -e '1p' -e '8,$p'  sed_test_file.txt
name    phone           birth           sex     score
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90
====================================================

$ sed -n -e '/F/p'  sed_test_file.txt
sim     010-4321-4321   1999-09-09      F       88
yut     010-2323-2323   1988-10-10      F       59
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80

```

![image](https://user-images.githubusercontent.com/93643813/142755869-605ce257-9082-45c0-8b58-55149410ba63.png)

* 기본적으로 전체의 줄을 출력하려면 command에 __/$/p__ 또는 __1,$p__ 로 출력해볼 수 있습니다.  
* 첫번째 줄만 출력해주기를 원하면  2번째 처럼 __'1p'__ 로 사용할 수 있습니다. 만약에 1~5까지의 값을 출력하고 싶으면 __'1,5p'__ 로 하면 됩니다.(1부터 5까지라는 말입니다.) 
* n~끝까지를 하고 싶으면 __'n,$p'__ 라고 적어주면 됩니다.
* 다중 command 사용을 하고 싶으면, -e 옵션을 이용해서 여러개 사용하여 command를 줄 수 있습니다.
* 특정 문자열에 있는 것만 표시하고 싶으면, __/포함된 문자열/p__ 이런 식으로 사용 할수 있습니다.

2. __특정 행 삭제__
```
$ cat sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90

====================================================
$ sed -n -e '2,6d' -e '1,$p'  sed_test_file.txt
name    phone           birth           sex     score
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90


```

![image](https://user-images.githubusercontent.com/93643813/142756902-060be76b-e12a-436e-a4b7-cd6b4d29519d.png)


 2-1. 2~6번째 줄을 삭제하고 나머지 모든 내용을 출력하는 내용을 예제로 썼습니다. __p를 넣는 부분에 d를__ 넣어주면 됩니다. 

3. __단어 치환__

```
$ cat sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90

====================================================
$ sed -n -e 's/reakwon/reak/g' -e '2p' sed_test_file.txt
reak 010-1234-1234   1981-01-01      M       100

```

![image](https://user-images.githubusercontent.com/93643813/142756876-dd888072-a347-4892-8259-f76bfa96d2cb.png)


 이것을 쓰는 방법은 __s/reakwon/reak/g__ 부분을 잘 보면 됩니다 . 여기서 s는 substitute의 약자로 치완해 주는 다는 것이고 reakwon 이름을 reak으로 바꾼다는 것입니다. 그리고 마지막 g는 global의 약자로 전체라는 것을 말합니다. __/gi__ 라는 것도 있는데 이것은 ignore case의 약자로 reakwon의 단어를 검색할때 대소문자 구분하지 않겠다는 것을 의미합니다. 그래서 대소문자 구분없이 쓰려면 __gi__ 를 쓰는것이 좋습니다.


4. __문자열 추가__

여기서는 let_it_go.txt라는 파일을 만들어 실행하였습니다.

```
$ cat let_it_go.txt
Let it go, let it go.
Can't hold it back anymore.
Let it go, let it go.
Turn away and slam the door.
I don't care what they're going to say.
Let the storm rage on.
The cold never bothered me anyway.

====================================================
$ sed -n -e '/go/a\end' -e '1,$p' let_it_go.txt
Let it go, let it go.
end
Can't hold it back anymore.
Let it go, let it go.
end
Turn away and slam the door.
I don't care what they're going to say.
end
Let the storm rage on.
The cold never bothered me anyway.

====================================================
$ sed -n -e '/go/i\end' -e '1,$p' let_it_go.txt
end
Let it go, let it go.
Can't hold it back anymore.
end
Let it go, let it go.
Turn away and slam the door.
end
I don't care what they're going to say.
Let the storm rage on.
The cold never bothered me anyway.

```

![image](https://user-images.githubusercontent.com/93643813/142756836-288df5db-a5fb-421c-867a-c3aa80943f69.png)


 * 여기서 __'/찾을 문자열/a,i\'__  의형태로 쓰여집니다.

1 a : 아래 줄에 추가할 문자열으로 들어 값니다. 그래서 go라는 것을 찾으면  다음 줄에 추가가 됩니다.
2 i : 위에 삽입할 문자열으로 들어 값니다. 그래서 go라는것을 찾으면 위에 삽입을 합니다.

5. __특정 행의 내용을 전부 교체__

```
$ cat let_it_go.txt
Let it go, let it go.
Can't hold it back anymore.
Let it go, let it go.
Turn away and slam the door.
I don't care what they're going to say.
Let the storm rage on.
The cold never bothered me anyway.

====================================================
$ sed -n -e '/^Let/c\Let it go X2' -e '1,$p' let_it_go.txt
Let it go X2
Can't hold it back anymore.
Let it go X2
Turn away and slam the door.
I don't care what they're going to say.
Let it go X2
The cold never bothered me anyway.

```

![image](https://user-images.githubusercontent.com/93643813/142756812-cf538a91-11c9-4cbb-a080-b2d3b0c04a45.png)

 기본적인 형태는 __'/바꿀 행이 포함한 문자열/c\바꿀 행의 내용'__ 로 시작됩니다. 그래서 위와 같이 내가 바꾸고 싶은 것을 ^를 사용하여 Let으로 시작하는 줄들을 찾고 c 커맨드로 바꿔질 줄 내용을 입력하였습니다.


6. __특정 행에 파일의 내용을 추가__

 특정파일을 만들기 위해서 perfect.txt을 만들었습니다.

```
$ cat sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90

$ cat perfect.txt
PERFECT! EXCELLENT!


====================================================

$  sed -n -e '/100$/r perfect.txt' -e '1,$p' sed_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
PERFECT! EXCELLENT!
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
sol     010-5911-1111   1976-10-12      F       60
lee     010-4949-4949   1988-09-30      F       80
feng    010-1111-9999   1979-03-20      M       90
```

![image](https://user-images.githubusercontent.com/93643813/142756790-0e8c38ab-5251-4f6f-9b7b-b109a851fef0.png)

 100으로 끝나는 줄에 저 텍스트 파일의 내용을 아랫줄에 첨가하라고 했는 명령어 입니다. 그래서 __'/100$/r perfect.txt'__ 되는 것입니다.


- - -




### awk 명령어

**awk란?**

* 대부분의 리눅스 명령어들은 이름만으로 짐작이 가능하나 awk는 이 명령어를 최초로 디자인한 사람 이름의 이니셜로 했다는 특징을 가지고 있다.(A:Alfred V. Aho, W:Peter J. Weinberger, 
K:Brian W. Kernighan)

* awk는 파일로부터 레코드(record)를 선택하고, 선택된 레코드에 포함된 값을 조작하거나 데이터화하는 것을 목적으로 사용하는 프로그램입니다. 즉,지정된 파일로부터 데이터를 분류한 다음, 분류된 텍스트 데이터를 바탕으로 패턴 매칭 여부를 검사하거나 데이터 조작 및 연산 등의 액션을 수행하고, 그 결과를 출력하는 기능을 수행는 명령어라는 것 입니다.

*  awk가 실행하는 기능들은 프로그래밍 언어로 작성이 되었습니다.

* awk 명령으로 할수 있는 일이 여러가지가 있는데 이것은 아래의 도표를 작성해서 나타내었습니다.


_(특징을 도표로 정리)_

| 이름 | 특징 |
|---:|:---|
| 1 | 텍스트 파일의 전체 내용 출력 | 
| 2 | 파일의 특정 필드만 출력 |  
| 3 | 특정 필드에 문자열을 추가해서 출력 |  
| 4 | 패턴이 포함된 레코드 출력 |  
| 5 | 특정 필드에 연산 수행 결과 출력 | 
| 6 | 필드 값 비교에 따라 레코드 출력 | 

_(특징을 그림으로 정리)_

![image](https://user-images.githubusercontent.com/93643813/142737519-edbcc365-50ee-4369-a30b-cead58a6c0c8.png)

* 기본적으로는 입력 데이터를 필드와 레코드 단위로 인식합니다.(데이터베이스와 흡사한 모습을 가지고 있습니다.)

(레코드 그림 예제)

![image](https://user-images.githubusercontent.com/93643813/142750400-13caecea-957b-4582-90d6-1ef7a0039ccc.png)

**사용법**

 * 처음에는 레코드와 필드에 틀에 맞추어진 txt 파일을 만들어 줍니다.
 
 *  awk [OPTION...] [pattern {action} ...] [ARGUMENT...] 와 같은 형식에 맞추어 만들어주면 됩니다. 아래 도표를 통하여 더 많은 정보들을 나열 했습니다.

| 번호 | awk 사용 예	 | 명령어 옵션 |
|---:|:---|:---|
| 1 | [파일의 전체 내용 출력](#파일의-전체-내용-출력) |awk '{ print }' [FILE] | 
| 2 |[필드 값 출력](#필드-값-출력) |awk '{ print $1 }' [FILE] |  
| 3 |[필드 값에 임의 문자열을 같이 출력](#필드-값에-임의-문자열을-같이-출력) |awk '{print "STR"$1, "STR"$2}' [FILE] |  
| 4 | [지정된 문자열을 포함하는 레코드만 출력](#지정된-문자열을-포함하는-레코드만-출력) |awk '/STR/' [FILE] |  
| 5 | [특정 필드 값 비교를 통해 선택된 레코드만 출력](#특정-필드-값-비교를-통해-선택된-레코드만-출력) |awk '$1 == 10 { print $2 }' [FILE]| 
| 6 |[특정 필드들의 합 구하기](#특정-필드들의-합-구하기)| awk '{sum += $3} END { print sum }' [FILE]| 
| 7 |[여러 필드들의 합 구하기](#여러-필드들의-합-구하기)| awk '{ for (i=2; i<=NF; i++) total += $i }; END { print "TOTAL : "total }' [FILE]| 
| 8 |[레코드 단위로 필드 합 및 평균 값 구하기](#레코드-단위로-필드-합-및-평균-값-구하기)|awk '{ sum = 0 } {sum += ($3+$4+$5) } { print $0, sum, sum/3 }' [FILE]|
| 9 |[필드에 연산을 수행한 결과 출력하기](필드에-연산을-수행한-결과-출력하기)| awk '{print $1, $2, $3+2, $4, $5}' [FILE]|
| 10 |[레코드 또는 필드의 문자열 길이 검사](레코드-또는-필드의-문자열-길이-검사)| awk ' length($0) > 20' [FILE]|
| 11 |[파일에 저장된 awk program 실행](파일에-저장된-awk-program-실행)| awk -f [AWK FILE] [FILE]|
| 12 |[필드 구분 문자 변경하기](필드-구분-문자-변경하기)| awk -F ':' '{ print $1 }' [FILE]|
| 13 |[awk 실행 결과 레코드 정렬하기](#awk-실행-결과-레코드-정렬하기)| awk '{ print $0 }' [FILE]|
| 14 |[특정 레코드만 출력하기](#특정-레코드만-출력하기)| awk 'NR == 2 { print $0; exit }' [FILE]|
| 15 |[출력 필드 너비 지정하기](#출력-필드-너비-지정하기)| awk '{ printf "%-3s %-8s %-4s %-4s %-4s\n", $1, $2, $3, $4, $5}' [FILE]|
| 16 |[필드 중 최대 값 출력](#필드-중-최대-값-출력)|awk '{max = 0; for (i=3; i<NF; i++) max = ($i > max) ? $i : max ; print max}' [FILE]|


 **예제**
 
 예제에 앞서 awk를 위한 txt를 만들.
 
```text
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75
```

1. 파일의 전체 내용 출력
###### 파일의 전체 내용 출력

```

$ awk '{ print }' ./awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

```

![image](https://user-images.githubusercontent.com/93643813/142750999-a4651469-15ef-41f7-8de3-731a972fe40c.png)


위와 같이 cat과 awk '{ print }'은 유사한 특징을 가지고 있습니다.

2. 필드 값 출력
###### 필드 값 출력
```

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================

$ awk '{ print $1, $2}' ./awk_test_file.txt
name phone
reakwon 010-1234-1234
sim 010-4321-4321
nara 010-1010-2020
yut 010-2323-2323
kim 010-1234-4321
nam 010-4321-7890

```

![image](https://user-images.githubusercontent.com/93643813/142751179-d7f2b8bb-9a8d-43d4-89e6-f5b90595bc85.png)

위에서 print $1, $2이 말은 필드값 1,2의 값을 나타내는 말입니다. 즉 $n이 n번째 필드값을 프린트 해라는 말입니다. $0은 레코드 전체를 해라는 말이다. 즉 파일값 전체를 알려주는 것입니다.


3. 필드 값에 임의 문자열을 같이 출력
###### 필드 값에 임의 문자열을 같이 출력
```

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================


$ awk '{print "name:"$1, "phone:"$2}' ./awk_test_file.txt
name:name phone:phone
name:reakwon phone:010-1234-1234
name:sim phone:010-4321-4321
name:nara phone:010-1010-2020
name:yut phone:010-2323-2323
name:kim phone:010-1234-4321
name:nam phone:010-4321-7890

```

![image](https://user-images.githubusercontent.com/93643813/142751220-5995addb-b2c1-442f-b343-d6081d6b66b6.png)

위와 같이 print "name:"$1, "phone:"$2 이런식으로 하면 $1,$2의 필드값에  name, phone을 넣는다는 말입니다.

4. 지정된 문자열을 포함하는 레코드만 출력
###### 지정된 문자열을 포함하는 레코드만 출력

```

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================


$ awk '/sim/' ./awk_test_file.txt
sim     010-4321-4321   1999-09-09      F       88


======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142751354-7d1f27a9-9a93-43b8-90e3-b3142216e10b.png)

위와 같이 '/sim/' 이라는 레코드 값만 출력하면 sim에 관련된 값들이 출력된다.

5. 특정 필드 값 비교를 통해 선택된 레코드만 출력
###### 특정 필드 값 비교를 통해 선택된 레코드만 출력
```

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================


$awk '$5 > 70 { print $0 }' ./awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nam     010-4321-7890   1996-06-20      M       75



======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142751526-97d4191d-e173-4e62-8777-86e2a6b91b98.png)


위와 같이 예를 들어 필드 5가 70보다 큰 값을 호출 할때 사용할수가 있습니다.

6. 특정 필드들의 합 구하기
###### 특정 필드들의 합 구하기

```

$ cat awk_test_file.txt
name    phone           birth           sex     score
reakwon 010-1234-1234   1981-01-01      M       100
sim     010-4321-4321   1999-09-09      F       88
nara    010-1010-2020   1993-12-12      M       20
yut     010-2323-2323   1988-10-10      F       59
kim     010-1234-4321   1977-07-17      M       69
nam     010-4321-7890   1996-06-20      M       75

======================================================

$ awk '{sum += $5} END { print sum }' ./awk_test_file.txt
411


======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142751663-e89f56ab-f038-498f-9cab-64536276791c.png)

필드 5 즉 , score값을 끝까지 더한 값을 구한 것을 예로 들었습니다.

7. 여러 필드들의 합 구하기
###### 여러 필드들의 합 구하기

이 부분은 전부 숫자로 되어 있는 txt를 만들어서 새로 하였습니다.

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20

======================================================

$ awk '{ for (i=2; i<=NF; i++) total += $i }; END { print "TOTAL : "total }' ./field.txt
TOTAL : 450


======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752143-ad855dfc-e811-4231-ac34-10f762b1cec5.png)

8. 레코드 단위로 필드 합 및 평균 값 구하기
###### 레코드 단위로 필드 합 및 평균 값 구하기

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20

======================================================

$ awk '{ sum = 0 } {sum += ($3+$4+$5) } { print $0, sum, sum/3 }' ./field.txt
1 kim 30 40 50 120 40
2 kong 60 70 80 210 70
3 lee 90 10 20 120 40


======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752210-71ad25c4-e786-4a22-885c-62b7f8a07911.png)

9. 필드에 연산을 수행한 결과 출력하기
###### 필드에 연산을 수행한 결과 출력하기

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20

======================================================

$ awk '{print $1, $2, $3+2, $4, $5}' ./field.txt
1 kim 32 40 50
2 kong 62 70 80
3 lee 92 10 20

======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752391-6f1c20e0-6c93-4c31-a704-2f388f49e280.png)

필드 3에 2를 더한것을 출력한 것입니다. 

10. 레코드 또는 필드의 문자열 길이 검사
###### 레코드 또는 필드의 문자열 길이 검사


```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20

======================================================

$ awk ' length($2) > 3 { print $0 } ' ./field.txt
2 kong 60 70 80

======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752500-8995a06a-ef3a-4c37-9213-9795b7e0205a.png)

 length()를 통해서 문자열의 길이를 확인 할수 있습니다.
 

11. 파일에 저장된 awk program 실행
###### 파일에 저장된 awk program 실행

파일을 script언어로 한개를 만들어서 실행하였습니다.

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ cat forworking.script
{
    for (i=2; i<=NF; i++)
        total += $i
}

END {
    print "TOTAL : "total
}

======================================================

$ awk -f forworking.script ./field.txt
TOTAL : 450

======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752715-124a8b11-4e7e-4c3f-a304-aa12803047fe.png)


여기에서는 sum 값을 구하는 파일을 만들어서 -f 옵션을 통해서 forworking파일이 작동하게 하였습니다.


12 필드 구분 문자 변경하기
###### 필드 구분 문자 변경하기

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ awk -F ' ' '{ print $1 }' ./field.txt
1
2
3
======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752855-37790310-b3ff-4a8b-b524-97050120b85d.png)

 본적으로 레코드의 필드를 구분하는 문자는 space 입니다. 그런데 여기서  -F를 사용하면 변경할수 있습니다. 만약에 kim,kong,lee 앞에 ',' 있으면 __-F ','__ 로 쓰면 됩니다.


13 awk 실행 결과 레코드 정렬하기
###### awk 실행 결과 레코드 정렬하기


```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ awk '{ print $0 }' field.txt | sort -r
3 lee 90 10 20
2 kong 60 70 80
1 kim 30 40 50
======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142752959-5565c54e-5b15-41c0-9f5b-f7ffc039e095.png)

여기에서는 파이프와 sort -r 명령어를 사용해서 정렬을 하였습니다.

14 특정 레코드만 출력하기
###### 특정 레코드만 출력하기

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ awk 'NR == 3 { print $0; exit }' field.txt
3 lee 90 10 20
======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142753063-7af11ede-07d2-4967-a6c9-a0ecb9c45841.png)

 여기서 NR는 3번째 레코드만 출력한다는 의미 입니다, exit 키워드로 조건에 따라 중지할수 있습니다.
 
 
15 출력 필드 너비 지정하기
###### 출력 필드 너비 지정하기

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ awk '{ printf "%-3s %-8s %-4s %-4s %-4s\n", $1, $2, $3, $4, $5}' field.txt
1   kim      30   40   50
2   kong     60   70   80
3   lee      90   10   20
======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142753122-cfcd0460-eb9f-4b49-b1bb-7d906ffab43f.png)


여기서 너비를 정하는 것은 c언와 동일하게 이용하면 됩니다.

16 필드 중 최대 값 출력
###### 필드 중 최대 값 출력

```
$ cat field.txt
1 kim 30 40 50
2 kong 60 70 80
3 lee 90 10 20
=========================================
$ awk '{max = 0; for (i=3; i<NF; i++) max = ($i > max) ? $i : max ; print max}' ./field.txt
40
70
90
======================================================
```

![image](https://user-images.githubusercontent.com/93643813/142753206-93858034-f81b-4a7f-831b-759a934392f0.png)

 이것도 마찬가지로 언어의 특징을 가지고 실행이 되는것을 알수가 있습니다.

---

### Reference

* [getopts,getop 관련자료](https://mug896.github.io/bash-shell/getopts.html "getop,getops 관련자료")
* [getopts 관련자료](https://www.ibm.com/docs/ko/aix/7.2?topic=g-getopts-command "getops 관련자료")
* [getop 관련자료](https://www.ibm.com/docs/ko/aix/7.2?topic=g-getopt-command"getop "getop 관련자료")
* [sed 관련 자료](https://reakwon.tistory.com/164 "sed 관련 자료")
* [sed 관련 자료2](https://www.ibm.com/docs/ko/aix/7.2?topic=s-sed-command"sed 관련 자료2")
* [awk 관련 자료](https://recipes4dev.tistory.com/171"awk관련자료")
