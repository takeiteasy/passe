# passe

Cryptographic password generation + manager based off [spectre.app](https://spectre.app/spectre-algorithm.pdf) (formerly "Master Password") **WIP**

## Dependencies

- [technion/libscrypt](https://github.com/technion/libscrypt) [BSD-2-Clause]
    - src/spectre.c -- scrypt + sha256 implementation
- [skandhurkat/Getopt-for-Visual-Studio](https://github.com/skandhurkat/Getopt-for-Visual-Studio) [ZPL-2.1]
    - src/getopt_win32.h
- [piotrmurach/tty-prompt](https://github.com/piotrmurach/tty-prompt) [MIT]
    - src/passe-cli.rb gem

## License
```
The MIT License (MIT)

Copyright (c) 2022 George Watson

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
