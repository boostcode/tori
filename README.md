
![Tori](https://raw.githubusercontent.com/boostcode/tori/master/.github/tori-logo.png)

[![Issues](https://img.shields.io/github/issues/boostcode/tori.svg?style=flat)](https://github.com/boostcode/tori/issues)
[![codebeat badge](https://codebeat.co/badges/8ddbd93f-ef3a-4ccc-9479-23dfbd3fe233)](https://codebeat.co/projects/github-com-boostcode-tori)

![Linux](https://img.shields.io/badge/linux-compatible-green.svg?style=flat)
![macOS](https://img.shields.io/badge/macOS-compatible-4BC51D.svg?style=flat)
![Swift 3 compatible](https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat)
[![Build Status](https://travis-ci.org/boostcode/tori.svg?branch=develop)](https://travis-ci.org/boostcode/tori)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

## Summary

[Tori](https://github.com/boostcode/tori) is a web framework that allows you to create **BaaS** for your application, it is a porting of [torii.js](https://github.com/boostcode/torii.js) based on [Kitura](https://github.com/IBM-Swift/Kitura) framework by **IBM** and written in **Swift**.

## Setup

Install Swift **DEVELOPMENT-SNAPSHOT-2016-06-20-a** first.

## Installation

In order to run **tori**, you need to install [Kitura](https://github.com/IBM-Swift/Kitura)'s requirements, if you want a ready-to-run env, you can use our [docker](https://github.com/boostcode/swift-ubuntu-docker) development sandbox.

Then proceed in this way:

1) Clone project
```
git clone https://github.com/boostcode/tori
cd tori
git submodule update --init --recursive
```

2) Build
```
export TORI_CONFIG_DIR=/path/to/tori
make run
```
If any error raises up during ```make``` continue instead till it is finished.

3) Run
```
.build/debug/tori
```

## Credits
Tori is proudly powered by:
- [Kitura](https://github.com/IBM-Swift/Kitura)
- [MongoKitten](https://github.com/PlanTeam/MongoKitten)

## License
This project is licensed under Apache 2.0. Full license text is available in [LICENSE](https://raw.githubusercontent.com/boostcode/tori/master/LICENSE).
