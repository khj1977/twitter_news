CREATE TABLE IF NOT EXISTS tweets (
  id int not null auto_increment,
  TWEET_ID varchar(128) not null,
  TWEET varchar(512) not null,
  GEO1 varchar(32) not null,
  GEO2 varchar(32) not null,
  ICON_URL varchar(1024) not null,
  CREATE_TIME datetime not null,
  PRIMARY KEY(id, CREATE_TIME)
) ENGINE=InnoDB PARTITION BY RANGE (to_days(CREATE_TIME)) (
  PARTITION c0 VALUES LESS THAN(to_days("2011-6-15"))
);

CREATE INDEX IDX_tweets_001 on tweets (TWEET_ID, CREATE_TIME);
