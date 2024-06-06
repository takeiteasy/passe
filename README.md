# passé

> [!WARNING]
> Work in progress

Passé is a password manager for MacOS that is based on [Spectre](https://spectre.app/spectre-algorithm.pdf) (formerly MasterPassword).

Passé has no sign up, and passwords aren't stored anywhere. All passwords are generated through a cryptographic process of combing a name, a password and a unique nonce string. The none string is suggested to be something memorable, like the name of the site the password corresponds to. The only data that Passé stores is usernames and site identifiers for each user. Passé doesn't make any in or outbound connections.

This means that in the event your computer dies and your data is lost, all you need to do is reinstall Passé, enter your username and master password then put the site name in and voilà - your password.

## Preview
<p align="center">
  <img src="https://github.com/takeiteasy/passe/blob/master/screenshot.png?raw=true">
</p>


## TODO

- [ ] Focus TextField on appear and when state changes
- [ ] Delete saved sites from user
- [ ] Add option to modify site counter, password template + scope
- [ ] Make simple web app
- [ ] App icon + Finish Makefile

## LICENSE
```
The MIT License (MIT)

Copyright (c) 2024 George Watson

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
