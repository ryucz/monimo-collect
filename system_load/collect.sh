#!/bin/bash
PWD=`pwd`
source "$PWD/../monimo-collect.cfg"
MY_TABLE="dtp_systemload"

# DATA COLLECTING
LOAD=`cat /proc/loadavg`
one=${LOAD:0:4}
five=${LOAD:5:4}
fifteen=${LOAD:10:4}

#every one minute get values and save into hourly, then delete all older values than 60min -> 60DTP per hour

# DATA SAVING
mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS << EOF
USE $MYSQL_DB;
INSERT INTO dtp_systemload (value_one, value_five, value_fifteen) VALUES ($one,$five,$fifteen);
DELETE FROM dtp_systemload
WHERE id NOT IN (
  SELECT id
  FROM (
    SELECT id
    FROM dtp_systemload
    ORDER BY id DESC
    LIMIT 60 -- keep this many records
  ) foo
);
EOF

#every 10th minute, average last ten values, insert into daily average -> 144DTP per day
# IF BLABLABLA


#INSERT INTO davg_systemload (value_one, value_five, value_fifteen)
#	SELECT AVG(value_one), AVG(value_five), AVG(value_fifteen) FROM dtp_systemload ORDER BY id DESC LIMIT 10;
#DELETE OLD DTP


#every midnight average full day, insert into yearly averages -> 365 averages per year

#INSERT INTO yavg_systemload (value_one, value_five, value_fifteen)
#	SELECT AVG(value_one), AVG(value_five), AVG(value_fifteen) FROM davg_systemload ORDER BY id DESC LIMIT 144;
