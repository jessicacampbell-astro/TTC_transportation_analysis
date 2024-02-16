-- 0. Data cleaning and preparation.

-- inspect table structures

-- 2022 delays
DESC delays_2022;

-- 2023 delays
DESC delays_2023;

-- delay codes
DESC delay_codes;

-- inspect readme file

SELECT *
FROM delay_readme;

-- replace spaces with underscores in column names

ALTER TABLE delays_2022
RENAME COLUMN `Min Delay` TO Min_Delay;

ALTER TABLE delays_2022
RENAME COLUMN `Min Gap` TO Min_Gap;

ALTER TABLE delays_2023
RENAME COLUMN `Min Delay` TO Min_Delay;

ALTER TABLE delays_2023
RENAME COLUMN `Min Gap` TO Min_Gap;

-- shorten column names

ALTER TABLE delay_codes
RENAME COLUMN `SUB RMENU CODE` TO CODE;

ALTER TABLE delay_codes
RENAME COLUMN `CODE DESCRIPTION` TO DESCRIPTION;

-- Stations required extensive cleaning: many of these lacked delay and vehicle information, station names that do not correspond to locations that are accessible to typical passengers, refer to entire subway lines rather than individual stations, typos, and additional information that caused confusion; such records were discarded.

-- distinct station names for 2022
SELECT DISTINCT(Station)
FROM delays_2022
ORDER BY Station;

-- distinct station names for 2023
SELECT DISTINCT Station, Line
FROM delays_2023
ORDER BY Station, Line;

-- turn off safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Separate BD-YU where possible and remove the rest
-- Bloor station: YU (Line 1)
-- Yonge station: BD (Line 2)

-- -------------------- 2022 --------------------

UPDATE delays_2022
	SET Station='BLOOR STATION'
	WHERE (Station = 'BLOOR/YONGE' AND Line = 'YU')
	OR (Station = 'BLOOR STATION TO YORK' AND Line = 'YU')
	OR (Station = 'YONGE AND BLOOR'	AND Line = 'YU')
	OR (Station = 'YONGE UNIVERSITY / BLO' AND Line = 'YU')
	OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU')
	OR (Station = 'YONGE/UNIVERSITY AND B' AND Line = 'YU');

UPDATE delays_2022
	SET Station='YONGE STATION'
	WHERE (Station = 'YONGE AND BLOOR' AND Line = 'BD');

-- 353 RECORDS
DELETE
FROM delays_2022
WHERE (Station = 'YONGE UNIVERSITY AND B' AND Line = 'YU/BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'BD/YU')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'Y/BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU / BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU & BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU/BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU/BD LINE')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU/BD LINES')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YUS AND BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YUS/BD')
OR (Station = 'YONGE-UNIVERSITY/BLOOR' AND Line = 'YU/BD')
OR (Station = 'YONGE/UNIVERSITY AND B' AND Line = 'YU/BD');

-- -------------------- 2023 --------------------

-- 16 records
UPDATE delays_2023
	SET Station='BLOOR STATION'
	WHERE (Station = 'YONGE AND BLOOR' AND Line = 'YU')
	OR (Station = 'YONGE AND BLOOR STATIO' AND Line = 'YU')
	OR (Station = 'YONGE UNIVERSITY AND B' AND Line = 'YU')
	OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU')
	OR (Station = 'EARLY CLOSURE - YONGE' AND Line = 'YU');

	-- 453 records
	UPDATE delays_2023
		SET Station='YONGE STATION'
		WHERE (Station = 'YONGE & BLOOR STATION' AND Line = 'BD')
		OR (Station = 'BLOOR YU / YONGE BD ST' AND Line = 'BD')
		OR (Station = 'BLOOR-DANFORTH SUBWAY' AND Line = 'BD');

-- 334 RECORDS
DELETE
FROM delays_2023
WHERE (Station = 'YONGE UNIVERSITY BLOOR' AND Line = 'YU/BD')
OR (Station = 'YONGE UNIVERSITY AND B' AND Line = 'YU/BD')
OR (Station = 'YONGE-BLOOR' AND Line = '')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU / BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YU/BD')
OR (Station = 'YONGE-UNIVERSITY AND B' AND Line = 'YUS/BD')
OR (Station = 'YONGE-UNIVERSITY AND BL' AND Line = 'YU/BD')
OR (Station = 'YONGE-UNIVERSTY AND BL' AND Line = 'YU/BD');

-- 635 records affected
DELETE
FROM delays_2022
WHERE Station IN ('ALL OPEN CUTS', 'BD LINE CHANGEOVERS', 'BETWEEN SHEPPARD AND S', 'BLOOR DANFORTH LINE', 'BLOOR DANFORTH SUBWAY', 'BLOOR-DANFORTH', 'BLOOR-DANFORTH LINE', 'BLOOR/DANFORTH LINE', 'BLOOR/DANFORTH AND YON', 'BROADVIEW CENTRE TRACK', 'CLOSURE FINCH TO ST CL', 'DANFORTH', 'DANFORTH DIVISION', 'DAVISVILLE CAR HOUSE', 'DAVISVILLE CARHOUSE', 'DAVISVILLE YARD', 'EGLINTON BUS TERMINAL', 'EGLINTON MIGRATION', 'EGLINTON (MIGRATION)', 'EGLINTON MIGRATION POI', 'EGLINTON PSUDO STATION', 'EGLINTON STATION (MIGR', 'GLENAYR EMERGENCY EXIT', 'GREENWOOD CAR HOUSE', 'GREENWOOD CARHOUSE', 'GREENWOOD COMPLEX - TR', 'GREENWOOD PORTAL', 'GREENWOOD SHOPS', 'GREENWOOD WYE', 'GREENWOOD WYE DEPARTIN', 'GREENWOOD YARD', 'GUNN BUILDING', 'GUNN BUILDING - 3RD FL', 'KEELE YARD', 'LINE 1 BLOOR TO QUEEN', 'LINE 1 YONGE UNIVERSIT', 'LINE 1 YONGE-UNIVERSIT', 'LINE 2 BLOOR DANFORTH', 'LINE 3', 'LINE 3 - KENNEDY TO LA', 'LINE 3 - KENNEDY TO MC', 'LINE 3 - SCARBOROUGH R', 'LINE 3 SCARBOROUGH SRT', 'LINE 3 SRT', 'MAINLINE STORAGE', 'MCBRIEN BUILDING', 'MCCOWAN CARHOUSE', 'MCCOWAN YARD', 'MIGRATION POINT', 'MIGRATION POINT EGLINT', 'N/B TOWARDS FINCH', 'N/O SUMMERHILL TO S/O', 'NORTH HOSTLER', 'OSGOODE STATION POCKET', 'OSSINGTON CENTRE TRACK', 'QUEEN''S QUAY - UNION', 'QUEEN''S QUAY LOOP', 'QUEENS QUAY LOOP', 'QUEEN''S QUAY STATION (', 'QUEENS QUAY STATION (', 'SCARBOROUGH RAPID LINE', 'SCARBOROUGH RAPID TRAN', 'SHEPPARD DISTRIBUTION', 'SHEPPARD DISTRUBTION', 'SHEPPARD LINE', 'SHEPPARD-YONGE AND DON', 'SHEPPARD-YONGE LINE 4', 'SOUTH BOUND SOUTH OF L', 'SRT - LINE 3', 'SRT LINE', 'STATION', 'SYSTEM WIDE', 'TORONTO TRANSIC COMMIS', 'TORONTO TRANSIT COMMIS', 'TORONTO TRANSIT CONTRO', 'TRANSIT CONTROL', 'TRANSIT CONTROL CENTRE', 'VIADUCT', 'VMC TO LAWRENCE', 'WILSON CARHOUSE', 'WILSON DIVISION', 'WILSON GARAGE', 'WILSON HOLSER', 'WILSON HOSTLER', 'WILSON NORTH HOSTLER', 'WILSON SOUTH HOSTLER', 'WILSON TRACK & STRUCTU', 'WILSON TRACK AND STRUC', 'WILSON YARD', 'WILSON YARD CARHOUSE', 'WILSON YARD HOSTLER 2', 'YONGE UNIVERSITY LINE', 'YONGE - UNIVERSITY SUB', 'YONGE / UNIVERSITY / S', 'YONGE STATION TO GREEN', 'YONGE UNIVERSITY LINE', 'YONGE UNIVERISTY LINE', 'YONGE UNIVERSITY SUBWAY', 'YONGE UNIVERSITY SUBWA', 'YONGE UNIVERSTY SUBWAY', 'YONGE- UNIVERSITY AND', 'YONGE-UNIVERSITY', 'YONGE-UNIVERSITY LINE', 'YONGE-UNIVERSITY SUBWA', 'YONGE/UNIVERSITY - LIN', 'YORK MILLS CENTRE TRAC', 'YUS AND BLOOR DANFORTH', 'YUS/ BD');

-- 432 records affected
DELETE
FROM delays_2023
WHERE Station IN ('1 TIPPETT ROAD', '1900 YONGE STREET', 'BIRCHMOUNT EE', 'BIRCHMOUNT EMERGENCY E', 'BLOOR DANFORTH LINE', 'BLOOR-DANFORTH SUBWAY', 'BLOOR HUB', 'BLOOR-DANFORTH LINE', 'BLOOR STATION-DUNDAS S', 'BLOOR YU / YONGE BD ST', 'BROADVIEW CENTRE TRACK', 'CHESTER CENTRE TRACK', 'CHRISTIE CENTER', 'CLANTON PORTAL TO EGLI', 'CLOSURE- VICTORIA PARK', 'CNE EAST LOOP', 'DANFORTH DIVISION', 'DANFORTH DIVSION', 'DAVISVILLE BUILD UP', 'DAVISVILLE BUILD-UP', 'DAVISVILLE BUILDUP', 'DAVISVILLE CARHOUSE', 'DAVISVILLE YARD', 'DUFFERIN AND DUFFERIN', 'DUNCAN BUILDING', 'EARLY CLOSURE - YONGE', 'EGLINTON GARAGE', 'FINCH TOWER', 'GREENWOOD CARHOUSE', 'GREENWOOD CAR HOUSE', 'GREENWOOD COMPLEX', 'GREENWOOD PLANT BUILDI', 'GREENWOOD SHOP', 'GREENWOOD SHOPS', 'GREENWOOD SHOPS.', 'GREENWOOD T&S BUILDING', 'GREENWOOD TRACK BUILDI', 'GREENWOOD TRACK&STRUCT', 'GREENWOOD WYE', 'GREENWOOD YARD', 'GREEENWOOD YARD', 'GUNN BUILDING', 'GUNN BUILDING - 2ND FL', 'GUNN THEATRE', 'HIGH PARK - KEELE', 'HWY 407 & DOWNSVIEW PA', 'HILLCREST - SUBWAY OPE', 'JANE AND DUFFERIN', 'KIPLING HUB', 'KEELE YARD', 'KIPLING TAIL TRACK 2', 'LAKESHORE AND YORK', 'LINE 1', 'LINE 1 YU', 'LINE 1 YONGE UNIVERSIT', 'LINE 1 YONGE-UNIVERSIT', 'LINE 1 YUS', 'LINE 1 YUS (YORK MILLS', 'LINE 2', 'LINE 2 - BD', 'LINE 1 - YONGE-UNIVERS', 'LINE 2 BD', 'LINE 2 BLOOR-DANFORTH', 'LINE 2 - BLOOR-DANFORT', 'LINE 3', 'LINE 3 SCARBOROUGH', 'LINE 3 SCARBOROUGH SRT', 'LINE 3 SRT', 'LINE 4', 'LYTTON EE', 'MC BRIEN', 'MAC DONALD CARTIER EE', 'MCBRIEN BUILDING', 'MCCOWAN YARD', 'MUSEUM STATION ST. GEO', 'N/O DAVISVILLE STATION', 'NORTH HOSTLER (LEAVING', 'OSGOODE POCKET', 'OSSINGTON CENTRE TRACK', 'QUEENS QUAY ELEVATOR', 'QUEENS QUAY STATION', 'SAFE APP', 'SCARBOROUGH RAPID TRAN', 'SCARBOROUGH RT', 'SCARBOROUGH SRT', 'SHEPPARD - YONGE (LINE', 'SHEPPARD TO ST CLAIR S', 'SHEPPARD WEST EE (3940', 'SHEPPARD-YONGE TAIL TR', 'SLOW ZONE LAWRENCE EAS', 'SPADINA AND ADELAIDE', 'SPADINA AND DUNDAS', 'SRT LINE', 'SRT LINE 3', 'SRT YARD', 'ST CLAIR - ROSEDALE', 'SYSTEM WIDE', 'TORONTO TRANSIT COMMIS', 'TRACK LEVEL ACTIVITY', 'TRANSIT CONTROL', 'UNION - UNIVERSITY', 'UNION AND HIGHWAY 407', 'UNION AND LESLIE', 'UNION HUB', 'UNION STATION - FINCH', 'UNION STATION-KING', 'UNIVERSITY AND QUEEN', 'WEEKEND CLOSURE ISLING', 'WEEKEND CLOSURE- ST AN', 'WEEKEND CLOSURE- ST GE', 'WELLBECK EE', 'WILSON CARHOUSE', 'WILSON CAR HOUSE', 'WILSON GARAGE', 'WILSON HOSTLER', 'WILSON NORTH HOSTLER', 'WILSON SOUTH HOSTLER', 'WILSON PLANT T&S', 'WILSON YARD', 'WILSON YARD - WALKWAY', 'WILSON YARD (TRACK 43)', 'WILSON YARD TRACK 3', 'WOODBINE - KENNEDY', 'YONGE AND BLOOR', 'YONGE AND BLOOR STATIO', 'YONGE & BLOOR STATION', 'YONGE BD STATION', 'YONGE UNIVERSITY SUBWA', 'YONGE UNIVERSITY - BLO', 'YONGE UNIVERSITY AND B', 'YONGE UNIVERSITY BLOOR', 'YONGE- UNIVERSITY AND', 'YONGE-BLOOR', 'YONGE-UNIVERSITY AND BL', 'YONGE UNIVERSITY LINE', 'YONGE UNIVERSITY LINE/', 'YONGE UNIVERSITY SUBWA', 'YONGE UNIVERISTY SUBWA', 'YONGE UNIVERSITY/BLOOR', 'YONGE UNIVRESITY/BLOOR', 'YONGE-UNIVERSTY AND BL', 'YONGE-UNIVERSITY AND B', 'YONGE-UNIVERSITY LINE', 'YONGE/UNIVERSITY SUBWA', 'YONGE/UNIVERSITY/SPADI', 'YOUNG UNIVERSITY SPADI', 'YONGE UNIVERSITY SPADI', 'YU/BD');

-- Rename station name records for consistency.

-- -------------------- 2022 --------------------

UPDATE delays_2022
	SET Station='BAY STATION'
	WHERE Station LIKE 'BAY %';

UPDATE delays_2022
	SET Station='BAYVIEW STATION'
	WHERE Station LIKE 'BAYVIEW%';

UPDATE delays_2022
	SET Station='BROADVIEW STATION'
	WHERE Station LIKE 'BROADVIEW%';

UPDATE delays_2022
	SET Station='CASTLE FRANK STATION'
	WHERE Station LIKE 'CASTLE FRANK%';

UPDATE delays_2022
	SET Station='CHESTER STATION'
	WHERE Station LIKE 'CHESTER%';

UPDATE delays_2022
	SET Station='CHRISTIE STATION'
	WHERE Station LIKE 'CHRISTIE%';

UPDATE delays_2022
	SET Station='COLLEGE STATION'
	WHERE Station LIKE 'COLLEGE%';

UPDATE delays_2022
	SET Station='DAVISVILLE STATION'
	WHERE Station LIKE 'DAVISVILLE%';

UPDATE delays_2022
	SET Station='DOWNSVIEW PARK STATION'
	WHERE Station='DOWNVIEW PARK STATION';

UPDATE delays_2022
	SET Station='DUFFERIN STATION'
	WHERE Station LIKE 'DUFFERIN%';

UPDATE delays_2022
	SET Station='DUNDAS WEST STATION'
	WHERE Station LIKE 'DUNDAS WEST%';

UPDATE delays_2022
	SET Station='DUPONT STATION'
	WHERE Station LIKE 'DUPONT%';

UPDATE delays_2022
	SET Station='DUNDAS STATION'
	WHERE Station LIKE 'EATON CENTRE%';

UPDATE delays_2022
	SET Station='EGLINTON STATION'
	WHERE Station LIKE 'EGLINTON TO%';

UPDATE delays_2022
	SET Station='FINCH STATION'
	WHERE Station LIKE 'FINCH%'
	AND STATION NOT LIKE 'FINCH WEST%';

UPDATE delays_2022
	SET Station='GLENCAIRN STATION'
	WHERE Station LIKE 'GLEN%';

UPDATE delays_2022
	SET Station='HIGH PARK STATION'
	WHERE Station LIKE 'HIGH PARK%';

UPDATE delays_2022
	SET Station='ISLINGTON STATION'
	WHERE Station LIKE 'ISLINGTON%';

UPDATE delays_2022
	SET Station='JANE STATION'
	WHERE Station LIKE 'JANE%';

UPDATE delays_2022
	SET Station='KENNEDY STATION'
	WHERE Station LIKE 'KENNEDY%';

UPDATE delays_2022
	SET Station='KING STATION'
	WHERE Station LIKE 'KING%';

UPDATE delays_2022
	SET Station='KIPLING STATION'
	WHERE Station LIKE 'KIPLING%';

UPDATE delays_2022
	SET Station='LANSDOWNE STATION'
	WHERE Station LIKE 'LANSDOWNE%';

UPDATE delays_2022
	SET Station='LAWRENCE WEST STATION'
	WHERE Station LIKE 'LAWRENCE WEST%'
	OR STATION LIKE 'LAWRECNE WEST%';

UPDATE delays_2022
	SET Station='LAWRENCE EAST STATION'
	WHERE Station LIKE 'LAWRENCE EAST%';

UPDATE delays_2022
	SET Station='LAWRENCE STATION'
	WHERE Station LIKE 'LAWRENCE TO%'
	OR STATION LIKE 'LAWRENCE STATION TO%';

UPDATE delays_2022
	SET Station='MAIN STREET STATION'
	WHERE Station LIKE 'MAIN%';

UPDATE delays_2022
	SET Station='MCCOWAN STATION'
	WHERE Station LIKE 'MC%';

UPDATE delays_2022
	SET Station='MIDLAND STATION'
	WHERE Station LIKE 'MIDLAND%';

UPDATE delays_2022
	SET Station='MUSEUM STATION'
	WHERE Station LIKE 'MUSEUM%';

UPDATE delays_2022
	SET Station='NORTH YORK CENTRE STATION'
	WHERE Station LIKE 'NORTH YORK%';

UPDATE delays_2022
	SET Station='PIONEER VILLAGE STATION'
	WHERE Station LIKE 'PIONEER%';

UPDATE delays_2022
	SET Station='QUEEN''S PARK STATION'
	WHERE Station LIKE 'QUEENS PARK%';

UPDATE delays_2022
	SET Station='SCARBOROUGH CENTRE STATION'
	WHERE Station LIKE 'SCARB%';

UPDATE delays_2022
	SET Station='SHEPPARD WEST STATION'
	WHERE Station LIKE 'SHEPPARD WEST%';

UPDATE delays_2022
	SET Station='SHEPPARD-YONGE STATION'
	WHERE Station LIKE 'SHEPPARD TO%';

UPDATE delays_2022
	SET Station='SHEPPARD-YONGE STATION'
	WHERE Station LIKE 'YONGE/SHEPPARD%'

UPDATE delays_2022
	SET Station='SPADINA STATION'
	WHERE Station LIKE 'SPADINA%';

UPDATE delays_2022
	SET Station='ST ANDREW STATION'
	WHERE Station LIKE 'ST ANDREW%';

UPDATE delays_2022
	SET Station='ST CLAIR STATION'
	WHERE Station LIKE 'ST CLAIR%'
	AND Station NOT LIKE 'ST CLAIR WEST%';

UPDATE delays_2022
	SET Station='UNION STATION'
	WHERE Station LIKE 'UNION%';

UPDATE delays_2022
	SET Station='SPADINA STATION'
	WHERE Station = 'YONGE UNIVERSITY SPADI'
	OR Station = 'YONGE-UNIVERSITY SPADI'
	OR Station = 'YONGE-UNIVERSITY-SPADI';

UPDATE delays_2022
	SET Station='ST GEORGE STATION'
	WHERE Station LIKE 'ST GEORGE%'
	OR Station LIKE 'ST. GEORGE%';

UPDATE delays_2022
	SET Station='SUMMERHILL STATION'
	WHERE Station LIKE 'SUMMER%';

UPDATE delays_2022
	SET Station='VAUGHAN STATION'
	WHERE Station LIKE 'VAUGHAN%';

UPDATE delays_2022
	SET Station='VICTORIA PARK STATION'
	WHERE Station LIKE 'VICTORIA PARK%';

UPDATE delays_2022
	SET Station='WARDEN STATION'
	WHERE Station LIKE 'WARDEN%';

UPDATE delays_2022
	SET Station='WILSON STATION'
	WHERE Station LIKE 'WILSON%';

UPDATE delays_2022
	SET Station='WOODBINE STATION'
	WHERE Station LIKE 'WOODBINE%';

UPDATE delays_2022
	SET Station='YORK MILLS STATION'
	WHERE Station LIKE 'YORK MILLS%';

UPDATE delays_2022
	SET Station='YORK UNIVERSITY STATION'
	WHERE Station LIKE 'YORK UNIVERSITY%';

UPDATE delays_2022
	SET Station='YONGE STATION'
	WHERE Station LIKE 'YONGE BD %'
	OR Station = 'YONGE';

-- -------------------- 2023 --------------------

UPDATE delays_2023
	SET Station='BLOOR STATION'
	WHERE Station LIKE 'BLOOR STATION TO%'
	OR Station LIKE 'BLOOR TO%';

UPDATE delays_2023
	SET Station='EGLINTON WEST STATION'
	WHERE Station LIKE 'ALLEN ROAD%';

	UPDATE delays_2023
		SET Station='EGLINTON WEST STATION'
		WHERE Station = 'ALLEN ROAD AND EGLINTO';

UPDATE delays_2023
	SET Station='OLD MILL STATION'
	WHERE Station LIKE 'APPROCHING OLD MILL%';

UPDATE delays_2023
	SET Station='BATHURST STATION'
	WHERE Station LIKE 'BATHURST%';

UPDATE delays_2023
	SET Station='BAY STATION'
	WHERE Station LIKE 'BAY %';

UPDATE delays_2023
	SET Station='BROADVIEW STATION'
	WHERE Station LIKE 'BROADVIEW%'
	OR Station LIKE 'BRAODVIEW%';

UPDATE delays_2023
	SET Station='DAVISVILLE STATION'
	WHERE Station LIKE 'DAVISVILLE%';

UPDATE delays_2023
	SET Station='DOWNSVIEW PARK STATION'
	WHERE Station LIKE 'DOWNSVIEW%';

UPDATE delays_2023
	SET Station='EGLINTON STATION'
	WHERE (Station LIKE 'EGLINTON%'	AND Station NOT LIKE 'EGLINTON WEST%')
	OR (Station = 'YONGE AND EGLINTON (EG');

UPDATE delays_2023
	SET Station='EGLINTON WEST STATION'
	WHERE Station LIKE 'EGLINTON WEST%';

UPDATE delays_2023
	SET Station='FINCH STATION'
	WHERE (Station LIKE 'FINCH%')
	AND (Station NOT LIKE 'FINCH WEST%');

UPDATE delays_2023
	SET Station='FINCH STATION'
	WHERE (Station = 'PLATFORM 2 FINCH');

UPDATE delays_2023
	SET Station='GLENCAIRN STATION'
	WHERE Station LIKE 'GLEN%';

UPDATE delays_2023
	SET Station='GREENWOOD STATION'
	WHERE Station LIKE 'GREENWOOD%';

UPDATE delays_2023
	SET Station='HIGH PARK STATION'
	WHERE Station LIKE 'HIGH PARK%';

UPDATE delays_2023
	SET Station='ISLINGTON STATION'
	WHERE (Station LIKE 'ISLINTON%')
	OR (Station LIKE 'ISLINGTON TO%');

UPDATE delays_2023
	SET Station='JANE STATION'
	WHERE Station LIKE 'JANE TO%';

UPDATE delays_2023
	SET Station='KENNEDY STATION'
	WHERE Station LIKE 'KENNEDY%';

UPDATE delays_2023
	SET Station='KING STATION'
	WHERE Station LIKE 'KING%';

UPDATE delays_2023
	SET Station='KIPLING STATION'
	WHERE Station LIKE 'KIPLING%';

UPDATE delays_2023
	SET Station='ST GEORGE STATION'
	WHERE Station = 'LATE OPENING - ST. GEO';

UPDATE delays_2023
	SET Station='LAWRENCE EAST STATION'
	WHERE Station LIKE 'LAWRENCE EAST%';

UPDATE delays_2023
	SET Station='LAWRENCE STATION'
	WHERE Station = 'LAWRENCE'
	OR Station LIKE 'LAWRENCE TO%';

UPDATE delays_2023
	SET Station='MCCOWAN STATION'
	WHERE Station LIKE 'MC%';

UPDATE delays_2023
	SET Station='MIDLAND STATION'
	WHERE Station LIKE 'MIDLAND%';

UPDATE delays_2023
	SET Station='MUSEUM STATION'
	WHERE Station LIKE 'MUSEUM%';

UPDATE delays_2023
	SET Station='NORTH YORK CENTRE STATION'
	WHERE Station LIKE 'NORTH YORK%';

UPDATE delays_2023
	SET Station='OSSINGTON STATION'
	WHERE Station LIKE 'OSSINGTON%';

UPDATE delays_2023
	SET Station='PAPE STATION'
	WHERE (Station LIKE 'PAPE%')
	OR (Station = 'LEAVING PAPE');

UPDATE delays_2023
	SET Station='PIONEER VILLAGE STATION'
	WHERE Station LIKE 'PIONEER VILLAGE%';

UPDATE delays_2023
	SET Station='QUEEN STATION'
	WHERE Station LIKE 'QUEEN %';

UPDATE delays_2023
	SET Station='QUEEN''S PARK STATION'
	WHERE Station LIKE 'QUEENS%';

UPDATE delays_2023
	SET Station='ROSEDALE STATION'
	WHERE Station LIKE 'ROSEDALE%';

	UPDATE delays_2023
		SET Station='ROSEDALE STATION'
		WHERE Station LIKE 'ROXBOROUGH%';

UPDATE delays_2023
	SET Station='SCARBOROUGH CENTRE STATION'
	WHERE Station LIKE 'SCARB%';

	UPDATE delays_2023
		SET Station='SHEPPARD STATION'
		WHERE (Station = 'SHEPPARD STATION - EGL')
		OR (Station LIKE 'SHEPPARD TO%');

UPDATE delays_2023
	SET Station='SHEPPARD WEST STATION'
	WHERE Station LIKE 'SHEPPARD WEST%';

UPDATE delays_2023
	SET Station='SHEPPARD-YONGE STATION'
	WHERE (Station LIKE 'SHEPPARD STATION TO%')
	OR (Station='SHEPPARD STATION')
	OR (Station = 'YONGE SHEPPARD STATION')
	OR (Station = 'YONGE SHEPPARD TO EGLI');

UPDATE delays_2023
	SET Station='SPADINA STATION'
	WHERE Station LIKE 'SPADINA%';

UPDATE delays_2023
	SET Station='ST ANDREW STATION'
	WHERE Station LIKE 'ST ANDREW%';

UPDATE delays_2023
	SET Station='ST CLAIR STATION'
	WHERE (Station LIKE 'ST CLAIR%')
	AND (Station NOT LIKE 'ST CLAIR WEST%');

UPDATE delays_2023
	SET Station='ST CLAIR STATION'
	WHERE (Station = 'ST. CLAIR STATION APP')
	OR (Station = 'ST. CLAIR STATION (APP');

UPDATE delays_2023
	SET Station='ST CLAIR WEST STATION'
	WHERE (Station = 'ST. CLAIR WEST')
	OR (Station LIKE 'ST. CLAIR WEST TO %');

UPDATE delays_2023
	SET Station='ST GEORGE STATION'
	WHERE Station LIKE 'ST GEORGE%'
	OR Station LIKE 'ST. GEORGE%'
	OR Station LIKE 'ST.GEORGE%';

UPDATE delays_2023
	SET Station='UNION STATION'
	WHERE Station LIKE 'UNION%';

UPDATE delays_2023
	SET Station='VAUGHAN STATION'
	WHERE Station LIKE 'VAUGHAN%';

UPDATE delays_2023
	SET Station='OSGOODE STATION'
	WHERE Station = 'UNIVERSITY AND QUEEN';

UPDATE delays_2023
	SET Station='VAUGHAN MC STATION'
	WHERE Station LIKE 'VAUGHAN MC%';

UPDATE delays_2023
	SET Station = 'SPADINA STATION'
	WHERE Station = 'YONGE- UNIVERSITY SPAD';

UPDATE delays_2023
	SET Station='WOODBINE STATION'
	WHERE Station LIKE 'WOODBINE%';

UPDATE delays_2023
	SET Station='DUNDAS STATION'
	WHERE Station = 'YONGE AND DUNDAS';

UPDATE delays_2023
	SET Station='WILSON STATION'
	WHERE Station LIKE 'WILSON TO %';

UPDATE delays_2023
	SET Station='YORK MILLS STATION'
	WHERE Station LIKE 'YORK MILLS%';

UPDATE delays_2023
	SET Station='YORK UNIVERSITY STATION'
	WHERE Station LIKE 'YORK UNI%';

-- Clean lines

-- -------------------- 2022 --------------------

-- Improper Lines for 2022

-- delete stations at major interchanges with incorrect or missing line designations for 2022 (4 records deleted)
DELETE
FROM delays_2022
WHERE (Station IN ('ST GEORGE STATION', 'SPADINA STATION') AND Line IN ('', 'YU/BD'))
OR (Station = 'SPADINA STATION' AND Line = 'SHP');

-- delete records associated with improper station names from 2022
DELETE
FROM delays_2022
WHERE Line IN ('506 CARLTON', '57 MIDLAND', '69 WARDEN SOUTH', '96 WILSON', 'LINE 2 SHUTTLE');

-- stations along the YU line with the incorrect line designation for 2022

SELECT DISTINCT(Station), Line
FROM delays_2022
-- stations uniquely on the YU line
WHERE Station IN ('BLOOR STATION', 'COLLEGE STATION', 'DAVISVILLE STATION', 'DOWNSVIEW PARK STATION', 'DUNDAS STATION', 'DUPONT STATION', 'EGLINTON STATION', 'EGLINTON WEST STATION', 'FINCH STATION', 'FINCH WEST STATION', 'GLENCAIRN STATION', 'HIGHWAY 407 STATION', 'KING STATION', 'LAWRENCE STATION', 'LAWRENCE WEST STATION', 'MUSEUM STATION', 'NORTH YORK CENTRE STATION', 'OSGOODE STATION', 'PIONEER VILLAGE STATION', 'QUEEN STATION', 'QUEEN''S PARK STATION', 'ROSEDALE STATION', 'SHEPPARD WEST STATION', 'ST ANDREW STATION', 'ST CLAIR STATION', 'ST CLAIR WEST STATION', 'ST PATRICK STATION', 'SUMMERHILL STATION', 'UNION STATION', 'VAUGHAN STATION', 'WELLESLEY STATION', 'WILSON STATION', 'YORK MILLS STATION', 'YORK UNIVERSITY STATION', 'YORKDALE STATION')

-- enforce correct line for stations along YU line for 2022 (changed 47 records)

UPDATE delays_2022
	SET Line = 'YU'
	WHERE Station IN ('BLOOR STATION', 'COLLEGE STATION', 'DAVISVILLE STATION', 'DOWNSVIEW PARK STATION', 'DUNDAS STATION', 'DUPONT STATION', 'EGLINTON STATION', 'EGLINTON WEST STATION', 'FINCH STATION', 'FINCH WEST STATION', 'GLENCAIRN STATION', 'HIGHWAY 407 STATION', 'KING STATION', 'LAWRENCE STATION', 'LAWRENCE WEST STATION', 'MUSEUM STATION', 'NORTH YORK CENTRE STATION', 'OSGOODE STATION', 'PIONEER VILLAGE STATION', 'QUEEN STATION', 'QUEEN''S PARK STATION', 'ROSEDALE STATION', 'SHEPPARD WEST STATION', 'ST ANDREW STATION', 'ST CLAIR STATION', 'ST CLAIR WEST STATION', 'ST PATRICK STATION', 'SUMMERHILL STATION', 'UNION STATION', 'VAUGHAN STATION', 'WELLESLEY STATION', 'WILSON STATION', 'YORK MILLS STATION', 'YORK UNIVERSITY STATION', 'YORKDALE STATION');

	UPDATE delays_2022
		SET Line = 'YU'
		WHERE Station = 'SPADINA STATION'
		AND Line = 'YUS';

-- enforce correct line for stations along BD line for 2022 (changed 445 records)

UPDATE delays_2022
	SET Line = 'BD'
	WHERE Station IN ('BATHURST STATION', 'BAY STATION', 'BROADVIEW STATION', 'CASTLE FRANK STATION', 'CHESTER STATION', 'CHRISTIE STATION', 'COXWELL STATION', 'DONLANDS STATION', 'DUFFERIN STATION', 'DUNDAS WEST STATION', 'GREENWOOD STATION', 'HIGH PARK STATION', 'ISLINGTON STATION', 'JANE STATION', 'KEELE STATION', 'KENNEDY STATION', 'KIPLING STATION', 'LANSDOWNE STATION', 'MAIN STREET STATION', 'OLD MILL STATION', 'OSSINGTON STATION', 'PAPE STATION', 'ROYAL YORK STATION', 'RUNNYMEDE STATION', 'SHERBOURNE STATION', 'VICTORIA PARK STATION', 'WARDEN STATION', 'WOODBINE STATION', 'YONGE STATION');


-- enforce correct line for stations along SHP line for 2022 (changed 9 records)

UPDATE delays_2022
	SET Line = 'SHP'
	WHERE Station IN ('BAYVIEW STATION', 'BESSARION STATION', 'DON MILLS STATION', 'LESLIE STATION');

-- enforce correct line for stations along SRT line for 2022 (changed 1 record)

UPDATE delays_2022
	SET Line = 'SRT'
	WHERE Station IN ('LAWRENCE EAST STATION', 'ELLESMERE STATION', 'MIDLAND STATION', 'SCARBOROUGH CENTRE STATION', 'MCCOWAN STATION');

-- verify that all stations have the correct line designation for 2022
SELECT DISTINCT(Station), Line
FROM delays_2022
ORDER BY Station;

-- verify that all stations have the correct line designation for 2022

SELECT DISTINCT(Station), Line,
-- use CASE to identify Lines 1-4
CASE
    WHEN Line = 'YU' THEN 'Line 1'
    WHEN Line = 'BD' THEN 'Line 2'
    WHEN Line = 'SRT' THEN 'Line 3'
    WHEN Line = 'SHP' THEN 'Line 4'
-- name new column Line_Num
END AS Line_Num
FROM delays_2022
-- order by station then line number
ORDER BY Station, Line;

-- -------------------- 2023 --------------------

-- Improper Lines for 2023

-- DELETE FROM delays_2023
-- WHERE Line NOT IN ('YU', 'BD', 'SHP', 'SRT');

-- enforce correct line for stations along YU line for 2023 (changed 37 records)
-- 48 records changed
UPDATE delays_2023
	SET Line = 'YU'
	WHERE Station IN ('BLOOR STATION', 'COLLEGE STATION', 'DAVISVILLE STATION', 'DOWNSVIEW PARK STATION', 'DUNDAS STATION', 'DUPONT STATION', 'EGLINTON STATION', 'EGLINTON WEST STATION', 'FINCH STATION', 'FINCH WEST STATION', 'GLENCAIRN STATION', 'HIGHWAY 407 STATION', 'KING STATION', 'LAWRENCE STATION', 'LAWRENCE WEST STATION', 'MUSEUM STATION', 'NORTH YORK CENTRE STATION', 'OSGOODE STATION', 'PIONEER VILLAGE STATION', 'QUEEN STATION', 'QUEEN''S PARK STATION', 'ROSEDALE STATION', 'SHEPPARD WEST STATION', 'ST ANDREW STATION', 'ST CLAIR STATION', 'ST CLAIR WEST STATION', 'ST PATRICK STATION', 'SUMMERHILL STATION', 'UNION STATION', 'VAUGHAN STATION', 'WELLESLEY STATION', 'WILSON STATION', 'YORK MILLS STATION', 'YORK UNIVERSITY STATION', 'YORKDALE STATION');

-- enforce correct line for stations along BD line for 2023 (changed 372 records)
-- 383 records changed
UPDATE delays_2023
	SET Line = 'BD'
	WHERE Station IN ('BATHURST STATION', 'BAY STATION', 'BROADVIEW STATION', 'CASTLE FRANK STATION', 'CHESTER STATION', 'CHRISTIE STATION', 'COXWELL STATION', 'DONLANDS STATION', 'DUFFERIN STATION', 'DUNDAS WEST STATION', 'GREENWOOD STATION', 'HIGH PARK STATION', 'ISLINGTON STATION', 'JANE STATION', 'KEELE STATION', 'KENNEDY STATION', 'KIPLING STATION', 'LANSDOWNE STATION', 'MAIN STREET STATION', 'OLD MILL STATION', 'OSSINGTON STATION', 'PAPE STATION', 'ROYAL YORK STATION', 'RUNNYMEDE STATION', 'SHERBOURNE STATION', 'VICTORIA PARK STATION', 'WARDEN STATION', 'WOODBINE STATION', 'YONGE STATION');

-- enforce correct line for stations along SHP line for 2023
-- 3 records changed
UPDATE delays_2023
	SET Line = 'SHP'
	WHERE Station IN ('BAYVIEW STATION', 'BESSARION STATION', 'DON MILLS STATION', 'LESLIE STATION');

-- enforce correct line for stations along SRT line for 2023
-- 3 records changed
UPDATE delays_2023
	SET Line = 'SRT'
	WHERE Station IN ('LAWRENCE EAST STATION', 'ELLESMERE STATION', 'MIDLAND STATION', 'SCARBOROUGH CENTRE STATION', 'MCCOWAN STATION');

-- delete stations at major interchanges with incorrect or missing line designations for 2023
-- 6 records changed
DELETE
FROM delays_2023
WHERE (Station IN ('SPADINA STATION', 'ST GEORGE STATION') AND Line = 'SHP')
OR (Station = 'SPADINA STATION' AND Line = '')
OR (Station = 'ST GEORGE STATION' AND Line = '')
OR (Station = 'SHEPPARD-YONGE STATION' AND Line = 'BD');

-- verify that all stations have the correct line designation for 2023
SELECT DISTINCT(Station), Line
FROM delays_2023
ORDER BY Station;

-- verify that all stations have the correct line designation for 2023

SELECT DISTINCT(Station), Line,
-- use CASE to identify Lines 1-4
CASE
    WHEN Line = 'YU' THEN 'Line 1'
    WHEN Line = 'BD' THEN 'Line 2'
    WHEN Line = 'SRT' THEN 'Line 3'
    WHEN Line = 'SHP' THEN 'Line 4'
-- name new column Line_Num
END AS Line_Num
FROM delays_2023
-- order by station then line number
ORDER BY Station, Line;

-- delete SRT from delay tables

-- 608 records
DELETE
FROM delays_2022
WHERE Line = 'SRT';

-- 377 records
DELETE
FROM delays_2023
WHERE Line = 'SRT';

-- turn safe update mode back on
SET SQL_SAFE_UPDATES = 1;