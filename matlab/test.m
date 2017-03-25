#!/usr/local/bin/matlab

clc
clear

datasource = 'Securities';
username = 'loadout';
password = 'pwd';
driver = 'org.postgresql.Driver';
url = 'jdbc:postgresql://securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com:5432/Securities';

conn = database(datasource, username, password, driver, url)

selectquery = "SELECT * FROM PIF_Monthly WHERE symbol= 'ALFMVB' ORDER BY mnth DESC";
data = select(conn, selectquery)

