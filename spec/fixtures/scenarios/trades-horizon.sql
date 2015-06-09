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
DROP INDEX public.index_history_transaction_statuses_lc_on_all;
DROP INDEX public.index_history_transaction_participants_on_transaction_hash;
DROP INDEX public.index_history_transaction_participants_on_account;
DROP INDEX public.index_history_operations_on_type;
DROP INDEX public.index_history_operations_on_transaction_id;
DROP INDEX public.index_history_operations_on_id;
DROP INDEX public.index_history_ledgers_on_sequence;
DROP INDEX public.index_history_ledgers_on_previous_ledger_hash;
DROP INDEX public.index_history_ledgers_on_ledger_hash;
DROP INDEX public.index_history_ledgers_on_closed_at;
DROP INDEX public.index_history_accounts_on_id;
DROP INDEX public.hs_transaction_by_id;
DROP INDEX public.hs_ledger_by_id;
DROP INDEX public.hist_op_p_id;
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
    details hstore
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
0	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC
12884905984	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h
12884910080	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p
12884914176	gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4
12884918272	gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	\N	0	0	1970-01-01 00:00:00	2015-06-08 20:47:12.715761	2015-06-08 20:47:12.715761	4294967296
2	8cf712ebcb4b225e510d561bf0e3d106b914538ebd02b39eaa19781546045a75	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0	0	2015-06-08 20:47:10	2015-06-08 20:47:12.72487	2015-06-08 20:47:12.72487	8589934592
3	6cce810bd5efe5fd4feb5c9a469fca9b265f8a069a7163259427881cafd23b17	8cf712ebcb4b225e510d561bf0e3d106b914538ebd02b39eaa19781546045a75	0	0	2015-06-08 20:47:11	2015-06-08 20:47:12.734061	2015-06-08 20:47:12.734061	12884901888
4	0574f929421e86c4ac90307d75f819a9d4e29fcdea5f760e406bf544a30c52bb	6cce810bd5efe5fd4feb5c9a469fca9b265f8a069a7163259427881cafd23b17	0	0	2015-06-08 20:47:12	2015-06-08 20:47:12.793506	2015-06-08 20:47:12.793506	17179869184
5	1e5bad4d6d92108d1c960a3e06a3438f37d839c6f45f329a278de33713b67c42	0574f929421e86c4ac90307d75f819a9d4e29fcdea5f760e406bf544a30c52bb	0	0	2015-06-08 20:47:13	2015-06-08 20:47:12.837639	2015-06-08 20:47:12.837639	21474836480
6	beef8eb516f201fb14119fbe6b7ed2a261267b3bad3827447f282c043cbd1b27	1e5bad4d6d92108d1c960a3e06a3438f37d839c6f45f329a278de33713b67c42	0	0	2015-06-08 20:47:14	2015-06-08 20:47:12.870801	2015-06-08 20:47:12.870801	25769803776
7	3afe2b7042d77be3fc5e036b2996a4244fc086feb519c97d8f285aaed6aa3234	beef8eb516f201fb14119fbe6b7ed2a261267b3bad3827447f282c043cbd1b27	0	0	2015-06-08 20:47:15	2015-06-08 20:47:12.902698	2015-06-08 20:47:12.902698	30064771072
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
65	12884905984	0
66	12884905984	12884905984
67	12884910080	0
68	12884910080	12884910080
69	12884914176	0
70	12884914176	12884914176
71	12884918272	0
72	12884918272	12884918272
73	17179873280	12884905984
74	17179877376	12884910080
75	17179881472	12884905984
76	17179885568	12884910080
77	21474840576	12884910080
78	21474840576	12884918272
79	21474844672	12884905984
80	21474844672	12884914176
81	25769807872	12884910080
82	25769811968	12884910080
83	25769816064	12884910080
84	30064775168	12884905984
85	30064779264	12884905984
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 85, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
12884905984	12884905984	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h", "starting_balance"=>"1000000000"
12884910080	12884910080	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p", "starting_balance"=>"1000000000"
12884914176	12884914176	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4", "starting_balance"=>"1000000000"
12884918272	12884918272	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD", "starting_balance"=>"1000000000"
17179873280	17179873280	0	6	"limit"=>"9223372036854775807", "trustee"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4", "trustor"=>"gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h", "currency_code"=>"USD", "currency_type"=>"alphanum", "currency_issuer"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4"
17179877376	17179877376	0	6	"limit"=>"9223372036854775807", "trustee"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4", "trustor"=>"gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p", "currency_code"=>"USD", "currency_type"=>"alphanum", "currency_issuer"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4"
17179881472	17179881472	0	6	"limit"=>"9223372036854775807", "trustee"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD", "trustor"=>"gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h", "currency_code"=>"EUR", "currency_type"=>"alphanum", "currency_issuer"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD"
17179885568	17179885568	0	6	"limit"=>"9223372036854775807", "trustee"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD", "trustor"=>"gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p", "currency_code"=>"EUR", "currency_type"=>"alphanum", "currency_issuer"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD"
21474840576	21474840576	0	1	"to"=>"gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p", "from"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD", "amount"=>"5000000000", "currency_code"=>"EUR", "currency_type"=>"alphanum", "currency_issuer"=>"gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD"
21474844672	21474844672	0	1	"to"=>"gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h", "from"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4", "amount"=>"5000000000", "currency_code"=>"USD", "currency_type"=>"alphanum", "currency_issuer"=>"gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4"
25769807872	25769807872	0	3	\N
25769811968	25769811968	0	3	\N
25769816064	25769816064	0	3	\N
30064775168	30064775168	0	3	\N
30064779264	30064779264	0	3	\N
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
58	4e8ed556069ac2ec831577e8776a9b8d8f0e07e06efea64e72d0d02296d85b6b	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	2015-06-08 20:47:12.739012	2015-06-08 20:47:12.739012
59	4e8ed556069ac2ec831577e8776a9b8d8f0e07e06efea64e72d0d02296d85b6b	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-08 20:47:12.740075	2015-06-08 20:47:12.740075
60	4680fccb623176dbf781d4443a356601f3dc526269b25a1983b95b10a4434351	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.750889	2015-06-08 20:47:12.750889
61	4680fccb623176dbf781d4443a356601f3dc526269b25a1983b95b10a4434351	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-08 20:47:12.75188	2015-06-08 20:47:12.75188
62	d26b5f0a5e47c9a17283bffa276dc9e18b56c0773cc3eb3988d42b8867573d65	gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4	2015-06-08 20:47:12.763368	2015-06-08 20:47:12.763368
63	d26b5f0a5e47c9a17283bffa276dc9e18b56c0773cc3eb3988d42b8867573d65	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-08 20:47:12.764383	2015-06-08 20:47:12.764383
64	f48d2e8971a920d9e0c177bf0b435456e99225c83c49dde71031eeb63e5979a7	gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD	2015-06-08 20:47:12.775999	2015-06-08 20:47:12.775999
65	f48d2e8971a920d9e0c177bf0b435456e99225c83c49dde71031eeb63e5979a7	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-08 20:47:12.777103	2015-06-08 20:47:12.777103
66	fbdd1ca00674166ef9a88e5220ab2d2059927228ca3936eea3d63c7c5c435b0e	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	2015-06-08 20:47:12.799709	2015-06-08 20:47:12.799709
67	7997c2d758380ad4febfcdc204258e9acd9316ea9c233181b140d7daff710bb5	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.81028	2015-06-08 20:47:12.81028
68	c48dbc6999f66156b8502bd289ed1d15ece508fec68e5aa6d0f08a7ba3fa957c	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	2015-06-08 20:47:12.817488	2015-06-08 20:47:12.817488
69	5fb7987dfab7854e62cb211c46c72b630a3cba684bfd9d46fe431d8b263f6950	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.82543	2015-06-08 20:47:12.82543
70	08077bd9ae29d04dc783903bb21eb846bf1f22534a2422520f45235e393f51dd	gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD	2015-06-08 20:47:12.843895	2015-06-08 20:47:12.843895
71	e28f9cc29a6decf87c4a465d7374b3f7dcabf06493429cbc43d4346248c29059	gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4	2015-06-08 20:47:12.857899	2015-06-08 20:47:12.857899
72	cf600078c815242a313c62ea26da3b4a275fa8202915dea8c245c298584115ae	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.875209	2015-06-08 20:47:12.875209
73	acd9f62c539706caafcc5b46e1211c72c31f6c402ec36142d7906e808eaa710d	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.882233	2015-06-08 20:47:12.882233
74	39463521299afd48a7684bf6f8c79e84443eef20f099e64e7c1c350a7adc55fa	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	2015-06-08 20:47:12.889606	2015-06-08 20:47:12.889606
75	64f301f5619cd98010ce9a07ca1c23099dd1a0d0679413636bea81ebcafcf0d8	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	2015-06-08 20:47:12.908867	2015-06-08 20:47:12.908867
76	a4ecaa95c88a13ca337bd0df48e9949fa79d0cff24b2f5f3250b127a9235ee35	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	2015-06-08 20:47:12.918428	2015-06-08 20:47:12.918428
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 76, true);


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
4e8ed556069ac2ec831577e8776a9b8d8f0e07e06efea64e72d0d02296d85b6b	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-06-08 20:47:12.737108	2015-06-08 20:47:12.737108	12884905984
4680fccb623176dbf781d4443a356601f3dc526269b25a1983b95b10a4434351	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-06-08 20:47:12.749323	2015-06-08 20:47:12.749323	12884910080
d26b5f0a5e47c9a17283bffa276dc9e18b56c0773cc3eb3988d42b8867573d65	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-06-08 20:47:12.761566	2015-06-08 20:47:12.761566	12884914176
f48d2e8971a920d9e0c177bf0b435456e99225c83c49dde71031eeb63e5979a7	3	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-06-08 20:47:12.774409	2015-06-08 20:47:12.774409	12884918272
fbdd1ca00674166ef9a88e5220ab2d2059927228ca3936eea3d63c7c5c435b0e	4	1	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	12884901889	10	10	1	-1	2015-06-08 20:47:12.797399	2015-06-08 20:47:12.797399	17179873280
7997c2d758380ad4febfcdc204258e9acd9316ea9c233181b140d7daff710bb5	4	2	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	12884901889	10	10	1	-1	2015-06-08 20:47:12.808675	2015-06-08 20:47:12.808675	17179877376
c48dbc6999f66156b8502bd289ed1d15ece508fec68e5aa6d0f08a7ba3fa957c	4	3	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	12884901890	10	10	1	-1	2015-06-08 20:47:12.816051	2015-06-08 20:47:12.816051	17179881472
5fb7987dfab7854e62cb211c46c72b630a3cba684bfd9d46fe431d8b263f6950	4	4	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	12884901890	10	10	1	-1	2015-06-08 20:47:12.823778	2015-06-08 20:47:12.823778	17179885568
08077bd9ae29d04dc783903bb21eb846bf1f22534a2422520f45235e393f51dd	5	1	gsJVy9Pm8GbJPghPt6py7n75ziCgMkKksKG8koC4PErnxrZCAWD	12884901889	10	10	1	-1	2015-06-08 20:47:12.841212	2015-06-08 20:47:12.841212	21474840576
e28f9cc29a6decf87c4a465d7374b3f7dcabf06493429cbc43d4346248c29059	5	2	gsLqYLeDoW52LKGysw616jSihFhCrgs8ctyu6SzotVyjSLNFnf4	12884901889	10	10	1	-1	2015-06-08 20:47:12.855674	2015-06-08 20:47:12.855674	21474844672
cf600078c815242a313c62ea26da3b4a275fa8202915dea8c245c298584115ae	6	1	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	12884901891	10	10	1	-1	2015-06-08 20:47:12.873554	2015-06-08 20:47:12.873554	25769807872
acd9f62c539706caafcc5b46e1211c72c31f6c402ec36142d7906e808eaa710d	6	2	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	12884901892	10	10	1	-1	2015-06-08 20:47:12.880837	2015-06-08 20:47:12.880837	25769811968
39463521299afd48a7684bf6f8c79e84443eef20f099e64e7c1c350a7adc55fa	6	3	gsqsSaGtwiEV1KZ9fqVHKsgsVUrS7QGHdrC9umBQAyE5iK6zV8p	12884901893	10	10	1	-1	2015-06-08 20:47:12.88765	2015-06-08 20:47:12.88765	25769816064
64f301f5619cd98010ce9a07ca1c23099dd1a0d0679413636bea81ebcafcf0d8	7	1	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	12884901891	10	10	1	-1	2015-06-08 20:47:12.90636	2015-06-08 20:47:12.90636	30064775168
a4ecaa95c88a13ca337bd0df48e9949fa79d0cff24b2f5f3250b127a9235ee35	7	2	gLRUakEUayqXqCibqEEkMqwwK4vPdpsFD27NRB6Nqtp8f1Vz3h	12884901892	10	10	1	-1	2015-06-08 20:47:12.916561	2015-06-08 20:47:12.916561	30064779264
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
-- Name: index_history_ledgers_on_closed_at; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_history_ledgers_on_closed_at ON history_ledgers USING btree (closed_at);


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
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);





--
-- PostgreSQL database dump complete
--
