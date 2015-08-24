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
8589938688	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU
8589942784	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW
8589946880	GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y
8589950976	GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 1000000000}
0	8589938688	1	3	{"amount": 1000000000, "asset_type": "native"}
8589942784	8589942784	0	0	{"starting_balance": 1000000000}
0	8589942784	1	3	{"amount": 1000000000, "asset_type": "native"}
8589946880	8589946880	0	0	{"starting_balance": 1000000000}
0	8589946880	1	3	{"amount": 1000000000, "asset_type": "native"}
8589950976	8589950976	0	0	{"starting_balance": 1000000000}
0	8589950976	1	3	{"amount": 1000000000, "asset_type": "native"}
8589938688	17179873280	0	2	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
8589946880	17179873280	1	3	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
8589942784	17179877376	0	2	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
8589950976	17179877376	1	3	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-08-24 18:14:17.024277	2015-08-24 18:14:17.024277	4294967296
2	0fa06e47edd13771469084807ed3dea414d34a04a68a963c9b48c54a35fbaceb	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	4	4	2015-08-24 18:14:15	2015-08-24 18:14:17.034637	2015-08-24 18:14:17.034637	8589934592
3	1458bc592cbff779e16cdbd12ab1e346135634da50404b8b58d4981dc1cecbec	0fa06e47edd13771469084807ed3dea414d34a04a68a963c9b48c54a35fbaceb	4	4	2015-08-24 18:14:16	2015-08-24 18:14:17.123101	2015-08-24 18:14:17.123101	12884901888
4	135245d81467cedb347f0aa506a6d63dcd878aed6fe83a4c34b987a4028e5314	1458bc592cbff779e16cdbd12ab1e346135634da50404b8b58d4981dc1cecbec	2	2	2015-08-24 18:14:17	2015-08-24 18:14:17.168791	2015-08-24 18:14:17.168791	17179869184
5	2dcf650a3920390a037dfe76b7cd19ceb13c8871cbab55436cf87d1aed22afd9	135245d81467cedb347f0aa506a6d63dcd878aed6fe83a4c34b987a4028e5314	3	3	2015-08-24 18:14:18	2015-08-24 18:14:17.217722	2015-08-24 18:14:17.217722	21474836480
6	716e5ff9f654b338f68c4f279423cebe5728b6f87f951874958521dd5d95bd45	2dcf650a3920390a037dfe76b7cd19ceb13c8871cbab55436cf87d1aed22afd9	2	2	2015-08-24 18:14:19	2015-08-24 18:14:17.251662	2015-08-24 18:14:17.251662	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
156	8589938688	0
157	8589938688	8589938688
158	8589942784	0
159	8589942784	8589942784
160	8589946880	0
161	8589946880	8589946880
162	8589950976	0
163	8589950976	8589950976
164	12884905984	8589938688
165	12884910080	8589942784
166	12884914176	8589938688
167	12884918272	8589942784
168	17179873280	8589938688
169	17179873280	8589946880
170	17179877376	8589942784
171	17179877376	8589950976
172	21474840576	8589942784
173	21474844672	8589942784
174	21474848768	8589942784
175	25769807872	8589938688
176	25769811968	8589938688
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 176, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU", "starting_balance": 1000000000}
8589942784	8589942784	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW", "starting_balance": 1000000000}
8589946880	8589946880	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "starting_balance": 1000000000}
8589950976	8589950976	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH", "starting_balance": 1000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "trustor": "GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "trustor": "GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH", "trustor": "GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH", "trustor": "GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
17179873280	17179873280	0	1	{"to": "GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU", "from": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
17179877376	17179877376	0	1	{"to": "GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW", "from": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH", "amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 1000000000, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "selling_asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
21474844672	21474844672	0	3	{"price": {"d": 9, "n": 10}, "amount": 1111111111, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "selling_asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
21474848768	21474848768	0	3	{"price": {"d": 4, "n": 5}, "amount": 1250000000, "offer_id": 0, "buying_asset_code": "USD", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "EUR", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y", "selling_asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH"}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0, "buying_asset_code": "EUR", "buying_asset_type": "credit_alphanum4", "selling_asset_code": "USD", "selling_asset_type": "credit_alphanum4", "buying_asset_issuer": "GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH", "selling_asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0, "buying_asset_type": "native", "selling_asset_code": "USD", "selling_asset_type": "credit_alphanum4", "selling_asset_issuer": "GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y"}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
138	5e444399b2a43856acd9dfa7cfad64d20dadb08b7f806b23de2e60179497290e	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 18:14:17.040135	2015-08-24 18:14:17.040135
139	5e444399b2a43856acd9dfa7cfad64d20dadb08b7f806b23de2e60179497290e	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	2015-08-24 18:14:17.041319	2015-08-24 18:14:17.041319
140	9b15d8c1fca92307ac89c92620fe84398bfe6979537cba3f25ed9931c6cf4c0e	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 18:14:17.058278	2015-08-24 18:14:17.058278
141	9b15d8c1fca92307ac89c92620fe84398bfe6979537cba3f25ed9931c6cf4c0e	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.059278	2015-08-24 18:14:17.059278
142	4ce83ec538d29cc04737004dd83a16bb98252e6b9e40796a82eefa06ef6e14aa	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 18:14:17.079831	2015-08-24 18:14:17.079831
143	4ce83ec538d29cc04737004dd83a16bb98252e6b9e40796a82eefa06ef6e14aa	GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y	2015-08-24 18:14:17.081376	2015-08-24 18:14:17.081376
144	35635178af35407a8ecb405af94fc00e660912023785a88f28004147bcaf3e2c	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 18:14:17.09901	2015-08-24 18:14:17.09901
145	35635178af35407a8ecb405af94fc00e660912023785a88f28004147bcaf3e2c	GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH	2015-08-24 18:14:17.099943	2015-08-24 18:14:17.099943
146	622ba36bdd05bdc230bece6bc8eff9aa534041fb64f3121e6618b8c1e2663355	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	2015-08-24 18:14:17.129917	2015-08-24 18:14:17.129917
147	c27947d5d59d12b100b6788457f127f3a8fcdf896ad07b4c3b7cbdd289d55c88	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.140732	2015-08-24 18:14:17.140732
148	8ad0f539fea613f9b48c3c96c4da89bd4b5eb286b2a8932d88ddba0f95ab249f	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	2015-08-24 18:14:17.149763	2015-08-24 18:14:17.149763
149	0f1b5b63c516c189c97e67ed9470a933e8011899bf6c89a9f1f17e39b7e37b99	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.157032	2015-08-24 18:14:17.157032
150	c3353614458a9803127d167741c7322df717f130a0bd42e8d18f2ac7f5d18268	GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y	2015-08-24 18:14:17.173282	2015-08-24 18:14:17.173282
151	f566ad6926b308a55fbbc1262a7ec4025aab68a9cf1bdd93ca60504650234022	GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH	2015-08-24 18:14:17.196712	2015-08-24 18:14:17.196712
152	3f203a89fcf3b2b80dc262823ac280b6c7168faf9a3a408f2cf783305d6b98ff	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.222387	2015-08-24 18:14:17.222387
153	42002b83bab3c1802b5c4f8c4829e7745ea88a02851bf947163e3afd6dbdb96d	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.230774	2015-08-24 18:14:17.230774
154	13cda2b4eeae79f84d5794fa5f8ed70abff900fb0764d8be76abc66ab584b561	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	2015-08-24 18:14:17.238814	2015-08-24 18:14:17.238814
155	c38a377d8e6758b141b5c55c579a740591ade7c2ad30712406892b5cf6627500	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	2015-08-24 18:14:17.256453	2015-08-24 18:14:17.256453
156	cf2ae664079123de09bb6e5126869435996570b60d5eb099b5329214b12f7349	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	2015-08-24 18:14:17.264551	2015-08-24 18:14:17.264551
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 156, true);


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
5e444399b2a43856acd9dfa7cfad64d20dadb08b7f806b23de2e60179497290e	2	1	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	1	10	10	1	-1	2015-08-24 18:14:17.037747	2015-08-24 18:14:17.037747	8589938688
9b15d8c1fca92307ac89c92620fe84398bfe6979537cba3f25ed9931c6cf4c0e	2	2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2	10	10	1	-1	2015-08-24 18:14:17.05629	2015-08-24 18:14:17.05629	8589942784
4ce83ec538d29cc04737004dd83a16bb98252e6b9e40796a82eefa06ef6e14aa	2	3	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	3	10	10	1	-1	2015-08-24 18:14:17.076997	2015-08-24 18:14:17.076997	8589946880
35635178af35407a8ecb405af94fc00e660912023785a88f28004147bcaf3e2c	2	4	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	4	10	10	1	-1	2015-08-24 18:14:17.097154	2015-08-24 18:14:17.097154	8589950976
622ba36bdd05bdc230bece6bc8eff9aa534041fb64f3121e6618b8c1e2663355	3	1	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	8589934593	10	10	1	-1	2015-08-24 18:14:17.127311	2015-08-24 18:14:17.127311	12884905984
c27947d5d59d12b100b6788457f127f3a8fcdf896ad07b4c3b7cbdd289d55c88	3	2	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	8589934593	10	10	1	-1	2015-08-24 18:14:17.138795	2015-08-24 18:14:17.138795	12884910080
8ad0f539fea613f9b48c3c96c4da89bd4b5eb286b2a8932d88ddba0f95ab249f	3	3	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	8589934594	10	10	1	-1	2015-08-24 18:14:17.147777	2015-08-24 18:14:17.147777	12884914176
0f1b5b63c516c189c97e67ed9470a933e8011899bf6c89a9f1f17e39b7e37b99	3	4	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	8589934594	10	10	1	-1	2015-08-24 18:14:17.155534	2015-08-24 18:14:17.155534	12884918272
c3353614458a9803127d167741c7322df717f130a0bd42e8d18f2ac7f5d18268	4	1	GADXUUK6CBVTZXJQV7HKIYSEQCRSAORJVLDYIOP2NHIW64SKCWIOLD4Y	8589934593	10	10	1	-1	2015-08-24 18:14:17.171711	2015-08-24 18:14:17.171711	17179873280
f566ad6926b308a55fbbc1262a7ec4025aab68a9cf1bdd93ca60504650234022	4	2	GA7FXGG476ZROVS3CYVHTPUYYCHYV5UHBKD5WN62SQ2LYWPNUUTVTWFH	8589934593	10	10	1	-1	2015-08-24 18:14:17.194572	2015-08-24 18:14:17.194572	17179877376
3f203a89fcf3b2b80dc262823ac280b6c7168faf9a3a408f2cf783305d6b98ff	5	1	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	8589934595	10	10	1	-1	2015-08-24 18:14:17.220595	2015-08-24 18:14:17.220595	21474840576
42002b83bab3c1802b5c4f8c4829e7745ea88a02851bf947163e3afd6dbdb96d	5	2	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	8589934596	10	10	1	-1	2015-08-24 18:14:17.229147	2015-08-24 18:14:17.229147	21474844672
13cda2b4eeae79f84d5794fa5f8ed70abff900fb0764d8be76abc66ab584b561	5	3	GA7ZILCPIJ654PFCNHXPXUX6G3XROZGQ72I6UFFUNY7OQI26YZJTTFAW	8589934597	10	10	1	-1	2015-08-24 18:14:17.237134	2015-08-24 18:14:17.237134	21474848768
c38a377d8e6758b141b5c55c579a740591ade7c2ad30712406892b5cf6627500	6	1	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	8589934595	10	10	1	-1	2015-08-24 18:14:17.254566	2015-08-24 18:14:17.254566	25769807872
cf2ae664079123de09bb6e5126869435996570b60d5eb099b5329214b12f7349	6	2	GAMYB4WCOG25M5NJDWZ74BGOXWM27G5R7MQY23OV6F2WIEEHTVP23QVU	8589934596	10	10	1	-1	2015-08-24 18:14:17.262965	2015-08-24 18:14:17.262965	25769811968
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

