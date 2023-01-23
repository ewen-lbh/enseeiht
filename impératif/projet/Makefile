routeursimple: routeursimple.adb
	gnatmake -gnatwa -gnata -g routeursimple.adb

routeur_la: routeur_la.adb
	gnatmake -gnatwa -gnata -g routeur_la.adb

routeur_ll: routeur_ll.adb
	gnatmake -gnatwa -gnata -g routeur_ll.adb

test: *_test.adb
	gnatmake -gnatwa -gnata -g *_test.adb

clean:
	gnatclean cache_abr cache_abr_test cache_lca_test caches lca lca_fifo lca_lfu lca_lru main operateur_routeur_la operateur_routeur_ll parsing parsing_test routeur_la routeur_ll routeur_normal_test routeur_simple_test routeurnormal routeursimple table table_test
	rm -v b~* b__* *_test main
