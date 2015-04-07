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
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
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
    seqnum bigint NOT NULL,
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
    paysisocurrency character varying(4) NOT NULL,
    paysissuer character varying(51) NOT NULL,
    getsisocurrency character varying(4) NOT NULL,
    getsissuer character varying(51) NOT NULL,
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
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
    txindex integer NOT NULL,
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
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	1000000000	21474836480	0	\N	01000000	0
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999996999999970	3	0	\N	01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1050000000	21474836480	0	\N	01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	949999990	21474836481	0	\N	01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
43cf4db3741a7d6c2322e7b646320ce9d7b099a0b3501734dcf70e74a8a4e637	0000000000000000000000000000000000000000000000000000000000000000	e34f893566871dadaab7fdbb9fe111aac7ac542417271f9f3fd891b963264d1d	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA40+JNWaHHa2qt/27n+ERqsesVCQXJx+fP9iRuWMmTR0AAAABAAAAAAAAAAABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
eb41fbea1b199ea4dd3c9966e0be835a537cc49317ea92f8cedde7f49cad7230	43cf4db3741a7d6c2322e7b646320ce9d7b099a0b3501734dcf70e74a8a4e637	1831262bef6a1962aaa245f4000edd3000c503fe282864f740777f4d74acbfc4	2	1428437387	Q89Ns3QafWwjIue2RjIM6dewmaCzUBc03PcOdKik5jf5KRx0BucwVFzutse7JWwEx/lTgjuFE8q7isUyUGec6eOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVGDEmK+9qGWKqokX0AA7dMADFA/4oKGT3QHd/TXSsv8QAAAACAAAAAFUkOYsBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
9a498ed19bc9b14fe854c517bf965e2607dc0a421c0fffae04541c148662fa3c	eb41fbea1b199ea4dd3c9966e0be835a537cc49317ea92f8cedde7f49cad7230	1831262bef6a1962aaa245f4000edd3000c503fe282864f740777f4d74acbfc4	3	1428437392	60H76hsZnqTdPJlm4L6DWlN8xJMX6pL4zt3n9JytcjC3TZn9iAxMs1X8wIAt7cEyida7MBh90+hPqtb+2dGpLOOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVGDEmK+9qGWKqokX0AA7dMADFA/4oKGT3QHd/TXSsv8QAAAADAAAAAFUkOZABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
7ff2368d003f7ae0d5deb181b392ef8bbb49ef76d3908d322bb1ac476c91a75c	9a498ed19bc9b14fe854c517bf965e2607dc0a421c0fffae04541c148662fa3c	9601f47723f0db7479fdff570d5f99e60621a9dd8e1fa7c0995df87adb810786	4	1428437397	mkmO0ZvJsU/oVMUXv5ZeJgfcCkIcD/+uBFQcFIZi+jwh2ZuXkDBfU5IKLgXGHONrMSsv1WBBPgFcQALso7uy9OOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVlgH0dyPw23R5/f9XDV+Z5gYhqd2OH6fAmV34etuBB4YAAAAEAAAAAFUkOZUBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
c398ac4e7d4931738011712fdd2d48a085c3b0642a42d65aadcfd6d557c3419a	7ff2368d003f7ae0d5deb181b392ef8bbb49ef76d3908d322bb1ac476c91a75c	555d35a830744c50f325460122136efac503c2157947435b05c55162726c24c4	5	1428437402	f/I2jQA/euDV3rGBs5Lvi7tJ73bTkI0yK7GsR2yRp1wbM8JLc+e7MrujP/OEIK5DCy4Tfhe7dpEUM9K91ck5kVEFbpKzehDQGGTYuAKTXK1VMGTB8nm9eJk5K8p9qQKaVV01qDB0TFDzJUYBIhNu+sUDwhV5R0NbBcVRYnJsJMQAAAAFAAAAAFUkOZoBY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloA=
f3a846f1d3df0b03adfe26d70ea140ffbb48df328fcc05fe818de89f1a776439	c398ac4e7d4931738011712fdd2d48a085c3b0642a42d65aadcfd6d557c3419a	652ac61409f14b9d9c7b015d824b8815a77c30543da26bcc94b0ca5c8d460f4f	6	1428437407	w5isTn1JMXOAEXEv3S1IoIXDsGQqQtZarc/W1VfDQZqU4JZRiNUjxPeaU9t+4MfPYXiIdSL+o2tnlspFHraaSu4DrUbsIS+REy0U3QAsiQ6vXYMdbB0eHPbSNTzPS5ogZSrGFAnxS52cewFdgkuIFad8MFQ9omvMlLDKXI1GD08AAAAGAAAAAFUkOZ8BY0V4XYoAAAAAAAAAAAAoAAAAAAAAAAAAAAAAAAAACgCYloA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysisocurrency, paysissuer, getsisocurrency, getsissuer, amount, pricen, priced, price) FROM stdin;
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
lastClosedLedger                	f3a846f1d3df0b03adfe26d70ea140ffbb48df328fcc05fe818de89f1a776439
historyArchiveState             	{\n    "version": 0,\n    "currentLedger": 6,\n    "currentBuckets": [\n        {\n            "curr": "d6ae3a74f7774085e18bf8aca507a48a17fc31226dbb11f770ff7d947db57490",\n            "snap": "118dd42b5e4e6728f600ccc54956f461f0f571193f6c10dfa134eeec5d585e2c"\n        },\n        {\n            "curr": "f8a547f05d88464ea0960d2616d11262af7a6f0a9227e7c7da0708f04732979b",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, isocurrency, tlimit, balance, authorized) FROM stdin;
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
6391dd190f15f7d1665ba53c63842e368f485651a53d8d852ed442a446d1c69a	5	1	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAEAAAAA/////wAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABiZsoQFQvjAdrPVykRCwv0xNJw3azmo7RhC4D+dbc8flfnUTDo8XkZ2KsT/BTBkP73qZL8Tm31vjtpWAEHMCB8Zwlmws=	Y5HdGQ8V99FmW6U8Y4QuNo9IVlGlPY2FLtRCpEbRxpoAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rKAAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAWNFeCHvNfYAAAAAAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAA
c31867b3ec0f745e0b2af87ee3f837a0dec71e270b072a9d3e93c557e74e2d60	5	2	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAIAAAAA/////wAAAAEAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABiZsoQOgneQaFQeTarIGR1nIWBRD6MjOLsIH7HLlTuFDrDVplgP2YaVmbSViWj78IAxS+yYCmuEiPCHuxBolJFUmlIQE=	wxhns+wPdF4LKvh+4/g3oN7HHicLByqdPpPFV+dOLWAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAAO5rKAAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAWNFd+ZUa+wAAAAAAAAAAgAAAAAAAAAAAAAAAAEAAAAAAAAA
774e2ce667a8c4070f4d43e8f74ec86f549cee6344dfe582877be72859586a8e	5	3	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAMAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABiZsoQBUO5K/IbcVtqv6hmAWw0eOmkfQoI19FxQAKRfTxDqVH6i+oTaLcDVEUz28qLBjNVuGhmG8nkZjIg6zGsvU2uwg=	d04s5meoxAcPTUPo907Ib1Sc7mNE3+WCh3vnKFlYao4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rKAAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAWNFd6q5oeIAAAAAAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAAA
30f00027f8a9def1fb908a90c27be44a6c1a4ec3842ac3fb0c5940284523e73d	6	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAABQAAAAEAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAAC+vCAAAAAAAAAAAAAAAAAAAAAAAL68IAAAAABrqN6LX0bpl6ptezfCnkVFz0RCrTF5KExMBTSLU9bzv0yU3bu69/KZeSGuRNBkla6ezQ6h3BamN7IzdsAINMNJacr6AE=	MPAAJ/ip3vH7kIqQwnvkSmwaTsOEKsP7DFlAKEUj5z0AAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAPpW6gAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADif2XYAAAAFAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAA
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

