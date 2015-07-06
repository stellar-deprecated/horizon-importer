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
12884905984	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5
12884910080	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz
12884914176	guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc
12884918272	gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
12884905984	12884905984	0	0	{"starting_balance": 1000000000}
0	12884905984	1	3	{"amount": 1000000000, "currency_type": "native"}
12884910080	12884910080	0	0	{"starting_balance": 1000000000}
0	12884910080	1	3	{"amount": 1000000000, "currency_type": "native"}
12884914176	12884914176	0	0	{"starting_balance": 1000000000}
0	12884914176	1	3	{"amount": 1000000000, "currency_type": "native"}
12884918272	12884918272	0	0	{"starting_balance": 1000000000}
0	12884918272	1	3	{"amount": 1000000000, "currency_type": "native"}
12884905984	21474840576	0	2	{"amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc"}
12884914176	21474840576	1	3	{"amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc"}
12884910080	21474844672	0	2	{"amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8"}
12884918272	21474844672	1	3	{"amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	\N	0	0	1970-01-01 00:00:00	2015-07-01 23:20:34.699493	2015-07-01 23:20:34.699493	4294967296
2	157b0a06ff8db3edf26fe1c56768ecf1c9576670bb9fa88d74c5b9e4eea36aab	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0	0	2015-07-01 23:20:32	2015-07-01 23:20:34.709799	2015-07-01 23:20:34.709799	8589934592
3	22f4d0850e9465042688e755c718fef9199c54d736fca941b6cd188d2d1bbbb3	157b0a06ff8db3edf26fe1c56768ecf1c9576670bb9fa88d74c5b9e4eea36aab	4	4	2015-07-01 23:20:33	2015-07-01 23:20:34.71906	2015-07-01 23:20:34.71906	12884901888
4	2f2317cb35e042b573828ae4daf8553436892795ff0014a08eb6f82529642484	22f4d0850e9465042688e755c718fef9199c54d736fca941b6cd188d2d1bbbb3	4	4	2015-07-01 23:20:34	2015-07-01 23:20:34.8004	2015-07-01 23:20:34.8004	17179869184
5	bee1bf3b017887c3045a3e86e84902a1113201c7545da3aa3e467a2dc6f4f72d	2f2317cb35e042b573828ae4daf8553436892795ff0014a08eb6f82529642484	2	2	2015-07-01 23:20:35	2015-07-01 23:20:34.84253	2015-07-01 23:20:34.84253	21474836480
6	4c75184d950f6dbc16246434023da3a290bfa23177d3e8c5ffb96793751fc60e	bee1bf3b017887c3045a3e86e84902a1113201c7545da3aa3e467a2dc6f4f72d	3	3	2015-07-01 23:20:36	2015-07-01 23:20:34.881238	2015-07-01 23:20:34.881238	25769803776
7	f35d1fda0154393747d2480887c00238964c52c9a8a730f6ec703465f3489fac	4c75184d950f6dbc16246434023da3a290bfa23177d3e8c5ffb96793751fc60e	2	2	2015-07-01 23:20:37	2015-07-01 23:20:34.918216	2015-07-01 23:20:34.918216	30064771072
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
150	12884905984	0
151	12884905984	12884905984
152	12884910080	0
153	12884910080	12884910080
154	12884914176	0
155	12884914176	12884914176
156	12884918272	0
157	12884918272	12884918272
158	17179873280	12884905984
159	17179877376	12884910080
160	17179881472	12884905984
161	17179885568	12884910080
162	21474840576	12884905984
163	21474840576	12884914176
164	21474844672	12884910080
165	21474844672	12884918272
166	25769807872	12884910080
167	25769811968	12884910080
168	25769816064	12884910080
169	30064775168	12884905984
170	30064779264	12884905984
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 170, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
12884905984	12884905984	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5", "starting_balance": 1000000000}
12884910080	12884910080	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz", "starting_balance": 1000000000}
12884914176	12884914176	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc", "starting_balance": 1000000000}
12884918272	12884918272	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8", "starting_balance": 1000000000}
17179873280	17179873280	0	6	{"limit": 9223372036854775807, "trustee": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc", "trustor": "gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc"}
17179877376	17179877376	0	6	{"limit": 9223372036854775807, "trustee": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc", "trustor": "gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc"}
17179881472	17179881472	0	6	{"limit": 9223372036854775807, "trustee": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8", "trustor": "gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8"}
17179885568	17179885568	0	6	{"limit": 9223372036854775807, "trustee": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8", "trustor": "gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8"}
21474840576	21474840576	0	1	{"to": "gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5", "from": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc", "amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc"}
21474844672	21474844672	0	1	{"to": "gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz", "from": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8", "amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8"}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 1000000000, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 9, "n": 10}, "amount": 1111111111, "offer_id": 0}
25769816064	25769816064	0	3	{"price": {"d": 4, "n": 5}, "amount": 1250000000, "offer_id": 0}
30064775168	30064775168	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
30064779264	30064779264	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
131	e0b50f2c637f5a8042ea52207eba411d639813653fa73b5a664bfa9e65d0f959	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	2015-07-01 23:20:34.723877	2015-07-01 23:20:34.723877
132	e0b50f2c637f5a8042ea52207eba411d639813653fa73b5a664bfa9e65d0f959	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:34.724957	2015-07-01 23:20:34.724957
133	3003fdb4e6d33d7d60446c742613fb421f3348b141f3417499d67f7bc320ffd3	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.741839	2015-07-01 23:20:34.741839
134	3003fdb4e6d33d7d60446c742613fb421f3348b141f3417499d67f7bc320ffd3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:34.742868	2015-07-01 23:20:34.742868
135	c89578ac4f4714bdddf70166d1a8eb24a61f19512a721e4c46ec434747fd408b	guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc	2015-07-01 23:20:34.759309	2015-07-01 23:20:34.759309
136	c89578ac4f4714bdddf70166d1a8eb24a61f19512a721e4c46ec434747fd408b	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:34.760346	2015-07-01 23:20:34.760346
137	2aac3384729a5d6c89ced7d05a25ee464046e25fa8011f4064c13ff7c5217135	gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8	2015-07-01 23:20:34.777347	2015-07-01 23:20:34.777347
138	2aac3384729a5d6c89ced7d05a25ee464046e25fa8011f4064c13ff7c5217135	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:34.77844	2015-07-01 23:20:34.77844
139	8a6c3b80797c22a4a20507a0d5cb3a22149ba8cce24f29afef7484e7803a37d4	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	2015-07-01 23:20:34.80517	2015-07-01 23:20:34.80517
140	81a7ec7a837c10874b9dbba3fb658b3dcd5cb49b4fa365cb3b7645f105fc485c	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.813216	2015-07-01 23:20:34.813216
141	e69b094a0852f6415899b31b09ab176414be9b658b018f92459c4f44fe9041ec	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	2015-07-01 23:20:34.820889	2015-07-01 23:20:34.820889
142	0d91515524f1a7e701d1813f3ab058c9131a77c77b3a165e3ff08c6294f87a3a	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.828933	2015-07-01 23:20:34.828933
143	59b5bcd7f0e1c6a2b9484d27977694eca575925d81e1962068b83689e15f5af2	guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc	2015-07-01 23:20:34.847098	2015-07-01 23:20:34.847098
144	690fefb8f2f61f601d39a409ab1b535d2ef5570ed98b1087872e9ecfb3d7d469	gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8	2015-07-01 23:20:34.863011	2015-07-01 23:20:34.863011
145	803ba9bcea8be1ac5303e210d5ae4f8af4b3b7bd1e602d0745b819c77221c569	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.885446	2015-07-01 23:20:34.885446
146	7d0e657af6b00c48e7901b9cee6a3ed4bafeafe7799e14895f5a1f702eccc729	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.892293	2015-07-01 23:20:34.892293
147	406e1025072e445d21916dad3254d16644fa11661b986ecaa3534ba23580fbae	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	2015-07-01 23:20:34.906135	2015-07-01 23:20:34.906135
148	8d14597334ac74213458fdd202209f851855ea4f1100def992a7fbc73f057d82	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	2015-07-01 23:20:34.92257	2015-07-01 23:20:34.92257
149	c9f3bc75b4ae92825f9cfd901e8409c37d6770c0f49643fbbf95fd0f7186f1d9	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	2015-07-01 23:20:34.930824	2015-07-01 23:20:34.930824
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 149, true);


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
e0b50f2c637f5a8042ea52207eba411d639813653fa73b5a664bfa9e65d0f959	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-01 23:20:34.721958	2015-07-01 23:20:34.721958	12884905984
3003fdb4e6d33d7d60446c742613fb421f3348b141f3417499d67f7bc320ffd3	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-01 23:20:34.7402	2015-07-01 23:20:34.7402	12884910080
c89578ac4f4714bdddf70166d1a8eb24a61f19512a721e4c46ec434747fd408b	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-01 23:20:34.757602	2015-07-01 23:20:34.757602	12884914176
2aac3384729a5d6c89ced7d05a25ee464046e25fa8011f4064c13ff7c5217135	3	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-07-01 23:20:34.775524	2015-07-01 23:20:34.775524	12884918272
8a6c3b80797c22a4a20507a0d5cb3a22149ba8cce24f29afef7484e7803a37d4	4	1	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	12884901889	10	10	1	-1	2015-07-01 23:20:34.803437	2015-07-01 23:20:34.803437	17179873280
81a7ec7a837c10874b9dbba3fb658b3dcd5cb49b4fa365cb3b7645f105fc485c	4	2	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	12884901889	10	10	1	-1	2015-07-01 23:20:34.811663	2015-07-01 23:20:34.811663	17179877376
e69b094a0852f6415899b31b09ab176414be9b658b018f92459c4f44fe9041ec	4	3	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	12884901890	10	10	1	-1	2015-07-01 23:20:34.819387	2015-07-01 23:20:34.819387	17179881472
0d91515524f1a7e701d1813f3ab058c9131a77c77b3a165e3ff08c6294f87a3a	4	4	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	12884901890	10	10	1	-1	2015-07-01 23:20:34.827453	2015-07-01 23:20:34.827453	17179885568
59b5bcd7f0e1c6a2b9484d27977694eca575925d81e1962068b83689e15f5af2	5	1	guQVuXAArvGzHurJvvsdc3CSgTnXMJ6DcqnbmLXywJMGgGrvNc	12884901889	10	10	1	-1	2015-07-01 23:20:34.845476	2015-07-01 23:20:34.845476	21474840576
690fefb8f2f61f601d39a409ab1b535d2ef5570ed98b1087872e9ecfb3d7d469	5	2	gM74v3srgRFsb8BQqpq6w99gZJ3oeTDaFSGJNPaLR2KwvkvVd8	12884901889	10	10	1	-1	2015-07-01 23:20:34.861498	2015-07-01 23:20:34.861498	21474844672
803ba9bcea8be1ac5303e210d5ae4f8af4b3b7bd1e602d0745b819c77221c569	6	1	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	12884901891	10	10	1	-1	2015-07-01 23:20:34.883907	2015-07-01 23:20:34.883907	25769807872
7d0e657af6b00c48e7901b9cee6a3ed4bafeafe7799e14895f5a1f702eccc729	6	2	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	12884901892	10	10	1	-1	2015-07-01 23:20:34.890871	2015-07-01 23:20:34.890871	25769811968
406e1025072e445d21916dad3254d16644fa11661b986ecaa3534ba23580fbae	6	3	gaxsaRawWD2ka1uBtpgGWz9GC8QcHWQksryKxzBgJsYLmdrLjz	12884901893	10	10	1	-1	2015-07-01 23:20:34.897604	2015-07-01 23:20:34.897604	25769816064
8d14597334ac74213458fdd202209f851855ea4f1100def992a7fbc73f057d82	7	1	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	12884901891	10	10	1	-1	2015-07-01 23:20:34.920925	2015-07-01 23:20:34.920925	30064775168
c9f3bc75b4ae92825f9cfd901e8409c37d6770c0f49643fbbf95fd0f7186f1d9	7	2	gsuP9iwXwFGAhArH2U2izVt93DVqnLDCNV6S4oPVtvHQy84xjF5	12884901892	10	10	1	-1	2015-07-01 23:20:34.929159	2015-07-01 23:20:34.929159	30064779264
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

