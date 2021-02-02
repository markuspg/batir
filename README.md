# Batir

[Batir](https://github.com/markuspg/batir.git) provides code to enable project
automation tasks:

 * a logging format for the build-in logger of Ruby
 * a command abstraction with a platform independent implementation for running
   shell commands and Ruby code
 * command sequences using the same command abstraction as single commands
 * a configuration format for configuration file written in Ruby

## Dependencies

The platform independence for shell commands is achieved with the help of the
[systemu](https://github.com/ahoward/systemu) gem.

Everything else is pure Ruby.

## Install

    sudo gem install batir

## License

The MIT License

Copyright (c) 2007-2012 Vassilis Rizopoulos
Copyright (c) 2021 Markus Prasser

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
