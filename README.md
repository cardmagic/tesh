# tesh

A highly dynamic object-oriented shell environment built specifically for programmers

## Installation

```console
$ git clone git@github.com:cardmagic/tesh.git
$ cd tesh
$ crystal build
$ mv tesh /usr/local/bin
$ tesh
```

## Usage

Tesh is built to look and feel like bash almost all the time.

```console
$ echo hello world
hello world
```
But then add various programming primitives and object-oriented classes that engineers expect.

```console
$ echo 1 + 2
3
```

Manipulating data becomes very natural for anyone familiar with Javascript, Ruby or Python.

```console
$ ls
foo      bar     baz
$ ls.upcase
FOO      BAR     BAZ
$ ls.split[1]
bar
$ ls.split.map { |i| i.capitalize }
Foo      Bar     Baz
$ (ls -la).split.first
drwxr-xr-x
$ if ls.split.last.present?; then
  cd ls.split.last
fi
```

## Contributing

1. Fork it (<https://github.com/cardmagic/lucash/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lucas Carlson](https://github.com/cardmagic) - creator and maintainer
