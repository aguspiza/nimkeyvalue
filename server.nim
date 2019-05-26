import httpbeast
import options, asyncdispatch

proc onRequest(req: Request): Future[void] =
  if req.httpMethod == some(HttpGet):
    case req.path.get()
    of "/":
      req.send("Hello World")
    else:
      #redirect to volume server
      req.send(Http302)
  elif req.httpMethod == some(HttpPut):
    req.send("PUTTED")
    req.send(Http201)
  elif req.httpMethod == some(HttpDelete):
    req.send("DELETED")
    req.send(Http202)
    #if (key not found):
    #    req.send(Http204)

let settings = initSettings(Port(3000))

run(onRequest, settings)