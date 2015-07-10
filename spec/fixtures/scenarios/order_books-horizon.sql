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
8589938688	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq
8589942784	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ
8589946880	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 10000000000}
0	8589938688	1	3	{"amount": 10000000000, "currency_type": "native"}
8589942784	8589942784	0	0	{"starting_balance": 10000000000}
0	8589942784	1	3	{"amount": 10000000000, "currency_type": "native"}
8589946880	8589946880	0	0	{"starting_balance": 10000000000}
0	8589946880	1	3	{"amount": 10000000000, "currency_type": "native"}
8589942784	17179873280	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179873280	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589946880	17179877376	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179877376	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589942784	17179881472	0	2	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179881472	1	3	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589946880	17179885568	0	2	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179885568	1	3	{"amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-07-10 15:49:37.65582	2015-07-10 15:49:37.65582	4294967296
2	89605b6be9fbc8374a51958b4bf7ddc9a3a1fea6823e18bccb91d730fe97955b	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	3	3	2015-07-10 15:49:35	2015-07-10 15:49:37.665387	2015-07-10 15:49:37.665387	8589934592
3	cc0a344fc1033efa3426a23a1d08d8e0d42251197db20b41945c804b4a0c2f83	89605b6be9fbc8374a51958b4bf7ddc9a3a1fea6823e18bccb91d730fe97955b	4	4	2015-07-10 15:49:36	2015-07-10 15:49:37.744145	2015-07-10 15:49:37.744145	12884901888
4	2dc2c88f0d93d121a5f30e08315c552c9c700180b7a659eb34d8caf06afe35c3	cc0a344fc1033efa3426a23a1d08d8e0d42251197db20b41945c804b4a0c2f83	4	4	2015-07-10 15:49:37	2015-07-10 15:49:37.789363	2015-07-10 15:49:37.789363	17179869184
5	6e67e96cba8a9388a7645eb273cc9d8b253a93bdd6d7d2f6804e1e1f518a7219	2dc2c88f0d93d121a5f30e08315c552c9c700180b7a659eb34d8caf06afe35c3	6	6	2015-07-10 15:49:38	2015-07-10 15:49:37.863831	2015-07-10 15:49:37.863831	21474836480
6	261cc3dd6651d057e1756fb9acb420e895fe1cf87e654b6f5906d12a5ab55eeb	6e67e96cba8a9388a7645eb273cc9d8b253a93bdd6d7d2f6804e1e1f518a7219	6	6	2015-07-10 15:49:39	2015-07-10 15:49:37.923286	2015-07-10 15:49:37.923286	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
45	8589938688	0
46	8589938688	8589938688
47	8589942784	0
48	8589942784	8589942784
49	8589946880	0
50	8589946880	8589946880
51	12884905984	8589942784
52	12884910080	8589946880
53	12884914176	8589942784
54	12884918272	8589946880
55	17179873280	8589938688
56	17179873280	8589942784
57	17179877376	8589938688
58	17179877376	8589946880
59	17179881472	8589938688
60	17179881472	8589942784
61	17179885568	8589938688
62	17179885568	8589946880
63	21474840576	8589942784
64	21474844672	8589946880
65	21474848768	8589946880
66	21474852864	8589942784
67	21474856960	8589942784
68	21474861056	8589946880
69	25769807872	8589942784
70	25769811968	8589946880
71	25769816064	8589946880
72	25769820160	8589942784
73	25769824256	8589942784
74	25769828352	8589946880
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 74, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "starting_balance": 10000000000}
8589942784	8589942784	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "starting_balance": 10000000000}
8589946880	8589946880	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "starting_balance": 10000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179873280	17179873280	0	1	{"to": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179877376	17179877376	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179881472	17179881472	0	1	{"to": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179885568	17179885568	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 5000, "currency_code": "BTC", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
21474840576	21474840576	0	3	{"price": {"d": 10, "n": 1}, "amount": 1, "offer_id": 0}
21474844672	21474844672	0	3	{"price": {"d": 1, "n": 15}, "amount": 10, "offer_id": 0}
21474848768	21474848768	0	3	{"price": {"d": 1, "n": 20}, "amount": 100, "offer_id": 0}
21474852864	21474852864	0	3	{"price": {"d": 9, "n": 1}, "amount": 11, "offer_id": 0}
21474856960	21474856960	0	3	{"price": {"d": 5, "n": 1}, "amount": 200, "offer_id": 0}
21474861056	21474861056	0	3	{"price": {"d": 1, "n": 50}, "amount": 1000, "offer_id": 0}
25769807872	25769807872	0	3	{"price": {"d": 10, "n": 1}, "amount": 1, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 15}, "amount": 10, "offer_id": 0}
25769816064	25769816064	0	3	{"price": {"d": 1, "n": 20}, "amount": 100, "offer_id": 0}
25769820160	25769820160	0	3	{"price": {"d": 9, "n": 1}, "amount": 11, "offer_id": 0}
25769824256	25769824256	0	3	{"price": {"d": 5, "n": 1}, "amount": 200, "offer_id": 0}
25769828352	25769828352	0	3	{"price": {"d": 1, "n": 50}, "amount": 1000, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
44	0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:37.672676	2015-07-10 15:49:37.672676
45	0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:37.674396	2015-07-10 15:49:37.674396
46	afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.69961	2015-07-10 15:49:37.69961
47	afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:37.701284	2015-07-10 15:49:37.701284
48	c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.718718	2015-07-10 15:49:37.718718
49	c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:37.72084	2015-07-10 15:49:37.72084
50	7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.748715	2015-07-10 15:49:37.748715
51	df4c6ac90b1676dbd14700ce39baac52c8d9a0cac8b084b845e4ad1ec7f2c061	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.75807	2015-07-10 15:49:37.75807
52	80422c70a1ca53c62e0cd5b6d79591024940870eb263f21e32f5b382d16b556c	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.765987	2015-07-10 15:49:37.765987
53	7200e84eb7e7b636e2cdb2585036bf5b9f545e9d39426c34eb3224d7a6964aa9	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.774338	2015-07-10 15:49:37.774338
54	192fb1919a67b63fac88c9e4db9923b1810b3442487a0712bf1197ea36672c24	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:37.793971	2015-07-10 15:49:37.793971
55	b28c0d0e6fc933792faa0a4f70633b93d88b969c0407cd99f3881ef781541f97	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:37.810318	2015-07-10 15:49:37.810318
56	7bebd9e8debab8bf95f560f9f45e49708f56aa2ec9950e0d808ffd1431b59d6e	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:37.825717	2015-07-10 15:49:37.825717
57	8338f1d185000f089f5504c512399e7d9828cf1aae9c37ef2ef7cb7fbad10814	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:37.842156	2015-07-10 15:49:37.842156
58	d2c7a0d6256324229256592acaa51477b3b13f3ebfaa0bca1fbeb2187f88fb37	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.868867	2015-07-10 15:49:37.868867
59	c0c1f53206f39477f038f2fae3ea590d08f38a9f12434dfefce2e28a45a50cc5	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.877005	2015-07-10 15:49:37.877005
60	b77efd903953ad583f647df4f78b2facc0799f68aa74f716dceb8b3b7f46dbb9	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.88494	2015-07-10 15:49:37.88494
61	8096977736bb9a9b09bc6116056e035c785105096481f8272e9b22bc40446b06	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.892698	2015-07-10 15:49:37.892698
62	20ece43bb6e22da1b2ccca57d0d38d059090f75b3451a0726071ae063e7a0612	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.90097	2015-07-10 15:49:37.90097
63	75f593013675be97938d2fe2e4c1d0629d873fee62f5a4836955deb596940848	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.909148	2015-07-10 15:49:37.909148
64	5e49320e88671aed48b98703e7a970a0325db564605337784c3a9bbf64863880	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.927616	2015-07-10 15:49:37.927616
65	b366b9cc08150970e1490241bacd4770492357860ead5d320b77e332292be3b7	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.935124	2015-07-10 15:49:37.935124
66	aa79ebd5fe9148a654021dfc4358cabee455f9f675943f84a96b24526e78ee6a	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.942093	2015-07-10 15:49:37.942093
67	f813a8dd57d30358b5bf9c5ef3af6f0f0052f660c14a96474c91acb7435b9e7d	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.948879	2015-07-10 15:49:37.948879
68	0e0551f3dc873db0d88ea60fcb44aabca45a6a213164e16d35a0af6f40e3e095	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:37.955832	2015-07-10 15:49:37.955832
69	0238eec8a7a195b41ed886e903a93a8a46ea6777b26bb600086c8b80a42da9d5	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:37.970693	2015-07-10 15:49:37.970693
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 69, true);


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
0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	2	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-10 15:49:37.669518	2015-07-10 15:49:37.669518	8589938688
afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	2	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-10 15:49:37.696601	2015-07-10 15:49:37.696601	8589942784
c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	2	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-10 15:49:37.716736	2015-07-10 15:49:37.716736	8589946880
7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	3	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934593	10	10	1	-1	2015-07-10 15:49:37.747094	2015-07-10 15:49:37.747094	12884905984
df4c6ac90b1676dbd14700ce39baac52c8d9a0cac8b084b845e4ad1ec7f2c061	3	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934593	10	10	1	-1	2015-07-10 15:49:37.756313	2015-07-10 15:49:37.756313	12884910080
80422c70a1ca53c62e0cd5b6d79591024940870eb263f21e32f5b382d16b556c	3	3	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934594	10	10	1	-1	2015-07-10 15:49:37.76428	2015-07-10 15:49:37.76428	12884914176
7200e84eb7e7b636e2cdb2585036bf5b9f545e9d39426c34eb3224d7a6964aa9	3	4	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934594	10	10	1	-1	2015-07-10 15:49:37.77258	2015-07-10 15:49:37.77258	12884918272
192fb1919a67b63fac88c9e4db9923b1810b3442487a0712bf1197ea36672c24	4	1	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934593	10	10	1	-1	2015-07-10 15:49:37.792273	2015-07-10 15:49:37.792273	17179873280
b28c0d0e6fc933792faa0a4f70633b93d88b969c0407cd99f3881ef781541f97	4	2	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934594	10	10	1	-1	2015-07-10 15:49:37.808565	2015-07-10 15:49:37.808565	17179877376
7bebd9e8debab8bf95f560f9f45e49708f56aa2ec9950e0d808ffd1431b59d6e	4	3	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934595	10	10	1	-1	2015-07-10 15:49:37.823867	2015-07-10 15:49:37.823867	17179881472
8338f1d185000f089f5504c512399e7d9828cf1aae9c37ef2ef7cb7fbad10814	4	4	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934596	10	10	1	-1	2015-07-10 15:49:37.840139	2015-07-10 15:49:37.840139	17179885568
d2c7a0d6256324229256592acaa51477b3b13f3ebfaa0bca1fbeb2187f88fb37	5	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934595	10	10	1	-1	2015-07-10 15:49:37.867016	2015-07-10 15:49:37.867016	21474840576
c0c1f53206f39477f038f2fae3ea590d08f38a9f12434dfefce2e28a45a50cc5	5	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934595	10	10	1	-1	2015-07-10 15:49:37.875371	2015-07-10 15:49:37.875371	21474844672
b77efd903953ad583f647df4f78b2facc0799f68aa74f716dceb8b3b7f46dbb9	5	3	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934596	10	10	1	-1	2015-07-10 15:49:37.883178	2015-07-10 15:49:37.883178	21474848768
8096977736bb9a9b09bc6116056e035c785105096481f8272e9b22bc40446b06	5	4	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934596	10	10	1	-1	2015-07-10 15:49:37.891082	2015-07-10 15:49:37.891082	21474852864
20ece43bb6e22da1b2ccca57d0d38d059090f75b3451a0726071ae063e7a0612	5	5	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934597	10	10	1	-1	2015-07-10 15:49:37.899139	2015-07-10 15:49:37.899139	21474856960
75f593013675be97938d2fe2e4c1d0629d873fee62f5a4836955deb596940848	5	6	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934597	10	10	1	-1	2015-07-10 15:49:37.907229	2015-07-10 15:49:37.907229	21474861056
5e49320e88671aed48b98703e7a970a0325db564605337784c3a9bbf64863880	6	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934598	10	10	1	-1	2015-07-10 15:49:37.926071	2015-07-10 15:49:37.926071	25769807872
b366b9cc08150970e1490241bacd4770492357860ead5d320b77e332292be3b7	6	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934598	10	10	1	-1	2015-07-10 15:49:37.93339	2015-07-10 15:49:37.93339	25769811968
aa79ebd5fe9148a654021dfc4358cabee455f9f675943f84a96b24526e78ee6a	6	3	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934599	10	10	1	-1	2015-07-10 15:49:37.940659	2015-07-10 15:49:37.940659	25769816064
f813a8dd57d30358b5bf9c5ef3af6f0f0052f660c14a96474c91acb7435b9e7d	6	4	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934599	10	10	1	-1	2015-07-10 15:49:37.947361	2015-07-10 15:49:37.947361	25769820160
0e0551f3dc873db0d88ea60fcb44aabca45a6a213164e16d35a0af6f40e3e095	6	5	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934600	10	10	1	-1	2015-07-10 15:49:37.954417	2015-07-10 15:49:37.954417	25769824256
0238eec8a7a195b41ed886e903a93a8a46ea6777b26bb600086c8b80a42da9d5	6	6	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934600	10	10	1	-1	2015-07-10 15:49:37.969058	2015-07-10 15:49:37.969058	25769828352
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

