-- Monthly Returns

-- CTE, 68 ms
EXPLAIN (ANALYZE ON, BUFFERS ON)
WITH PriceMonthly
AS (
SELECT row_number() OVER (ORDER BY dt) AS period,
	   price,
	   date_part('year', dt) AS year,
	   date_part('month', dt) AS month
  FROM pif_quotes
 WHERE dt IN (SELECT MAX(dt) as a 
        		FROM pif_quotes
    		   GROUP BY date_part('year', dt), date_part('month', dt)
      		  )
   AND symbol='ALFCPT'
)
SELECT year, month,
	   price AS "Present",
	   COALESCE(LAG(price) OVER (ORDER BY year, month), price) AS "Previous",
	   round((price/COALESCE(LAG(price) OVER (ORDER BY year, month), price))-1, 6) AS "Monthly Return"
  FROM PriceMonthly;

-- вложенный запрос, 67 ms
\! clear
EXPLAIN (ANALYZE ON, BUFFERS ON)
SELECT year AS "Year", month AS "Month",
       Present AS "Present",
       Previous AS "Previous",
       round(Present/Previous - 1, 6) AS "Monthly Return" 
  FROM (SELECT row_number() OVER (ORDER BY dt) AS period,
			   price AS Present,
			   COALESCE(LAG(price) OVER (ORDER BY dt), price) AS Previous,
			   date_part('year', dt) AS year,
			   date_part('month', dt) AS month
		  FROM pif_quotes
		 WHERE dt IN (SELECT MAX(dt) as a 
						FROM pif_quotes
					   GROUP BY date_part('year', dt), date_part('month', dt)
			  		  )
		   AND symbol='ALFCPT'
		) x;

-- вложенный запрос, 67 ms
-- test, doesn't work
\! clear
--EXPLAIN (ANALYZE ON, BUFFERS ON)
SELECT year AS "Year", month AS "Month",
       Present AS "Present",
       Previous AS "Previous",
       round(Present/Previous - 1, 6) AS "Monthly Return" 
  FROM (SELECT row_number() OVER (ORDER BY max_dt) AS period,
			   price AS Present,
			   COALESCE(LAG(price) OVER (ORDER BY max_dt), price) AS Previous,
			   date_part('year', max_dt) AS year,
			   date_part('month', max_dt) AS month
		  FROM pif_quotes
		 WHERE (max_dt, min_dt) IN (SELECT MAX(dt) AS max_dt, MIN(dt) AS min_dt 
							FROM pif_quotes
						   GROUP BY date_part('year', dt), date_part('month', dt)
			  		  		)
		   AND symbol='ALFCPT'
		) x;

-- CTE, 68 ms
-- test
\! clear
--EXPLAIN (ANALYZE ON, BUFFERS ON)
WITH PriceMonthly AS (
SELECT row_number() OVER (ORDER BY dt) AS period,
	   price,
	   date_part('year', dt) AS year,
	   date_part('month', dt) AS month
  FROM pif_quotes
 WHERE dt IN (SELECT MAX(dt)
        		FROM pif_quotes
    		   GROUP BY date_part('year', dt), date_part('month', dt)
      		  )
   AND symbol='ALFCPT'
)
SELECT year, month,
	   price AS "Present",
	   COALESCE(LAG(price) OVER (ORDER BY year, month), price) AS "Previous",
	   round((price/COALESCE(LAG(price) OVER (ORDER BY year, month), price))-1, 6) AS "Monthly Return"
  FROM PriceMonthly;


--- window functions:
EXPLAIN (ANALYZE ON, BUFFERS ON)
WITH PIFMonthlyPrices AS (
	SELECT DISTINCT ON (2)
		symbol						  AS "Symbol",
		date(date_trunc('month', dt)) AS "Month",
		first_value(dt)    OVER w 	  AS "Open Date",
		first_value(price) OVER w 	  AS "Open Price",
		last_value(dt) 	   OVER w	  AS "Close Date",
		last_value(price)  OVER w	  AS "Close Price"
	  FROM pif_quotes
	 WHERE symbol = 'ALFMVB'
	WINDOW w AS (PARTITION BY date_trunc('month', dt) ORDER BY dt
				 RANGE BETWEEN UNBOUNDED PRECEDING
						  AND UNBOUNDED FOLLOWING)
	 ORDER BY 2
)
SELECT 
	*,
	round(
		  "Close Price" /
		  COALESCE(
		  		   LAG("Close Price") OVER (ORDER BY date_part('year', "Month"), date_part('month', "Month")),
		  		   "Open Price"
		  		   ) - 1,
		  12)	AS "Return"
FROM PIFMonthlyPrices;





-- trigger --

-- table PIF_Monthly
-- stores PIFs monthly open and close prices
-- and monthly return
-- table:
-- mnth_id | symbol | mnth | open_date | open_price | close_date | close_price | return | 
-- previous_price = OR close_price(date_period-1)
--                  OR open_price(date_period)
-- present_price = close_price(date_period)
-- return = present_price / previous_price - 1
CREATE TABLE PIF_Monthly (
	mnth_id		SERIAL,
	symbol		varchar(6) REFERENCES PIFs,
	mnth		date,
	open_date	date,
	open_price	NUMERIC(19, 2) CHECK (open_price > 0),
	close_date	date,
	close_price	NUMERIC(19, 2) CHECK (close_price > 0),	
	return		NUMERIC(19, 12),
				UNIQUE (symbol, mnth)
);


-- function PIF_Get_Monthly
-- calculates one row of table PIF_Monthly
-- from rows PIF_quotes with one symbol and month
DROP FUNCTION PIF_Get_Monthly(var_smbl varchar, var_mnth date) CASCADE;
CREATE OR REPLACE FUNCTION PIF_Get_Monthly(var_smbl varchar, var_mnth date)
	RETURNS TABLE (
				   symbol		varchar(6),
				   mnth			date,
				   open_date	date,
				   open_price	NUMERIC(19, 2),
				   close_date	date,
				   close_price	NUMERIC(19, 2),	
				   return		NUMERIC(19, 12)
				   )
AS $$
BEGIN
RETURN QUERY
	WITH PIF_Monthly_Prices AS (
		SELECT DISTINCT ON (2)
			p.symbol					  AS "Symbol",
			date(date_trunc('month', dt)) AS "Month",
			first_value(dt)    OVER w 	  AS "Open Date",
			first_value(price) OVER w 	  AS "Open Price",
			last_value(dt) 	   OVER w	  AS "Close Date",
			last_value(price)  OVER w	  AS "Close Price"
		  FROM PIF_quotes p
		 WHERE p.symbol = var_smbl ---'ALFMVB'
		   AND date_trunc('month', p.dt) = date_trunc('month', var_mnth)
		WINDOW w AS (PARTITION BY date_trunc('month', dt) ORDER BY dt
					 RANGE BETWEEN UNBOUNDED PRECEDING
							  AND UNBOUNDED FOLLOWING)
		 ORDER BY 2
	)
	SELECT 
		*,
		round(
			  "Close Price" /
			  COALESCE(
					   LAG("Close Price") OVER (ORDER BY date_part('year', "Month"), date_part('month', "Month")),
					   "Open Price"
					   ) - 1,
			  12)	AS "Return"
	FROM PIF_Monthly_Prices;
END; $$
LANGUAGE plpgsql;


-- function PIF_Update_Monthly
-- updates or insertes rows to table PIF_Monthly
DROP FUNCTION PIF_Update_Monthly() CASCADE;
CREATE OR REPLACE FUNCTION PIF_Update_Monthly() RETURNS trigger AS $$
BEGIN
	if EXISTS (SELECT symbol, mnth
				 FROM PIF_Monthly
				WHERE symbol = NEW.symbol
				  AND mnth = date(date_trunc('month', NEW.dt)))
	then UPDATE PIF_Monthly SET (symbol,
								 mnth,
								 open_date,
								 open_price,
								 close_date,
								 close_price,	
								 return ) = (SELECT *
								 			   FROM PIF_Get_Monthly(NEW.symbol, NEW.dt) )
		  WHERE symbol = NEW.symbol
		    AND mnth = date(date_trunc('month', NEW.dt));
	else INSERT INTO PIF_Monthly (symbol,
								  mnth,
								  open_date,
								  open_price,
								  close_date,
								  close_price,	
								  return )
		 SELECT *
		   FROM PIF_Get_Monthly(NEW.symbol, NEW.dt);
	end if;
	return NEW;
END; $$
LANGUAGE plpgsql;

-- trigger PIF_Trigger_Monthly
-- watches for inserted rows to table PIF_quotes
-- and keeps PIF_Monthly up-to-date
CREATE TRIGGER PIF_Trigger_Monthly AFTER INSERT
    ON PIF_quotes
       FOR EACH ROW
       EXECUTE PROCEDURE PIF_Update_Monthly();
	   
