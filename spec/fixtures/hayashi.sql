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
    clfhash character(64) NOT NULL,
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

COPY ledgerheaders (ledgerhash, prevhash, clfhash, ledgerseq, closetime, data) FROM stdin;
04ea70785b4ae34053d4012ed1c2bd0e12202b9b1a83ea3c2bcec473b7ef27fe	0000000000000000000000000000000000000000000000000000000000000000	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAAAQAAAAAAAAAAAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
c4bd9451adb3a6a524df24675aee24c40a0b36f51cfbf0dd0ae5a34159082988	04ea70785b4ae34053d4012ed1c2bd0e12202b9b1a83ea3c2bcec473b7ef27fe	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	2	18633	BOpweFtK40BT1AEu0cK9DhIgK5sag+o8K87Ec7fvJ/4BAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAAAgAAAAAAAEjJAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
3f0f7884561344e184d3c9001b9c1a4ce56ecf8e727643c052347a03cb4bebd0	c4bd9451adb3a6a524df24675aee24c40a0b36f51cfbf0dd0ae5a34159082988	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	3	18635	xL2UUa2zpqUk3yRnWu4kxAoLNvUc+/DdCuWjQVkIKYgBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAAAwAAAAAAAEjLAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
4cbeb09e77f60e3727e243244d9337c783ec2157c4f8ef409a82f8114ca944bd	3f0f7884561344e184d3c9001b9c1a4ce56ecf8e727643c052347a03cb4bebd0	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	4	18637	Pw94hFYTROGE08kAG5waTOVuz45ydkPAUjR6A8tL69ABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAABAAAAAAAAEjNAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
b4b53a2228fb49d72856a588ff58112a0a5c50d0050b7243bf4814da164e885a	4cbeb09e77f60e3727e243244d9337c783ec2157c4f8ef409a82f8114ca944bd	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	5	18639	TL6wnnf2Djcn4kMkTZM3x4PsIVfE+O9AmoL4EUypRL0BAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAABQAAAAAAAEjPAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
dca0a81c916da871cdbcccd2d7ce995c51213289a936325a863fc25a3db74190	b4b53a2228fb49d72856a588ff58112a0a5c50d0050b7243bf4814da164e885a	50aaac0501d667f3e81ef44d25188c29282dcfdc6ed106d32d9afdd2b0d1294a	6	18641	tLU6Iij7SdcoVqWI/1gRKgpcUNAFC3JDv0gU2hZOiFoBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAVCqrAUB1mfz6B70TSUYjCkoLc/cbtEG0y2a/dKw0SlKAAAABgAAAAAAAEjRAWNFeF2KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAmJaA
1bcb217959536696cf31f5a183254f5d1d850ffac88eb80db0bbc58986bdb121	dca0a81c916da871cdbcccd2d7ce995c51213289a936325a863fc25a3db74190	910005fcd582935004a9666c9b7c761b6e4ac78438a89760667d7797e00aee40	7	18643	3KCoHJFtqHHNvMzS186ZXFEhMompNjJahj/CWj23QZABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAZEABfzVgpNQBKlmbJt8dhtuSseEOKiXYGZ9d5fgCu5AAAAABwAAAAAAAEjTAWNFeF2KAAAAAAAAAAAAHgAAAAAAAAAAAAAAAAAAAAoAmJaA
79d9750d35292229860802547ac74993deb7a25e286937ddb941370e37697373	1bcb217959536696cf31f5a183254f5d1d850ffac88eb80db0bbc58986bdb121	ba932904b8db08ca32f5867d2469de6e68f67443a6ae2499ae948493b8e1fb59	8	18645	G8sheVlTZpbPMfWhgyVPXR2FD/rIjrgNsLvFiYa9sSEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAbqTKQS42wjKMvWGfSRp3m5o9nRDpq4kma6UhJO44ftZAAAACAAAAAAAAEjVAWNFeF2KAAAAAAAAAAAAKAAAAAAAAAAAAAAAAAAAAAoAmJaA
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
lastClosedLedger                	79d9750d35292229860802547ac74993deb7a25e286937ddb941370e37697373
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
8cea3ab2c4c7d7089e9a576e35acecc2da16944b8790b687cd9e233b2891f8b5	7	1	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAEAAAAA/////wAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABLjw1AZo4mBorsVDAp3NW1+9EGUU8w+k4b0FYUpbG4oyaWxJ+4hJOA7O5awYGD+jsGHc6R3k+qKQFG31InZV+NMfdIwA=	AAAAAAAAAAoAAAAAAAAAAQAAAAEAAAAAAAAAAA==	gAAApAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAADuaygAAAAAHAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALjw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIBY0V4Ie819gAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
14efac6515fc0ab6fd53a83721ff0f1f6a8e390f47f51460334bc6d52d50af85	7	2	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAIAAAAA/////wAAAAEAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABLjw1Ab4ueNiUKx19CMoTYocKfDLUMCvMbimM64zeYqbpJKfwf9HbK0eZ3zr4fdIVYG41fb86DrpJ9oZ82Vyys+SgPgk=	AAAAAAAAAAoAAAAAAAAAAQAAAAEAAAAAAAAAAA==	gAAApAAAAAIAAAAAAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAADuaygAAAAAHAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALjw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIBY0V35lRr7AAAAAAAAAACAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
1f06db4e328bb2156b87287a423aee24d030c8a7df0c3d1975b9d2085c91678f	7	3	Ljw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIAAAAKAAAAAAAAAAMAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAA7msoAAAAAAAAAAAA7msoAAAAAAAAAAAAAAAABLjw1AVbJmob+Dy1eO8bEFu4Re4Voi0h8PMl8GHTqcjJ4ttg7NHe2PVEy1jnxeg4BHwNJrS+SrHDyVaiY4i2879jK1Q8=	AAAAAAAAAAoAAAAAAAAAAQAAAAEAAAAAAAAAAA==	gAAApAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAADuaygAAAAAHAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALjw1AQdJwd49mlvdajHBJFh2jaXOh8ymqtY+u6rvdDIBY0V3qrmh4gAAAAAAAAADAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
7464bfdbc356dc52167a7b00475cf2592348af1937dbb22ed678f79fa567dd06	8	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAABwAAAAEAAAAA/////wAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAAC+vCAAAAAAAAAAAAC+vCAAAAAAAAAAAAAAAABrqN6LZd4bEHcTVZ5HcXsxLIXM8CO93CkxpNe+B3/VHQ4mLUr6HwPx8h53CGWkpWYkmc7TS4yqis3AQ7zMRL51Dl1nwQ=	AAAAAAAAAAoAAAAAAAAAAQAAAAEAAAAAAAAAAA==	gAAApAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAD6VuoAAAAAHAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAOJ/ZdgAAAAcAAAABAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
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

