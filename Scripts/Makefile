ECHO=
#LOCAL=/media/christof/mydata/repos/cost/
LOCAL=/home/lou/Public
CORPUS=$(LOCAL)/ELTeC-ita
ORIG=$(CORPUS)/Orig
TEXTS=$(CORPUS)/level1
SCHEMA0=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-0.rng
SCHEMA1=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-1.rng
REPORTER=$(LOCAL)/WG1/distantreading.github.io/Scripts/reporter.xsl
CURRENT=`pwd`

driver:
	echo rebuild driver file for originals
	echo '<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>TEI Corpus testharness</title></titleStmt> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>No source driver file</p> </sourceDesc> </fileDesc> </teiHeader>' >  $(ORIG)/driver.tei;\
		for f in $(ORIG)/*.xml ; do \
		echo "<xi:include href='$$f'/>" >> $(ORIG)/driver.tei; \
	done; echo "</teiCorpus>" >> $(ORIG)/driver.tei
tagusage:
	echo check tags used in originals
	saxon -xi $(ORIG)/driver.tei maketagusage.xsl > taguse.xml 
convert:
	echo convert to eltec1 and rewrite repo
	cd $(ORIG); for f in *.xml; do \
	echo $$f; java -jar /usr/share/java/saxon9he.jar $$f ../Scripts/CLIGStoELTeC.xsl > ../level1/$$f; done; \
	cd $(CURRENT)
validate:
	echo check validity of files in repo
	cd $(CORPUS)/level1; for f in *.xml; do \
	echo $$f; jing $(SCHEMA1) $$f; done; \
	cd $(CURRENT)
report:
	cp $(CORPUSHDR) driver.tei;\
		for f in $(TEXTS)/*.xml ; do \
		echo "<xi:include href='$$f'/>" >> driver.tei; \
	done; echo "</teiCorpus>" >> driver.tei
	saxon -xi driver.tei $(REPORTER) >balance_report.html

# run this makefile from within Scripts directory  
