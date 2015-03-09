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
    seqnum integer NOT NULL,
    numsubentries integer NOT NULL,
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

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, thresholds, flags) FROM stdin;
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	1000000000	0	0	\N	01000000	0
gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7	99999996999999970	3	0	\N	01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1050000000	0	0	\N	01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	949999990	1	0	\N	01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, txsethash, clfhash, totcoins, feepool, ledgerseq, inflationseq, basefee, basereserve, closetime) FROM stdin;
0f12cf3f3a1ec9eb9dcb019224c684a208fcf48c72fad78e1a518fc0728f996f	0000000000000000000000000000000000000000000000000000000000000000	0101010101010101010101010101010101010101010101010101010101010101	a435724e67a12d6e94d0d8595bf8f100ee1fa467051a8f181d8dde13269ad135	100000000000000000	0	1	0	10	10000000	0
dcf768763e676a6a00439d212428a3e969b16e44ed5ac606f293e5ff69233147	0f12cf3f3a1ec9eb9dcb019224c684a208fcf48c72fad78e1a518fc0728f996f	0101010101010101010101010101010101010101010101010101010101010101	a435724e67a12d6e94d0d8595bf8f100ee1fa467051a8f181d8dde13269ad135	100000000000000000	0	2	0	10	10000000	1486181
23bcf88c18e356feac9581d55e8a76a87768894043552872a94816f44c45d24c	dcf768763e676a6a00439d212428a3e969b16e44ed5ac606f293e5ff69233147	0101010101010101010101010101010101010101010101010101010101010101	a435724e67a12d6e94d0d8595bf8f100ee1fa467051a8f181d8dde13269ad135	100000000000000000	0	3	0	10	10000000	1486183
c12a85214ab997f77168afb10dd8f6ce28574967a7477cb311f0067b5141018c	23bcf88c18e356feac9581d55e8a76a87768894043552872a94816f44c45d24c	0101010101010101010101010101010101010101010101010101010101010101	a435724e67a12d6e94d0d8595bf8f100ee1fa467051a8f181d8dde13269ad135	100000000000000000	0	4	0	10	10000000	1486185
22177209e124c496fac00b8c16c885f487871762d5f2331b7036d4400a816573	c12a85214ab997f77168afb10dd8f6ce28574967a7477cb311f0067b5141018c	0101010101010101010101010101010101010101010101010101010101010101	a435724e67a12d6e94d0d8595bf8f100ee1fa467051a8f181d8dde13269ad135	100000000000000000	0	5	0	10	10000000	1486187
ad0422c5106995fd58370af578b0c7f523ad56e5213fbb6156829d80db31fdcc	22177209e124c496fac00b8c16c885f487871762d5f2331b7036d4400a816573	0101010101010101010101010101010101010101010101010101010101010101	41a314224808824c01f369e23d9bb0e5e9ebe27a4bfdb6eba1ecb7709529ce86	100000000000000000	30	6	0	10	10000000	1486189
97c5463970c35b8929bb633616afb6bf025a83a56936024511aacf5e65c7de0b	ad0422c5106995fd58370af578b0c7f523ad56e5213fbb6156829d80db31fdcc	0101010101010101010101010101010101010101010101010101010101010101	92b1fbf9e8d393d875e5e106bec0eb2c57b25a3792393d82688c54affe29a555	100000000000000000	40	7	0	10	10000000	1486191
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
lastClosedLedger                	97c5463970c35b8929bb633616afb6bf025a83a56936024511aacf5e65c7de0b
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
35b87c0f6adbb84c65c5e42af06a0845946d54832b4e31952159bc77a3988e7d	6	gAAAzC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAABAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABem+oPw89dl/n3GgkeZyttXO30i1lAkuLsIzfqq9PwBU1Xi+56qNqzGKtV2gu7cX/3pMtvWvezW3MsVzQMQ9cCA==	gAAAHAAAAAAAAAAKAAAAAAAAAAEAAAABAAAAAAAAAAA=	gAAAnAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuaygAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXgh7zX2AAAAAQAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
9af8934c06bf6b5070ebcc863e5825d73f2e273a71ee8c9580affcc0eee0dfb2	6	gAAAzC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAACAAAAAAAAAAB//////////wAAAAEAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABr3eLRPKdVCBiJGOqWJLWU3y4IasTxj0xAtQiLS0tUUkfbJD63ATV1pQOZbt+xcNKTJ4EpChZmRtuaAySqkLlDA==	gAAAHAAAAAAAAAAKAAAAAAAAAAEAAAABAAAAAAAAAAA=	gAAAnAAAAAIAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuaygAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXfmVGvsAAAAAgAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
0348aced4c1462211d8017e1a598f58642f3774ca6aaac6281314ac6c4eb7fc3	6	gAAAzC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAAAACgAAAAAAAAADAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAB8edTcLdG1ByxEP2dXQI5nAfu+8ARw1kJ5eu3w76KG6oy7BcEynCgKBuCrqrjXhOxH8NzB/7prgy7KSuRc8XyDg==	gAAAHAAAAAAAAAAKAAAAAAAAAAEAAAABAAAAAAAAAAA=	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuaygAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuPDUBB0nB3j2aW91qMcEkWHaNpc6HzKaq1j67qu90MgFjRXequaHiAAAAAwAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
b41c1fa00feb44bc61b69c59b6dace0c2d0382b1908f2353ddd08d5cedc55899	7	gAAAzK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAAAAAABAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAAC+vCAAAAAAAAAAAAC+vCAAAAAAAAAAAAAAAABFkWaIFhHyKwj7lc0Px+mi7x21c3HopRccRLMbw82dKA8Yy5ezLxJ4YujqtQc7l8FpJoXpZsmYHgxrtrHfHSQBQ==	gAAAHAAAAAAAAAAKAAAAAAAAAAEAAAABAAAAAAAAAAA=	gAAAnAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAD6VuoAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA4n9l2AAAAAQAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
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

