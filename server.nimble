# Package

version     = "0.1.0"
author      = "aguspiza"
description = "keyvalue distributed server"
license     = "MIT"

bin = @["server", "volume"]

# Deps

requires "nim >= 0.19.4", "httpbeast >= 0.2.2", "nimleveldb >= 0.0.1", "fmt"