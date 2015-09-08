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
DROP INDEX public.sellingissuerindex;
DROP INDEX public.priceindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.buyingissuerindex;
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
    accountid character varying(56) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(56),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
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
    sellerid character varying(56) NOT NULL,
    offerid bigint NOT NULL,
    sellingassettype integer,
    sellingassetcode character varying(12),
    sellingissuer character varying(56),
    buyingassettype integer,
    buyingassetcode character varying(12),
    buyingissuer character varying(56),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
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
    accountid character varying(56) NOT NULL,
    publickey character varying(56) NOT NULL,
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
    accountid character varying(56) NOT NULL,
    assettype integer NOT NULL,
    issuer character varying(56) NOT NULL,
    assetcode character varying(12) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
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

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags, lastmodified) FROM stdin;
GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H	99999994999999950	5	0	\N		AQAAAA==	0	2
GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	999999990	8589934593	1	\N		AQAAAA==	0	3
GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	999999980	8589934594	0	\N		AQAAAA==	0	4
GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	999999980	8589934594	0	\N		AQAAAA==	0	4
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	999999970	8589934595	3	\N		AQAAAA==	0	5
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	999999980	8589934594	1	\N		AQAAAA==	0	6
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
5ade5048fb66795219cbb45a55bf5e2710f739610d10e6875bf7f85d85900669	0000000000000000000000000000000000000000000000000000000000000000	759f642a94be58e4118ef79bd7f343832a82db2fc4f98f41ee7d22b61df716ed	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1n2QqlL5Y5BGO95vX80ODKoLbL8T5j0HufSK2HfcW7QAAAAEBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
0253312715229b1eae80953b7630394ef896e4b17f7adffdf13f207a25a9f9c2	5ade5048fb66795219cbb45a55bf5e2710f739610d10e6875bf7f85d85900669	585600f4ee731b713c0186307c55144158496da748dd377e757c53c44bccc9ee	2	1441737827	AAAAAVreUEj7ZnlSGcu0WlW/XicQ9zlhDRDmh1v3+F2FkAZpMpbF6Kdm7P6nhcsI2w0hIWxKS3B5FIHG2Mh6lK2+ZJsAAAAAVe8sYwAAAAEAAAAIAAAAAQAAAAEAAAAAtG46XY1z83VxYqRxqvJmiXN/yL2Bd/VOJ5MQGCPYnU9YVgD07nMbcTwBhjB8VRRBWEltp0jdN351fFPES8zJ7gAAAAIBY0V4XYoAAAAAAAAAAAAyAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
5b6126702f4b5b2f63b478dba6240d8434f8a0447e2e5f49bf6811e199bf5979	0253312715229b1eae80953b7630394ef896e4b17f7adffdf13f207a25a9f9c2	97c84b5753cee573ee790a724f2ca4d69dbbbbdcb2aff5c64fcac202ce6434e5	3	1441737828	AAAAAQJTMScVIpseroCVO3YwOU74luSxf3rf/fE/IHolqfnCPNuDmcLhTOX7rnZq1viEN06ydJw6ZUWxw+/+sXy5eW8AAAAAVe8sZAAAAAAAAAAAFHL4u/PVx9RHCW7tiFFsATYSyFYDue7mVZOZbW3rXieXyEtXU87lc+55CnJPLKTWnbu73LKv9cZPysICzmQ05QAAAAMBY0V4XYoAAAAAAAAAAABaAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
0dbe06db2c78dc729c7e04813a179536ebd5f33f66a91c82084800d3fc9ab544	5b6126702f4b5b2f63b478dba6240d8434f8a0447e2e5f49bf6811e199bf5979	5dad5af420dd9fbd1b0f1f291416d942036090ccc6b1fccc0ceb8908fe612cc2	4	1441737829	AAAAAVthJnAvS1svY7R426YkDYQ0+KBEfi5fSb9oEeGZv1l5hPr1Zyf2ZrNYsB8RJRpahyll9bvYjAVxkd6+Fpk8I4QAAAAAVe8sZQAAAAAAAAAAPROSWLzF63P7iUpDCc1evlBhiPAXoQQgSUSuvAPEx1xdrVr0IN2fvRsPHykUFtlCA2CQzMax/MwM64kI/mEswgAAAAQBY0V4XYoAAAAAAAAAAACCAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
6bba7a9cd1e62016ab5a81217a01a6afe5e265666a734295d20c6f9b42518551	0dbe06db2c78dc729c7e04813a179536ebd5f33f66a91c82084800d3fc9ab544	ab8facee53ecbbf0c82eb339eba7e9f77a8bb5deb0d32cc8f69be223b58d5689	5	1441737830	AAAAAQ2+BtsseNxynH4EgToXlTbr1fM/ZqkcgghIANP8mrVEagCSDch6fu3XzCqa5YdoDs5VAP7PR7vQeRa8n43zeiIAAAAAVe8sZgAAAAAAAAAAt/DHhpHzSxALd41k2kXydNy9iGGaTxyelpZzgTzkGtyrj6zuU+y78Mgusznrp+n3eou13rDTLMj2m+IjtY1WiQAAAAUBY0V4XYoAAAAAAAAAAACMAAAAAAAAAAAAAAABAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
c21afdba6f5efa89669b718c3e5bd834fcb9a9b504d6fe497b309a7dfeb07ab5	6bba7a9cd1e62016ab5a81217a01a6afe5e265666a734295d20c6f9b42518551	edc697f9514dfb00a275a90688dccf8f8cbe0997f81bab760e225e88aced8537	6	1441737831	AAAAAWu6epzR5iAWq1qBIXoBpq/l4mVmanNCldIMb5tCUYVR04p0kMvNb3dIieBSsvfsSMlBJPBnIuX7ohfNbBXgPawAAAAAVe8sZwAAAAAAAAAAJNoVSejIHw9coBbuiAnCmnryRo2Xe2Bqxd0Pt8wZ2qDtxpf5UU37AKJ1qQaI3M+PjL4Jl/gbq3YOIl6IrO2FNwAAAAYBY0V4XYoAAAAAAAAAAACWAAAAAAAAAAAAAAABAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (sellerid, offerid, sellingassettype, sellingassetcode, sellingissuer, buyingassettype, buyingassetcode, buyingissuer, amount, pricen, priced, price, flags, lastmodified) FROM stdin;
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	1	EUR	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	1	USD	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	199999990	1	1	10000000	0	6
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
lastclosedledger                	c21afdba6f5efa89669b718c3e5bd834fcb9a9b504d6fe497b309a7dfeb07ab5
historyarchivestate             	{\n    "version": 1,\n    "server": "343b61d",\n    "currentLedger": 6,\n    "currentBuckets": [\n        {\n            "curr": "64c68d6843efee943700f1aa324a3cddd80abdee6c2755f28e0a0df1c34ac7d4",\n            "next": {\n                "state": 0\n            },\n            "snap": "6aea55a862f8c862088966691116445215f1bf636da71ba3bb112636230b75e2"\n        },\n        {\n            "curr": "baf0f9d53deb734df23174f2abad9c7e3939e440cce5b3d306a862594ad047cb",\n            "next": {\n                "state": 1,\n                "output": "6aea55a862f8c862088966691116445215f1bf636da71ba3bb112636230b75e2"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, assettype, issuer, assetcode, tlimit, balance, flags, lastmodified) FROM stdin;
GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	1	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	EUR	9223372036854775807	1000000010	1	6
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	9223372036854775807	200000010	1	6
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	GCQPYGH4K57XBDENKKX55KDTWOTK5WDWRQOH2LHEDX3EKVIQRLMESGBG	EUR	9223372036854775807	199999990	1	6
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	9223372036854775807	999999990	1	6
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
02d2c559b2c72d5e778e19731f98889a89854fe2e1a045db9e877341822adf8a	2	1	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAACgAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAO5rKAAAAAAAAAAABVvwF9wAAAEA4iLwhoEBrw+dx0jBFYVl6n3qK0ZuX5aubB8VUmR7sgn6guu+TAWwBBoKPuLUhPIl3FKJUEv+ZR4RWEws1uIsH	AtLFWbLHLV53jhlzH5iImomFT+LhoEXbnodzQYIq34oAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAgAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcBY0V4XYn/9gAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAACAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAA7msoAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wFjRXgh7zX2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
2f386b76c4dfd3b0ae3271880ae9780ea4f7f95c6cb9ec67ee00ba74f51ab2e3	2	2	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAACgAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAO5rKAAAAAAAAAAABVvwF9wAAAECqq+nCBIXII6c3TVs2bBY+bXJtTtvwnjAZbimWLYdaoOyfJKuSdOwhaSOzcKJgQjoPYuJ466rW99i///TZkk0K	LzhrdsTf07CuMnGICul4DqT3+Vxsuexn7gC6dPUasuMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAgAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcBY0V4Ie817AAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAACAAAAAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAA7msoAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wFjRXfmVGvsAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
2ea11f77ea64e5d24978176ab762904921f236c9b6f867032161e7d439f5fc0e	2	3	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAACgAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rKAAAAAAAAAAABVvwF9wAAAECEIeCxPJe3yRtnh0sMzF8b0F0GtR1zmiJ3QtT9rEnCv1PjqiTzwgH17er14ERCqDQPy82j560ImRCLns6779kL	LqEfd+pk5dJJeBdqt2KQSSHyNsm2+GcDIWHn1Dn1/A4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAgAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcBY0V35lRr4gAAAAAAAAADAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAACAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msoAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wFjRXequaHiAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
4dd8766311c71e609007dfe56cd8e57e2f0c080121d7e7c7288d652f4c9da507	2	4	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAACgAAAAAAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAAO5rKAAAAAAAAAAABVvwF9wAAAEBp4Q3bDmFtRs2DQOCf3f7UN+9HxdTFByeZ/F3BD8btCfKBhZITwDv3Rlr1Vg8gJrSrNXDMN7zKuPbpCHZZ6yUB	Tdh2YxHHHmCQB9/lbNjlfi8MCAEh1+fHKI1lL0ydpQcAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAgAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcBY0V3qrmh2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAACAAAAAAAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAA7msoAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wFjRXdvHtfYAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
b1b3da7166cbb36bdf100ed58b86a495266a329c6ae3efd62dc7402bee631f6c	2	5	AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAACgAAAAAAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rKAAAAAAAAAAABVvwF9wAAAECLq7+pduJUAcGraH4Uj6XD6JDmb9MrQoVTAwa+u57U8hD3Nyi4p4DxOX2GOQIGUFT4VXVQzTbUr2YP5Yl/4gMF	sbPacWbLs2vfEA7Vi4aklSZqMpxq4+/WLcdAK+5jH2wAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAgAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcBY0V3bx7XzgAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAACAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA7msoAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wFjRXczhA3OAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
9c583f2a3c6c209dfd10cefb7e88e833008ea8cf3d666ae18d4022e14c2466d2	3	1	AAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSX//////////AAAAAAAAAAEnciLVAAAAQLr0i3XJBc0JSAFyrv9N4+PQFQLKk0wi31pZru9Zm/tap3WBlXZmXlbk+m9UXF943ZOw02cSwwhUwxvIPfshHwk=	nFg/KjxsIJ39EM77fojoMwCOqM89ZmrhjUAi4UwkZtIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAwAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAAAO5rJ9gAAAAIAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAADAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAAAAAAEAAAADAAAAAAAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAA7msn2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
a8db03f213fe5ebd47f5e3b86923a384212405ad406dfb3499f5aa3e56862256	3	2	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQC5fAydW9AJqKcCilC1Vo2f+LuWEaui1lHdb5q7HkAFU4dkMUIlgpibkGYlZqcypf4MCmw/Hu2c7BXuAEq4zbQk=	qNsD8hP+Xr1H9eO4aSOjhCEkBa1Abfs0mfWqPlaGIlYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAwAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rJ9gAAAAIAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAADAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAAAAAAEAAAADAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAA7msn2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
677b1d851c14207ee539dc643027f72696f5fa95da2d668703f703aa4d559e2f	3	3	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAFvFIhaAAAAQIiruYK4zIkyS4+gMOKFNAmE1/dfY6igM/JhSOWn0xowD0riYK8iYJ1R/rc/2/z0bjCTW6p28FF7EPJKF2P4AQ4=	Z3sdhRwUIH7lOdxkMCf3Jpb1+pXaLWaHA/cDqk1Vni8AAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAwAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rJ9gAAAAIAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAADAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAAAAAAEAAAADAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msn2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
d49a212b6ca97c62ffc269ab014cb3ebf9d029efff8a67f120cce39211c34c22	3	4	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSX//////////AAAAAAAAAAFvFIhaAAAAQOm6EwSRly0Y1y7GXq1uwLSRDfHOI3BtgsR5gP5ACbVONO5mGHa8E0ieMhg3MNVufINUp2JlxuA9tpQE3RhdTwk=	1JohK2ypfGL/wmmrAUyz6/nQKe//imfxIMzjkhHDTCIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAwAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rJ7AAAAAIAAAACAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAADAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAAAAAAB//////////wAAAAEAAAAAAAAAAAAAAAEAAAADAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAA7msnsAAAAAgAAAAIAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==
1ee0cc69f8584a6ad631d5e67fefcbd3eaa7f860b6c53137e40abd761947651a	4	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAA7msoAAAAAAAAAAAH5kC3vAAAAQPbGgBthxrn18MbN9RJ3ItA61oWrzzQc8JmUtma8HjWZZvYBI2SGRH+6NM5qN2gjXl21sUJ2wyHNruWgfS8jfwg=	HuDMafhYSmrWMdXmf+/L0+qn+GC2xTE35Aq9dhlHZRoAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAABAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAO5rJ9gAAAAIAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAAEAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAADuaygB//////////wAAAAEAAAAAAAAAAA==
a99ea4f63ebbd7d32822ed0a38253221574b3e19e62b7fa23b4edc0ce3d3f8fa	4	2	AAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAAL68IAAAAAAAAAAAEQithJAAAAQMf21VBOoNgt0d167+PYRqfy6uxoJa0I/VpGBv8FLnw5s0zwlpvqDzqthS9bkykG5XXAZtWC+yx7xvt6QnlXpAI=	qZ6k9j6719MoIu0KOCUyIVdLPhnmK3+iO07cDOPT+PoAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAABAAAAAAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAO5rJ9gAAAAIAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAAEAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAAvrwgB//////////wAAAAEAAAAAAAAAAA==
0bbb18378f3ebf6c71c1ebc98eb8540cab60dca63eb047b067c23e6b557f18ee	4	3	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAL68IAAAAAAAAAAAH5kC3vAAAAQBZVdGTuYwpUa1DZqEGe86r+Ucu4w/xZB3/PWIHZRvgyhmUOIcIE+qzJOn8P9rxh+0MHMmx5PB78eNUozpyR5Qo=	C7sYN48+v2xxwevJjrhUDKtg3KY+sEewZ8I+a1V/GO4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAABAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAO5rJ7AAAAAIAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAAEAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAvrwgB//////////wAAAAEAAAAAAAAAAA==
7802eae7e2c072fc05c5e4471b5df52fb30495c3c580fbea637c071896f97815	4	4	AAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAA7msoAAAAAAAAAAAEQithJAAAAQDGPaPuYXrCGEGMI9s9nplZ0cQhSs3xRxjp1tyljcOu8mwLoIo8vuROEznL5EyDawji9dF7AYFLP+UBf/qS4ogY=	eALq5+LAcvwFxeRHG131L7MElcPFgPvqY3wHGJb5eBUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAABAAAAAAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAO5rJ7AAAAAIAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAAEAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAADuaygB//////////wAAAAEAAAAAAAAAAA==
42450ffe3956b8618cffaae48665c252869440aeb41fd8bf4921929a61982630	5	1	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAvrwgAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAFvFIhaAAAAQCOOqFcnnWHWK76Z8pjnvodFYuMwTEFssfwqO0+ZcvrpLFjr6ztXFo6bBf70+tIO6IRNjo7xOnJ9gRfzX/1j3wI=	QkUP/jlWuGGM/6rkhmXCUoaUQK60H9i/SSGSmmGYJjAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAQAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAC+vCAAAAAAEAAAABAAAAAAAAAAAAAAAA	AAAAAAAAAAEAAAABAAAABQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rJ4gAAAAIAAAADAAAAAgAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAAFAAAAAgAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAABAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAL68IAAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAABAAAABQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAO5rJ4gAAAAIAAAADAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAA=
95324dec7c94f8cc992522794b2a84a732cddcb5641992589cfe328884a4c132	6	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAIAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAKAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAAAAACgAAAAAAAAAAAAAAAa7kvkwAAABAjnmFTAcoRWZdLy3I3ESN1ZEIUYuPB3D6O1xGoXv1vz+qkUmjDAqeARIAjGmcjbogtwhxALtQYxqQRsmJpgGEAQ==	lTJN7HyU+MyZJSJ5SyqEpzLN3LVkGZJYnP4yiISkwTIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAIAAAAAAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAABAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAAAAAAACgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAoAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAABRVVSAAAAAACg/Bj8V39wjI1Sr96oc7Omrth2jBx9LOQd9kVVEIrYSQAAAAAAAAAKAAAAAA==	AAAAAAAAAAEAAAABAAAABgAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAO5rJ7AAAAAIAAAACAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAABAAAABQAAAAEAAAAGAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAADuaygp//////////wAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFFVVIAAAAAAKD8GPxXf3CMjVKv3qhzs6au2HaMHH0s5B32RVUQithJAAAAAAvrwfZ//////////wAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAvrwgp//////////wAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAADuayfZ//////////wAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAgAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAABAAAAAUVVUgAAAAAAoPwY/Fd/cIyNUq/eqHOzpq7YdowcfSzkHfZFVRCK2EkAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAL68H2AAAAAQAAAAEAAAAAAAAAAAAAAAA=
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
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, assetcode);


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

CREATE INDEX accountbalances ON accounts USING btree (balance) WHERE (balance >= 1000000000);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: buyingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX buyingissuerindex ON offers USING btree (buyingissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: sellingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sellingissuerindex ON offers USING btree (sellingissuer);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--

