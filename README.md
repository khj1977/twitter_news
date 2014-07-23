# Twitter上の単語分類とWeb UI、Crowler

tweetをstreaming API(garden hose level以上)で取得して時事関連単語を自動抽出する。自動抽出にはLSA(bin/svd/)とkmeans(bin/kmeans/)を使用している。自動抽出の一例を下記に示す。

[example1](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/191072099.png)

Web系のコードは量が少なくてシンプルなので、sinatraを使っている。クローラーは正確にはstreaming apiにアクセスして、もろもろの処理をしている。また、クローラーはバッチ処理で、特にフレームワークは使用していない。バッチ処理はデータ量がそれなりに多くても、うまくさばけるように設計されている。

Web系(sinatra/)、クローラー(bin/crowler/)はRubyで書かれている。

クローラーは大きく二つに分かれていて、Streaming APIにアクセスする部分(bin/crowler/TWSQueueClient.rb)と、tweetを受け取って、各種処理をする部分に分かれている(bin/crowler/TWNewsFlusher.rb)。二つの部分はMQで繋がっていて、各種処理が重くてもStreaming API側が対応できるように設計されている。

Streaming API => クローラー(永続プロセス) => MQ => 各種処理(永続プロセス)

というイメージ。各種処理では例えば、DB insertの高速化のために、MQからのデータをある程度まとめてbulk insertをするなどしている。

収集されたデータを元にLSAとkmeansで単語をクラスタリングしている。

以下にクラスタリングされた単語の例を示す。

[example1](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/191072099.png)
[example2](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/191635883.png)
[example3](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/191683773.png)
[example4](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/192037905.png)
[example5](https://github.com/pcaffeine/algorithm/blob/master/twitter-analysis/example/192041281.png)

この例では単語をクラスタリングしているが、例えばあるサービス内で十分なユーザーの行動のログなどがあればユーザーのクラスタリングも行えると思われる。したがって、Webサービスのデータマイニングにも有用だと思われる。
