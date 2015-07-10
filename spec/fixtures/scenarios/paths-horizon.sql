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
8589938688	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc
8589942784	gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ
8589946880	gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC
8589950976	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe
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
8589950976	8589950976	0	0	{"starting_balance": 10000000000}
0	8589950976	1	3	{"amount": 10000000000, "currency_type": "native"}
8589942784	17179873280	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179873280	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179877376	0	2	{"amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179877376	1	3	{"amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179881472	0	2	{"amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179881472	1	3	{"amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179885568	0	2	{"amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179885568	1	3	{"amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179889664	0	2	{"amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179889664	1	3	{"amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179893760	0	2	{"amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179893760	1	3	{"amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179897856	0	2	{"amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179897856	1	3	{"amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589950976	17179901952	0	2	{"amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
8589938688	17179901952	1	3	{"amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-07-10 15:49:48.787191	2015-07-10 15:49:48.787191	4294967296
2	ec65083646d18a99bd722acee1fc8d61f181a301c96d3926c4bc3cec0144fc47	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	4	4	2015-07-10 15:49:46	2015-07-10 15:49:48.801027	2015-07-10 15:49:48.801027	8589934592
3	cab87cc4e07cf15b04824ac4b5cc06ccb0ec9592f3e1d7f20e68361a4690a126	ec65083646d18a99bd722acee1fc8d61f181a301c96d3926c4bc3cec0144fc47	10	10	2015-07-10 15:49:47	2015-07-10 15:49:48.896841	2015-07-10 15:49:48.896841	12884901888
4	a0a0103266ed3776ca21c2e0b133a562d539a9ef22cb2671ea01478a780939c7	cab87cc4e07cf15b04824ac4b5cc06ccb0ec9592f3e1d7f20e68361a4690a126	8	8	2015-07-10 15:49:48	2015-07-10 15:49:48.997316	2015-07-10 15:49:48.997316	17179869184
5	9a8e7b8078ce77512ceafa945c9b23422ead79e74434bfd4562a1a74ccfe89e1	a0a0103266ed3776ca21c2e0b133a562d539a9ef22cb2671ea01478a780939c7	10	10	2015-07-10 15:49:49	2015-07-10 15:49:49.125428	2015-07-10 15:49:49.125428	21474836480
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
100	8589938688	0
101	8589938688	8589938688
102	8589942784	0
103	8589942784	8589942784
104	8589946880	0
105	8589946880	8589946880
106	8589950976	0
107	8589950976	8589950976
108	12884905984	8589942784
109	12884910080	8589946880
110	12884914176	8589950976
111	12884918272	8589950976
112	12884922368	8589950976
113	12884926464	8589950976
114	12884930560	8589950976
115	12884934656	8589950976
116	12884938752	8589950976
117	12884942848	8589950976
118	17179873280	8589938688
119	17179873280	8589942784
120	17179877376	8589938688
121	17179877376	8589950976
122	17179881472	8589938688
123	17179881472	8589950976
124	17179885568	8589938688
125	17179885568	8589950976
126	17179889664	8589938688
127	17179889664	8589950976
128	17179893760	8589938688
129	17179893760	8589950976
130	17179897856	8589938688
131	17179897856	8589950976
132	17179901952	8589938688
133	17179901952	8589950976
134	21474840576	8589950976
135	21474844672	8589950976
136	21474848768	8589950976
137	21474852864	8589950976
138	21474856960	8589950976
139	21474861056	8589950976
140	21474865152	8589950976
141	21474869248	8589950976
142	21474873344	8589950976
143	21474877440	8589950976
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 143, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "starting_balance": 10000000000}
8589942784	8589942784	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ", "starting_balance": 10000000000}
8589946880	8589946880	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC", "starting_balance": 10000000000}
8589950976	8589950976	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "starting_balance": 10000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884922368	12884922368	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884926464	12884926464	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884930560	12884930560	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884934656	12884934656	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884938752	12884938752	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
12884942848	12884942848	0	6	{"limit": 9223372036854775807, "trustee": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "trustor": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179873280	17179873280	0	1	{"to": "gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179877376	17179877376	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179881472	17179881472	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179885568	17179885568	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179889664	17179889664	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179893760	17179893760	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179897856	17179897856	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
17179901952	17179901952	0	1	{"to": "gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe", "from": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc", "amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 10, "offer_id": 0}
21474844672	21474844672	0	3	{"price": {"d": 1, "n": 1}, "amount": 20, "offer_id": 0}
21474848768	21474848768	0	3	{"price": {"d": 1, "n": 1}, "amount": 20, "offer_id": 0}
21474852864	21474852864	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
21474856960	21474856960	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
21474861056	21474861056	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
21474865152	21474865152	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
21474869248	21474869248	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
21474873344	21474873344	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
21474877440	21474877440	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
90	d20ac4ca15e0c9df685d629189a894eff4f99960fe77179bf6d524387b6faff7	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:48.808809	2015-07-10 15:49:48.808809
91	d20ac4ca15e0c9df685d629189a894eff4f99960fe77179bf6d524387b6faff7	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:48.810478	2015-07-10 15:49:48.810478
92	b5956066e8f4ffcbfda083c37fadabc9a2061e560ba2b4a53333cf59279e8196	gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ	2015-07-10 15:49:48.833014	2015-07-10 15:49:48.833014
93	b5956066e8f4ffcbfda083c37fadabc9a2061e560ba2b4a53333cf59279e8196	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:48.834148	2015-07-10 15:49:48.834148
94	fbe5e605fda6375d9721059603cc45eb665f51aebdc42db224ed508bab3d8453	gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC	2015-07-10 15:49:48.852669	2015-07-10 15:49:48.852669
95	fbe5e605fda6375d9721059603cc45eb665f51aebdc42db224ed508bab3d8453	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:48.853748	2015-07-10 15:49:48.853748
96	b6ab723db7571f628eeb4172133fa38105a00dd830b25e410c88d87895fa7b5b	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.871366	2015-07-10 15:49:48.871366
97	b6ab723db7571f628eeb4172133fa38105a00dd830b25e410c88d87895fa7b5b	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:48.872436	2015-07-10 15:49:48.872436
98	8813da8d6a5655f9faea30ad40f8d4e4be07a3e3b191ef0ad3cdeb8313fe7041	gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ	2015-07-10 15:49:48.901627	2015-07-10 15:49:48.901627
99	b1ecb9ff7c223c3d1a19d4be5ecb91328e2f52bc142c85484d82969bf4ff2dda	gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC	2015-07-10 15:49:48.910452	2015-07-10 15:49:48.910452
100	262e2d5d7da7127b3f3ffcafdeb5a80ea03505f5755a5573bcaf5a090cb1bda0	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.919049	2015-07-10 15:49:48.919049
101	49d255b32e55b1108a7a535b992e869d61dd5d98ae31b222ee62b0688f4d710a	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.927976	2015-07-10 15:49:48.927976
102	ad4a36e0568d6b62ced009b527f3f84eef50d31ecf18c0f3523a47973eb4ee18	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.935084	2015-07-10 15:49:48.935084
103	b6dffa75864642698916345707edd8fea81f41ab56021ae2ddc33a39490cdc57	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.941992	2015-07-10 15:49:48.941992
104	4d11915bf1bf629e9b09e8617a1e6eab85937d3abef243d27e067b8e48239e94	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.956745	2015-07-10 15:49:48.956745
105	f43d4f30ba2af2fdc3dc8d0b056056145957f1147bc36eaf9b85c6cf7f743b6d	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.964418	2015-07-10 15:49:48.964418
106	14877264ae47160b60019cd993cd66863b763366462d6153c4b3898ded317014	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.972996	2015-07-10 15:49:48.972996
107	155839dfda0ed6bebb6d330668742c3cb553e110bbbcaff8a412d26a2db82632	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:48.982421	2015-07-10 15:49:48.982421
108	21ca3b917e83fd3f2071e534af58026252645a39b37f989bfb473152a13068a8	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.001804	2015-07-10 15:49:49.001804
109	17f6895808b77bd871e80d1913b9bfdb2dadf6f7a8bf1d3a2076af6e33ec5378	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.016621	2015-07-10 15:49:49.016621
110	9ca47d948d4bda26599ae91e6ea31f9acf40c9c1914f0b28a94fd1843aa45d9e	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.031104	2015-07-10 15:49:49.031104
111	d4e200f8e9e8c48e1a48f2de5e5f0b6698c5b9fe9cc9a398b994f1441d05b941	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.045467	2015-07-10 15:49:49.045467
112	8326cf13e8f4fd7a8a34a3ac9b781a26665edd04b9d1fd210ff960d393982b84	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.05994	2015-07-10 15:49:49.05994
113	a9ad6793df72cbbd64c355796e3846a20194709eedf3cc717ede745b67c18874	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.074263	2015-07-10 15:49:49.074263
114	e734462fd1ddb38074201899ce0e7f1a15e609bd4c794972091934bffc6eba1d	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.08891	2015-07-10 15:49:49.08891
115	6b9cd4c131b1efce3172c2a608c67776947181628420468cd095a3977ff029c9	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	2015-07-10 15:49:49.103333	2015-07-10 15:49:49.103333
116	6d5df09d78a900d7c1468825701dd2d080fe357e5351492d12ce43b405623a14	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.130279	2015-07-10 15:49:49.130279
117	892df7beb6c5ce3c6e205016576b203c98fb0a2fbd0a236816cd3d6572925afe	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.137903	2015-07-10 15:49:49.137903
118	6c8c25937ff3f54d785a4cf0b56cdc0f8a94a06888e0e7ddddaa8c6b2cf91c52	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.145243	2015-07-10 15:49:49.145243
119	8eb6a8a2d17a65e6eb75e8cdd4e45a7376736f54d43e4ed0e3e9249e04e517a4	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.152786	2015-07-10 15:49:49.152786
120	992d0a5aa1bcebfa355797dfc37ad4ba691fd94dd59d323505fb9e288cfd3545	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.160361	2015-07-10 15:49:49.160361
121	1d188cb21bff57f0a9a115f63d641c2ae13c870a494333bc3519a5999205d225	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.168015	2015-07-10 15:49:49.168015
122	1024e43df0fc0d64c7d0fe019861964f726a1b04c2f9f8f895fe27284b1674f3	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.175479	2015-07-10 15:49:49.175479
123	5d789bee987365dad5ba517583c153de989def7995f8d72bf150714b9dbc3d07	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.183474	2015-07-10 15:49:49.183474
124	1531f434acd0ba0ce722b9a84dc911e619ead9ad27498afdc493343ecfb77fd3	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.190598	2015-07-10 15:49:49.190598
125	bc612e7d03957e15e14e11e87297dd411d1ce01c575e653c8291c261b5d1758b	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	2015-07-10 15:49:49.198664	2015-07-10 15:49:49.198664
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 125, true);


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
d20ac4ca15e0c9df685d629189a894eff4f99960fe77179bf6d524387b6faff7	2	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-10 15:49:48.80559	2015-07-10 15:49:48.80559	8589938688
b5956066e8f4ffcbfda083c37fadabc9a2061e560ba2b4a53333cf59279e8196	2	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-10 15:49:48.831055	2015-07-10 15:49:48.831055	8589942784
fbe5e605fda6375d9721059603cc45eb665f51aebdc42db224ed508bab3d8453	2	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-10 15:49:48.850695	2015-07-10 15:49:48.850695	8589946880
b6ab723db7571f628eeb4172133fa38105a00dd830b25e410c88d87895fa7b5b	2	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-07-10 15:49:48.869508	2015-07-10 15:49:48.869508	8589950976
8813da8d6a5655f9faea30ad40f8d4e4be07a3e3b191ef0ad3cdeb8313fe7041	3	1	gkbrs4E8duufpRyWq8Ww8fXhr3VHs6a2W7KPqseXWdkSBWEYYJ	8589934593	10	10	1	-1	2015-07-10 15:49:48.899878	2015-07-10 15:49:48.899878	12884905984
b1ecb9ff7c223c3d1a19d4be5ecb91328e2f52bc142c85484d82969bf4ff2dda	3	2	gs5gkyRVPxJjoFREJ9gRDEkZAzKzYam79NuAKSLRK11kV2TWHJC	8589934593	10	10	1	-1	2015-07-10 15:49:48.908493	2015-07-10 15:49:48.908493	12884910080
262e2d5d7da7127b3f3ffcafdeb5a80ea03505f5755a5573bcaf5a090cb1bda0	3	3	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934593	10	10	1	-1	2015-07-10 15:49:48.917301	2015-07-10 15:49:48.917301	12884914176
49d255b32e55b1108a7a535b992e869d61dd5d98ae31b222ee62b0688f4d710a	3	4	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934594	10	10	1	-1	2015-07-10 15:49:48.926425	2015-07-10 15:49:48.926425	12884918272
ad4a36e0568d6b62ced009b527f3f84eef50d31ecf18c0f3523a47973eb4ee18	3	5	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934595	10	10	1	-1	2015-07-10 15:49:48.933638	2015-07-10 15:49:48.933638	12884922368
b6dffa75864642698916345707edd8fea81f41ab56021ae2ddc33a39490cdc57	3	6	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934596	10	10	1	-1	2015-07-10 15:49:48.940502	2015-07-10 15:49:48.940502	12884926464
4d11915bf1bf629e9b09e8617a1e6eab85937d3abef243d27e067b8e48239e94	3	7	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934597	10	10	1	-1	2015-07-10 15:49:48.955216	2015-07-10 15:49:48.955216	12884930560
f43d4f30ba2af2fdc3dc8d0b056056145957f1147bc36eaf9b85c6cf7f743b6d	3	8	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934598	10	10	1	-1	2015-07-10 15:49:48.962917	2015-07-10 15:49:48.962917	12884934656
14877264ae47160b60019cd993cd66863b763366462d6153c4b3898ded317014	3	9	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934599	10	10	1	-1	2015-07-10 15:49:48.971265	2015-07-10 15:49:48.971265	12884938752
155839dfda0ed6bebb6d330668742c3cb553e110bbbcaff8a412d26a2db82632	3	10	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934600	10	10	1	-1	2015-07-10 15:49:48.980147	2015-07-10 15:49:48.980147	12884942848
21ca3b917e83fd3f2071e534af58026252645a39b37f989bfb473152a13068a8	4	1	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934593	10	10	1	-1	2015-07-10 15:49:49.000271	2015-07-10 15:49:49.000271	17179873280
17f6895808b77bd871e80d1913b9bfdb2dadf6f7a8bf1d3a2076af6e33ec5378	4	2	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934594	10	10	1	-1	2015-07-10 15:49:49.015047	2015-07-10 15:49:49.015047	17179877376
9ca47d948d4bda26599ae91e6ea31f9acf40c9c1914f0b28a94fd1843aa45d9e	4	3	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934595	10	10	1	-1	2015-07-10 15:49:49.029518	2015-07-10 15:49:49.029518	17179881472
d4e200f8e9e8c48e1a48f2de5e5f0b6698c5b9fe9cc9a398b994f1441d05b941	4	4	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934596	10	10	1	-1	2015-07-10 15:49:49.043883	2015-07-10 15:49:49.043883	17179885568
8326cf13e8f4fd7a8a34a3ac9b781a26665edd04b9d1fd210ff960d393982b84	4	5	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934597	10	10	1	-1	2015-07-10 15:49:49.058194	2015-07-10 15:49:49.058194	17179889664
a9ad6793df72cbbd64c355796e3846a20194709eedf3cc717ede745b67c18874	4	6	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934598	10	10	1	-1	2015-07-10 15:49:49.072527	2015-07-10 15:49:49.072527	17179893760
e734462fd1ddb38074201899ce0e7f1a15e609bd4c794972091934bffc6eba1d	4	7	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934599	10	10	1	-1	2015-07-10 15:49:49.08727	2015-07-10 15:49:49.08727	17179897856
6b9cd4c131b1efce3172c2a608c67776947181628420468cd095a3977ff029c9	4	8	gsf2EkNXGX5PCkdZiakQ2Co3tTLV7S937fccqTFkYcMdFakFaDc	8589934600	10	10	1	-1	2015-07-10 15:49:49.101745	2015-07-10 15:49:49.101745	17179901952
6d5df09d78a900d7c1468825701dd2d080fe357e5351492d12ce43b405623a14	5	1	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934601	10	10	1	-1	2015-07-10 15:49:49.128517	2015-07-10 15:49:49.128517	21474840576
892df7beb6c5ce3c6e205016576b203c98fb0a2fbd0a236816cd3d6572925afe	5	2	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934602	10	10	1	-1	2015-07-10 15:49:49.136362	2015-07-10 15:49:49.136362	21474844672
6c8c25937ff3f54d785a4cf0b56cdc0f8a94a06888e0e7ddddaa8c6b2cf91c52	5	3	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934603	10	10	1	-1	2015-07-10 15:49:49.143687	2015-07-10 15:49:49.143687	21474848768
8eb6a8a2d17a65e6eb75e8cdd4e45a7376736f54d43e4ed0e3e9249e04e517a4	5	4	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934604	10	10	1	-1	2015-07-10 15:49:49.151051	2015-07-10 15:49:49.151051	21474852864
992d0a5aa1bcebfa355797dfc37ad4ba691fd94dd59d323505fb9e288cfd3545	5	5	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934605	10	10	1	-1	2015-07-10 15:49:49.158705	2015-07-10 15:49:49.158705	21474856960
1d188cb21bff57f0a9a115f63d641c2ae13c870a494333bc3519a5999205d225	5	6	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934606	10	10	1	-1	2015-07-10 15:49:49.166466	2015-07-10 15:49:49.166466	21474861056
1024e43df0fc0d64c7d0fe019861964f726a1b04c2f9f8f895fe27284b1674f3	5	7	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934607	10	10	1	-1	2015-07-10 15:49:49.173879	2015-07-10 15:49:49.173879	21474865152
5d789bee987365dad5ba517583c153de989def7995f8d72bf150714b9dbc3d07	5	8	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934608	10	10	1	-1	2015-07-10 15:49:49.181815	2015-07-10 15:49:49.181815	21474869248
1531f434acd0ba0ce722b9a84dc911e619ead9ad27498afdc493343ecfb77fd3	5	9	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934609	10	10	1	-1	2015-07-10 15:49:49.189028	2015-07-10 15:49:49.189028	21474873344
bc612e7d03957e15e14e11e87297dd411d1ce01c575e653c8291c261b5d1758b	5	10	gBividpgAzyYpUALhcsEtvWkK1aPKqZC6d1mUQMDK3ZteQPkYe	8589934610	10	10	1	-1	2015-07-10 15:49:49.196999	2015-07-10 15:49:49.196999	21474877440
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

