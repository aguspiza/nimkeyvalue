FROM nimlang/nim:0.19.4

RUN chmod +x /bin/nimble

RUN apt update && apt install -y net-tools curl build-essential libssl-dev git
