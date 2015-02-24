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
    sequence integer DEFAULT 1 NOT NULL,
    ownercount integer DEFAULT 0 NOT NULL,
    inflationdest character varying(51),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_ownercount_check CHECK ((ownercount >= 0)),
    CONSTRAINT accounts_sequence_check CHECK ((sequence >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    hash character(64) NOT NULL,
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
    sequence integer NOT NULL,
    paysisocurrency character varying(4) NOT NULL,
    paysissuer character varying(51) NOT NULL,
    getsisocurrency character varying(4) NOT NULL,
    getsissuer character varying(51) NOT NULL,
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    flags integer NOT NULL,
    price bigint NOT NULL,
    CONSTRAINT offers_sequence_check CHECK ((sequence >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character(11) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK ((port >= 0)),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
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

COPY accounts (accountid, balance, sequence, ownercount, inflationdest, thresholds, flags) FROM stdin;
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	1000000000	1	0	\N	01000000	0
gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7	99999996999999970	4	0	\N	01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1050000000	1	0	\N	01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	949999990	2	0	\N	01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (hash, prevhash, txsethash, clfhash, totcoins, feepool, ledgerseq, inflationseq, basefee, basereserve, closetime) FROM stdin;
e2bb98525ddd096dd853ce82e435f8aaa7aca77613509d4adf48cbd98cdf1ca8	0000000000000000000000000000000000000000000000000000000000000000	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	1	0	10	10000000	0
4ca3ad0684f9e271bedfdbc7a748e23d2e62e4c160376a19b85af1002fad58b6	e2bb98525ddd096dd853ce82e435f8aaa7aca77613509d4adf48cbd98cdf1ca8	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	2	0	10	10000000	0
7b98119cd51cd13ebbf6798918a4f0b319b813dd703de6f5d8b8b60d052ef652	4ca3ad0684f9e271bedfdbc7a748e23d2e62e4c160376a19b85af1002fad58b6	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	3	0	10	10000000	0
e2875023bcea054e4384ee00f2bb2f29d41c244187e752f468da9e9ee3d2b323	7b98119cd51cd13ebbf6798918a4f0b319b813dd703de6f5d8b8b60d052ef652	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	4	0	10	10000000	0
a9591a4626c515f71b9246304ea1b4758efd96903b225f916ff10e542b5f86dc	e2875023bcea054e4384ee00f2bb2f29d41c244187e752f468da9e9ee3d2b323	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	5	0	10	10000000	0
1309a2589f3648136e629495c112a7178dee37ec0740cd2b2d66f249c3029bf1	a9591a4626c515f71b9246304ea1b4758efd96903b225f916ff10e542b5f86dc	0101010101010101010101010101010101010101010101010101010101010101	d4f9f6fecb7892f224d64c754e7e4ab473761d46f43b5433dfd8dd51ee3b6818	100000000000000000	0	6	0	10	10000000	0
1912af07353a2964bebf7765eb9e09b4f04be873057cecb15ed1d1866abba26d	1309a2589f3648136e629495c112a7178dee37ec0740cd2b2d66f249c3029bf1	0101010101010101010101010101010101010101010101010101010101010101	c3e698ca2e633df8a8c9fce6519a74ef8fe7c139e53025520a0ceab22505aa9a	100000000000000000	30	7	0	10	10000000	0
f82e493cda2a61272f136548f8328363dcd4323f840d6529c61c2b2ccbe75a8f	1912af07353a2964bebf7765eb9e09b4f04be873057cecb15ed1d1866abba26d	0101010101010101010101010101010101010101010101010101010101010101	a2db9ebb917ec6ad6b92089e2c0a1d9efad774cb1afa67d5ce99bd5342456c93	100000000000000000	40	8	0	10	10000000	0
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, sequence, paysisocurrency, paysissuer, getsisocurrency, getsissuer, amount, pricen, priced, flags, price) FROM stdin;
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
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
lastClosedLedger                	f82e493cda2a61272f136548f8328363dcd4323f840d6529c61c2b2ccbe75a8f
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
f4a1682820f176b9b8e05b2362b6c983219826d231c22bccf21ff663070e665b	7	gAAAwC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAF//////////wAAAAAAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABHUJFU8e9GSBZI+QQ8naNDkw7nAZxeadIFNTK/J/JfYQI8O+NjDXKZtylh0zvXCLPcEFWRQXE5xAqu3Le8lIWCA==	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuaygAAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXgh7zX2AAAAAgAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
8a366443f014736d18b9a99ea589884bcd9c95aa52b419fc43356cddc71166b2	7	gAAAwC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAJ//////////wAAAAAAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABaaOtJmLIJ+7YIZwTFf9fERu7Bd14rYiHu2nzwWNm/fHAs7Aabllbj10T+zAdJNl8v/gNPpSqZx1kr7BsOFhrBg==	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuaygAAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXfmVGvsAAAAAwAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
5ed90159251db688d2d09eef2b9e2d53db48ed1697885d1dff80e16461b23b63	7	gAAAwC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAN//////////wAAAAAAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABNFR7Gb4wCRqneAi4iB/KyOU5uM+cyanl/9r7j5nSlmVUnsS8xZG350WdP+XVuDY+8cFfGQbLrID21Yng1AxFCQ==	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuaygAAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXequaHiAAAABAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
e0c756ac51a15392a514008881bbd61658906e4b3e1f98e3107bb668be694d39	8	gAAAwK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAF//////////wAAAAAAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAAC+vCAAAAAAAAAAAAC+vCAAAAAAAAAAAAAAAABPwgjewBRX7VoOy4+TIM5tlMd3qVHQ6CMTp91AF3M4vVYHVCGGnvPuTh0sT3iQGIqWGpYsN3nlCDfZeJHlYt2Aw==	gAAAFAAAAAAAAAAKAAAAAAAAAAAAAAAA	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAD6VuoAAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA4n9l2AAAAAgAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
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
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (hash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (accountid, sequence);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


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

