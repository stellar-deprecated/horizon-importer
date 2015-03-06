--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.ledgersbyseq;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.seqslots DROP CONSTRAINT seqslots_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
ALTER TABLE ONLY public.accountdata DROP CONSTRAINT accountdata_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.seqslots;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP TABLE public.accountdata;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accountdata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accountdata (
    accountid character varying(51) NOT NULL,
    key integer NOT NULL,
    value text NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(51) NOT NULL,
    balance bigint NOT NULL,
    numsubentries integer DEFAULT 0 NOT NULL,
    inflationdest character varying(51),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    txsethash character(64) NOT NULL,
    clfhash character(64) NOT NULL,
    totcoins bigint NOT NULL,
    feepool bigint NOT NULL,
    ledgerseq bigint,
    inflationseq integer NOT NULL,
    basefee integer NOT NULL,
    basereserve integer NOT NULL,
    closetime bigint NOT NULL,
    CONSTRAINT ledgerheaders_basefee_check CHECK ((basefee >= 0)),
    CONSTRAINT ledgerheaders_basereserve_check CHECK ((basereserve >= 0)),
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_feepool_check CHECK ((feepool >= 0)),
    CONSTRAINT ledgerheaders_inflationseq_check CHECK ((inflationseq >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0)),
    CONSTRAINT ledgerheaders_totcoins_check CHECK ((totcoins >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    accountid character varying(51) NOT NULL,
    offerid bigint NOT NULL,
    paysisocurrency character varying(4) NOT NULL,
    paysissuer character varying(51) NOT NULL,
    getsisocurrency character varying(4) NOT NULL,
    getsissuer character varying(51) NOT NULL,
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    flags integer NOT NULL,
    price bigint NOT NULL,
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK ((port >= 0)),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: seqslots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seqslots (
    accountid character varying(51) NOT NULL,
    seqslot integer NOT NULL,
    seqnum integer NOT NULL
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(51) NOT NULL,
    publickey character varying(51) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(51) NOT NULL,
    issuer character varying(51) NOT NULL,
    isocurrency character varying(4) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    authorized boolean NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accountdata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accountdata (accountid, key, value) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, numsubentries, inflationdest, thresholds, flags) FROM stdin;
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	1000000000	0	\N	01000000	0
gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7	99999996999999970	0	\N	01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1050000000	0	\N	01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	949999990	0	\N	01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, txsethash, clfhash, totcoins, feepool, ledgerseq, inflationseq, basefee, basereserve, closetime) FROM stdin;
c2df118ad4998ce12e6d00d3bec68f2d77acb5f3e577d9620b19ceea7e38f6be	0000000000000000000000000000000000000000000000000000000000000000	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	1	0	10	10000000	0
baef5a6cc88b333d3011c22360b9ebf038406c2ac06f0906aaf4e6a60062d32f	c2df118ad4998ce12e6d00d3bec68f2d77acb5f3e577d9620b19ceea7e38f6be	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	2	0	10	10000000	1
1b29fbf0fb4fcdfd5bc4ba3cdf21587e3a9abc45c0c0b6879f37d27b1a6d258f	baef5a6cc88b333d3011c22360b9ebf038406c2ac06f0906aaf4e6a60062d32f	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	3	0	10	10000000	1457714
706f1a93d08c3d0ac5d66fba27306f19cdc9dbcec4113ed05f42e87b4bcfcfe0	1b29fbf0fb4fcdfd5bc4ba3cdf21587e3a9abc45c0c0b6879f37d27b1a6d258f	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	4	0	10	10000000	1457716
707615f71298c926abe859337f1cf2c76391e759a87f7e98505752f445edb820	706f1a93d08c3d0ac5d66fba27306f19cdc9dbcec4113ed05f42e87b4bcfcfe0	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	5	0	10	10000000	1457718
48703a4b71a76a234dbdce48f4d182aead440ec7f654401312a94249008ae82e	707615f71298c926abe859337f1cf2c76391e759a87f7e98505752f445edb820	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	6	0	10	10000000	1457720
76de28e7b4fcba5d9a1e5cbad29c5491e230a4f76e617fe4416a61d0e3884078	48703a4b71a76a234dbdce48f4d182aead440ec7f654401312a94249008ae82e	0101010101010101010101010101010101010101010101010101010101010101	459db4a7571a6c876879280f1196cb35feef5742d8cf56ab3791521e4910e3c4	100000000000000000	0	7	0	10	10000000	1457722
211a8d597545e206d1917c4ef88e3a8d661936b833f873957095cced2490871c	76de28e7b4fcba5d9a1e5cbad29c5491e230a4f76e617fe4416a61d0e3884078	0101010101010101010101010101010101010101010101010101010101010101	5808c42b62693185b979fb27ae17ae38a13ebba594b3b0c3a5f2cb0bd65c5d8e	100000000000000000	0	8	0	10	10000000	1457724
22b3fc032dc8d9f9ce489c701fbb3fb73a8cfecf8df8ea6b0ca055260857519f	211a8d597545e206d1917c4ef88e3a8d661936b833f873957095cced2490871c	0101010101010101010101010101010101010101010101010101010101010101	4d2525252409bbe1d05ddfb87a080ab069299b6ade00d4f34f799a654de8b647	100000000000000000	30	9	0	10	10000000	1457726
cf7ff0d967fdc86c4816a68424f191ed0c4408d61bbd0560442bab4ca6722605	22b3fc032dc8d9f9ce489c701fbb3fb73a8cfecf8df8ea6b0ca055260857519f	0101010101010101010101010101010101010101010101010101010101010101	e2ab331a390f805a1e97d2399f1c4c7b78de6d0b38cc3720fc747e258d5638ec	100000000000000000	40	10	0	10	10000000	1457728
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysisocurrency, paysissuer, getsisocurrency, getsissuer, amount, pricen, priced, flags, price) FROM stdin;
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: seqslots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY seqslots (accountid, seqslot, seqnum) FROM stdin;
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	0	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	0	0
gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7	0	3
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	0	1
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseInitialized             	true
forceSCPOnNextLaunch            	false
lastClosedLedger                	cf7ff0d967fdc86c4816a68424f191ed0c4408d61bbd0560442bab4ca6722605
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, isocurrency, tlimit, balance, authorized) FROM stdin;
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txbody, txresult, txmeta) FROM stdin;
c70d619e2b6564f8de49f2ac78c3b851ebfcbade6076b321dbcf695028db6695	9	gAAAxC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAABAAAAAAAAAAB//////////wAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAAAO5rKAAAAAAAAAAAAO5rKAAAAAAAAAAAAAAAAASn2zNuAipEfXlPJvgdnWc2m85P7iI7z2SJ1hn2cSQ05xbgc490PSuiyWgYXfqeF304NWadLiUl22MQLvXi4TgY=	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuaygAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXgh7zX2AAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAA==
7cb31a32ddff15a55c65546e446ef3c8fda7cd95065f70968bb135a8912b583a	9	gAAAxC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAACAAAAAAAAAAB//////////wAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAAAAAAAO5rKAAAAAAAAAAAAO5rKAAAAAAAAAAAAAAAAAQMjFc9S6T4OTNmC8rTNea290oKVdwGEmP1EbuXoECAqp2yZaTp5h64ZpnYIAe32ojEXRtfrDfRZTrkaIxBFTAk=	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuaygAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXfmVGvsAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAA==
cf70187c7238c2b18a7546e02be9ae396ea560a5f9b733b2eecc237dc5bd1ed2	9	gAAAxC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAADAAAAAAAAAAB//////////wAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAAO5rKAAAAAAAAAAAAO5rKAAAAAAAAAAAAAAAAAV+jz6XHBihnyZUqAZyDgxxEMtQm7heNca/TiVti7waz1GVIkLAjBE5F7/bIDEGvcm+U7jmqZDDVdH7IMBNeiwk=	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuaygAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXequaHiAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAA==
50da5bf14fb2b65c1449ae63d7003019b40d0c699e81a62fac9f55849bb3a781	10	gAAAxK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAAAAAABAAAAAAAAAAB//////////wAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAAAvrwgAAAAAAAAAAAAvrwgAAAAAAAAAAAAAAAAdyX76m80r5cW+UK+n8o9Xl/dV1W+4kOHue7vcGWuO0FaTdp1WTKjznHP4nZzQsupMk7qXzIyupxy9XP0ycb+Q8=	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAD6VuoAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA4n9l2AAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAA==
\.


--
-- Name: accountdata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accountdata
    ADD CONSTRAINT accountdata_pkey PRIMARY KEY (accountid);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: seqslots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seqslots
    ADD CONSTRAINT seqslots_pkey PRIMARY KEY (accountid, seqslot);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, isocurrency);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nullstyle;
GRANT ALL ON SCHEMA public TO nullstyle;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

