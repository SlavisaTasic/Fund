
listSymbols = loadSymbols

function loadGroups()
% LOADGROUPS
% LowerGroup <= GroupMatrix * Port <= UpperGroup
% obj = setGroups(obj,GroupMatrix,LowerGroup,UpperGroup) 
	conn = estimateConnection()
	
	query = 'SELECT DISTINCT symbol FROM PIFs WHERE type=''open-end'' ORDER BY symbol;';
	setdbprefs('DataReturnFormat','table');
	curs = exec(conn, query);
	curs = fetch(curs);
	listSymbols = curs.Data;
	listSymbols = listSymbols.symbol;
	close(curs)
	close(conn)

end

