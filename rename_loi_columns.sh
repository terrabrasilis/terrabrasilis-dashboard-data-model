#!/bin/bash

cd local-of-interest-processing/pampa/

#ogrinfo -sql "ALTER TABLE consunit RENAME COLUMN NOME_UC1 TO name" consunit.shp
ogrinfo -sql "ALTER TABLE indi RENAME COLUMN terrai_nom TO name" indi.shp
#ogrinfo -sql "ALTER TABLE mun RENAME COLUMN NM_MUNICIP TO name" mun.shp
#ogrinfo -sql "ALTER TABLE uf RENAME COLUMN NM_ESTADO TO name" uf.shp

cd ../pantanal/

#ogrinfo -sql "ALTER TABLE consunit RENAME COLUMN NOME_UC1 TO name" consunit.shp
ogrinfo -sql "ALTER TABLE indi RENAME COLUMN terrai_nom TO name" indi.shp
#ogrinfo -sql "ALTER TABLE mun RENAME COLUMN NM_MUNICIP TO name" mun.shp
#ogrinfo -sql "ALTER TABLE uf RENAME COLUMN NM_ESTADO TO name" uf.shp

cd ../cerrado/

ogrinfo -sql "ALTER TABLE indi RENAME COLUMN terrai_nom TO name" indi.shp

cd ../amazon/

ogrinfo -sql "ALTER TABLE indi RENAME COLUMN terrai_nom TO name" indi.shp

cd ../legal_amazon/

ogrinfo -sql "ALTER TABLE indi RENAME COLUMN terrai_nom TO name" indi.shp