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
8589938688	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ
8589942784	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ
8589946880	GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE
8589950976	GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y
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
8589938688	17179873280	0	2	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE"}
8589946880	17179873280	1	3	{"amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE"}
8589942784	17179877376	0	2	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y"}
8589950976	17179877376	1	3	{"amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-07-24 18:39:23.350538	2015-07-24 18:39:23.350538	4294967296
2	58d6c7399c974311f111139120384969d7a5e19ddc3b69b0ab4025b9cc351d91	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	4	4	2015-07-24 18:39:21	2015-07-24 18:39:23.360517	2015-07-24 18:39:23.360517	8589934592
3	efd638262799551cc518af96bfd04f2ae9dd0f3fe3f0e80f69dadcdb2849ba38	58d6c7399c974311f111139120384969d7a5e19ddc3b69b0ab4025b9cc351d91	4	4	2015-07-24 18:39:22	2015-07-24 18:39:23.454619	2015-07-24 18:39:23.454619	12884901888
4	4dcd7ceceeb4abd234c5d449d0df6116725685b0fb90996c3365c98801accaf3	efd638262799551cc518af96bfd04f2ae9dd0f3fe3f0e80f69dadcdb2849ba38	2	2	2015-07-24 18:39:23	2015-07-24 18:39:23.505115	2015-07-24 18:39:23.505115	17179869184
5	06cb2e88f6166b3a1ecd3faf60e63769da56d4d6b9c54ebb20a5b79a0fa6116b	4dcd7ceceeb4abd234c5d449d0df6116725685b0fb90996c3365c98801accaf3	3	3	2015-07-24 18:39:24	2015-07-24 18:39:23.546303	2015-07-24 18:39:23.546303	21474836480
6	ba1cb2f82a232b0779288c0c02a5b148165b7fda0ede3ac098366b0c6e82123a	06cb2e88f6166b3a1ecd3faf60e63769da56d4d6b9c54ebb20a5b79a0fa6116b	2	2	2015-07-24 18:39:25	2015-07-24 18:39:23.581204	2015-07-24 18:39:23.581204	25769803776
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
164	12884905984	8589942784
165	12884910080	8589938688
166	12884914176	8589942784
167	12884918272	8589938688
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
8589938688	8589938688	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ", "starting_balance": 1000000000}
8589942784	8589942784	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ", "starting_balance": 1000000000}
8589946880	8589946880	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE", "starting_balance": 1000000000}
8589950976	8589950976	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y", "starting_balance": 1000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE", "trustor": "GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE", "trustor": "GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ", "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y", "trustor": "GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y", "trustor": "GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ", "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y"}
17179873280	17179873280	0	1	{"to": "GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ", "from": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE", "amount": 5000000000, "asset_code": "USD", "asset_type": "credit_alphanum4", "asset_issuer": "GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE"}
17179877376	17179877376	0	1	{"to": "GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ", "from": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y", "amount": 5000000000, "asset_code": "EUR", "asset_type": "credit_alphanum4", "asset_issuer": "GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 1000000000, "offer_id": 0}
21474844672	21474844672	0	3	{"price": {"d": 9, "n": 10}, "amount": 1111111111, "offer_id": 0}
21474848768	21474848768	0	3	{"price": {"d": 4, "n": 5}, "amount": 1250000000, "offer_id": 0}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
224	715a1e4272b09b060dac43d59866c44594df24ff660513e35350e58bd52da476	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.366038	2015-07-24 18:39:23.366038
225	715a1e4272b09b060dac43d59866c44594df24ff660513e35350e58bd52da476	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.367967	2015-07-24 18:39:23.367967
226	715a1e4272b09b060dac43d59866c44594df24ff660513e35350e58bd52da476	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.369198	2015-07-24 18:39:23.369198
227	02629530e08d219cfee35cae406baedf09dc438e345f2006eb893813baf8e349	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.388637	2015-07-24 18:39:23.388637
228	02629530e08d219cfee35cae406baedf09dc438e345f2006eb893813baf8e349	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.389668	2015-07-24 18:39:23.389668
229	02629530e08d219cfee35cae406baedf09dc438e345f2006eb893813baf8e349	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.390568	2015-07-24 18:39:23.390568
230	8112af325193a73f59a464f6d5dfa761ebe2c74d685c8e3ea54c67875457307f	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.406947	2015-07-24 18:39:23.406947
231	8112af325193a73f59a464f6d5dfa761ebe2c74d685c8e3ea54c67875457307f	GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE	2015-07-24 18:39:23.407978	2015-07-24 18:39:23.407978
232	8112af325193a73f59a464f6d5dfa761ebe2c74d685c8e3ea54c67875457307f	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.408889	2015-07-24 18:39:23.408889
233	9d8e207b76664359e5d7485d943ed3280153eec4c6bdd3028d4e6814ba244a9a	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.430788	2015-07-24 18:39:23.430788
234	9d8e207b76664359e5d7485d943ed3280153eec4c6bdd3028d4e6814ba244a9a	GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y	2015-07-24 18:39:23.432199	2015-07-24 18:39:23.432199
235	9d8e207b76664359e5d7485d943ed3280153eec4c6bdd3028d4e6814ba244a9a	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-07-24 18:39:23.433398	2015-07-24 18:39:23.433398
236	116963f43359f846ec6c43a32f3152b9c4121f786b082dca17601b66b95d12f7	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.459367	2015-07-24 18:39:23.459367
237	116963f43359f846ec6c43a32f3152b9c4121f786b082dca17601b66b95d12f7	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.460321	2015-07-24 18:39:23.460321
238	0b461e29d80dc058af51ed1fb140f7f1c650db73d23d3f205a2ee0cf00e511c8	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.470076	2015-07-24 18:39:23.470076
239	0b461e29d80dc058af51ed1fb140f7f1c650db73d23d3f205a2ee0cf00e511c8	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.471742	2015-07-24 18:39:23.471742
240	d486a59f3be946abc0af292e26e0d442d9050b827245cefa8c06bde2a5d29875	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.481644	2015-07-24 18:39:23.481644
241	d486a59f3be946abc0af292e26e0d442d9050b827245cefa8c06bde2a5d29875	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.482685	2015-07-24 18:39:23.482685
242	37af3d917aeafd22d8c875a483b028116e560e80c8770b3bdced918a26ec3fa2	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.491312	2015-07-24 18:39:23.491312
243	37af3d917aeafd22d8c875a483b028116e560e80c8770b3bdced918a26ec3fa2	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.492244	2015-07-24 18:39:23.492244
244	255694b1598948645b1b3bb2279ee0fdac3ea05997fbf54620d00841695a41c6	GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE	2015-07-24 18:39:23.50952	2015-07-24 18:39:23.50952
245	a87bb6e0dc0d4b85c5143eb1bff3142989f7d2d33d3c73f72943da4eb8ad38de	GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y	2015-07-24 18:39:23.526585	2015-07-24 18:39:23.526585
246	92d0ce190413a77a47ac9ec5eb0b13adfc92af68cb18acba03e4f7f13001c44a	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.551014	2015-07-24 18:39:23.551014
247	92d0ce190413a77a47ac9ec5eb0b13adfc92af68cb18acba03e4f7f13001c44a	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.552012	2015-07-24 18:39:23.552012
248	5415bed0ae5eb38fda546cfd84f93c4b8f1f77531f0e27c76d3756532f856705	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.559635	2015-07-24 18:39:23.559635
249	5415bed0ae5eb38fda546cfd84f93c4b8f1f77531f0e27c76d3756532f856705	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.560593	2015-07-24 18:39:23.560593
250	78f7a4809772964cab7093129ae09fe899e8d488edbb6140165cc0c9f8dbb1d8	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.568006	2015-07-24 18:39:23.568006
251	78f7a4809772964cab7093129ae09fe899e8d488edbb6140165cc0c9f8dbb1d8	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	2015-07-24 18:39:23.56908	2015-07-24 18:39:23.56908
252	b49302986cc6bcd1404dca76bd040dc40e4ba31a99e0f10205a6c070b2527dd9	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.58597	2015-07-24 18:39:23.58597
253	863c9664a756f946f883e322bcda266a93b64cea8c4660fa3ec7265ee5a757eb	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.593539	2015-07-24 18:39:23.593539
254	863c9664a756f946f883e322bcda266a93b64cea8c4660fa3ec7265ee5a757eb	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	2015-07-24 18:39:23.594606	2015-07-24 18:39:23.594606
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 254, true);


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
715a1e4272b09b060dac43d59866c44594df24ff660513e35350e58bd52da476	2	1	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	1	10	10	1	-1	2015-07-24 18:39:23.363631	2015-07-24 18:39:23.363631	8589938688
02629530e08d219cfee35cae406baedf09dc438e345f2006eb893813baf8e349	2	2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2	10	10	1	-1	2015-07-24 18:39:23.38661	2015-07-24 18:39:23.38661	8589942784
8112af325193a73f59a464f6d5dfa761ebe2c74d685c8e3ea54c67875457307f	2	3	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	3	10	10	1	-1	2015-07-24 18:39:23.404982	2015-07-24 18:39:23.404982	8589946880
9d8e207b76664359e5d7485d943ed3280153eec4c6bdd3028d4e6814ba244a9a	2	4	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	4	10	10	1	-1	2015-07-24 18:39:23.428405	2015-07-24 18:39:23.428405	8589950976
116963f43359f846ec6c43a32f3152b9c4121f786b082dca17601b66b95d12f7	3	1	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	8589934593	10	10	1	-1	2015-07-24 18:39:23.457418	2015-07-24 18:39:23.457418	12884905984
0b461e29d80dc058af51ed1fb140f7f1c650db73d23d3f205a2ee0cf00e511c8	3	2	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	8589934593	10	10	1	-1	2015-07-24 18:39:23.467001	2015-07-24 18:39:23.467001	12884910080
d486a59f3be946abc0af292e26e0d442d9050b827245cefa8c06bde2a5d29875	3	3	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	8589934594	10	10	1	-1	2015-07-24 18:39:23.479535	2015-07-24 18:39:23.479535	12884914176
37af3d917aeafd22d8c875a483b028116e560e80c8770b3bdced918a26ec3fa2	3	4	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	8589934594	10	10	1	-1	2015-07-24 18:39:23.489393	2015-07-24 18:39:23.489393	12884918272
255694b1598948645b1b3bb2279ee0fdac3ea05997fbf54620d00841695a41c6	4	1	GAWL2SYOSRZUPZ7IDBTVGK5NGHTPD53SV7ABF6SO27GUFRSUX2U5NTJE	8589934593	10	10	1	-1	2015-07-24 18:39:23.507809	2015-07-24 18:39:23.507809	17179873280
a87bb6e0dc0d4b85c5143eb1bff3142989f7d2d33d3c73f72943da4eb8ad38de	4	2	GDPD6G5PQE4K54IBPNQHDH3YXTJV37E4QKP5LOEUK33KRA75TMPMBK3Y	8589934593	10	10	1	-1	2015-07-24 18:39:23.524654	2015-07-24 18:39:23.524654	17179877376
92d0ce190413a77a47ac9ec5eb0b13adfc92af68cb18acba03e4f7f13001c44a	5	1	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	8589934595	10	10	1	-1	2015-07-24 18:39:23.549134	2015-07-24 18:39:23.549134	21474840576
5415bed0ae5eb38fda546cfd84f93c4b8f1f77531f0e27c76d3756532f856705	5	2	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	8589934596	10	10	1	-1	2015-07-24 18:39:23.557876	2015-07-24 18:39:23.557876	21474844672
78f7a4809772964cab7093129ae09fe899e8d488edbb6140165cc0c9f8dbb1d8	5	3	GBZ7HXZJEJPJQ4E33RYZEJW6UHURU3O5TOR7FGM6NNUC763S5IVG4PXJ	8589934597	10	10	1	-1	2015-07-24 18:39:23.56627	2015-07-24 18:39:23.56627	21474848768
b49302986cc6bcd1404dca76bd040dc40e4ba31a99e0f10205a6c070b2527dd9	6	1	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	8589934595	10	10	1	-1	2015-07-24 18:39:23.584074	2015-07-24 18:39:23.584074	25769807872
863c9664a756f946f883e322bcda266a93b64cea8c4660fa3ec7265ee5a757eb	6	2	GDROVMEX4WARVPHRU7AKZTIAP4E5CMFOKCKLFOSGVMBRSYFWD7EW7SBJ	8589934596	10	10	1	-1	2015-07-24 18:39:23.59186	2015-07-24 18:39:23.59186	25769811968
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

