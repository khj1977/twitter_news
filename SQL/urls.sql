CREATE TABLE IF NOT EXISTS urls (
  id int not null auto_increment,
  TWEET_ID varchar(128) not null,
  URL varchar(1024) not null,
  TITLE varchar(1024) not null,
  CREATE_TIME datetime not null,
  PRIMARY KEY(id, CREATE_TIME)
) ENGINE=InnoDB PARTITION BY RANGE (to_days(CREATE_TIME)) (
  PARTITION c0 VALUES LESS THAN (to_days("2011-6-15"))
);

CREATE INDEX IDX_URL_001 on urls (TWEET_ID);
CREATE INDEX IDX_URL_002 on urls (CREATE_TIME);
CREATE INDEX IDX_URL_003 on urls (TWEET_ID, CREATE_TIME);