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
    result_code_s character varying(255) NOT NULL,
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
12884905984	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ
12884910080	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU
12884914176	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR
12884918272	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	\N	0	0	1970-01-01 00:00:00	2015-06-04 21:17:56.659379	2015-06-04 21:17:56.659379	4294967296
2	f2bad86d76baa9d3394b797f2ae92a5b20d76a317944fdedc68843e92d853bb3	41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	0	0	2015-06-04 21:17:54	2015-06-04 21:17:56.668497	2015-06-04 21:17:56.668497	8589934592
3	a412518e9066d1fe9fae4c0ee08088fd356f2a96b2a50ba6f2684a6674c0f5f1	f2bad86d76baa9d3394b797f2ae92a5b20d76a317944fdedc68843e92d853bb3	0	0	2015-06-04 21:17:55	2015-06-04 21:17:56.677326	2015-06-04 21:17:56.677326	12884901888
4	49652708de8af028bdb46c4534a9cbc6a8b8cd0852688b25e725a7bbd410db64	a412518e9066d1fe9fae4c0ee08088fd356f2a96b2a50ba6f2684a6674c0f5f1	0	0	2015-06-04 21:17:56	2015-06-04 21:17:56.736005	2015-06-04 21:17:56.736005	17179869184
5	3c988c9bd0e6bffe9983119da11018d476e6d7e549a0414accf0def8553970fe	49652708de8af028bdb46c4534a9cbc6a8b8cd0852688b25e725a7bbd410db64	0	0	2015-06-04 21:17:57	2015-06-04 21:17:56.77519	2015-06-04 21:17:56.77519	21474836480
6	8d01ae4344af06ae04d1c3485d91942dbee0c9e7d32a87e24b5907a8dbdaed1e	3c988c9bd0e6bffe9983119da11018d476e6d7e549a0414accf0def8553970fe	0	0	2015-06-04 21:17:58	2015-06-04 21:17:56.799661	2015-06-04 21:17:56.799661	25769803776
7	18e66798224d66b175e5ce41a272432f62e1a4d1e1c942e4fd0743e6a9b4e56f	8d01ae4344af06ae04d1c3485d91942dbee0c9e7d32a87e24b5907a8dbdaed1e	0	0	2015-06-04 21:17:59	2015-06-04 21:17:56.827238	2015-06-04 21:17:56.827238	30064771072
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
108	12884905984	0
109	12884905984	12884905984
110	12884910080	0
111	12884910080	12884910080
112	12884914176	0
113	12884914176	12884914176
114	12884918272	0
115	12884918272	12884918272
116	17179873280	12884905984
117	17179877376	12884910080
118	17179881472	12884910080
119	17179885568	12884905984
120	21474840576	12884910080
121	21474840576	12884918272
122	21474844672	12884905984
123	21474844672	12884914176
124	25769807872	12884910080
125	25769811968	12884910080
126	25769816064	12884910080
127	30064775168	12884905984
128	30064779264	12884905984
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 128, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
12884905984	12884905984	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ", "starting_balance"=>"1000000000"
12884910080	12884910080	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU", "starting_balance"=>"1000000000"
12884914176	12884914176	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR", "starting_balance"=>"1000000000"
12884918272	12884918272	0	0	"funder"=>"gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account"=>"ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg", "starting_balance"=>"1000000000"
17179873280	17179873280	0	5	\N
17179877376	17179877376	0	5	\N
17179881472	17179881472	0	5	\N
17179885568	17179885568	0	5	\N
21474840576	21474840576	0	1	"to"=>"gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU", "from"=>"ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg", "amount"=>"5000000000", "currency_code"=>"EUR", "currency_type"=>"alphanum", "currency_issuer"=>"ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg"
21474844672	21474844672	0	1	"to"=>"ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ", "from"=>"ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR", "amount"=>"5000000000", "currency_code"=>"USD", "currency_type"=>"alphanum", "currency_issuer"=>"ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR"
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
94	d7a53c5962376f23969e39fba12f391fea511e1c29cf4ebc6633fff4416a8fe0	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	2015-06-04 21:17:56.682449	2015-06-04 21:17:56.682449
95	d7a53c5962376f23969e39fba12f391fea511e1c29cf4ebc6633fff4416a8fe0	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-04 21:17:56.68379	2015-06-04 21:17:56.68379
96	1c25bcf4aa6bc6fe325d19fce7710722cccf1ca9bde4b42125e44b495cf128dc	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.696117	2015-06-04 21:17:56.696117
97	1c25bcf4aa6bc6fe325d19fce7710722cccf1ca9bde4b42125e44b495cf128dc	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-04 21:17:56.697093	2015-06-04 21:17:56.697093
98	fff99c8c12fe7c305ac3cf80df69878154821dde49b0d6d78e511bbe05dbfd41	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	2015-06-04 21:17:56.708269	2015-06-04 21:17:56.708269
99	fff99c8c12fe7c305ac3cf80df69878154821dde49b0d6d78e511bbe05dbfd41	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-04 21:17:56.709236	2015-06-04 21:17:56.709236
100	c504015cb1200aafa438dfe10344242f7f2570a81f02afe66b9694c2f4c4f516	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	2015-06-04 21:17:56.719325	2015-06-04 21:17:56.719325
101	c504015cb1200aafa438dfe10344242f7f2570a81f02afe66b9694c2f4c4f516	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-04 21:17:56.720494	2015-06-04 21:17:56.720494
102	f07830552abb8105e9986bf4abc3feee45b57eefa2344a39314b2e13e76e715c	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	2015-06-04 21:17:56.740293	2015-06-04 21:17:56.740293
103	1b5676b60f59d7a4264794d43ce26474e937b4084a4751f4a99f9ff14eee952a	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.747497	2015-06-04 21:17:56.747497
104	ab1c216a6a1d8d7ae9637e1ef7fe3da4d10f5249345b1d7c52e9cc79bfe127cb	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.754527	2015-06-04 21:17:56.754527
105	e04a4722935b30d8045dd898b315d53564043aa93199d8bce65b1c7e45b32583	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	2015-06-04 21:17:56.762441	2015-06-04 21:17:56.762441
106	292139b79c3aaf676895c677df44e3e69dadc06ce83e23a62bd3e5db08caeb12	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	2015-06-04 21:17:56.779912	2015-06-04 21:17:56.779912
107	8cc5980baba280e0feb3c178f6795b1e4c5c42d72bc73d8cbb405088c3bc01b9	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	2015-06-04 21:17:56.787878	2015-06-04 21:17:56.787878
108	69551ad850ca8522869261933d55b397ee7d38587fb3c2bb4823831d526cc1a9	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.80358	2015-06-04 21:17:56.80358
109	4743ad3107855da78b59a1cdf8e9b86477d6af6c5d81ba8ecafa2ab1b92d8122	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.80964	2015-06-04 21:17:56.80964
110	cb29e9218a75c79ece3322675d3b5f10a61b43f5e1bbd4539052c33961311a80	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2015-06-04 21:17:56.815936	2015-06-04 21:17:56.815936
111	e3cd450c7c0a030b5e3f6f86b1f7e5271b598283ad525821984540acc03cf88c	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	2015-06-04 21:17:56.831525	2015-06-04 21:17:56.831525
112	b88ae11c1adbf8e5fa657bfb3a50a5c1d25c069d503ea815fe26a338f0140a9b	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	2015-06-04 21:17:56.838135	2015-06-04 21:17:56.838135
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 112, true);


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
d7a53c5962376f23969e39fba12f391fea511e1c29cf4ebc6633fff4416a8fe0	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-06-04 21:17:56.680497	2015-06-04 21:17:56.680497	12884905984
1c25bcf4aa6bc6fe325d19fce7710722cccf1ca9bde4b42125e44b495cf128dc	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-06-04 21:17:56.694478	2015-06-04 21:17:56.694478	12884910080
fff99c8c12fe7c305ac3cf80df69878154821dde49b0d6d78e511bbe05dbfd41	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-06-04 21:17:56.706624	2015-06-04 21:17:56.706624	12884914176
c504015cb1200aafa438dfe10344242f7f2570a81f02afe66b9694c2f4c4f516	3	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-06-04 21:17:56.717799	2015-06-04 21:17:56.717799	12884918272
f07830552abb8105e9986bf4abc3feee45b57eefa2344a39314b2e13e76e715c	4	1	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	12884901889	10	10	1	-1	2015-06-04 21:17:56.73892	2015-06-04 21:17:56.73892	17179873280
1b5676b60f59d7a4264794d43ce26474e937b4084a4751f4a99f9ff14eee952a	4	2	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	12884901889	10	10	1	-1	2015-06-04 21:17:56.746114	2015-06-04 21:17:56.746114	17179877376
ab1c216a6a1d8d7ae9637e1ef7fe3da4d10f5249345b1d7c52e9cc79bfe127cb	4	3	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	12884901890	10	10	1	-1	2015-06-04 21:17:56.753046	2015-06-04 21:17:56.753046	17179881472
e04a4722935b30d8045dd898b315d53564043aa93199d8bce65b1c7e45b32583	4	4	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	12884901890	10	10	1	-1	2015-06-04 21:17:56.760427	2015-06-04 21:17:56.760427	17179885568
292139b79c3aaf676895c677df44e3e69dadc06ce83e23a62bd3e5db08caeb12	5	1	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	12884901889	10	10	1	-1	2015-06-04 21:17:56.778301	2015-06-04 21:17:56.778301	21474840576
8cc5980baba280e0feb3c178f6795b1e4c5c42d72bc73d8cbb405088c3bc01b9	5	2	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	12884901889	10	10	1	-1	2015-06-04 21:17:56.786675	2015-06-04 21:17:56.786675	21474844672
69551ad850ca8522869261933d55b397ee7d38587fb3c2bb4823831d526cc1a9	6	1	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	12884901891	10	10	1	-1	2015-06-04 21:17:56.802318	2015-06-04 21:17:56.802318	25769807872
4743ad3107855da78b59a1cdf8e9b86477d6af6c5d81ba8ecafa2ab1b92d8122	6	2	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	12884901892	10	10	1	-1	2015-06-04 21:17:56.808368	2015-06-04 21:17:56.808368	25769811968
cb29e9218a75c79ece3322675d3b5f10a61b43f5e1bbd4539052c33961311a80	6	3	gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	12884901893	10	10	1	-1	2015-06-04 21:17:56.8147	2015-06-04 21:17:56.8147	25769816064
e3cd450c7c0a030b5e3f6f86b1f7e5271b598283ad525821984540acc03cf88c	7	1	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	12884901891	10	10	1	-1	2015-06-04 21:17:56.830057	2015-06-04 21:17:56.830057	30064775168
b88ae11c1adbf8e5fa657bfb3a50a5c1d25c069d503ea815fe26a338f0140a9b	7	2	ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	12884901892	10	10	1	-1	2015-06-04 21:17:56.836704	2015-06-04 21:17:56.836704	30064779264
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
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nullstyle;
GRANT ALL ON SCHEMA public TO nullstyle;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

