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
gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	1000000000	30064771072	0	\N	01000000	0
gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7	99999996999999970	3	0	\N	01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1050000000	30064771072	0	\N	01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	949999990	30064771073	0	\N	01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
f97d5a06cde156925b18bcc25f828d09a6e707336575001fc54eb6d3b293ec50	0000000000000000000000000000000000000000000000000000000000000000	27da89b86b2c02e24a17b07d7771452e2dd9678c4208e43a48bcd12944f2ed66	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJ9qJuGssAuJKF7B9d3FFLi3ZZ4xCCOQ6SLzRKUTy7WYAAAABAAAAAAAAAAABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
260c42e9cbb38acd9c42ad4de59b8969a01c8494f196414f0993cd9b16bf87ea	f97d5a06cde156925b18bcc25f828d09a6e707336575001fc54eb6d3b293ec50	4b2f4a5262f873c5a0ba0de70c232082700f26f1d8b7b9618792be015abd21cf	2	438746	+X1aBs3hVpJbGLzCX4KNCabnBzNldQAfxU6207KT7FDHNeC5a1CwZCNiY/rdwSZeMxvJ2a77mpmkhBv3xcxQQeOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVSy9KUmL4c8Wgug3nDCMggnAPJvHYt7lhh5K+AVq9Ic8AAAACAAAAAAAGsdoBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
6ed8772a4a7b31d9f0fb8dedee5c68096d80c89fed38334dc2d015eb687415bc	260c42e9cbb38acd9c42ad4de59b8969a01c8494f196414f0993cd9b16bf87ea	4b2f4a5262f873c5a0ba0de70c232082700f26f1d8b7b9618792be015abd21cf	3	438750	JgxC6cuzis2cQq1N5ZuJaaAchJTxlkFPCZPNmxa/h+qfjpgzvBw2RZCtV7fTsu9/iK9tsRdhxL+yAWFHtCs4zeOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVSy9KUmL4c8Wgug3nDCMggnAPJvHYt7lhh5K+AVq9Ic8AAAADAAAAAAAGsd4BY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
23e1cdf83f1c6c18ccab789af8723fca72d18c50ac105a8bd0cb40238050b141	6ed8772a4a7b31d9f0fb8dedee5c68096d80c89fed38334dc2d015eb687415bc	8728e7b10232c01cfc77d6a88bd3c09129ab7cc24ae407d79742ecdbd22d1c8f	4	438754	bth3Kkp7Mdnw+43t7lxoCW2AyJ/tODNNwtAV62h0FbwBU3KDNZTEVjm/512C3z2fiT6Mnm6/KEPG8AUKlOs14+OwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVhyjnsQIywBz8d9aoi9PAkSmrfMJK5AfXl0Ls29ItHI8AAAAEAAAAAAAGseIBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
35f1022feae68affdcddae6d8c93f33336b69db47fba9a923410c9ecf68879c9	23e1cdf83f1c6c18ccab789af8723fca72d18c50ac105a8bd0cb40238050b141	8728e7b10232c01cfc77d6a88bd3c09129ab7cc24ae407d79742ecdbd22d1c8f	5	438758	I+HN+D8cbBjMq3ia+HI/ynLRjFCsEFqL0MtAI4BQsUFY7xXN8LPg94sHMuLT8MYSxR8D4zq2QQm6fBgUH0pLL+OwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVhyjnsQIywBz8d9aoi9PAkSmrfMJK5AfXl0Ls29ItHI8AAAAFAAAAAAAGseYBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
87ecdb6eec4844bee5bb9fab1347be2d9853d04f043ebe5e7dedb900bf6d51e2	35f1022feae68affdcddae6d8c93f33336b69db47fba9a923410c9ecf68879c9	8728e7b10232c01cfc77d6a88bd3c09129ab7cc24ae407d79742ecdbd22d1c8f	6	438762	NfECL+rmiv/c3a5tjJPzMza2nbR/upqSNBDJ7PaIecmxKYgAYaoe9VJTekkB2P/j9rX1DTyQz30Mr5ILBDKdLeOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVhyjnsQIywBz8d9aoi9PAkSmrfMJK5AfXl0Ls29ItHI8AAAAGAAAAAAAGseoBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
e47d824bf7eb14c7b5b583060e5cabd11bfb2b9b81642a0e1a82ef0541ffddbd	87ecdb6eec4844bee5bb9fab1347be2d9853d04f043ebe5e7dedb900bf6d51e2	f283b61edd430f5e9a1b3de8e6b0e13e27df92d235df0c468b70428431159753	7	438766	h+zbbuxIRL7lu5+rE0e+LZhT0E8EPr5efe25AL9tUeLBZ/06QQMhY9nc/nhOXdz5firoKrY5B7ockt7rBsdlID5SCg/EIcF4c/qXZZYy5/5IoQtB3WVSBqpiPmAcCuFi8oO2Ht1DD16aGz3o5rDhPiffktI13wxGi3BChDEVl1MAAAAHAAAAAAAGse4BY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloA=
06c6daede0f06bda8f075cb36049268c3f5811b870408f82ccf74635f921f84c	e47d824bf7eb14c7b5b583060e5cabd11bfb2b9b81642a0e1a82ef0541ffddbd	8ee1624745da6a447c3d144b2219b6336643f1a44d22a186f0ee2d459387ef0d	8	438770	5H2CS/frFMe1tYMGDlyr0Rv7K5uBZCoOGoLvBUH/3b0br1RHKFnV+MTK/9nQr3ZxQIpz1Hd3tlJfVI1JgUOwLlq1jAy2pB1/oE1Cs3GQjX/+NwyBZ/FNlZV5no7gp+5GjuFiR0XaakR8PRRLIhm2M2ZD8aRNIqGG8O4tRZOH7w0AAAAIAAAAAAAGsfIBY0V4XYoAAAAAAAAAAAAoAAAAAAAAAAAAAAAAAAAACgCYloA=
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
lastClosedLedger                	06c6daede0f06bda8f075cb36049268c3f5811b870408f82ccf74635f921f84c
historyArchiveState             	{\n    "version": 0,\n    "currentLedger": 8,\n    "currentBuckets": [\n        {\n            "curr": "07919334b3bd9684222c558278fdf93bf8d84a055843d85c86a666a2e40dd8d2",\n            "snap": "df0aae713ba9ca082329b8015d65780c870870329701b2f3650e326d1058cf32"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "81bc70b3ecdeb5a633995d6b394174879e97fc38bf4c3d2b58a760b6fa823769"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
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
14478f5ca4ec3518181f7a96cb032748ff1d44dfdc2a56488637449aef1bb452	7	1	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAEAAAAA/////wAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABLjw1AQSwZMUpJZ7p/WeG1UmDg1EMRgzsaLTu/IsAzWhob2C/8zbVzMca78FwS0rC5k/VTkyLydj6q8gbCEwUIPQZ9gk=	FEePXKTsNRgYH3qWywMnSP8dRN/cKlZIhjdEmu8btFIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rKAAAAAAcAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAWNFeCHvNfYAAAAAAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAA
8577331397e5c6a3b646be83cf074e621adae6e6df7b3931ad69e7546036baab	7	2	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAIAAAAA/////wAAAAEAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABLjw1AXeTDJRmx2FYP8bTCXkr0Ewr1px7/NG5vJlS95F/ICOfrAmCqpvTgxNkmnFCZ7ehhnbWmmA9R1EygLX32naO8AI=	hXczE5flxqO2Rr6DzwdOYhra5ubfezkxrWnnVGA2uqsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAAO5rKAAAAAAcAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAWNFd+ZUa+wAAAAAAAAAAgAAAAAAAAAAAAAAAAEAAAAAAAAA
e3b482c6f9f458d6f04f13eca72ca1ff8ac7edd2f2bd773d8bdf5be1ba10b48b	7	3	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAMAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAA7msoAAAAAAAAAAAAAAAAAAAAAADuaygAAAAABLjw1AdkmWRibNEKDvCDlEr7sDRmbDdQ72UshG/QXfKd7UwrjKU3Q/OjZAe01VqGJbL2MuDkwXY+3odkBH2OgndmhQAQ=	47SCxvn0WNbwTxPspyyh/4rH7dLyvXc9i99b4boQtIsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rKAAAAAAcAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAC48NQEHScHePZpb3WoxwSRYdo2lzofMpqrWPruq73QyAWNFd6q5oeIAAAAAAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAAA
cba7467ede75f0efe5201f003aa4411faa8e4c090a06bb375956ab12adecef42	8	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAABwAAAAEAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAAC+vCAAAAAAAAAAAAAAAAAAAAAAAL68IAAAAABrqN6LQq8pepgKX4tKLzRV5cKggF/6QphX/+AcuM4ByzB+yXR3UBsYaHqEeSlbw1lhgS81VDNYr/+NrRBr3MdBWM4vgs=	y6dGft518O/lIB8AOqRBH6qOTAkKBrs3WVarEq3s70IAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAPpW6gAAAAAcAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADif2XYAAAAHAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAA
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

