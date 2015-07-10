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
8589942784	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd
8589946880	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ
8589950976	gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA
8589955072	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 1000000000}
0	8589938688	1	3	{"amount": 1000000000, "currency_type": "native"}
8589942784	8589942784	0	0	{"starting_balance": 1000000000}
0	8589942784	1	3	{"amount": 1000000000, "currency_type": "native"}
8589946880	8589946880	0	0	{"starting_balance": 1000000000}
0	8589946880	1	3	{"amount": 1000000000, "currency_type": "native"}
8589950976	8589950976	0	0	{"starting_balance": 1000000000}
0	8589950976	1	3	{"amount": 1000000000, "currency_type": "native"}
8589955072	8589955072	0	0	{"starting_balance": 1000000000}
0	8589955072	1	3	{"amount": 1000000000, "currency_type": "native"}
8589955072	17179873280	0	2	{"amount": 1000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179873280	1	3	{"amount": 1000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589946880	17179877376	0	2	{"amount": 200000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589942784	17179877376	1	3	{"amount": 200000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589946880	17179881472	0	2	{"amount": 200000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589938688	17179881472	1	3	{"amount": 200000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
8589950976	17179885568	0	2	{"amount": 1000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589942784	17179885568	1	3	{"amount": 1000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589950976	25769807872	0	2	{"amount": 10, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589950976	25769807872	1	2	{"amount": 10, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
8589955072	25769807872	2	3	{"amount": 10, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-07-10 15:49:42.995932	2015-07-10 15:49:42.995932	4294967296
2	c774d401038e22d5e491f0ce56a421b989141f8c8cd43ea6be47a4748ac8c557	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	5	5	2015-07-10 15:49:41	2015-07-10 15:49:43.009322	2015-07-10 15:49:43.009322	8589934592
3	7fe242606a8739322561d7e41fa53d2788fbebbc30a8374073f9fad9b57a11b8	c774d401038e22d5e491f0ce56a421b989141f8c8cd43ea6be47a4748ac8c557	4	4	2015-07-10 15:49:42	2015-07-10 15:49:43.110946	2015-07-10 15:49:43.110946	12884901888
4	6a355b009660343734e4cced83484faf51433fe8cdd5ab3aa4a40109e8c1b1ef	7fe242606a8739322561d7e41fa53d2788fbebbc30a8374073f9fad9b57a11b8	4	4	2015-07-10 15:49:43	2015-07-10 15:49:43.153403	2015-07-10 15:49:43.153403	17179869184
5	078185d2bd5adaddf3b74dafaefa47015a9779a0857127d4f443dc4ac0fec1ae	6a355b009660343734e4cced83484faf51433fe8cdd5ab3aa4a40109e8c1b1ef	1	1	2015-07-10 15:49:44	2015-07-10 15:49:43.221563	2015-07-10 15:49:43.221563	21474836480
6	99240bd0f08a62246ea398a9887c3b78d9215634d732ab068154ed4cb4b2276d	078185d2bd5adaddf3b74dafaefa47015a9779a0857127d4f443dc4ac0fec1ae	1	1	2015-07-10 15:49:45	2015-07-10 15:49:43.239059	2015-07-10 15:49:43.239059	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
75	8589938688	0
76	8589938688	8589938688
77	8589942784	0
78	8589942784	8589942784
79	8589946880	0
80	8589946880	8589946880
81	8589950976	0
82	8589950976	8589950976
83	8589955072	0
84	8589955072	8589955072
85	12884905984	8589955072
86	12884910080	8589946880
87	12884914176	8589950976
88	12884918272	8589946880
89	17179873280	8589938688
90	17179873280	8589955072
91	17179877376	8589942784
92	17179877376	8589946880
93	17179881472	8589938688
94	17179881472	8589946880
95	17179885568	8589942784
96	17179885568	8589950976
97	21474840576	8589946880
98	25769807872	8589950976
99	25769807872	8589955072
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 99, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "starting_balance": 1000000000}
8589942784	8589942784	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "starting_balance": 1000000000}
8589946880	8589946880	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "starting_balance": 1000000000}
8589950976	8589950976	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA", "starting_balance": 1000000000}
8589955072	8589955072	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "starting_balance": 1000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "trustor": "gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "trustor": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
17179873280	17179873280	0	1	{"to": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 1000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179877376	17179877376	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "amount": 200000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
17179881472	17179881472	0	1	{"to": "gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ", "from": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq", "amount": 200000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
17179885568	17179885568	0	1	{"to": "gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA", "from": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "amount": 1000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 200000000, "offer_id": 0}
25769807872	25769807872	0	2	{"to": "gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA", "from": "gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ", "amount": 10, "currency_code": "EUR", "currency_type": "alphanum", "source_amount": 10, "currency_issuer": "gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd", "send_currency_code": "USD", "send_currency_type": "alphanum", "send_currency_issuer": "gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq"}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
70	2433f90e42d2bc8a8047b1561dfd2e4919452ccca845b34fb4a791fdf54ef697	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:43.015803	2015-07-10 15:49:43.015803
71	2433f90e42d2bc8a8047b1561dfd2e4919452ccca845b34fb4a791fdf54ef697	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:43.01686	2015-07-10 15:49:43.01686
72	78549d521218d33b16bf87ba3684f62959ef8fdf592101591893537c69f14ec4	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd	2015-07-10 15:49:43.034171	2015-07-10 15:49:43.034171
73	78549d521218d33b16bf87ba3684f62959ef8fdf592101591893537c69f14ec4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:43.035162	2015-07-10 15:49:43.035162
74	aa810ffa52e4574337d24b34950fa0d1970ae42aded04f684d551d82cef3b4db	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:43.052169	2015-07-10 15:49:43.052169
75	aa810ffa52e4574337d24b34950fa0d1970ae42aded04f684d551d82cef3b4db	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:43.053234	2015-07-10 15:49:43.053234
76	f79c0d169c2c7ade7ff7f53348c5b807bbc1bff6206a93b0bc1c78da044cd78d	gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	2015-07-10 15:49:43.069956	2015-07-10 15:49:43.069956
77	f79c0d169c2c7ade7ff7f53348c5b807bbc1bff6206a93b0bc1c78da044cd78d	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:43.070999	2015-07-10 15:49:43.070999
78	b6b08e996d1951aa25cb57529d1c28a16dfe41a63d88ee1be4594e30f63eb85a	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:43.087307	2015-07-10 15:49:43.087307
79	b6b08e996d1951aa25cb57529d1c28a16dfe41a63d88ee1be4594e30f63eb85a	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:43.088295	2015-07-10 15:49:43.088295
80	7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:43.115647	2015-07-10 15:49:43.115647
81	df4c6ac90b1676dbd14700ce39baac52c8d9a0cac8b084b845e4ad1ec7f2c061	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:43.124359	2015-07-10 15:49:43.124359
82	0bd570cda972719d99e8d262fa9ad5cc3efb1e729114c0dc11b65f74b5976b59	gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	2015-07-10 15:49:43.132217	2015-07-10 15:49:43.132217
83	0dc24f5f641ece05450c8e91417974b87c1fc36d4c9998e8aebdea8e13b394eb	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:43.14032	2015-07-10 15:49:43.14032
84	327b065a438361fa1173861683eee57c88fc190aa8ea1dd19faee93aaed2a618	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:43.157977	2015-07-10 15:49:43.157977
85	840aa82e8945222305d0fc44610942da755330caed102d5d463b7b9615cf5090	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd	2015-07-10 15:49:43.173105	2015-07-10 15:49:43.173105
86	6cc420ebc8b5c0dd5b8444a4564627cf172b673bacc8df8ce558e064c99344ee	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	2015-07-10 15:49:43.187536	2015-07-10 15:49:43.187536
87	344ca8641e64636001eda48e407c4ffb2fd7471411ac89511db5384834ec6a59	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd	2015-07-10 15:49:43.202005	2015-07-10 15:49:43.202005
88	b90cc19c414426269ce9c245d7b079c34735a6d8a7afca594ce7cc362673269a	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2015-07-10 15:49:43.226433	2015-07-10 15:49:43.226433
89	c3399f16ed7edb2327fb8b44fe6af021eab1ab1f3d48bcca3ca4eb0fb4d47773	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2015-07-10 15:49:43.244651	2015-07-10 15:49:43.244651
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 89, true);


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
2433f90e42d2bc8a8047b1561dfd2e4919452ccca845b34fb4a791fdf54ef697	2	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-10 15:49:43.013367	2015-07-10 15:49:43.013367	8589938688
78549d521218d33b16bf87ba3684f62959ef8fdf592101591893537c69f14ec4	2	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-10 15:49:43.032334	2015-07-10 15:49:43.032334	8589942784
aa810ffa52e4574337d24b34950fa0d1970ae42aded04f684d551d82cef3b4db	2	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-10 15:49:43.050325	2015-07-10 15:49:43.050325	8589946880
f79c0d169c2c7ade7ff7f53348c5b807bbc1bff6206a93b0bc1c78da044cd78d	2	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-07-10 15:49:43.067951	2015-07-10 15:49:43.067951	8589950976
b6b08e996d1951aa25cb57529d1c28a16dfe41a63d88ee1be4594e30f63eb85a	2	5	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	5	10	10	1	-1	2015-07-10 15:49:43.085439	2015-07-10 15:49:43.085439	8589955072
7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	3	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934593	10	10	1	-1	2015-07-10 15:49:43.113896	2015-07-10 15:49:43.113896	12884905984
df4c6ac90b1676dbd14700ce39baac52c8d9a0cac8b084b845e4ad1ec7f2c061	3	2	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934593	10	10	1	-1	2015-07-10 15:49:43.122606	2015-07-10 15:49:43.122606	12884910080
0bd570cda972719d99e8d262fa9ad5cc3efb1e729114c0dc11b65f74b5976b59	3	3	gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA	8589934593	10	10	1	-1	2015-07-10 15:49:43.130661	2015-07-10 15:49:43.130661	12884914176
0dc24f5f641ece05450c8e91417974b87c1fc36d4c9998e8aebdea8e13b394eb	3	4	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934594	10	10	1	-1	2015-07-10 15:49:43.138641	2015-07-10 15:49:43.138641	12884918272
327b065a438361fa1173861683eee57c88fc190aa8ea1dd19faee93aaed2a618	4	1	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934593	10	10	1	-1	2015-07-10 15:49:43.156411	2015-07-10 15:49:43.156411	17179873280
840aa82e8945222305d0fc44610942da755330caed102d5d463b7b9615cf5090	4	2	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd	8589934593	10	10	1	-1	2015-07-10 15:49:43.171306	2015-07-10 15:49:43.171306	17179877376
6cc420ebc8b5c0dd5b8444a4564627cf172b673bacc8df8ce558e064c99344ee	4	3	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	8589934594	10	10	1	-1	2015-07-10 15:49:43.185821	2015-07-10 15:49:43.185821	17179881472
344ca8641e64636001eda48e407c4ffb2fd7471411ac89511db5384834ec6a59	4	4	gsDu9aPmZy7uH5FzmfJKW7jWyXGHjSWbcb8k6UH743pYzaxWcWd	8589934594	10	10	1	-1	2015-07-10 15:49:43.200438	2015-07-10 15:49:43.200438	17179885568
b90cc19c414426269ce9c245d7b079c34735a6d8a7afca594ce7cc362673269a	5	1	gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8589934595	10	10	1	-1	2015-07-10 15:49:43.224714	2015-07-10 15:49:43.224714	21474840576
c3399f16ed7edb2327fb8b44fe6af021eab1ab1f3d48bcca3ca4eb0fb4d47773	6	1	gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	8589934594	10	10	1	-1	2015-07-10 15:49:43.242466	2015-07-10 15:49:43.242466	25769807872
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

