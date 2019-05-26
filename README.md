Shameless copy of geohot's minikeyvalue https://github.com/geohot/minikeyvalue ported to nim

NOTE: minikeyvalue was programmed in python3 originally but it seems it has been rewritten in go

This implementation tries to test how fast can be programmed and how fast it is compared to python3 and go implementation


# Usage

    # put "bigswag" in key "wehave"
    curl -v -L -X PUT -d bigswag localhost:3000/wehave

    # get key "wehave" (should be "bigswag")
    curl -v -L localhost:3000/wehave

    # delete key "wehave"
    curl -v -L -X DELETE localhost:3000/wehave

    # list keys starting with "we"
    curl -v -L localhost:3000/we?list


### minikeyvalue Performance

```
# Fetching non-existent key: 116338 req/sec
wrk -t2 -c100 -d10s http://localhost:3000/key

# go run thrasher.go lib.go
starting thrasher
10000 write/read/delete in 2.620922675s
thats 3815.40/sec
```


### nimkeyvalue Performance

*IMPORTANT: build server.nim with --threads:on -d:realese *

```
# Fetching non-existent key: 197865 req/sec :) my computer??
wrk# ./wrk -t2 -c100 -d10s http://localhost:3000/key/sd
Running 10s test @ http://localhost:3000/key/sd
  2 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.38ms    2.33ms  24.41ms   86.92%
    Req/Sec    99.50k     5.61k  111.64k    71.00%
  1979126 requests in 10.00s, 200.07MB read
Requests/sec: 197865.09
Transfer/sec:     20.00MB


# nim c -r thrasher.nim
starting thrasher
10000 write/read/delete in -
thats -/sec
```
