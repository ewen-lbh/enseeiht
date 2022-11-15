with LCA;

procedure LCA_Sujet is
    package LcaStrInt is new LCA (String(1..20), Integer);
    use LcaStrInt;
    dict : LcaStrInt.T_LCA;
begin
    Initialiser (dict);
    Enregistrer (dict, "un", 1);
    Enregistrer (dict, "deux", 2);
end LCA_Sujet;
