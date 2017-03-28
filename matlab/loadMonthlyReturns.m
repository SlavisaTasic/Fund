% #!/usr/local/bin/matlab

function monthlyReturns = loadMonthlyReturns(varargin)
% LOADMONTHLYRETURNS Load monthly returns
	p = inputParser;
	addOptional(p, 'firstMonth', datestr('2013-01-01', 'yyyy-mm-dd'));
	addOptional(p, 'lastMonth', datestr(now, 'yyyy-mm-dd'));
	parse(p, varargin{:});
	firstMonth = p.Results.firstMonth;
	lastMonth = p.Results.lastMonth;

	list = loadSymbols();
	monthlyReturns = loadAllSymbols(list, 'firstMonth', firstMonth, 'lastMonth', lastMonth);
end


function conn = estimateConnection()
% ESTIMATECONNECTION Estimates connection to Securities database
	conn = database('Securities', 'loadout', 'RDS.1PostgreSQL.1LoadOut', ...
					'Vendor','PostgreSQL', ...
					'Server', 'securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com', ...
					'PortNumber', 5432);
end

function listSymbols = loadSymbols
% LOADSYMBOLS Loads list of all symbols
	conn = estimateConnection;
	query = 'SELECT DISTINCT symbol FROM PIFs WHERE type=''open-end'' ORDER BY symbol;';
	setdbprefs('DataReturnFormat','table');
	curs = exec(conn, query);
	curs = fetch(curs);
	listSymbols = curs.Data;
	listSymbols = listSymbols.symbol;
	close(curs)
	close(conn)
end

function oneSymbol = loadOneSymbol(symbol, varargin)
% LOADONESYMBOL Loads monthly returns of one symbol
	p = inputParser;
	addRequired(p, 'symbol', @ischar);
	addOptional(p, 'firstMonth', datestr('2013-01-01', 'yyyy-mm-dd'));
	addOptional(p, 'lastMonth', datestr(now, 'yyyy-mm-dd'));
	parse(p, symbol, varargin{:});
	firstMonth = p.Results.firstMonth;
	lastMonth = p.Results.lastMonth;
	conn = estimateConnection;
	query = strcat('SELECT mnth, return FROM PIF_Monthly WHERE symbol=''', ...
				   symbol, ...
				   ''' AND mnth BETWEEN ''', firstMonth, ''' AND ''', lastMonth, ...
				   ''' ORDER BY mnth;');
	setdbprefs('DataReturnFormat','table');
	curs = exec(conn, query);
	curs = fetch(curs);
	oneSymbol = curs.Data;
	oneSymbol = timetable(datetime(oneSymbol.mnth), oneSymbol.xReturn, 'VariableNames', {symbol});
	close(curs)
	close(conn)
end

function allSymbols = loadAllSymbols(list, varargin)
% LOADALLSYMBOLS Loads monthly returns of all symbols from list
	p = inputParser;
	addRequired(p, 'list', @iscell);
	addOptional(p, 'firstMonth', datestr('2013-01-01', 'yyyy-mm-dd'));
	addOptional(p, 'lastMonth', datestr(now, 'yyyy-mm-dd'));
	parse(p, list, varargin{:});
	firstMonth = p.Results.firstMonth;
	lastMonth = p.Results.lastMonth;
	for i = 1:length(list)
		oneSymbol = loadOneSymbol(char(list(i)), ...
						 'firstMonth', firstMonth, 'lastMonth', lastMonth);
		if exist('allSymbols')
			allSymbols = outerjoin(allSymbols, oneSymbol);
		else
			allSymbols = oneSymbol;
		end
	end
end
