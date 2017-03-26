% #!/usr/local/bin/matlab

clc
clear


%driver = 'org.postgresql.Driver';
%driver = 'postgresql-42.0.0.jre7';
%url = 'jdbc:postgresql://securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com:5432/Securities';
%conn = database('Securities', 'loadout', 'RDS.1PostgreSQL.1LoadOut', ...
%			driver, url)
			
conn = database('Securities', 'loadout', 'RDS.1PostgreSQL.1LoadOut', ...
			'Vendor','PostgreSQL', ...
			'Server', 'securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com', ...
			'PortNumber', 5432);

selectquery = 'SELECT symbol, return FROM PIF_Monthly WHERE symbol= ''ALFMVB'' ORDER BY mnth DESC;';
curs = exec(conn, selectquery, 'MaxRows', 3);
rs = fetch(curs);
res = rs.Data;
numCols = curs.ResultSet.getMetaData().getColumnCount();
colLabels = cell(1,numCols);
for i_col=1:numCols
   colLabels(i_col) = curs.ResultSet.getMetaData().getColumnLabel(i_col);
end    
res.Properties.VariableNames = colLabels;


close(data)
close(conn)