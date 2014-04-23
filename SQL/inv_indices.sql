CREATE TABLE IF NOT EXISTS inv_indices (
  id int not null auto_increment,
  WORD varchar(64) not null,
  TWEET_ID varchar(128) not null,
  CREATE_TIME datetime not null,
  PRIMARY KEY(id, CREATE_TIME)
) ENGINE=InnoDB PARTITION BY RANGE (to_days(CREATE_TIME)) (
  PARTITION c0 VALUES LESS THAN (to_days("2011-6-15"))
);

CREATE INDEX IDX_inv_indices_001 on inv_indices (WORD, TWEET_ID);
CREATE INDEX IDX_inv_indices_002 on inv_indices (CREATE_TIME);
