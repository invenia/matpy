# matpy
Call Python from MATLAB

## Source

This package is based on work originally done by Stanislaw Adaszewski. You can
find his original work [on his blog](http://algoholic.eu/matpy/). His license
is included below and in `py.cpp`.

## Modifications

This repository puts the code under public source control for the first time,
and adds a build script which deals with some build issues with the default
instructions on the original blog. Pull requests are welcome.

## License

```
Copyright (c) 2012, STANISLAW ADASZEWSKI
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of STANISLAW ADASZEWSKI nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANISLAW ADASZEWSKI BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

## Types supported to Import and Export

- String
- Unicode String (Import only)
- int8
- uint8
- int16
- uint16
- int32
- uint32
- int64
- uint64
- single
- double
- logical
- Matlab structs
    - structs are exported as python dictionary such that each field is a key in the dictionary and has a corresponding list of values, one for each of the elements of the struct.
    - only dictionaries in this form can be imported as structs.
    - ex. s =

          1x2 struct array with fields:
				f1
				f2

          s(1) =
                f1: 'v1'
                f2: 'v2'
          s(2) =
                f1: 'v3'
                f2: 'v4'

          would be exported as:
          {'f1': ['v1', 'v3'], 'f2': ['v2', 'v4']}


- Matlab cells
  - cells are exported as a list of objects

## Some simple examples

Running a python command with matpy must have the following format:

> py('eval', '**python command here**')

An example

```
>> py('eval', 'print "hello, world"')
hello, world
```

This is a simple example of exporting a variable to python, changing it, and importing the new value.

```
>> test = 3

test =

     3

>> py_export test
>> py('eval', 'test = test + 3')
>> py_import test
>> test

test =

     6

```

The example below shows that exporting a simple value to python is represted in python as a single value in a 2d array

```
>> test = 4

test =

     4

>> py_export test
>> py('eval', 'print test')
[[ 4.]]
>> py('eval', 'print test[0][0]')
4.0
```

Here's the example of using the py shell

```
>> test = 5

test =

     5

>> py_export test
>> py_shell
py> print "hello, world"
hello, world
py> print test
[[ 5.]]
py> 1 + 1
py> print 1 + 1
2
py> if test[0][0] < 10: print "hi, again"
hi, again
py> exit
```

Here's an example of exporting a struct to python, note how it is represented in python

```
>> test2 = struct('field1', 'value1', 'field2', 'value2');
>> test2(2) = struct('field1', 'value3', 'field2', 'value4');
>> test2(1)

ans =

    field1: 'value1'
    field2: 'value2'

>> test2(2)

ans =

    field1: 'value3'
    field2: 'value4'

>> py_export test2
>> py_shell
py> print test2
{'field2': ['value2', 'value4'], 'field1': ['value1', 'value3']}
```

## Troubleshooting

### Compilation Problems

##### Can't find MATLAB
If you are getting errors similar to 

```
make: mexext: Command not found
make: mex: Command not found
```
It is possible that the Makefile cannot locate your MATLAB. To Fix, try adding something like this to your ~/.bash_profile `export MATPATH=[path to matlab]` for example `export MATPATH=/Applications/MATLAB_R2012b.app/bin/matlab` worked for me.

##### Can't find Python
If you are getting errors similar to

```
py.cpp:27:10: fatal error: 'Python.h' file not found
#include <Python.h>
          ^
```
It is possible that your `which python` doesn't point to a specific python that we want. You may have to set in your ~/.bash_profile `export PYPATH=[path to .pyenv]/versions/2.7.9/bin/python` for example `export PYPATH=~/.pyenv/versions/2.7.9/bin/python` worked for me.

##### Warnings
If your last line after compiling is,

```

7 warnings generated.
```
then everything is working as should.
