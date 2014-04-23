# Twitter上の単語分類とWeb UI、Crowler

tweetをstreaming API(garden hose level以上)で取得して時事関連単語を自動抽出する。自動抽出にはLSAとkmeansを使用している。

Web系のコードは量が少なくてシンプルなので、sinatraを使っている。クローラーは正確にはstreaming apiにアクセスして、もろもろの処理をしている。また、クローラーはバッチ処理で、特にフレームワークは使用していない。

Web系、クローラーはRubyで書かれている。

クローラーは大きく二つに分かれていて、Streaming APIにアクセスする部分と、tweetを受け取って、各種処理をする部分に分かれている。二つの部分はMQで繋がっていて、各種処理が重くてもStreaming API側が対応できるように設計されている。

