lca: lca.adb lca.ads
	gnatmake -gnatwa -gnata -g lca.adb

parsing: parsing.adb
	gnatmake -gnatwa -gnata -g parsing.adb

main: main.adb parsing.adb table.adb
	gnatmake -gnatwa -gnata -g main.adb

test: *_test.adb
	gnatmake -gnatwa -gnata -g *_test.adb

clean:
	gnatclean lca parsing table main routeursimple routeur_simple_test table_test parsing_test 
	rm -v b~* b__* *_test main
