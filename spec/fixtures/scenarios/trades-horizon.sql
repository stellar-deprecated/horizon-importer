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
8589938688	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT
8589942784	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW
8589946880	GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR
8589950976	GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 1000000000}
0	8589938688	1	3	{"amount": 1000000000, "asset_type": "native"}
0	8589938688	2	10	{"weight": 1, "public_key": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT"}
8589942784	8589942784	0	0	{"starting_balance": 1000000000}
0	8589942784	1	3	{"amount": 1000000000, "asset_type": "native"}
0	8589942784	2	10	{"weight": 1, "public_key": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW"}
8589946880	8589946880	0	0	{"starting_balance": 1000000000}
0	8589946880	1	3	{"amount": 1000000000, "asset_type": "native"}
0	8589946880	2	10	{"weight": 1, "public_key": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
8589950976	8589950976	0	0	{"starting_balance": 1000000000}
0	8589950976	1	3	{"amount": 1000000000, "asset_type": "native"}
0	8589950976	2	10	{"weight": 1, "public_key": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589938688	12884905984	0	20	{"limit": 9223372036854775807, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
8589942784	12884910080	0	20	{"limit": 9223372036854775807, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
8589938688	12884914176	0	20	{"limit": 9223372036854775807, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589942784	12884918272	0	20	{"limit": 9223372036854775807, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589938688	17179873280	0	2	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
8589946880	17179873280	1	3	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
8589942784	17179877376	0	2	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589950976	17179877376	1	3	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589938688	25769807872	0	33	{"seller": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW", "offer_id": 1, "sold_amount": 500000000, "bought_amount": 500000000, "sold_asset_code": "USD", "sold_asset_type": "credit_alphanum4", "bought_asset_code": "EUR", "bought_asset_type": "credit_alphanum4", "sold_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "bought_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
8589942784	25769807872	1	33	{"seller": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT", "offer_id": 1, "sold_amount": 500000000, "bought_amount": 500000000, "sold_asset_code": "EUR", "sold_asset_type": "credit_alphanum4", "bought_asset_code": "USD", "bought_asset_type": "credit_alphanum4", "sold_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "bought_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-08-25 16:34:32.719651	2015-08-25 16:34:32.719651	4294967296
2	457bfa568e7788d29a2116ac1d7f93e46233325931f8aab3615b53d437ac16bd	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	4	4	2015-08-25 16:34:31	2015-08-25 16:34:32.730355	2015-08-25 16:34:32.730355	8589934592
3	7691aff805660f73207a3af34ea36299c23d2fa520927193390807c300f95246	457bfa568e7788d29a2116ac1d7f93e46233325931f8aab3615b53d437ac16bd	4	4	2015-08-25 16:34:32	2015-08-25 16:34:32.827415	2015-08-25 16:34:32.827415	12884901888
4	01d96e58651d194231db4c1eb8f4f61d1f8af5a6ffd74770d6134ded7b6bc5ed	7691aff805660f73207a3af34ea36299c23d2fa520927193390807c300f95246	2	2	2015-08-25 16:34:33	2015-08-25 16:34:32.883533	2015-08-25 16:34:32.883533	17179869184
5	ef8aab7779ea788c2335bdd08ffbf0edc548413596e594b3d7551e1c4dbb532e	01d96e58651d194231db4c1eb8f4f61d1f8af5a6ffd74770d6134ded7b6bc5ed	3	3	2015-08-25 16:34:34	2015-08-25 16:34:32.930167	2015-08-25 16:34:32.930167	21474836480
6	48b68b7b95b53605f34b57aac1a333481572643a694781858c1bad0d88669538	ef8aab7779ea788c2335bdd08ffbf0edc548413596e594b3d7551e1c4dbb532e	2	2	2015-08-25 16:34:35	2015-08-25 16:34:32.975136	2015-08-25 16:34:32.975136	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
164	8589938688	0
165	8589938688	8589938688
166	8589942784	0
167	8589942784	8589942784
168	8589946880	0
169	8589946880	8589946880
170	8589950976	0
171	8589950976	8589950976
172	12884905984	8589938688
173	12884910080	8589942784
174	12884914176	8589938688
175	12884918272	8589942784
176	17179873280	8589938688
177	17179873280	8589946880
178	17179877376	8589942784
179	17179877376	8589950976
180	21474840576	8589942784
181	21474844672	8589942784
182	21474848768	8589942784
183	25769807872	8589938688
184	25769811968	8589938688
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 184, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT", "starting_balance": 1000000000}
8589942784	8589942784	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW", "starting_balance": 1000000000}
8589946880	8589946880	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "starting_balance": 1000000000}
8589950976	8589950976	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "starting_balance": 1000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "trustor": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "trustor": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "trustor": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "trustor": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
17179873280	17179873280	0	1	{"to": "GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT", "from": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
17179877376	17179877376	0	1	{"to": "GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW", "from": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 1000000000, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "selling_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
21474844672	21474844672	0	3	{"price": {"d": 9, "n": 10}, "amount": 1111111111, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "selling_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
21474848768	21474848768	0	3	{"price": {"d": 4, "n": 5}, "amount": 1250000000, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR", "selling_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP"}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0, "buying_asset_code": "EUR", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "USD", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP", "selling_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0, "buying_asset_type": "native", "selling_asset_code": "USD", "selling_asset_type": "credit_alphanum4", "selling_asset_issuer": "GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR"}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
146	f3469a483751e42e5b1a93659cefab9256f474b322a4da2863b01b8d1c6e7698	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:34:32.735796	2015-08-25 16:34:32.735796
147	f3469a483751e42e5b1a93659cefab9256f474b322a4da2863b01b8d1c6e7698	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	2015-08-25 16:34:32.736916	2015-08-25 16:34:32.736916
148	fcc73b0399fcb7bbe5bc8551fd5da9ac4d5ac66a032ca45d59b11cbf885e190d	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:34:32.759274	2015-08-25 16:34:32.759274
149	fcc73b0399fcb7bbe5bc8551fd5da9ac4d5ac66a032ca45d59b11cbf885e190d	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.760304	2015-08-25 16:34:32.760304
150	014caa4ee8469d810c2e19c9ba56cfe16f832c601fc70b85d01e0c5606e11386	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:34:32.780485	2015-08-25 16:34:32.780485
151	014caa4ee8469d810c2e19c9ba56cfe16f832c601fc70b85d01e0c5606e11386	GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR	2015-08-25 16:34:32.781531	2015-08-25 16:34:32.781531
152	ac9f6527b3e4ee620d20d8291f3d27fae9d09eb8ac324019253c972b23642014	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-25 16:34:32.802333	2015-08-25 16:34:32.802333
153	ac9f6527b3e4ee620d20d8291f3d27fae9d09eb8ac324019253c972b23642014	GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP	2015-08-25 16:34:32.803424	2015-08-25 16:34:32.803424
154	64c3d437bdf916f6d1f003cfdec04d019d197f9496aaafad235fcc5d2c9c3f20	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	2015-08-25 16:34:32.831984	2015-08-25 16:34:32.831984
155	0433eb68d0714405e5f7e6678b661777586d806566c70de64e5a52195ebb5c84	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.843897	2015-08-25 16:34:32.843897
156	2a673a92d4a35680307e6ce83aa8830aa4e0fb5a7d1579d16f2289ca51cef06a	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	2015-08-25 16:34:32.854946	2015-08-25 16:34:32.854946
157	e81c5edf97394341030fa130a1facb856866672de4570fb13b566328fcd934a1	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.866564	2015-08-25 16:34:32.866564
158	4b805cdc1fe99eba9c1524ba64276db54014c757c893a3c34688cdcd27d8e22f	GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR	2015-08-25 16:34:32.888397	2015-08-25 16:34:32.888397
159	bdd0d152902a08a3bd3cfbe3d3c56df5881343f8aa44cef6bcfa39a263ced2ec	GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP	2015-08-25 16:34:32.90367	2015-08-25 16:34:32.90367
160	5c9c3e10cdbf03084677e1d63b31ca577df3d7c2f37d563155ac0ce6d3a1a557	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.934833	2015-08-25 16:34:32.934833
161	365e6a82a12fec14eee76e78295fcbd39b7c0a39ee6af74f8e2d0c21c5af90d4	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.943762	2015-08-25 16:34:32.943762
162	fa00586d11668f89292fa0ac63a84107adcaa6ad5d7626ddfbd282ebfeda2d61	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	2015-08-25 16:34:32.952941	2015-08-25 16:34:32.952941
163	5b87c1dadedfc48b504716ff4af9028a45eb863409c02e28d6ee3f6289e4aea1	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	2015-08-25 16:34:32.980399	2015-08-25 16:34:32.980399
164	ac8f874dc5e397eeec96a072fb288e5160b001b66b5eb9c39a7c7c483a6dd4bc	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	2015-08-25 16:34:32.996348	2015-08-25 16:34:32.996348
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 164, true);


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
f3469a483751e42e5b1a93659cefab9256f474b322a4da2863b01b8d1c6e7698	2	1	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	1	10	10	1	-1	2015-08-25 16:34:32.733607	2015-08-25 16:34:32.733607	8589938688
fcc73b0399fcb7bbe5bc8551fd5da9ac4d5ac66a032ca45d59b11cbf885e190d	2	2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2	10	10	1	-1	2015-08-25 16:34:32.757271	2015-08-25 16:34:32.757271	8589942784
014caa4ee8469d810c2e19c9ba56cfe16f832c601fc70b85d01e0c5606e11386	2	3	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	3	10	10	1	-1	2015-08-25 16:34:32.778558	2015-08-25 16:34:32.778558	8589946880
ac9f6527b3e4ee620d20d8291f3d27fae9d09eb8ac324019253c972b23642014	2	4	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	4	10	10	1	-1	2015-08-25 16:34:32.800119	2015-08-25 16:34:32.800119	8589950976
64c3d437bdf916f6d1f003cfdec04d019d197f9496aaafad235fcc5d2c9c3f20	3	1	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	8589934593	10	10	1	-1	2015-08-25 16:34:32.830233	2015-08-25 16:34:32.830233	12884905984
0433eb68d0714405e5f7e6678b661777586d806566c70de64e5a52195ebb5c84	3	2	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	8589934593	10	10	1	-1	2015-08-25 16:34:32.841953	2015-08-25 16:34:32.841953	12884910080
2a673a92d4a35680307e6ce83aa8830aa4e0fb5a7d1579d16f2289ca51cef06a	3	3	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	8589934594	10	10	1	-1	2015-08-25 16:34:32.853315	2015-08-25 16:34:32.853315	12884914176
e81c5edf97394341030fa130a1facb856866672de4570fb13b566328fcd934a1	3	4	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	8589934594	10	10	1	-1	2015-08-25 16:34:32.86478	2015-08-25 16:34:32.86478	12884918272
4b805cdc1fe99eba9c1524ba64276db54014c757c893a3c34688cdcd27d8e22f	4	1	GBIIWRZZXZMDXW6EI3BAJL3NJJZ5S3WC7JP54KTTXECJUW2A2CXVJWYR	8589934593	10	10	1	-1	2015-08-25 16:34:32.886521	2015-08-25 16:34:32.886521	17179873280
bdd0d152902a08a3bd3cfbe3d3c56df5881343f8aa44cef6bcfa39a263ced2ec	4	2	GDVLTJYLKNN3P7FR3Q7XS7FTENPYOSMIOLF53K3XWIMQ2OVDSOB5JVRP	8589934593	10	10	1	-1	2015-08-25 16:34:32.902148	2015-08-25 16:34:32.902148	17179877376
5c9c3e10cdbf03084677e1d63b31ca577df3d7c2f37d563155ac0ce6d3a1a557	5	1	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	8589934595	10	10	1	-1	2015-08-25 16:34:32.933013	2015-08-25 16:34:32.933013	21474840576
365e6a82a12fec14eee76e78295fcbd39b7c0a39ee6af74f8e2d0c21c5af90d4	5	2	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	8589934596	10	10	1	-1	2015-08-25 16:34:32.941822	2015-08-25 16:34:32.941822	21474844672
fa00586d11668f89292fa0ac63a84107adcaa6ad5d7626ddfbd282ebfeda2d61	5	3	GBNXHMMLLNKCFOJ3TVLBU3COMFKQBYGHLW7ZJOMB4KRXNTHM5WT46CKW	8589934597	10	10	1	-1	2015-08-25 16:34:32.95125	2015-08-25 16:34:32.95125	21474848768
5b87c1dadedfc48b504716ff4af9028a45eb863409c02e28d6ee3f6289e4aea1	6	1	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	8589934595	10	10	1	-1	2015-08-25 16:34:32.978468	2015-08-25 16:34:32.978468	25769807872
ac8f874dc5e397eeec96a072fb288e5160b001b66b5eb9c39a7c7c483a6dd4bc	6	2	GABVO53X7WYKSAUIZX2KWGHN74A3UYEA2GILC7QIHE4O7FCSWYD4B6ZT	8589934596	10	10	1	-1	2015-08-25 16:34:32.994611	2015-08-25 16:34:32.994611	25769811968
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

