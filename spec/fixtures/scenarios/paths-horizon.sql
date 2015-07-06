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
12884905984	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn
12884910080	g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e
12884914176	gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41
12884918272	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
12884910080	21474840576	0	2	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474840576	1	3	{"amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474844672	0	2	{"amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474844672	1	3	{"amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474848768	0	2	{"amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474848768	1	3	{"amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474852864	0	2	{"amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474852864	1	3	{"amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474856960	0	2	{"amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474856960	1	3	{"amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474861056	0	2	{"amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474861056	1	3	{"amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474865152	0	2	{"amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474865152	1	3	{"amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884918272	21474869248	0	2	{"amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	21474869248	1	3	{"amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
12884905984	12884905984	0	0	{"starting_balance": 10000000000}
0	12884905984	1	3	{"amount": 10000000000, "currency_type": "native"}
12884910080	12884910080	0	0	{"starting_balance": 10000000000}
0	12884910080	1	3	{"amount": 10000000000, "currency_type": "native"}
12884914176	12884914176	0	0	{"starting_balance": 10000000000}
0	12884914176	1	3	{"amount": 10000000000, "currency_type": "native"}
12884918272	12884918272	0	0	{"starting_balance": 10000000000}
0	12884918272	1	3	{"amount": 10000000000, "currency_type": "native"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	\N	0	0	1970-01-01 00:00:00	2015-07-01 23:20:25.40172	2015-07-01 23:20:25.40172	4294967296
2	c0c9df658a141195f2df9ed21a25380ccf92badfe48c4b7b3e8e7d21c1544c3f	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0	0	2015-07-01 23:20:22	2015-07-01 23:20:25.411859	2015-07-01 23:20:25.411859	8589934592
3	835ec356c3b6f70e641b357b2e3125a68e8d63917c39d015fd501321f68c537b	c0c9df658a141195f2df9ed21a25380ccf92badfe48c4b7b3e8e7d21c1544c3f	4	4	2015-07-01 23:20:23	2015-07-01 23:20:25.421753	2015-07-01 23:20:25.421753	12884901888
4	a21e183fd8b044eb6d7f32f4c634bbf7e4a5ff94c1d2db9efb225ab1b07e4e68	835ec356c3b6f70e641b357b2e3125a68e8d63917c39d015fd501321f68c537b	10	10	2015-07-01 23:20:24	2015-07-01 23:20:25.508449	2015-07-01 23:20:25.508449	17179869184
5	ec9cc598ffd3f4f6ba13bf6dfc42800186e24dc3a84735d5032cf6fe05ed0dcc	a21e183fd8b044eb6d7f32f4c634bbf7e4a5ff94c1d2db9efb225ab1b07e4e68	8	8	2015-07-01 23:20:25	2015-07-01 23:20:25.609224	2015-07-01 23:20:25.609224	21474836480
6	55837c42c2be9dd6feef81d8ca4ab7032840c4568b2c56feb023aef63f66a80b	ec9cc598ffd3f4f6ba13bf6dfc42800186e24dc3a84735d5032cf6fe05ed0dcc	10	10	2015-07-01 23:20:26	2015-07-01 23:20:25.760697	2015-07-01 23:20:25.760697	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
111	17179906048	12884918272
112	17179910144	12884918272
113	21474840576	12884905984
114	21474840576	12884910080
115	21474844672	12884905984
116	21474844672	12884918272
117	21474848768	12884905984
118	21474848768	12884918272
119	21474852864	12884905984
120	21474852864	12884918272
121	21474856960	12884905984
122	21474856960	12884918272
123	21474861056	12884905984
124	21474861056	12884918272
125	21474865152	12884905984
126	21474865152	12884918272
127	21474869248	12884905984
128	21474869248	12884918272
129	25769807872	12884918272
130	25769811968	12884918272
131	25769816064	12884918272
132	25769820160	12884918272
133	25769824256	12884918272
134	25769828352	12884918272
135	25769832448	12884918272
136	25769836544	12884918272
137	25769840640	12884918272
138	25769844736	12884918272
95	12884905984	0
96	12884905984	12884905984
97	12884910080	0
98	12884910080	12884910080
99	12884914176	0
100	12884914176	12884914176
101	12884918272	0
102	12884918272	12884918272
103	17179873280	12884918272
104	17179877376	12884910080
105	17179881472	12884914176
106	17179885568	12884918272
107	17179889664	12884918272
108	17179893760	12884918272
109	17179897856	12884918272
110	17179901952	12884918272
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 138, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
21474856960	21474856960	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474861056	21474861056	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474865152	21474865152	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474869248	21474869248	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 10, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 1}, "amount": 20, "offer_id": 0}
25769816064	25769816064	0	3	{"price": {"d": 1, "n": 1}, "amount": 20, "offer_id": 0}
25769820160	25769820160	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
25769824256	25769824256	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
25769828352	25769828352	0	3	{"price": {"d": 1, "n": 1}, "amount": 30, "offer_id": 0}
25769832448	25769832448	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
25769836544	25769836544	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
25769840640	25769840640	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
25769844736	25769844736	0	3	{"price": {"d": 1, "n": 1}, "amount": 40, "offer_id": 0}
12884905984	12884905984	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "starting_balance": 10000000000}
12884910080	12884910080	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e", "starting_balance": 10000000000}
12884914176	12884914176	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41", "starting_balance": 10000000000}
12884918272	12884918272	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "starting_balance": 10000000000}
17179873280	17179873280	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179877376	17179877376	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179881472	17179881472	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179885568	17179885568	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179889664	17179889664	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179893760	17179893760	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179897856	17179897856	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179901952	17179901952	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179906048	17179906048	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
17179910144	17179910144	0	6	{"limit": 9223372036854775807, "trustee": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "trustor": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474840576	21474840576	0	1	{"to": "g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474844672	21474844672	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474848768	21474848768	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
21474852864	21474852864	0	1	{"to": "gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa", "from": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn", "amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn"}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
102	556c827c93b28e89a646fee61a9058571b7b5205e9ad5f99e035c703e08a8a84	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.614199	2015-07-01 23:20:25.614199
103	315a8f6be9649c8ce42205c2cdaf675dd11767a33a19f161d4fd76df86da6b83	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.630499	2015-07-01 23:20:25.630499
104	208937c32be6da97d73da0d6ce11767415aa0e1093aa8c73bd9a172815557c7f	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.646826	2015-07-01 23:20:25.646826
105	012ade991fe738dac4d524f913fcd925619de8fb5073cedb23962e369315ce29	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.665682	2015-07-01 23:20:25.665682
106	57a3f18d7f49389366a5edf2a6a930f95df4b651681bfd551ce023c64abaab1c	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.682937	2015-07-01 23:20:25.682937
107	ae337f74457ca9d2375e3eb38ac0bf5fa6f89a82e41708fd6b25906178ba02ea	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.697919	2015-07-01 23:20:25.697919
108	c5da93996dbf0c1d3f8e0b33ae18f9ba0eb01c00ad5921b2330e8cbd777d4e37	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.714065	2015-07-01 23:20:25.714065
109	6994d8d3e10b08364136118b99d9bc0bd0d56efa6e7b758ab49f3d510a37f73e	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.736699	2015-07-01 23:20:25.736699
110	e254419d1ffedd9afbd1db91a219fdcbff375b04515f942baee8f40d85af209e	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.76589	2015-07-01 23:20:25.76589
111	fda3121593b39aa4273791fbb8e13b62a9653780abceb4eed95016540b756d39	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.775071	2015-07-01 23:20:25.775071
112	bd95b76f8c560039ef4940b752b66c3410c757621b16b09463f53e659493591b	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.783484	2015-07-01 23:20:25.783484
113	9ff663d6c10e3138717e744536135b01829b79674eaa87b062bdcb1509c9be53	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.790719	2015-07-01 23:20:25.790719
114	238f0419d20c0c30177ba1a72d78d1f58d3cca4ed0cd8f4ba7047993424c3708	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.798104	2015-07-01 23:20:25.798104
115	2e5b428e2138afdca80bdbac054e3d0a2c843b3797d1f980acd00026af638a3e	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.806934	2015-07-01 23:20:25.806934
116	bd4b08e05d21a2c803fa1f8cb82bcf326574b6dc9bb8bd34576ba990803f446d	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.816374	2015-07-01 23:20:25.816374
117	3adca7921f1c3de5637557f560a204e86d94d20f35586be79ce88af5714d903e	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.825329	2015-07-01 23:20:25.825329
118	1d8d84bfea8a376128264558522c2090d22faaa49a574e6a15349a2a19077e2a	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.833172	2015-07-01 23:20:25.833172
119	f111bfcaf5d1657dfbc4b7120e50dc70002ce231860d20ab81f0a61279a3d605	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.840275	2015-07-01 23:20:25.840275
84	ee950550e353e92b49e0df0b232afa2054658c60e5e4b5fc51cd6fe98a7d5b12	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	2015-07-01 23:20:25.427128	2015-07-01 23:20:25.427128
85	ee950550e353e92b49e0df0b232afa2054658c60e5e4b5fc51cd6fe98a7d5b12	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:25.428242	2015-07-01 23:20:25.428242
86	dce3d72f0312f86c27e4d56c48d58f6aa6a0515e0a899e4c5974e95376dc0556	g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e	2015-07-01 23:20:25.446121	2015-07-01 23:20:25.446121
87	dce3d72f0312f86c27e4d56c48d58f6aa6a0515e0a899e4c5974e95376dc0556	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:25.447218	2015-07-01 23:20:25.447218
88	84f5d5bfd9104e817bb36d5ae6258968cd6508bc31676cc5968476b4cbd78056	gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41	2015-07-01 23:20:25.465822	2015-07-01 23:20:25.465822
89	84f5d5bfd9104e817bb36d5ae6258968cd6508bc31676cc5968476b4cbd78056	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:25.466934	2015-07-01 23:20:25.466934
90	3c99b935d962fc673256b05a67f46c0918dc4eeb39000daeb52261be4e1b0a32	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.484244	2015-07-01 23:20:25.484244
91	3c99b935d962fc673256b05a67f46c0918dc4eeb39000daeb52261be4e1b0a32	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-01 23:20:25.485334	2015-07-01 23:20:25.485334
92	177f95aa5af1bc5f18c9e5006b6157079713c2bcb98f617bd2106c726cf862e8	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.513272	2015-07-01 23:20:25.513272
93	a6233d334848ef9ebdc4059a813c5d3fd55354bf3b63e7f4c699dc6891872016	g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e	2015-07-01 23:20:25.521793	2015-07-01 23:20:25.521793
94	5b32841986587466c948f944b104ee5637511ea241d693346d23ca1bc658fe3d	gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41	2015-07-01 23:20:25.530863	2015-07-01 23:20:25.530863
95	299163167925d70d44b2632dfaaec8b6368646aeccfd0f7115007e1b035bdc2e	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.539045	2015-07-01 23:20:25.539045
96	0f83a2eb879c9fe3934aae2b4773d0e66d0e1291b1168643cf36e99e2f4fcd8b	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.546913	2015-07-01 23:20:25.546913
97	79ea531295a5f04d37cf6e3393de246b65ba21e979f47bff7a56b06d73912583	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.556246	2015-07-01 23:20:25.556246
98	cffb771bdc887e31cc6303e3f178ebebf58204b200dd82d9de705257090589f1	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.565101	2015-07-01 23:20:25.565101
99	6ce990ec2e483e381335d23b0806d9b003e4121df6d1260f5f7a105e75fe5f93	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.573941	2015-07-01 23:20:25.573941
100	ff62ab38df8decf97f0af415ab85464ecee9de0806e35833d665276378d6617e	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.58361	2015-07-01 23:20:25.58361
101	a473c295e0fc3483f753c74c7b467f0db7b8fd7450f3eda013b4d8907fe7000b	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	2015-07-01 23:20:25.593178	2015-07-01 23:20:25.593178
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 119, true);


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
208937c32be6da97d73da0d6ce11767415aa0e1093aa8c73bd9a172815557c7f	5	3	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901891	10	10	1	-1	2015-07-01 23:20:25.644872	2015-07-01 23:20:25.644872	21474848768
012ade991fe738dac4d524f913fcd925619de8fb5073cedb23962e369315ce29	5	4	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901892	10	10	1	-1	2015-07-01 23:20:25.663723	2015-07-01 23:20:25.663723	21474852864
57a3f18d7f49389366a5edf2a6a930f95df4b651681bfd551ce023c64abaab1c	5	5	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901893	10	10	1	-1	2015-07-01 23:20:25.68134	2015-07-01 23:20:25.68134	21474856960
ae337f74457ca9d2375e3eb38ac0bf5fa6f89a82e41708fd6b25906178ba02ea	5	6	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901894	10	10	1	-1	2015-07-01 23:20:25.696103	2015-07-01 23:20:25.696103	21474861056
c5da93996dbf0c1d3f8e0b33ae18f9ba0eb01c00ad5921b2330e8cbd777d4e37	5	7	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901895	10	10	1	-1	2015-07-01 23:20:25.712394	2015-07-01 23:20:25.712394	21474865152
6994d8d3e10b08364136118b99d9bc0bd0d56efa6e7b758ab49f3d510a37f73e	5	8	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901896	10	10	1	-1	2015-07-01 23:20:25.735106	2015-07-01 23:20:25.735106	21474869248
e254419d1ffedd9afbd1db91a219fdcbff375b04515f942baee8f40d85af209e	6	1	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901897	10	10	1	-1	2015-07-01 23:20:25.763996	2015-07-01 23:20:25.763996	25769807872
fda3121593b39aa4273791fbb8e13b62a9653780abceb4eed95016540b756d39	6	2	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901898	10	10	1	-1	2015-07-01 23:20:25.77306	2015-07-01 23:20:25.77306	25769811968
bd95b76f8c560039ef4940b752b66c3410c757621b16b09463f53e659493591b	6	3	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901899	10	10	1	-1	2015-07-01 23:20:25.781825	2015-07-01 23:20:25.781825	25769816064
9ff663d6c10e3138717e744536135b01829b79674eaa87b062bdcb1509c9be53	6	4	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901900	10	10	1	-1	2015-07-01 23:20:25.789204	2015-07-01 23:20:25.789204	25769820160
238f0419d20c0c30177ba1a72d78d1f58d3cca4ed0cd8f4ba7047993424c3708	6	5	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901901	10	10	1	-1	2015-07-01 23:20:25.79641	2015-07-01 23:20:25.79641	25769824256
2e5b428e2138afdca80bdbac054e3d0a2c843b3797d1f980acd00026af638a3e	6	6	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901902	10	10	1	-1	2015-07-01 23:20:25.804869	2015-07-01 23:20:25.804869	25769828352
bd4b08e05d21a2c803fa1f8cb82bcf326574b6dc9bb8bd34576ba990803f446d	6	7	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901903	10	10	1	-1	2015-07-01 23:20:25.814671	2015-07-01 23:20:25.814671	25769832448
3adca7921f1c3de5637557f560a204e86d94d20f35586be79ce88af5714d903e	6	8	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901904	10	10	1	-1	2015-07-01 23:20:25.823517	2015-07-01 23:20:25.823517	25769836544
1d8d84bfea8a376128264558522c2090d22faaa49a574e6a15349a2a19077e2a	6	9	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901905	10	10	1	-1	2015-07-01 23:20:25.831647	2015-07-01 23:20:25.831647	25769840640
f111bfcaf5d1657dfbc4b7120e50dc70002ce231860d20ab81f0a61279a3d605	6	10	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901906	10	10	1	-1	2015-07-01 23:20:25.838753	2015-07-01 23:20:25.838753	25769844736
ee950550e353e92b49e0df0b232afa2054658c60e5e4b5fc51cd6fe98a7d5b12	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-01 23:20:25.425172	2015-07-01 23:20:25.425172	12884905984
dce3d72f0312f86c27e4d56c48d58f6aa6a0515e0a899e4c5974e95376dc0556	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-01 23:20:25.444217	2015-07-01 23:20:25.444217	12884910080
84f5d5bfd9104e817bb36d5ae6258968cd6508bc31676cc5968476b4cbd78056	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-01 23:20:25.46328	2015-07-01 23:20:25.46328	12884914176
3c99b935d962fc673256b05a67f46c0918dc4eeb39000daeb52261be4e1b0a32	3	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-07-01 23:20:25.482482	2015-07-01 23:20:25.482482	12884918272
177f95aa5af1bc5f18c9e5006b6157079713c2bcb98f617bd2106c726cf862e8	4	1	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901889	10	10	1	-1	2015-07-01 23:20:25.511562	2015-07-01 23:20:25.511562	17179873280
a6233d334848ef9ebdc4059a813c5d3fd55354bf3b63e7f4c699dc6891872016	4	2	g62GvcFEMMiz3ux5Cz6V49WTtQ2KJenahMdXGnt2V4AneQaZ2e	12884901889	10	10	1	-1	2015-07-01 23:20:25.520215	2015-07-01 23:20:25.520215	17179877376
5b32841986587466c948f944b104ee5637511ea241d693346d23ca1bc658fe3d	4	3	gfrDLq9eLCPFqud45zE6bCHNc21wxPfW8AL4YPsa3zVbrzcC41	12884901889	10	10	1	-1	2015-07-01 23:20:25.528986	2015-07-01 23:20:25.528986	17179881472
299163167925d70d44b2632dfaaec8b6368646aeccfd0f7115007e1b035bdc2e	4	4	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901890	10	10	1	-1	2015-07-01 23:20:25.537469	2015-07-01 23:20:25.537469	17179885568
0f83a2eb879c9fe3934aae2b4773d0e66d0e1291b1168643cf36e99e2f4fcd8b	4	5	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901891	10	10	1	-1	2015-07-01 23:20:25.545395	2015-07-01 23:20:25.545395	17179889664
79ea531295a5f04d37cf6e3393de246b65ba21e979f47bff7a56b06d73912583	4	6	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901892	10	10	1	-1	2015-07-01 23:20:25.554506	2015-07-01 23:20:25.554506	17179893760
cffb771bdc887e31cc6303e3f178ebebf58204b200dd82d9de705257090589f1	4	7	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901893	10	10	1	-1	2015-07-01 23:20:25.563408	2015-07-01 23:20:25.563408	17179897856
6ce990ec2e483e381335d23b0806d9b003e4121df6d1260f5f7a105e75fe5f93	4	8	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901894	10	10	1	-1	2015-07-01 23:20:25.572077	2015-07-01 23:20:25.572077	17179901952
ff62ab38df8decf97f0af415ab85464ecee9de0806e35833d665276378d6617e	4	9	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901895	10	10	1	-1	2015-07-01 23:20:25.581605	2015-07-01 23:20:25.581605	17179906048
a473c295e0fc3483f753c74c7b467f0db7b8fd7450f3eda013b4d8907fe7000b	4	10	gsFJG8CkpJZYwp3zLyjnYzbDFD3jogJgSafpzuG6TgxjaXVVVQa	12884901896	10	10	1	-1	2015-07-01 23:20:25.5912	2015-07-01 23:20:25.5912	17179910144
556c827c93b28e89a646fee61a9058571b7b5205e9ad5f99e035c703e08a8a84	5	1	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901889	10	10	1	-1	2015-07-01 23:20:25.612485	2015-07-01 23:20:25.612485	21474840576
315a8f6be9649c8ce42205c2cdaf675dd11767a33a19f161d4fd76df86da6b83	5	2	gcACxiDEUZozNAc5eXKNJZesypjJnD4yd2z2MFhHfJ5SpkBqwn	12884901890	10	10	1	-1	2015-07-01 23:20:25.628804	2015-07-01 23:20:25.628804	21474844672
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

