1A
	$ram_swrite_aread(...) avec %rad2 -> %r12 en mode lecture (%r12 car réservé)
1B
	// decode -> load [$ram_swrite_aread(...)] -> pcplus1 [rdest <- %r12 op %r2]
	decode --( si /ir[31] * ir[15] )-> load      faire r12 <- [rad2]
	load   --( toujours )->            pcplus1   faire rdest <- rs1 op r12
1C
	decode -> load: il faut charger 
		areg	ir[19..16] 	(%rad2)
		breg	0 		(par convention, pas utilisé)
		dreg	1100 		(%r12)
		ualcmd	0 		(par convention, pas utilisé)
		dbusin	10
		write	0
	load -> pcplus1:
		areg	ir[23..20] 	(%rs1)
		breg	1100		(%r12)
		dreg	ir[27..24] 	(%rest)
		ualcmd	ir[31..28] 	(cop)
		dbusin	01
		write	0
	
