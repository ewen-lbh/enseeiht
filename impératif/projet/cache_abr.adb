with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Bounded;      use Ada.Strings.Bounded;
with Ada.Strings.Fixed;
with Ada.Unchecked_Deallocation;
with Ada.Text_IO;              use Ada.Text_IO;

package body cache_abr is
   NL : constant Character := (Character'Val (10));

   procedure Free is new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_ABR);

   procedure vider_arbre (arbre : in out T_ABR) is
   begin
      if arbre = null then
         return;
      end if;
      vider_arbre (arbre.fils_gauche);
      vider_arbre (arbre.fils_droit);
      Free (arbre);
   end vider_arbre;

   procedure Vider (cache : in out T_Cache_ABR) is
   begin
      vider_arbre (cache.arbre);
   end Vider;

   procedure Initialiser (cache : out T_Cache_ABR; politique : T_Politique; capacite : Integer) is
      arbre : T_ABR;
      stats : StatsCache;
   begin
      Creer_ABR
        (fils_droit => null, fils_gauche => null, critere_politique => 0.0,
         eth => To_Unbounded_String (""), arbre => arbre, fragment => To_Unbounded_String (""),
         masque     => 0);
      stats := (Defauts => 0, Demandes => 0);
      cache := (arbre => arbre, politique => politique, stats => stats, Capacite => capacite);
   end Initialiser;

   procedure Creer_ABR
     (fils_gauche : in     T_ABR; fils_droit : in T_ABR; critere_politique : in Float;
      eth : in     Unbounded_String; fragment : in Unbounded_String; masque : in Table.T_Adresse_IP;
      arbre       :    out T_ABR)
   is
   begin
      arbre                   := new T_Noeud;
      arbre.fils_gauche       := fils_gauche;
      arbre.fils_droit        := fils_droit;
      arbre.critere_politique := critere_politique;
      arbre.eth               := eth;
      arbre.fragment          := fragment;
      arbre.masque            := masque;
   end Creer_ABR;

   function Arbre_To_String (arbre : T_ABR; indentation_initiale : Integer) return Unbounded_String
   is
      indentation : Unbounded_String := To_Unbounded_String ("");
      type Fixed is delta 0.01 range -1.0e6 .. 1.0e6;
   begin
      for i in 1 .. indentation_initiale loop
         indentation := indentation & To_Unbounded_String (" ");
      end loop;
      if arbre = null then
         return To_Unbounded_String ("x") & NL;
      else
         return

           (To_Unbounded_String ("[") & arbre.fragment & To_Unbounded_String ("] (") & arbre.eth &
            To_Unbounded_String (") ") & Fixed (arbre.critere_politique)'Image & NL & indentation &
            To_Unbounded_String ("└─0─") &
            Arbre_To_String (arbre.fils_gauche, indentation_initiale + 4) & indentation &
            To_Unbounded_String ("└─1─") &
            Arbre_To_String (arbre.fils_droit, indentation_initiale + 4));

      end if;
   end Arbre_To_String;

   function debug_arbre (arbre : T_ABR; indentation_initiale : Integer) return Unbounded_String is
      indentation : Unbounded_String := To_Unbounded_String ("");
      type Fixed is delta 0.01 range -1.0e6 .. 1.0e6;
   begin
      for i in 1 .. indentation_initiale loop
         indentation := indentation & To_Unbounded_String (" ");
      end loop;
      if arbre = null then
         return To_Unbounded_String ("x");
      else
         return

           (To_Unbounded_String ("[") & arbre.fragment & To_Unbounded_String ("] (") & arbre.eth &
            To_Unbounded_String (")") &
            To_Unbounded_String (Fixed (arbre.critere_politique)'Image) & " { " &
            debug_arbre (arbre.fils_gauche, indentation_initiale + 4) & "; " &
            debug_arbre (arbre.fils_droit, indentation_initiale + 4)) &
           " }";

      end if;
   end debug_arbre;

   procedure Afficher (cache : T_Cache_ABR) is
      procedure aux (arbre : T_ABR; addresse_accumulee : Unbounded_String) is
      begin
         if arbre = null then
            return;
         end if;

         if arbre.eth /= To_Unbounded_String ("") then
            Put_Line
              (Table.T_Adresse_IP_Vers_String_IP
                 (bitstring_to_t_addresse_ip (addresse_accumulee & arbre.fragment)) &
               To_Unbounded_String (" ") & Table.T_Adresse_IP_Vers_String_IP (arbre.masque) &
               To_Unbounded_String (" ") & arbre.eth);
         end if;

         if arbre.fils_gauche /= null then
            aux
              (arbre.fils_gauche, addresse_accumulee & arbre.fragment & To_Unbounded_String ("0"));
         end if;

         if arbre.fils_droit /= null then
            aux (arbre.fils_droit, addresse_accumulee & arbre.fragment & To_Unbounded_String ("1"));
         end if;
      end aux;
   begin
      aux (cache.arbre, To_Unbounded_String (""));
   end Afficher;

   function bitstring_to_t_addresse_ip (bitstring : Unbounded_String) return Table.T_Adresse_IP is
      adresse          : Table.T_Adresse_IP := 0;
      padding          : Integer;
      padded_bitstring : Unbounded_String;
   begin
      padding          := 32 - Length (bitstring);
      padded_bitstring := bitstring;
      for i in 1 .. padding loop
         padded_bitstring := padded_bitstring & To_Unbounded_String ("0");
      end loop;
      for i in 1 .. 32 loop
         if Element (padded_bitstring, i) = '1' then
            adresse := Table."+" (adresse, 2**(32 - i));
         end if;
      end loop;
      return adresse;
   end bitstring_to_t_addresse_ip;

   procedure Afficher_debug (cache : in T_Cache_ABR) is
   begin
      Ada.Text_IO.Put_Line ("cache " & T_Politique'Image (cache.politique));
      Put_Line
        (" arbre: " & Arbre_To_String (cache.arbre, Length (To_Unbounded_String (" arbre: "))));
   end Afficher_debug;

   procedure Recuperer_Stat (cache : in T_Cache_ABR; Demande : out Integer; Defaut : out Integer) is
   begin
      Demande := cache.stats.Demandes;
      Defaut  := cache.stats.Defauts;
   end Recuperer_Stat;

   procedure Afficher_Stat (cache : T_Cache_ABR) is
   begin
      Caches.Afficher_Stat (cache.stats);
   end Afficher_Stat;

   procedure incrementer_anciennete (arbre : in T_ABR) is
   begin
      if arbre = null then
         null;
      else
         if arbre.fils_droit /= null then
            incrementer_anciennete (arbre.fils_droit);
         end if;
         if arbre.fils_gauche /= null then
            incrementer_anciennete (arbre.fils_gauche);
         end if;
         arbre.critere_politique := arbre.critere_politique + 1.0;
      end if;
   end incrementer_anciennete;

   procedure Ajouter_Dans_Cache
     (cache : in out T_Cache_ABR; addr : in Table.T_Adresse_IP; Masque : in Table.T_Adresse_IP;
      Eth   : in     Unbounded_String)
   is

      procedure aux
        (arbre : in out T_ABR; politique : in T_Politique; prefixe : in Unbounded_String;
         eth   : in     Unbounded_String; anciennete_a_incrementer : in Boolean)
      is
         fragment_haut          : Unbounded_String;
         fragment_nouveau_noeud : Unbounded_String;
         fragment_ancien_noeud  : Unbounded_String;
         ancien_noeud           : T_ABR;
         nouveau_noeud          : T_ABR;
         suffixe_nouveau_noeud  : Unbounded_String;
         vide                   : Unbounded_String;
      begin
         if arbre = null then
            Creer_ABR
              (fils_gauche => null, fils_droit => null, critere_politique => 0.0,
               fragment    => prefixe, arbre => arbre, eth => eth, masque => Masque);
            return;
         end if;

         if anciennete_a_incrementer then
            incrementer_anciennete (arbre);
         end if;
         if Length (prefixe) = 0 and Length (arbre.fragment) = 0 then
            -- ce cas est particulier: on est en train d'ajouter 0.0.0.0, l'adresse "catch-all"
            arbre.eth               := eth;
            arbre.critere_politique := 0.0;
         elsif a_prefixe (prefixe, arbre.fragment) then
            -- dans ce cas, le fragment du noeud actuel est complètement contenu dans le début du fragment à insérer: on va continuer à descendre dans l'arbre, si possible, ou bien insérer à gauche ou à droite.
            -- suffixe_nouveau_noeud continent le premier bit, qui sera encodé par le fait de passer par le fils gauche ou droit. Il font donc enlever ce premier bit lors de la récursion.
            separer_prefixe (arbre.fragment, prefixe, vide, vide, suffixe_nouveau_noeud);

            if Length(suffixe_nouveau_noeud) = 0 then
               -- le nouveau noeud est exactement l'ancien, on met à jour eth et le critère de politique
               arbre.eth := eth;
               arbre.critere_politique := 0.0;
            elsif Element (suffixe_nouveau_noeud, 1) = '0' then
               -- le suffixe commence par 0: on va à gauche
               if arbre.fils_gauche /= null then
                  -- il y a déjà un fils gauche: on continue à descendre
                  aux
                    (arbre.fils_gauche, politique,
                     To_Unbounded_String
                       (Slice (suffixe_nouveau_noeud, 2, Length (suffixe_nouveau_noeud))),
                     eth, False);
               else
                  -- plus rien à gauche, on ajoute le nouveau noeud
                  Creer_ABR
                    (fils_droit => null, fils_gauche => null, critere_politique => 0.0, eth => eth,
                     masque     => Masque,
                     fragment   =>
                       To_Unbounded_String
                         (Slice (suffixe_nouveau_noeud, 2, Length (suffixe_nouveau_noeud))),
                     arbre      => arbre.fils_gauche);
               end if;
            else
               -- le suffixe commence par 1: on va à droite
               if arbre.fils_droit /= null then
                  -- il y a déjà un fils droit: on continue à descendre
                  aux
                    (arbre.fils_droit, politique,
                     To_Unbounded_String
                       (Slice (suffixe_nouveau_noeud, 2, Length (suffixe_nouveau_noeud))),
                     eth, False);
               else
                  -- plus rien à droite, on ajoute le nouveau noeud
                  Creer_ABR
                    (fils_droit => null, fils_gauche => null, critere_politique => 0.0, eth => eth,
                     masque     => Masque,
                     fragment   =>
                       To_Unbounded_String
                         (Slice (suffixe_nouveau_noeud, 2, Length (suffixe_nouveau_noeud))),
                     arbre      => arbre.fils_droit);
               end if;
            end if;
         else
            -- on détermine quelle partie du fragment est au noeud actuel et au noeud à insérer
            separer_prefixe
              (arbre.fragment, prefixe, fragment_haut, fragment_ancien_noeud,
               fragment_nouveau_noeud);

            -- on crée les deux nouveaux noeuds: l'actuel, et le nouveau, qui ont tout les deux perdus leur partie commune ainsi que le premier bit (qui est encodé par le fils gauche ou droit)
            Creer_ABR
              (fils_droit => null, fils_gauche => null, critere_politique => 0.0, eth => eth,
               masque     => Masque,
               fragment   =>
                 To_Unbounded_String
                   (Slice (fragment_nouveau_noeud, 2, Length (fragment_nouveau_noeud))),
               arbre      => nouveau_noeud);

            Creer_ABR
              (fils_droit        => arbre.fils_droit, fils_gauche => arbre.fils_gauche,
               critere_politique => arbre.critere_politique, eth => arbre.eth,
               masque            => arbre.masque,
               fragment          =>
                 To_Unbounded_String
                   (Slice (fragment_ancien_noeud, 2, Length (fragment_ancien_noeud))),
               arbre             => ancien_noeud);

            if anciennete_a_incrementer then
               incrementer_anciennete (ancien_noeud);
            end if;

            -- on rattache les deux noeuds au noeud haut qui contient la partie commune.
            if Element (fragment_nouveau_noeud, 1) = '0' then
               arbre.fils_droit  := ancien_noeud;
               arbre.fils_gauche := nouveau_noeud;
            else
               arbre.fils_droit  := nouveau_noeud;
               arbre.fils_gauche := ancien_noeud;
            end if;
            arbre.critere_politique := 0.0;
            arbre.eth               := To_Unbounded_String ("");
            arbre.fragment          := fragment_haut;
         end if;
      end aux;
      prefixe : Unbounded_String;
   begin
      if Est_Plein (cache) then
         Put_Line
           ("le cache est plein (taille = " & Integer'Image (taille_cache (cache.arbre)) &
            ") on supprime le pire noeud");
         Supprimer_pire_noeud (cache);
      end if;
      prefixe := prefixe_adresse (ip_to_binary_string (addr), ip_to_binary_string (Masque));
      --  Put_Line ("        (" & To_String (prefixe) & ")");
      aux (cache.arbre, cache.politique, prefixe, Eth, cache.politique = FIFO);
   end Ajouter_Dans_Cache;

   function Est_Plein (cache : T_Cache_ABR) return Boolean is
   begin
      return taille_cache (cache.arbre) >= cache.Capacite;
   end Est_Plein;

   function taille_cache (arbre : T_ABR) return Integer is
      function aux (arbre : T_ABR; taille_actuelle : in Integer) return Integer is
      begin
         if arbre = null then
            return taille_actuelle;
         elsif arbre.eth /= To_Unbounded_String ("") then
            return taille_actuelle + 1;
         else
            return
              aux (arbre.fils_gauche, taille_actuelle) + aux (arbre.fils_droit, taille_actuelle);
         end if;
      end aux;
   begin
      return aux (arbre, 0);
   end taille_cache;

   procedure Supprimer_pire_noeud (cache : in out T_Cache_ABR) is
      function Pire_valeur_politique_est
        (a : Float; b : Float; politique : T_Politique) return Boolean
      is
      begin
         if a = -1.0 then
            return False;
         elsif b = -1.0 then
            return True;
         end if;
         case politique is
            when LRU | FIFO =>
               return a > b;
            when LFU =>
               return a < b;
         end case;
      end Pire_valeur_politique_est;

      procedure Nettoyer_sous_arbres_vides (arbre : in out T_ABR) is
      begin
         -- cette fonction retourne l'ABR donné, mais sans les sous-arbres ne stockant aucune interface.
         if arbre = null then
            null;
         elsif est_feuille (arbre) then
            if arbre.eth = To_Unbounded_String ("") then
               Free (arbre);
            else
               null;
            end if;
         else
            if arbre.fils_droit /= null then
               Nettoyer_sous_arbres_vides (arbre.fils_droit);
            end if;
            if arbre.fils_gauche /= null then
               Nettoyer_sous_arbres_vides (arbre.fils_gauche);
            end if;
         end if;
      end Nettoyer_sous_arbres_vides;

      function Pire_valeur_politique_dans_arbre (arbre : T_ABR) return Float is
         a_gauche : Float;
         a_droite : Float;
      begin
         if arbre = null then
            raise Arbre_Vide;
            return -1.0;
         elsif est_feuille (arbre) then
            return arbre.critere_politique;
         else
            if arbre.fils_gauche = null then
               return Pire_valeur_politique_dans_arbre (arbre.fils_droit);
            elsif arbre.fils_droit = null then
               return Pire_valeur_politique_dans_arbre (arbre.fils_gauche);
            else
               a_gauche := Pire_valeur_politique_dans_arbre (arbre.fils_gauche);
               a_droite := Pire_valeur_politique_dans_arbre (arbre.fils_droit);
               if Pire_valeur_politique_est (a_gauche, a_droite, cache.politique) then
                  return a_gauche;
               else
                  return a_droite;
               end if;
            end if;
         end if;
      end Pire_valeur_politique_dans_arbre;

      procedure supprimer_noeud_avec_critere_politique
        (arbre : in out T_ABR; critere_politique : in Float; supprime : out Boolean)
      is
         nouveau_critere_politique : Float;
         nouvelle_eth              : Unbounded_String;
         supprime_a_gauche         : Boolean;
         supprime_a_droite         : Boolean;
      begin
         if arbre = null then
            null;
         elsif est_feuille (arbre) then
            if arbre.critere_politique = critere_politique then
               Free (arbre);
               supprime := True;
            else
               null;
            end if;
         else
            if arbre.critere_politique = critere_politique then
               arbre.critere_politique := 0.0;
               arbre.eth               := To_Unbounded_String ("");
            else
               null;
            end if;
            supprimer_noeud_avec_critere_politique
              (arbre.fils_droit, critere_politique, supprime_a_droite);
            supprimer_noeud_avec_critere_politique
              (arbre.fils_gauche, critere_politique, supprime_a_gauche);
         end if;
      end supprimer_noeud_avec_critere_politique;
      supprime : Boolean := False;
   begin
      supprimer_noeud_avec_critere_politique
        (cache.arbre, Pire_valeur_politique_dans_arbre (cache.arbre), supprime);
      Nettoyer_sous_arbres_vides (cache.arbre);
   end Supprimer_pire_noeud;

   procedure Verifier_cache
     (cache : in out T_Cache_ABR; trouve : out Boolean; addr : in Table.T_Adresse_IP;
      eth   :    out Unbounded_String)
   is

      procedure mettre_a_jour_frequence (arbre : in T_ABR) is
      -- on met à jour la fréquence de chaque arbre: f_(n+1) = u_n / (a_n + 1)
      -- avec u_n nombre d'accès au noeud précédents et a_n nombre total d'accès précédents à l'arbre
      -- or on sait a_n = cache.stats.Demandes
      -- donc f_(n+1) = u_n / (cache.stats.Demandes + 1)
      -- et aussi u_n = f_n * a_n = f_n * cache.stats.Demandes
      -- donc f_(n+1) = f_n * cache.stats.Demandes / (cache.stats.Demandes + 1)
      begin
         if arbre = null then
            null;
         else
            arbre.critere_politique :=
              arbre.critere_politique * Float (cache.stats.Demandes) /
              Float ((cache.stats.Demandes) + 1);
            mettre_a_jour_frequence (arbre.fils_gauche);
            mettre_a_jour_frequence (arbre.fils_droit);
         end if;

      end mettre_a_jour_frequence;

      function indentation (depth : Integer) return Unbounded_String is
         s : Unbounded_String := To_Unbounded_String ("");
      begin
         for i in 1 .. depth loop
            s := s & "    ";
         end loop;
         return s;
      end indentation;

      procedure mettre_critere_politique_a
        (arbre : in out T_ABR; chemin : in Unbounded_String; critere_politique : in Float;
         depth : in     Integer := 0)
      is
         reste_chemin : Unbounded_String;
         vide         : Unbounded_String;
         indent       : Unbounded_String := indentation (depth);
      begin
         if arbre = null then
            null;
            return;
         end if;
         --  Put_Line (indent & "à matcher: " & chemin & " sur " & arbre.fragment);
         if chemin = arbre.fragment then
            --  Put_Line (indent & "chemin trouvé");
            arbre.critere_politique := critere_politique;
         else
            separer_prefixe (chemin, arbre.fragment, vide, reste_chemin, vide);
            if Element (reste_chemin, 1) = '0' then
               separer_prefixe (chemin, arbre.fragment & "0", vide, reste_chemin, vide);
               --  Put_Line (indent & "descente à gauche avec " & reste_chemin & "à matcher");
               mettre_critere_politique_a
                 (arbre.fils_gauche, reste_chemin, critere_politique, depth + 1);
            else
               separer_prefixe (chemin, arbre.fragment & "1", vide, reste_chemin, vide);
               --  Put_Line (indent & "descente à droite avec " & reste_chemin & "à matcher");
               mettre_critere_politique_a
                 (arbre.fils_droit, reste_chemin, critere_politique, depth + 1);
            end if;
         end if;
      end mettre_critere_politique_a;

      procedure aux
        (arbre : in out T_ABR; adresse : in Unbounded_String; chemin : in Unbounded_String;
         eth   :    out Unbounded_String; trouve_avec_chemin : out Unbounded_String;
         depth : in     Natural := 0)
      is
         -- chemin: chemin de l'adresse jusqu'à avant le noeud courant
         eth_gauche                : Unbounded_String;
         chemin_avec_noeud_courant : Unbounded_String;
         chemin_gauche             : Unbounded_String;
         eth_droite                : Unbounded_String;
         chemin_droit              : Unbounded_String;
         indent                    : Unbounded_String := To_Unbounded_String ("");
         chemin_fils_gauche        : Unbounded_String := To_Unbounded_String ("");
         chemin_fils_droit         : Unbounded_String := To_Unbounded_String ("");
      begin
         for i in 1 .. depth loop
            indent := indent & To_Unbounded_String ("    ");
         end loop;
         if arbre /= null then
            chemin_avec_noeud_courant := chemin & arbre.fragment;
         else
            chemin_avec_noeud_courant := chemin;
         end if;
         --  Put_Line (indent & " traitement à " & debug_arbre (arbre, 0));
         --  Put_Line (indent & "addr " & adresse);
         --  Put_Line (indent & "path " & chemin_avec_noeud_courant);
         if arbre = null then
            eth                := To_Unbounded_String ("");
            trouve_avec_chemin := To_Unbounded_String ("");
         elsif a_prefixe (adresse, chemin_avec_noeud_courant) then
            --  Put_Line
            --    (indent & adresse & To_Unbounded_String (" a prefixe ") & chemin_avec_noeud_courant);
            if est_feuille (arbre) then
               --  Put_Line (indent & "feuille => " & arbre.eth);
               eth                := arbre.eth;
               trouve_avec_chemin := chemin_avec_noeud_courant;
            else
               --  Put_Line (indent & "noeud");
               --  Put_Line (indent & "à gauche");
               aux
                 (arbre.fils_gauche, adresse, chemin_avec_noeud_courant & "0", eth_gauche,
                  chemin_gauche, depth + 1);
               --  Put_Line (indent & "à droite");
               aux
                 (arbre.fils_droit, adresse, chemin_avec_noeud_courant & "1", eth_droite,
                  chemin_droit, depth + 1);

               --  Put_Line
               --    (indent & "testing left match " & eth_gauche & " vs right match " & eth_droite);
               if eth_droite = To_Unbounded_String ("") and eth_gauche = To_Unbounded_String ("")
               then
                  --  Put_Line (indent & "no match with more precision => " & arbre.eth);
                  eth                := arbre.eth;
                  trouve_avec_chemin := chemin_avec_noeud_courant;
               elsif Length (chemin_droit) > Length (chemin_gauche) then
                  --  Put_Line (indent & "right-side match is better => " & eth_droite);
                  eth                := eth_droite;
                  trouve_avec_chemin := chemin_droit;
               else
                  --  Put_Line (indent & "left-side match is better => " & eth_gauche);
                  eth                := eth_gauche;
                  trouve_avec_chemin := chemin_gauche;
               end if;
            end if;
         else
            --  Put_Line (indent & "no match here");
            eth                := To_Unbounded_String ("");
            trouve_avec_chemin := To_Unbounded_String ("");
         end if;
      end aux;

      trouve_avec_chemin : Unbounded_String;
   begin
      if cache.politique = LRU then
         incrementer_anciennete (cache.arbre);
      elsif cache.politique = LFU then
         mettre_a_jour_frequence (cache.arbre);
      end if;
      cache.stats.Demandes := cache.stats.Demandes + 1;
      aux
        (cache.arbre, ip_to_binary_string (addr), To_Unbounded_String (""), eth,
         trouve_avec_chemin);
      trouve := eth /= To_Unbounded_String ("");
      --  Put_Line ("trouve? au chemin " & trouve_avec_chemin);

      if trouve then
         case cache.politique is
            when LRU =>
               mettre_critere_politique_a (cache.arbre, trouve_avec_chemin, 0.0);
            when others =>
               null;
         end case;
      else
         cache.stats.Defauts := cache.stats.Defauts + 1;
      end if;
   end Verifier_cache;

   --  procedure Supprimer
   --     (cache : in out T_Cache_ABR; addr : Table.T_Adresse_IP);

   function ip_to_binary_string (addr : in Table.T_Adresse_IP) return Unbounded_String is

      function aux (addr : in Long_Integer) return Unbounded_String is
         bit       : Long_Integer;
         bit_image : Unbounded_String;
         reste     : Long_Integer := addr;
      begin
         if reste = 1 then
            return To_Unbounded_String ("1");
         elsif reste = 0 then
            return To_Unbounded_String ("0");
         else
            bit       := reste mod 2;
            reste     := reste / 2;
            bit_image :=
              To_Unbounded_String
                (Ada.Strings.Fixed.Trim (Long_Integer'Image (bit), Ada.Strings.Left));
            return aux (reste) & bit_image;
         end if;
      end aux;
   begin
      return aux (Long_Integer (addr));
   end ip_to_binary_string;

   function est_feuille (noeud : T_ABR) return Boolean is
   begin
      if noeud = null then
         return False;
      else
         return noeud.fils_gauche = null and noeud.fils_droit = null;
      end if;
   end est_feuille;

   function prefixe_adresse
     (ip : Unbounded_String; masque : Unbounded_String) return Unbounded_String
   is
   begin
      if Length (masque) = 0 then
         return To_Unbounded_String ("");
      elsif Element (masque, 1) = '0' then
         return To_Unbounded_String ("");
      else
         return
           Element (ip, 1) &
           prefixe_adresse
             (To_Unbounded_String (Slice (ip, 2, Length (ip))),
              To_Unbounded_String (Slice (masque, 2, Length (masque))));
      end if;
   end prefixe_adresse;

   function a_prefixe (source : Unbounded_String; prefixe : Unbounded_String) return Boolean is
   begin
      if prefixe = To_Unbounded_String ("") then
         return True;
      elsif Length (prefixe) > Length (source) then
         return False;
      elsif Element (prefixe, 1) /= Element (source, 1) then
         return False;
      else
         return
           a_prefixe
             (To_Unbounded_String (Slice (source, 2, Length (source))),
              To_Unbounded_String (Slice (prefixe, 2, Length (prefixe))));
      end if;
   end a_prefixe;

   procedure separer_prefixe
     (a         : in     Unbounded_String; b : in Unbounded_String; prefixe : out Unbounded_String;
      suffixe_a :    out Unbounded_String; suffixe_b : out Unbounded_String)
   is
      dans_le_prefixe : Boolean := True;
      function max (a, b : Integer) return Integer is
      begin
         if a > b then
            return a;
         else
            return b;
         end if;
      end max;
   begin
      if Length (a) = 0 or Length (b) = 0 then
         prefixe   := To_Unbounded_String ("");
         suffixe_a := a;
         suffixe_b := b;
         return;
      end if;

      suffixe_a := To_Unbounded_String ("");
      suffixe_b := To_Unbounded_String ("");
      prefixe   := To_Unbounded_String ("");
      for i in 1 .. max (Length (a), Length (b)) loop
         if i > Length (a) then
            dans_le_prefixe := False;
            suffixe_b       := suffixe_b & Element (b, i);
         elsif i > Length (b) then
            dans_le_prefixe := False;
            suffixe_a       := suffixe_a & Element (a, i);
         elsif dans_le_prefixe then
            if Element (a, i) /= Element (b, i) then
               dans_le_prefixe := False;
               suffixe_a       := suffixe_a & Element (a, i);
               suffixe_b       := suffixe_b & Element (b, i);
            else
               prefixe := prefixe & Element (a, i);
            end if;
         else
            suffixe_a := suffixe_a & Element (a, i);
            suffixe_b := suffixe_b & Element (b, i);

         end if;
      end loop;
      --  Put_Line ("difference starts at " & Integer'Image (i));
      --  prefixe   := To_Unbounded_String (Slice (a, 1, i - 1));
      --  suffixe_a := To_Unbounded_String (Slice (a, i, Length (a)));
      --  suffixe_b := To_Unbounded_String (Slice (b, i, Length (b)));
   end separer_prefixe;

end cache_abr;
