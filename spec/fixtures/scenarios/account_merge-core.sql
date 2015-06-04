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

DROP INDEX public.signersaccount;
DROP INDEX public.priceindex;
DROP INDEX public.paysissuerindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.getsissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
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
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(51) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(51),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    accountid character varying(51) NOT NULL,
    offerid bigint NOT NULL,
    paysalphanumcurrency character varying(4),
    paysissuer character varying(51),
    getsalphanumcurrency character varying(4),
    getsissuer character varying(51),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
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
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
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
    alphanumcurrency character varying(4) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999979999999980	2	0	\N		01000000	0
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	19999999990	12884901888	0	\N		01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	0000000000000000000000000000000000000000000000000000000000000000	e71064e28d0740ac27cf07b267200ea9b8916ad1242195c015fa3012086588d3	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5xBk4o0HQKwnzweyZyAOqbiRatEkIZXAFfowEghliNMAAAABAAAAAAAAAAABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
5ff3ef45991aa7c5f5710c3ea360e36dcf7c9ed4d432f1fc4b212f15faf82ef8	41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	24128cf784e4c94f58a5a72a5036a54e82b2e37c1b1b327bd8af8ab48684abf6	2	1433454709	QTEKAYGjqC/xPASTaVBOl4c0zxfaG68C9+TYgehgg3HWnizXf2VvYXCoygkt/wDezda8dXZTRIUXo6e9UAqQU+OwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVJBKM94TkyU9YpacqUDalToKy43wbGzJ72K+KtIaEq/YAAAACAAAAAFVwyHUBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
39d2bad2501336a724e1d705e4c99e88ea396794bf9e702f3837ac87cdcfc3a4	5ff3ef45991aa7c5f5710c3ea360e36dcf7c9ed4d432f1fc4b212f15faf82ef8	a99c64a2d3715dd006f1dc72c35fe594517bde0dadf001c7d22c9c52b28d0dba	3	1433454710	X/PvRZkap8X1cQw+o2Djbc98ntTUMvH8SyEvFfr4LvgVsYI1RzgnWFiu16x7kjHPLR7N85qwb8UC9u5SQ7UzJJPiilsf0FGBJoAcQNG0NDm3fUpThAO0NLkqsYLarif3qZxkotNxXdAG8dxyw1/llFF73g2t8AHH0iycUrKNDboAAAADAAAAAFVwyHYBY0V4XYoAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAACgCYloA=
46cbea30388a431619fc2fd0ebd08eb328f7c3391823c31f8fac426beb25509d	39d2bad2501336a724e1d705e4c99e88ea396794bf9e702f3837ac87cdcfc3a4	249b88b84f95d7a3d213aaea6dd94e5b3e67e65d4ba4e42f058919924b94af4a	4	1433454711	OdK60lATNqck4dcF5MmeiOo5Z5S/nnAvODesh83Pw6SpLNLY8PXa6lVeoV+xAA60nmbFtfZZFNIZd+L7wIvuP3cNIjzmSVxaXpKRLE454tOwA1doQG/nKfDHX9cnqiGiJJuIuE+V16PSE6rqbdlOWz5n5l1LpOQvBYkZkkuUr0oAAAAEAAAAAFVwyHcBY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysalphanumcurrency, paysissuer, getsalphanumcurrency, getsissuer, amount, pricen, priced, price) FROM stdin;
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
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	46cbea30388a431619fc2fd0ebd08eb328f7c3391823c31f8fac426beb25509d
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 4,\n    "currentBuckets": [\n        {\n            "curr": "30bbab0eb46a59a9e7e1fcb3d1056cd63b4fe3f5059ef27465e27dfd86e72049",\n            "next": {\n                "state": 0\n            },\n            "snap": "7141de76141f231422b5358afaccc618fda153de4d8386751346158f969674db"\n        },\n        {\n            "curr": "dbbd826d458ade51d4a8cfc70260528fb788d3eb80c9a73e49a4cbba1a8f566c",\n            "next": {\n                "state": 1,\n                "output": "7141de76141f231422b5358afaccc618fda153de4d8386751346158f969674db"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, alphanumcurrency, tlimit, balance, flags) FROM stdin;
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
cae6912408e3552ac1653fdacd73aee0b063258b1ea90ed194aecdbdd224c684	3	1	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL5AAAAAABiZsoQAkPQE/vM9msNNOzIMULKVXSalttRpPImBH7bpNz74ZxndhRqOWuIVZSSAvxRab1nFgpcsznFSHxCMiKpJnv/gM=	yuaRJAjjVSrBZT/azXOu4LBjJYseqQ7RlK7NvdIkxoQAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXYJfhv2AAAAAAAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
a47e33a4d8f868fa1fdb91028cd98b7c3e58093807928c94a74a5fc317a2c802	3	2	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAIAAAAAAAAAAAAAAAEAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAlQL5AAAAAABiZsoQLodlJo+YEzWjUYeRC6kNMqpGyRiAleVmhDZbuRZQm6Mu+CUlsW9Wibihm6qr1YwjfoldgrS4XSm/ioi3I7DLgk=	pH4zpNj4aPof25ECjNmLfD5YCTgHkoyUp0pfwxeiyAIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAACVAvkAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXO1cjfsAAAAAAAAAAIAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
f9936ac9899223b7a42904bbad4836daca3725a3387109cb81c00ab3d00dc423	4	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAABztgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAa6jei3ntfy5tU9+bB8gSoAFq125AQNiefZhL48lRi/DZncnogWZa4UVQwmrn4rF80Lll0M88vcmPRxa4l0UQriDEesI	+ZNqyYmSI7ekKQS7rUg22so3JaM4cQnLgcAKs9ANxCMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAcAAAAA	AAAAAgAAAAEAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAEqBfH9gAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAgAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TA==
\.


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
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, alphanumcurrency);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: getsissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX getsissuerindex ON offers USING btree (getsissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: paysissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX paysissuerindex ON offers USING btree (paysissuer);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


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

