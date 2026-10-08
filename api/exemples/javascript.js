// Exemple API Investlytic : recherche d'un symbole, puis note de l'action.
// Usage : INVESTLYTIC_KEY=ilv_votre_cle node javascript.js lvmh   (Node 18+)
// Côté serveur uniquement : ne mettez jamais la clé dans le code envoyé au navigateur.
const BASE = "https://investlytic.co/api/v1";
const CLE = process.env.INVESTLYTIC_KEY;

async function appel(chemin, params) {
  const url = new URL(BASE + chemin);
  for (const [k, v] of Object.entries(params || {})) url.searchParams.set(k, v);
  const r = await fetch(url, { headers: { Authorization: "Bearer " + CLE } });
  const corps = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error("Erreur " + r.status + " : " + (corps.erreur || ""));
  return corps;
}

async function main() {
  if (!CLE) throw new Error("Définissez la variable INVESTLYTIC_KEY (votre clé ilv_...).");
  const requete = process.argv[2] || "lvmh";
  const { resultats } = await appel("/recherche", { q: requete, limite: 5 });
  if (!resultats.length) throw new Error("Aucun symbole pour « " + requete + " ».");
  const fiche = await appel("/action/" + encodeURIComponent(resultats[0].symbole));
  console.log(`${fiche.nom} (${fiche.symbole}) : ${fiche.note}/${fiche.sur}`);
  console.log(`Données du ${fiche.donnees_du} (${fiche.donnees})`);
  for (const c of fiche.criteres) console.log((c.verdict ? "  OK  " : "  NON ") + c.libelle);
  console.log(fiche.avertissement);
}

main().catch((e) => { console.error(e.message); process.exit(1); });
