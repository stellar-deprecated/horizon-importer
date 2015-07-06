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

DROP INDEX public.unique_schema_migrations;
DROP INDEX public.index_history_transactions_on_id;
DROP INDEX public.index_history_transaction_statuses_lc_on_all;
DROP INDEX public.index_history_transaction_participants_on_transaction_hash;
DROP INDEX public.index_history_transaction_participants_on_account;
DROP INDEX public.index_history_operations_on_type;
DROP INDEX public.index_history_operations_on_transaction_id;
DROP INDEX public.index_history_operations_on_id;
DROP INDEX public.index_history_ledgers_on_sequence;
DROP INDEX public.index_history_ledgers_on_previous_ledger_hash;
DROP INDEX public.index_history_ledgers_on_ledger_hash;
DROP INDEX public.index_history_ledgers_on_id;
DROP INDEX public.index_history_ledgers_on_closed_at;
DROP INDEX public.index_history_effects_on_type;
DROP INDEX public.index_history_accounts_on_id;
DROP INDEX public.hs_transaction_by_id;
DROP INDEX public.hs_ledger_by_id;
DROP INDEX public.hist_op_p_id;
DROP INDEX public.hist_e_id;
DROP INDEX public.hist_e_by_order;
DROP INDEX public.by_status;
DROP INDEX public.by_ledger;
DROP INDEX public.by_hash;
DROP INDEX public.by_account;
ALTER TABLE ONLY public.history_transaction_statuses DROP CONSTRAINT history_transaction_statuses_pkey;
ALTER TABLE ONLY public.history_transaction_participants DROP CONSTRAINT history_transaction_participants_pkey;
ALTER TABLE ONLY public.history_operation_participants DROP CONSTRAINT history_operation_participants_pkey;
ALTER TABLE public.history_transaction_statuses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.history_transaction_participants ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.history_operation_participants ALTER COLUMN id DROP DEFAULT;
DROP TABLE public.schema_migrations;
DROP TABLE public.history_transactions;
DROP SEQUENCE public.history_transaction_statuses_id_seq;
DROP TABLE public.history_transaction_statuses;
DROP SEQUENCE public.history_transaction_participants_id_seq;
DROP TABLE public.history_transaction_participants;
DROP TABLE public.history_operations;
DROP SEQUENCE public.history_operation_participants_id_seq;
DROP TABLE public.history_operation_participants;
DROP TABLE public.history_ledgers;
DROP TABLE public.history_effects;
DROP TABLE public.history_accounts;
DROP EXTENSION hstore;
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


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: history_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_accounts (
    id bigint NOT NULL,
    address character varying(64)
);


--
-- Name: history_effects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_effects (
    history_account_id bigint NOT NULL,
    history_operation_id bigint NOT NULL,
    "order" integer NOT NULL,
    type integer NOT NULL,
    details jsonb
);


--
-- Name: history_ledgers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_ledgers (
    sequence integer NOT NULL,
    ledger_hash character varying(64) NOT NULL,
    previous_ledger_hash character varying(64),
    transaction_count integer DEFAULT 0 NOT NULL,
    operation_count integer DEFAULT 0 NOT NULL,
    closed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id bigint
);


--
-- Name: history_operation_participants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_operation_participants (
    id integer NOT NULL,
    history_operation_id bigint NOT NULL,
    history_account_id bigint NOT NULL
);


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_operation_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_operation_participants_id_seq OWNED BY history_operation_participants.id;


--
-- Name: history_operations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_operations (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    application_order integer NOT NULL,
    type integer NOT NULL,
    details jsonb
);


--
-- Name: history_transaction_participants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transaction_participants (
    id integer NOT NULL,
    transaction_hash character varying(64) NOT NULL,
    account character varying(64) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_transaction_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_transaction_participants_id_seq OWNED BY history_transaction_participants.id;


--
-- Name: history_transaction_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transaction_statuses (
    id integer NOT NULL,
    result_code_s character varying NOT NULL,
    result_code integer NOT NULL
);


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_transaction_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_transaction_statuses_id_seq OWNED BY history_transaction_statuses.id;


--
-- Name: history_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transactions (
    transaction_hash character varying(64) NOT NULL,
    ledger_sequence integer NOT NULL,
    application_order integer NOT NULL,
    account character varying(64) NOT NULL,
    account_sequence bigint NOT NULL,
    max_fee integer NOT NULL,
    fee_paid integer NOT NULL,
    operation_count integer NOT NULL,
    transaction_status_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id bigint
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_operation_participants ALTER COLUMN id SET DEFAULT nextval('history_operation_participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_transaction_participants ALTER COLUMN id SET DEFAULT nextval('history_transaction_participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_transaction_statuses ALTER COLUMN id SET DEFAULT nextval('history_transaction_statuses_id_seq'::regclass);


--
-- Data for Name: history_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_accounts (id, address) FROM stdin;
0	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC
12884905984	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq
12884910080	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ
12884914176	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
12884905984	12884905984	0	0	{"starting_balance": 10000000000}
0	12884905984	1	3	{"amount": 10000000000, "currency_type": "native"}
12884910080	12884910080	0	0	{"starting_balance": 10000000000}
0	12884910080	1	3	{"amount": 10000000000, "currency_type": "native"}
12884914176	12884914176	0	0	{"starting_balance": 10000000000}
0	12884914176	1	3	{"amount": 10000000000, "currency_type": "native"}
12884910080	21474840576	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884905984	21474840576	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884914176	21474844672	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884905984	21474844672	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884910080	21474848768	0	2	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884905984	21474848768	1	3	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884914176	21474852864	0	2	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884905984	21474852864	1	3	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	\N	0	0	1970-01-01 00:00:00	2015-07-01 23:20:15.726898	2015-07-01 23:20:15.726898	4294967296
2	7f00148e898589c653c77aee81d06b9697d28be748ea06b8a0022ccd29647d83	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0	0	2015-07-01 23:20:13	2015-07-01 23:20:15.735356	2015-07-01 23:20:15.735356	8589934592
3	3d4af496687964ffe3d9d98d50e6b790fd1188ccc6466f2fd6f0c42863f25485	7f00148e898589c653c77aee81d06b9697d28be748ea06b8a0022ccd29647d83	3	3	2015-07-01 23:20:14	2015-07-01 23:20:15.754183	2015-07-01 23:20:15.754183	12884901888
4	66f89bced279528e87f3c9eba012e4addaf92cff3875c3f0156919b27cf33983	3d4af496687964ffe3d9d98d50e6b790fd1188ccc6466f2fd6f0c42863f25485	4	4	2015-07-01 23:20:15	2015-07-01 23:20:15.823373	2015-07-01 23:20:15.823373	17179869184
5	92833b51b582bd4f625c89f44f0d098ca40e671a55f4c0aac137e39c1a454fa0	66f89bced279528e87f3c9eba012e4addaf92cff3875c3f0156919b27cf33983	4	4	2015-07-01 23:20:16	2015-07-01 23:20:15.867117	2015-07-01 23:20:15.867117	21474836480
6	398be9535f34707b36ab068c5d67e1f7f1d4992237383fec5126a31008a3a936	92833b51b582bd4f625c89f44f0d098ca40e671a55f4c0aac137e39c1a454fa0	6	6	2015-07-01 23:20:17	2015-07-01 23:20:15.937205	2015-07-01 23:20:15.937205	25769803776
7	38c4f2a990773dc285328604106362a50f800c78eeddfb06de2665e808bc1154	398be9535f34707b36ab068c5d67e1f7f1d4992237383fec5126a31008a3a936	6	6	2015-07-01 23:20:18	2015-07-01 23:20:15.991059	2015-07-01 23:20:15.991059	30064771072
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
40	12884905984	0
41	12884905984	12884905984
42	12884910080	0
43	12884910080	12884910080
44	12884914176	0
45	12884914176	12884914176
46	17179873280	12884910080
47	17179877376	12884914176
48	17179881472	12884910080
49	17179885568	12884914176
50	21474840576	12884905984
51	21474840576	12884910080
52	21474844672	12884905984
53	21474844672	12884914176
54	21474848768	12884905984
55	21474848768	12884910080
56	21474852864	12884905984
57	21474852864	12884914176
58	25769807872	12884914176
59	25769811968	12884910080
60	25769816064	12884914176
61	25769820160	12884910080
62	25769824256	12884910080
63	25769828352	12884914176
64	30064775168	12884910080
65	30064779264	12884914176
66	30064783360	12884914176
67	30064787456	12884910080
68	30064791552	12884910080
69	30064795648	12884914176
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 69, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
12884905984	12884905984	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "starting_balance": 10000000000}
12884910080	12884910080	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "starting_balance": 10000000000}
12884914176	12884914176	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "starting_balance": 10000000000}
17179873280	17179873280	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179877376	17179877376	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179881472	17179881472	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179885568	17179885568	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
21474840576	21474840576	0	1	{"to": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
21474844672	21474844672	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
21474848768	21474848768	0	1	{"to": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
21474852864	21474852864	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 15}, "amount": 10, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 10, "n": 1}, "amount": 1, "offer_id": 0}
25769816064	25769816064	0	3	{"price": {"d": 1, "n": 20}, "amount": 100, "offer_id": 0}
25769820160	25769820160	0	3	{"price": {"d": 9, "n": 1}, "amount": 11, "offer_id": 0}
25769824256	25769824256	0	3	{"price": {"d": 5, "n": 1}, "amount": 200, "offer_id": 0}
25769828352	25769828352	0	3	{"price": {"d": 1, "n": 50}, "amount": 1000, "offer_id": 0}
30064775168	30064775168	0	3	{"price": {"d": 10, "n": 1}, "amount": 1, "offer_id": 0}
30064779264	30064779264	0	3	{"price": {"d": 1, "n": 15}, "amount": 10, "offer_id": 0}
30064783360	30064783360	0	3	{"price": {"d": 1, "n": 20}, "amount": 100, "offer_id": 0}
30064787456	30064787456	0	3	{"price": {"d": 9, "n": 1}, "amount": 11, "offer_id": 0}
30064791552	30064791552	0	3	{"price": {"d": 5, "n": 1}, "amount": 200, "offer_id": 0}
30064795648	30064795648	0	3	{"price": {"d": 1, "n": 50}, "amount": 1000, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
38	e2b3ecd737eb4c241e7abe15a6d079dbe1de708263f59d1882c05eb7d0e89c08	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-01 23:20:15.759049	2015-07-01 23:20:15.759049
39	e2b3ecd737eb4c241e7abe15a6d079dbe1de708263f59d1882c05eb7d0e89c08	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:15.760103	2015-07-01 23:20:15.760103
40	9692abb6739c52f1b76a2bc1ecc515763e8c481f8c46ac0bb13386305040af99	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.781166	2015-07-01 23:20:15.781166
41	9692abb6739c52f1b76a2bc1ecc515763e8c481f8c46ac0bb13386305040af99	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:15.782738	2015-07-01 23:20:15.782738
42	7aa3ca5873e4f8bd88715475d8be02fe3d31c82becad84fe1b41541fd442ec21	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.799886	2015-07-01 23:20:15.799886
43	7aa3ca5873e4f8bd88715475d8be02fe3d31c82becad84fe1b41541fd442ec21	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:15.800934	2015-07-01 23:20:15.800934
44	1b92d9a9651b11379a62c13a21958d516cf3dfe15f3628981243f0b4475c02fa	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.828177	2015-07-01 23:20:15.828177
45	f44b155ce8e6a7db7dd6294166bb710a481f102514b3c73fcada10ff20dca37c	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.836335	2015-07-01 23:20:15.836335
46	6926fd316741a0dcc449863a3f57e7e311311099be8d98d667c6c2c30da8ed13	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.843882	2015-07-01 23:20:15.843882
47	2539e9b5d905c70fb01874c98fd3b4026118c6b0d487f2c33258c3dc8f805aab	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.851661	2015-07-01 23:20:15.851661
48	2a837e4ec972a058de2c94598f9e44478f1efdbc30f6e8302324e7b5485172d6	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-01 23:20:15.871991	2015-07-01 23:20:15.871991
49	4e4af6fa9c4b4d908da5a9a3457d744baeef2aa858afec364d25510ac4698560	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-01 23:20:15.886751	2015-07-01 23:20:15.886751
50	d292bdbc5d65e7b81c9fb81ac4201e6f64b117c048b93024c0a5822ff5ac7d45	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-01 23:20:15.902126	2015-07-01 23:20:15.902126
51	7193ad8f9fc201eee35cad60fa456ad6373e46e06487814f74d064b95bb0e16b	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-01 23:20:15.916978	2015-07-01 23:20:15.916978
52	f0957ad75f54e72aecf74032bb37ce2307032b6772fa8d4b28161eb975c1a623	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.941746	2015-07-01 23:20:15.941746
53	24d3f1cea2ea00634fafc5a5247f17e003947e9ec5763235e3e8950ebfca169c	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.949296	2015-07-01 23:20:15.949296
54	53366442616e19a8fdcbbefe5fc7e4f35bc333d5c82cffad3b5a335aee105bc2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.956432	2015-07-01 23:20:15.956432
55	aab7ebae362461dfc6b5452fa507751ee05509d3015821b44e311f865c709f80	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.963655	2015-07-01 23:20:15.963655
56	f30d222e6f13c505946b3d499633dfc440af67d9eaea6a264e8fc01d2afdf5f0	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.970897	2015-07-01 23:20:15.970897
57	88d133fe0c3b703ca6f62afa9434b840de8a3d8b0089e4732825dac556c96573	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:15.978398	2015-07-01 23:20:15.978398
58	f99ecd57eadce52b981792264554ec6528c73b7bda3e828d65f26769476253e0	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:15.995322	2015-07-01 23:20:15.995322
59	82a463c3129e41293499fae5db1cc90f1f0710bf12bd33cb3a82d843c11aa311	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:16.003317	2015-07-01 23:20:16.003317
60	11b37de46c9846b3ac349b4cc64b06a0aee8c41205fb6e12be004759b4a07016	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:16.011117	2015-07-01 23:20:16.011117
61	774d6fd7f515481d5374d4a1120236382b7a87f8172294aa6834480af3606037	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:16.018274	2015-07-01 23:20:16.018274
62	d655d70e665ac894085bf98db8d512e7963ec1b7dd611251a30813c46f2f3fa1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-01 23:20:16.025855	2015-07-01 23:20:16.025855
63	38dfc4049bb6a5d4aa72264e556dd6140edc5264c1f6b02bf1ba3c452ee57620	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-01 23:20:16.033477	2015-07-01 23:20:16.033477
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 63, true);


--
-- Data for Name: history_transaction_statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_statuses (id, result_code_s, result_code) FROM stdin;
\.


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_statuses_id_seq', 1, false);


--
-- Data for Name: history_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transactions (transaction_hash, ledger_sequence, application_order, account, account_sequence, max_fee, fee_paid, operation_count, transaction_status_id, created_at, updated_at, id) FROM stdin;
e2b3ecd737eb4c241e7abe15a6d079dbe1de708263f59d1882c05eb7d0e89c08	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-01 23:20:15.757317	2015-07-01 23:20:15.757317	12884905984
9692abb6739c52f1b76a2bc1ecc515763e8c481f8c46ac0bb13386305040af99	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-01 23:20:15.778727	2015-07-01 23:20:15.778727	12884910080
7aa3ca5873e4f8bd88715475d8be02fe3d31c82becad84fe1b41541fd442ec21	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-01 23:20:15.797968	2015-07-01 23:20:15.797968	12884914176
1b92d9a9651b11379a62c13a21958d516cf3dfe15f3628981243f0b4475c02fa	4	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901889	10	10	1	-1	2015-07-01 23:20:15.826463	2015-07-01 23:20:15.826463	17179873280
f44b155ce8e6a7db7dd6294166bb710a481f102514b3c73fcada10ff20dca37c	4	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901889	10	10	1	-1	2015-07-01 23:20:15.834718	2015-07-01 23:20:15.834718	17179877376
6926fd316741a0dcc449863a3f57e7e311311099be8d98d667c6c2c30da8ed13	4	3	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901890	10	10	1	-1	2015-07-01 23:20:15.842453	2015-07-01 23:20:15.842453	17179881472
2539e9b5d905c70fb01874c98fd3b4026118c6b0d487f2c33258c3dc8f805aab	4	4	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901890	10	10	1	-1	2015-07-01 23:20:15.849992	2015-07-01 23:20:15.849992	17179885568
2a837e4ec972a058de2c94598f9e44478f1efdbc30f6e8302324e7b5485172d6	5	1	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	12884901889	10	10	1	-1	2015-07-01 23:20:15.870269	2015-07-01 23:20:15.870269	21474840576
4e4af6fa9c4b4d908da5a9a3457d744baeef2aa858afec364d25510ac4698560	5	2	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	12884901890	10	10	1	-1	2015-07-01 23:20:15.885195	2015-07-01 23:20:15.885195	21474844672
d292bdbc5d65e7b81c9fb81ac4201e6f64b117c048b93024c0a5822ff5ac7d45	5	3	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	12884901891	10	10	1	-1	2015-07-01 23:20:15.900053	2015-07-01 23:20:15.900053	21474848768
7193ad8f9fc201eee35cad60fa456ad6373e46e06487814f74d064b95bb0e16b	5	4	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	12884901892	10	10	1	-1	2015-07-01 23:20:15.915146	2015-07-01 23:20:15.915146	21474852864
f0957ad75f54e72aecf74032bb37ce2307032b6772fa8d4b28161eb975c1a623	6	1	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901891	10	10	1	-1	2015-07-01 23:20:15.940073	2015-07-01 23:20:15.940073	25769807872
24d3f1cea2ea00634fafc5a5247f17e003947e9ec5763235e3e8950ebfca169c	6	2	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901891	10	10	1	-1	2015-07-01 23:20:15.947832	2015-07-01 23:20:15.947832	25769811968
53366442616e19a8fdcbbefe5fc7e4f35bc333d5c82cffad3b5a335aee105bc2	6	3	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901892	10	10	1	-1	2015-07-01 23:20:15.95495	2015-07-01 23:20:15.95495	25769816064
aab7ebae362461dfc6b5452fa507751ee05509d3015821b44e311f865c709f80	6	4	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901892	10	10	1	-1	2015-07-01 23:20:15.962087	2015-07-01 23:20:15.962087	25769820160
f30d222e6f13c505946b3d499633dfc440af67d9eaea6a264e8fc01d2afdf5f0	6	5	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901893	10	10	1	-1	2015-07-01 23:20:15.96938	2015-07-01 23:20:15.96938	25769824256
88d133fe0c3b703ca6f62afa9434b840de8a3d8b0089e4732825dac556c96573	6	6	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901893	10	10	1	-1	2015-07-01 23:20:15.976684	2015-07-01 23:20:15.976684	25769828352
f99ecd57eadce52b981792264554ec6528c73b7bda3e828d65f26769476253e0	7	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901894	10	10	1	-1	2015-07-01 23:20:15.993845	2015-07-01 23:20:15.993845	30064775168
82a463c3129e41293499fae5db1cc90f1f0710bf12bd33cb3a82d843c11aa311	7	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901894	10	10	1	-1	2015-07-01 23:20:16.001635	2015-07-01 23:20:16.001635	30064779264
11b37de46c9846b3ac349b4cc64b06a0aee8c41205fb6e12be004759b4a07016	7	3	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901895	10	10	1	-1	2015-07-01 23:20:16.009464	2015-07-01 23:20:16.009464	30064783360
774d6fd7f515481d5374d4a1120236382b7a87f8172294aa6834480af3606037	7	4	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901895	10	10	1	-1	2015-07-01 23:20:16.016775	2015-07-01 23:20:16.016775	30064787456
d655d70e665ac894085bf98db8d512e7963ec1b7dd611251a30813c46f2f3fa1	7	5	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	12884901896	10	10	1	-1	2015-07-01 23:20:16.024155	2015-07-01 23:20:16.024155	30064791552
38dfc4049bb6a5d4aa72264e556dd6140edc5264c1f6b02bf1ba3c452ee57620	7	6	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12884901896	10	10	1	-1	2015-07-01 23:20:16.031856	2015-07-01 23:20:16.031856	30064795648
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20150629181921
20150310224849
20150313225945
20150313225955
20150501160031
20150508003829
20150508175821
20150508183542
20150508215546
20150609230237
\.


--
-- Name: history_operation_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_operation_participants
    ADD CONSTRAINT history_operation_participants_pkey PRIMARY KEY (id);


--
-- Name: history_transaction_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_transaction_participants
    ADD CONSTRAINT history_transaction_participants_pkey PRIMARY KEY (id);


--
-- Name: history_transaction_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_transaction_statuses
    ADD CONSTRAINT history_transaction_statuses_pkey PRIMARY KEY (id);


--
-- Name: by_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_account ON history_transactions USING btree (account, account_sequence);


--
-- Name: by_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_hash ON history_transactions USING btree (transaction_hash);


--
-- Name: by_ledger; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_ledger ON history_transactions USING btree (ledger_sequence, application_order);


--
-- Name: by_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_status ON history_transactions USING btree (transaction_status_id);


--
-- Name: hist_e_by_order; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_e_by_order ON history_effects USING btree (history_operation_id, "order");


--
-- Name: hist_e_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_e_id ON history_effects USING btree (history_account_id, history_operation_id, "order");


--
-- Name: hist_op_p_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_op_p_id ON history_operation_participants USING btree (history_account_id, history_operation_id);


--
-- Name: hs_ledger_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hs_ledger_by_id ON history_ledgers USING btree (id);


--
-- Name: hs_transaction_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hs_transaction_by_id ON history_transactions USING btree (id);


--
-- Name: index_history_accounts_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_accounts_on_id ON history_accounts USING btree (id);


--
-- Name: index_history_effects_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_effects_on_type ON history_effects USING btree (type);


--
-- Name: index_history_ledgers_on_closed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_ledgers_on_closed_at ON history_ledgers USING btree (closed_at);


--
-- Name: index_history_ledgers_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_id ON history_ledgers USING btree (id);


--
-- Name: index_history_ledgers_on_ledger_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_ledger_hash ON history_ledgers USING btree (ledger_hash);


--
-- Name: index_history_ledgers_on_previous_ledger_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_previous_ledger_hash ON history_ledgers USING btree (previous_ledger_hash);


--
-- Name: index_history_ledgers_on_sequence; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_sequence ON history_ledgers USING btree (sequence);


--
-- Name: index_history_operations_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_operations_on_id ON history_operations USING btree (id);


--
-- Name: index_history_operations_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_operations_on_transaction_id ON history_operations USING btree (transaction_id);


--
-- Name: index_history_operations_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_operations_on_type ON history_operations USING btree (type);


--
-- Name: index_history_transaction_participants_on_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_transaction_participants_on_account ON history_transaction_participants USING btree (account);


--
-- Name: index_history_transaction_participants_on_transaction_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_transaction_participants_on_transaction_hash ON history_transaction_participants USING btree (transaction_hash);


--
-- Name: index_history_transaction_statuses_lc_on_all; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_transaction_statuses_lc_on_all ON history_transaction_statuses USING btree (id, result_code, result_code_s);


--
-- Name: index_history_transactions_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_transactions_on_id ON history_transactions USING btree (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


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

