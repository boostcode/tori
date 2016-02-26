![Tori](https://raw.githubusercontent.com/boostcode/tori/master/.github/tori-logo.jpg)

**A [Kitura](https://github.com/IBM-Swift/Kitura) based framework to develop your custom Backend as a Service in Swift**

[![codebeat badge](https://codebeat.co/badges/8ddbd93f-ef3a-4ccc-9479-23dfbd3fe233)](https://codebeat.co/projects/github-com-boostcode-tori)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Swift 2 compatible](https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

## Summary

[Tori](https://github.com/boostcode/tori) is a web framework that allows you to create **BaaS** for your application, it is a porting of [torii.js](https://github.com/boostcode/torii.js) based on [Kitura](https://github.com/IBM-Swift/Kitura) framework by **IBM** and written in **Swift**.

## Features

- Responsive HTML5 backend



## Installation

In order to run **tori**, you need to install [Kitura](https://github.com/IBM-Swift/Kitura)'s requirements, if you want a ready-to-run env, you can use our [docker](https://github.com/boostcode/swift-ubuntu-docker) development sandbox.

Then proceed in this way:

1) Clone project
```
git clone https://github.com/boostcode/tori
```

2) Build
```
cd tori && swift build && make
```
If any error raises up during ```swift build``` continue instead with make that will fix all those and build the executable

3) Run
```
.build/debug/tori
```

## License
This project is licensed under Apache 2.0. Full license text is available in [LICENSE](https://raw.githubusercontent.com/boostcode/tori/master/LICENSE).
