import asyncdispatch, asyncstreams, httpcore, httpclient, strformat, md5, base64, sequtils, strutils, asyncFutures

func toPath* (key: string) : string =
  let mkey = key.toMd5()
  let b64key = key.encode()

  # 2 byte layers deep, meaning a fanout of 256
  # optimized for 2^24 = 16M files per volume server
  return "/{mkey[0]:02x}/{mkey[1]:02x}/{b64key}".fmt

func key2volume(key : string, volumes : openarray[string]) : string =
  # this is an intelligent way to pick the volume server for a file
  # stable in the volume server name (not position!)
  # and if more are added the correct portion will move (yay md5!)
  var best_score = ""
  var ret = ""
  for v in volumes:
    let hash = key & v
    let score = $hash.toMd5()
    if best_score.len == 0 or best_score.cmp(score) < 0:
      best_score = score
      ret = v
  #echo "{key}, {ret}, {best_score}".fmt
  return ret



# *** Remote Access Functions ***

proc remote_delete(remote: string) {.async.} =
  let client = newAsyncHttpClient()
  let resp = await client.request(remote, "DELETE")

  if resp.status != Http204:
    raise newException(IOError, "remote_delete: wrong status code {resp.status}".fmt)

proc remote_put(remote string, length: int64, bodyStream: FutureStream[string]) {.async.} =
  let client = newAsyncHttpClient()

  #TODO: we should read some amount of bodyStream and write the body in a async way until we have written "length" bytes
  let body = await bodyStream.readAll()
  let resp = await client.request(remote, "PUT", body.substring(length))

  if resp.status != Http201 && resp.status != Http204:
    return raise newException(IOError, "remote_put: wrong status code {resp.status}".fmt)

proc remote_get(remote: string) : Future[string] {.async.} =
  let client = newAsyncHttpClient()
  let resp = await client.get(remote)

  if resp.status != Http200:
    raise newException(IOError,"remote_get: wrong status code {resp.status}".fmt)

  return await resp.bodyStream.readAll()

when isMainModule:
    echo "1234".toPath()
    echo "1234".key2volume(["a", "b"])
    #this is not doing DNS resolution for localhost inside docker!
    #"http://localhost:8888".remote_delete().waitFor()
    try:
      "http://127.0.0.1:8888".remote_delete().waitFor()
    except:
      echo getCurrentExceptionMsg()
    
    try:
      "http://www.google.com".remote_delete().waitFor()
    except:
      echo getCurrentExceptionMsg()
    
    echo "http://www.google.com".remote_get().waitFor()
