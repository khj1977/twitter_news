CREATE TABLE IF NOT EXISTS pop_words (
  id int not null auto_increment,
  WORD varchar(64) not null,
  DF int not null,
  CREATE_TIME datetime not null,
  PRIMARY KEY(id, CREATE_TIME)
) ENGINE=InnoDB PARTITION BY RANGE (to_days(CREATE_TIME)) (
  PARTITION c0 VALUES LESS THAN (to_days("2011-6-15"))
);

CREATE INDEX IDX_pop_words_001 on pop_words (CREATE_TIME, WORD);
CREATE INDEX IDX_pop_words_002 on pop_words (CREATE_TIME);

