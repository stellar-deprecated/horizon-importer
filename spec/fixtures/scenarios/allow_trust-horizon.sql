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
    version character varying(255) NOT NULL
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
0	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ
8589938688	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4
8589942784	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU
8589946880	GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 10000000000}
0	8589938688	1	3	{"amount": 10000000000, "asset_type": "native"}
0	8589938688	2	10	{"weight": 1, "public_key": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
8589942784	8589942784	0	0	{"starting_balance": 10000000000}
0	8589942784	1	3	{"amount": 10000000000, "asset_type": "native"}
0	8589942784	2	10	{"weight": 1, "public_key": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU"}
8589946880	8589946880	0	0	{"starting_balance": 10000000000}
0	8589946880	1	3	{"amount": 10000000000, "asset_type": "native"}
0	8589946880	2	10	{"weight": 1, "public_key": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON"}
8589938688	12884905984	0	6	{"auth_required_flag": true}
8589938688	12884910080	0	6	{"auth_revocable_flag": true}
8589942784	17179873280	0	20	{"limit": 9223372036854775807, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
8589946880	21474840576	0	20	{"limit": 4000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
8589938688	25769807872	0	23	{"trustor": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU", "asset_code": "USD", "asset_type": "credit_alphanum4"}
8589938688	30064775168	0	23	{"trustor": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "asset_code": "USD", "asset_type": "credit_alphanum4"}
8589938688	34359742464	0	24	{"trustor": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "asset_code": "USD", "asset_type": "credit_alphanum4"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-08-25 16:33:48.909563	2015-08-25 16:33:48.909563	4294967296
2	f52fef036820a83e5a5914dc2291549867353611575797176a8cae615f3b9650	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	3	3	2015-08-25 16:33:47	2015-08-25 16:33:48.918947	2015-08-25 16:33:48.918947	8589934592
3	661b8fb47935dd2a925c5473be2230c259ae3966c2b027584e9f7d868ca063d5	f52fef036820a83e5a5914dc2291549867353611575797176a8cae615f3b9650	2	2	2015-08-25 16:33:48	2015-08-25 16:33:48.991131	2015-08-25 16:33:48.991131	12884901888
4	e08d95defe73bf07f3a0ee0f1e70a3980a923374c67be15af6d60d4982d58daa	661b8fb47935dd2a925c5473be2230c259ae3966c2b027584e9f7d868ca063d5	1	1	2015-08-25 16:33:49	2015-08-25 16:33:49.020637	2015-08-25 16:33:49.020637	17179869184
5	9254b1467b04615a6f3c13c580fa8e7d286586089be8e232a05c9c2ad95483ab	e08d95defe73bf07f3a0ee0f1e70a3980a923374c67be15af6d60d4982d58daa	1	1	2015-08-25 16:33:50	2015-08-25 16:33:49.040969	2015-08-25 16:33:49.040969	21474836480
6	824967190b22309d7bda22e3f77ef809bf2d45fba891ffcf9c09060bec719360	9254b1467b04615a6f3c13c580fa8e7d286586089be8e232a05c9c2ad95483ab	1	1	2015-08-25 16:33:51	2015-08-25 16:33:49.061484	2015-08-25 16:33:49.061484	25769803776
7	b4c8e9a90518a6adfc2f5968a5c22376a8fdf24f5b11bd1c2e6bfc8d3fe8cf85	824967190b22309d7bda22e3f77ef809bf2d45fba891ffcf9c09060bec719360	1	1	2015-08-25 16:33:52	2015-08-25 16:33:49.081638	2015-08-25 16:33:49.081638	30064771072
8	51cfb375076eecce71eb0f3b2751ecad85beb2d05e2777f88b69a8e6683d32e5	b4c8e9a90518a6adfc2f5968a5c22376a8fdf24f5b11bd1c2e6bfc8d3fe8cf85	1	1	2015-08-25 16:33:53	2015-08-25 16:33:49.102499	2015-08-25 16:33:49.102499	34359738368
9	cef3627472f39493ee2ce57a49a1d44f84ccfafaf802edff9a8fe431b0e5a8ca	51cfb375076eecce71eb0f3b2751ecad85beb2d05e2777f88b69a8e6683d32e5	0	0	2015-08-25 16:33:54	2015-08-25 16:33:49.123323	2015-08-25 16:33:49.123323	38654705664
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
7	8589938688	0
8	8589938688	8589938688
9	8589942784	0
10	8589942784	8589942784
11	8589946880	0
12	8589946880	8589946880
13	12884905984	8589938688
14	12884910080	8589938688
15	17179873280	8589942784
16	21474840576	8589946880
17	25769807872	8589938688
18	30064775168	8589938688
19	34359742464	8589938688
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 19, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "starting_balance": 10000000000}
8589942784	8589942784	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU", "starting_balance": 10000000000}
8589946880	8589946880	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "starting_balance": 10000000000}
12884905984	12884905984	0	5	{"set_flags": [1], "set_flags_s": ["auth_required_flag"]}
12884910080	12884910080	0	5	{"set_flags": [2], "set_flags_s": ["auth_revocable_flag"]}
17179873280	17179873280	0	6	{"limit": 9223372036854775807, "trustee": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "trustor": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
21474840576	21474840576	0	6	{"limit": 4000, "trustee": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "trustor": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
25769807872	25769807872	0	7	{"trustee": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "trustor": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU", "authorize": true, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
30064775168	30064775168	0	7	{"trustee": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "trustor": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "authorize": true, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
34359742464	34359742464	0	7	{"trustee": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "trustor": "GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON", "authorize": false, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4"}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
7	0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:33:48.923713	2015-08-25 16:33:48.923713
8	0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:48.924748	2015-08-25 16:33:48.924748
9	afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:33:48.944161	2015-08-25 16:33:48.944161
10	afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-25 16:33:48.945142	2015-08-25 16:33:48.945142
11	c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:33:48.965584	2015-08-25 16:33:48.965584
12	c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	2015-08-25 16:33:48.966571	2015-08-25 16:33:48.966571
13	76ccdbb609e433a04ce3e82474af0f4370a55eba81d53bf8362409affa4f3c1c	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:48.995619	2015-08-25 16:33:48.995619
14	41ce66dbd7f8d8877b0ba805f4a37778a4f94e245c3f2dec3ec5e19a36449cc8	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:49.005917	2015-08-25 16:33:49.005917
15	7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-25 16:33:49.025144	2015-08-25 16:33:49.025144
16	10035e44564a32960c4385468d4e484a3eed8ad5c88e3199365cac496ac35dab	GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	2015-08-25 16:33:49.045589	2015-08-25 16:33:49.045589
17	004a44b27ea6287cc8070442d144b5232cb178a525c4600908d084669b7241c6	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:49.06598	2015-08-25 16:33:49.06598
18	850e4810c37771d37b1fb2598529b00af9ae089986c5e6b9c1856e265b613f9a	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:49.086201	2015-08-25 16:33:49.086201
19	5ff4c0a489771bdaa8304b1b1f63d77a46242854a626e480d8adc82c6753b433	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	2015-08-25 16:33:49.107297	2015-08-25 16:33:49.107297
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 19, true);


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
0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	2	1	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	1	10	10	1	-1	2015-08-25 16:33:48.921832	2015-08-25 16:33:48.921832	8589938688
afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	2	2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2	10	10	1	-1	2015-08-25 16:33:48.942312	2015-08-25 16:33:48.942312	8589942784
c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	2	3	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	3	10	10	1	-1	2015-08-25 16:33:48.963741	2015-08-25 16:33:48.963741	8589946880
76ccdbb609e433a04ce3e82474af0f4370a55eba81d53bf8362409affa4f3c1c	3	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	8589934593	10	10	1	-1	2015-08-25 16:33:48.993965	2015-08-25 16:33:48.993965	12884905984
41ce66dbd7f8d8877b0ba805f4a37778a4f94e245c3f2dec3ec5e19a36449cc8	3	2	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	8589934594	10	10	1	-1	2015-08-25 16:33:49.004303	2015-08-25 16:33:49.004303	12884910080
7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	4	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934593	10	10	1	-1	2015-08-25 16:33:49.023409	2015-08-25 16:33:49.023409	17179873280
10035e44564a32960c4385468d4e484a3eed8ad5c88e3199365cac496ac35dab	5	1	GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	8589934593	10	10	1	-1	2015-08-25 16:33:49.043785	2015-08-25 16:33:49.043785	21474840576
004a44b27ea6287cc8070442d144b5232cb178a525c4600908d084669b7241c6	6	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	8589934595	10	10	1	-1	2015-08-25 16:33:49.064258	2015-08-25 16:33:49.064258	25769807872
850e4810c37771d37b1fb2598529b00af9ae089986c5e6b9c1856e265b613f9a	7	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	8589934596	10	10	1	-1	2015-08-25 16:33:49.084474	2015-08-25 16:33:49.084474	30064775168
5ff4c0a489771bdaa8304b1b1f63d77a46242854a626e480d8adc82c6753b433	8	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	8589934597	10	10	1	-1	2015-08-25 16:33:49.105347	2015-08-25 16:33:49.105347	34359742464
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20150508215546
20150310224849
20150313225945
20150313225955
20150501160031
20150508003829
20150508175821
20150508183542
20150609230237
20150629181921
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

