# Tematiche
Directory tematiche/ contenente tutti i file xml delle varie tematiche. Per generare il menu di tutti i sondaggi uno script legge i nomi dei file nella directory. Ogni tematica ha un nome di directory contenente un file index.xml che contiene commenti e caratteristiche generali della tematica, e una serie di file xml che rappresentano ogni singola soluzione (approfondimento, pro/contro, dati del sondaggio, domande, risultati).

## tematiche/index.xml
- Descrizione generale: testo
- commenti: lista di (nome utente, data, voto, commento)

## sondaggio_soluzione.xml
Il nome di un sondaggio e' il nome del file che lo contiene.

- domanda: testo
- pro: lista di vantaggi (testo)
- contro: lista di svantaggi (testo)
- opzioni: lista di (descrizione, numero voti)
<!-- - votanti: lista di utenti che hanno gia' votato -->

# utenti.xml
File singolo con informazioni sugli utenti registrati

- username
- email
- md5 (password)

# Eventi (news)
Directory eventi/ contenente file index.xml che descrive gli eventi in generale e contenente i file html statici che descrivono un singolo evento.
 
## eventi/index.xml
- data evento
- data inserimento
- titolo
- breve descrizione
- link pagina statica
