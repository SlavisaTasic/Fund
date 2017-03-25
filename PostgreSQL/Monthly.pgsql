-- table:
-- date_period | symbol | previous_price | present_price | 
-- previous_price = OR last_price(date_period-1)
--                  OR first_prie(date_period)
-- present_price = last_price(date_period)
-- should be convert to:
-- date_period | symbol | present_price | present_price/previous_price - 1 | 

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
			p.symbol						AS "Symbol",
			date(date_trunc('month', p.dt)) AS "Month",
			first_value(p.dt)    OVER w 	AS "Open Date",
			first_value(p.price) OVER w 	AS "Open Price",
			last_value(p.dt) 	 OVER w		AS "Close Date",
			last_value(p.price)  OVER w		AS "Close Price"
		  FROM PIF_quotes p
		 WHERE p.symbol = var_smbl ---'ALFMVB'
		   AND date_trunc('month', p.dt) 
		       BETWEEN date_trunc('month', var_mnth) - interval '1 month'
		    	   AND date_trunc('month', var_mnth)
		WINDOW w AS (PARTITION BY date_trunc('month', p.dt) ORDER BY p.dt
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
	FROM PIF_Monthly_Prices
	ORDER BY "Month" DESC
	LIMIT 1;
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
	   
