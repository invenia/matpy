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
          {'f1': ['v1', 'v3'], 'f2': ['v2', 'v3']}
- Matlab cells
  - cells are exported as a list of objects


## Types NOT supported to Import and Export

- uint64
  * Reason: When Importing a uint64 type, 
    it would be successful on the first attempt, 
    but the next time the code try to run the functions
    Py_CompileString or PyRun_String
    it would cause matlab to crash.

  * Instead, the code to Export and Import uint64
    will now say that it is not supported and output
    an error to matlab 
