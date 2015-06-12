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
12884905984	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb
12884910080	gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu
12884914176	gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N
12884918272	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	\N	0	0	1970-01-01 00:00:00	2015-06-11 16:34:32.251135	2015-06-11 16:34:32.251135	4294967296
2	b524791e8226a08bb6fae8f96631d61cbfe617be2fb325475cd614a7f6a24c91	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0	0	2015-06-11 16:34:29	2015-06-11 16:34:32.264965	2015-06-11 16:34:32.264965	8589934592
3	84c80a58a1077e25b04e77d72eca8b06a5c0791562c7b052224afc15b34752b9	b524791e8226a08bb6fae8f96631d61cbfe617be2fb325475cd614a7f6a24c91	0	0	2015-06-11 16:34:30	2015-06-11 16:34:32.276815	2015-06-11 16:34:32.276815	12884901888
4	72f492587d995e9f0bb9a8c7aa051586801b82b727287a66db45b99753599122	84c80a58a1077e25b04e77d72eca8b06a5c0791562c7b052224afc15b34752b9	0	0	2015-06-11 16:34:31	2015-06-11 16:34:32.409892	2015-06-11 16:34:32.409892	17179869184
5	aadfd9a86ebdf3fb660dce229d290c495d28b8cb1cfc98fc295a85a0acd64ab3	72f492587d995e9f0bb9a8c7aa051586801b82b727287a66db45b99753599122	0	0	2015-06-11 16:34:32	2015-06-11 16:34:32.492182	2015-06-11 16:34:32.492182	21474836480
6	8d23b9d784221e40bc3ca557f12cf5ce17b3fa81a5e70562a0588505ad2b45e7	aadfd9a86ebdf3fb660dce229d290c495d28b8cb1cfc98fc295a85a0acd64ab3	0	0	2015-06-11 16:34:33	2015-06-11 16:34:32.579005	2015-06-11 16:34:32.579005	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
231	12884905984	0
232	12884905984	12884905984
233	12884910080	0
234	12884910080	12884910080
235	12884914176	0
236	12884914176	12884914176
237	12884918272	0
238	12884918272	12884918272
239	17179873280	12884918272
240	17179877376	12884910080
241	17179881472	12884914176
242	17179885568	12884918272
243	17179889664	12884918272
244	17179893760	12884918272
245	17179897856	12884918272
246	17179901952	12884918272
247	17179906048	12884918272
248	17179910144	12884918272
249	21474840576	12884905984
250	21474840576	12884910080
251	21474844672	12884905984
252	21474844672	12884918272
253	21474848768	12884905984
254	21474848768	12884918272
255	21474852864	12884905984
256	21474852864	12884918272
257	21474856960	12884905984
258	21474856960	12884918272
259	21474861056	12884905984
260	21474861056	12884918272
261	21474865152	12884905984
262	21474865152	12884918272
263	21474869248	12884905984
264	21474869248	12884918272
265	25769807872	12884918272
266	25769811968	12884918272
267	25769816064	12884918272
268	25769820160	12884918272
269	25769824256	12884918272
270	25769828352	12884918272
271	25769832448	12884918272
272	25769836544	12884918272
273	25769840640	12884918272
274	25769844736	12884918272
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 274, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
12884905984	12884905984	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "starting_balance": 10000000000}
12884910080	12884910080	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu", "starting_balance": 10000000000}
12884914176	12884914176	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N", "starting_balance": 10000000000}
12884918272	12884918272	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "starting_balance": 10000000000}
17179873280	17179873280	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179877376	17179877376	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179881472	17179881472	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179885568	17179885568	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179889664	17179889664	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179893760	17179893760	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179897856	17179897856	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179901952	17179901952	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179906048	17179906048	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
17179910144	17179910144	0	6	{"limit": 9223372036854775807, "trustee": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "trustor": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474840576	21474840576	0	1	{"to": "gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474844672	21474844672	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474848768	21474848768	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "1", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474852864	21474852864	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "21", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474856960	21474856960	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "22", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474861056	21474861056	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "31", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474865152	21474865152	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "32", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
21474869248	21474869248	0	1	{"to": "gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW", "from": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb", "amount": 5000, "currency_code": "33", "currency_type": "alphanum", "currency_issuer": "gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb"}
25769807872	25769807872	0	3	\N
25769811968	25769811968	0	3	\N
25769816064	25769816064	0	3	\N
25769820160	25769820160	0	3	\N
25769824256	25769824256	0	3	\N
25769828352	25769828352	0	3	\N
25769832448	25769832448	0	3	\N
25769836544	25769836544	0	3	\N
25769840640	25769840640	0	3	\N
25769844736	25769844736	0	3	\N
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
462	134a0e4e9bf5f46ecd235adf376c78caa3d8d134a4e3f56d68455ff8a3ce053c	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.295322	2015-06-11 16:34:32.295322
463	134a0e4e9bf5f46ecd235adf376c78caa3d8d134a4e3f56d68455ff8a3ce053c	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-11 16:34:32.298873	2015-06-11 16:34:32.298873
464	80b78d4db2187843bc406e579b9cfa55f44b334c4b46b59885acebb5bb1f4c19	gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu	2015-06-11 16:34:32.368001	2015-06-11 16:34:32.368001
465	80b78d4db2187843bc406e579b9cfa55f44b334c4b46b59885acebb5bb1f4c19	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-11 16:34:32.369598	2015-06-11 16:34:32.369598
466	3c5d62a68430c6c5c0addb2b46f1913e02582fac7541dbfa6609d42e1d2ede83	gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N	2015-06-11 16:34:32.381058	2015-06-11 16:34:32.381058
467	3c5d62a68430c6c5c0addb2b46f1913e02582fac7541dbfa6609d42e1d2ede83	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-11 16:34:32.382322	2015-06-11 16:34:32.382322
468	701d2b4daec74b69717c53389132053295b0174e014c92775303ad1ece2e53b1	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.393389	2015-06-11 16:34:32.393389
469	701d2b4daec74b69717c53389132053295b0174e014c92775303ad1ece2e53b1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-06-11 16:34:32.394509	2015-06-11 16:34:32.394509
470	1eb6a57d072dcabfa06d297c5cd736fdf12bc669fa85ebed0f11fceb4ddf0ae1	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.414593	2015-06-11 16:34:32.414593
471	a6fcfa08f10609eea3ce899c206503fe18010dbceccd4695055ba9ada938cf6d	gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu	2015-06-11 16:34:32.422045	2015-06-11 16:34:32.422045
472	09999bb1ed9b49990146f873d0868a0b7af0493b58f328b82a6341d3257431c8	gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N	2015-06-11 16:34:32.429096	2015-06-11 16:34:32.429096
473	067dd8d6d6e259d51c0b41854bbdd296c91cedb8d2bb83342aa308bbebd4d499	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.436115	2015-06-11 16:34:32.436115
474	b84da8270097b9d00f8a9a2fc4e4434d9694f4a121df1ac1607dc2f4f0c5da86	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.443071	2015-06-11 16:34:32.443071
475	19113182d195406cf9737560a746f143c3bd1afdd1472b36eb03fccb3773b36e	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.450977	2015-06-11 16:34:32.450977
476	0b6d70d4addbb9e587a84e99d218d9f98e88e20a41044313d9ae236747619035	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.458747	2015-06-11 16:34:32.458747
477	14e864a64fa7bacf5f7c001bc9b1df96930c7dc7ba22218cf80bf3f1e5180fba	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.465969	2015-06-11 16:34:32.465969
478	07a8ccddee897dfc80720c6888a196b93f9613e37f47eb8dd1d99d8d81347c81	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.472899	2015-06-11 16:34:32.472899
479	5c605237b717e0e53fbd007641ee6dbdd43c06077cbd36c6f577bc32ac5553ab	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.479879	2015-06-11 16:34:32.479879
480	a7573afa76f774a7546f3212b4b8caa6ee6a608e9041574add231149152bfcad	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.497366	2015-06-11 16:34:32.497366
481	202c53787d22fcc39424fc6b4cb803fde8be0ed1e2e38344332a41fe912ed1e6	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.508065	2015-06-11 16:34:32.508065
482	a325424539a2e13e21ee991139f156ed73ac86c03c1e61cd4a616eb10f207a49	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.519083	2015-06-11 16:34:32.519083
483	8391035dd353651448b17e21fb6c10e7d394a5b37fc89a3e16eba033acc79a0a	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.529472	2015-06-11 16:34:32.529472
484	b3c3a3864fc22cda7460ba0088846953fd765216754d7d8f9928bb3fb6b26e65	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.538707	2015-06-11 16:34:32.538707
485	a070c8f1298dc2bc4781e4a8431ceb428205acd99879aaa07c6cf30051c50c4c	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.548161	2015-06-11 16:34:32.548161
486	1d2399eb61db32d96ed69965a5f6d1eb436f37896d9ae36ecf1f414e6d06e0b9	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.557378	2015-06-11 16:34:32.557378
487	1117cb4f032c3dbad210ef536882a4caa51f3bf11922fdff4ec1fcfa3530286c	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	2015-06-11 16:34:32.565675	2015-06-11 16:34:32.565675
488	aaf947893760b8be679cb19f5e19b0fd4201806ce000b851f74fcd0bd5365a52	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.583782	2015-06-11 16:34:32.583782
489	51d2aa637003115e3d03b7f97538db2a4e24bd6445d9d7895589a44d50a3c2ea	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.590998	2015-06-11 16:34:32.590998
490	ae62f6f04893132a17bf7265882eb9b2b79db958d976b38e768ff71eeea9bc76	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.599836	2015-06-11 16:34:32.599836
491	4da0d5b01a494342d7754be504650be66feb6fa87805387701ea245bb0393c0f	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.607068	2015-06-11 16:34:32.607068
492	856199cd825977224dd744fb4ebb8cd571e406ff5ed4515b03d9885e394f1d51	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.614164	2015-06-11 16:34:32.614164
493	9fd8b715b26d1596534e13389efa4125e40093e12bc68d47e4f3686fbf492dd7	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.622118	2015-06-11 16:34:32.622118
494	4298731edea30b9e6b09c6b709cf8020f9e0136cb1656d781e6bfd3bac5e527a	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.629563	2015-06-11 16:34:32.629563
495	bb013139b5f14065c8294d063a1465b0c7e4ad410b7908d8e8281342281940fd	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.637095	2015-06-11 16:34:32.637095
496	2837a6d0ab2dd177c41e9efb4a9ca757b1b4eed6de98701f2e6acffbb25d9126	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.643711	2015-06-11 16:34:32.643711
497	ed5c89d96b5621002100b06f9341321aa9b0ef679ecb10acc834256276ab5e77	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	2015-06-11 16:34:32.650439	2015-06-11 16:34:32.650439
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 497, true);


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
134a0e4e9bf5f46ecd235adf376c78caa3d8d134a4e3f56d68455ff8a3ce053c	3	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-06-11 16:34:32.287202	2015-06-11 16:34:32.287202	12884905984
80b78d4db2187843bc406e579b9cfa55f44b334c4b46b59885acebb5bb1f4c19	3	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-06-11 16:34:32.365621	2015-06-11 16:34:32.365621	12884910080
3c5d62a68430c6c5c0addb2b46f1913e02582fac7541dbfa6609d42e1d2ede83	3	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-06-11 16:34:32.37917	2015-06-11 16:34:32.37917	12884914176
701d2b4daec74b69717c53389132053295b0174e014c92775303ad1ece2e53b1	3	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-06-11 16:34:32.391585	2015-06-11 16:34:32.391585	12884918272
1eb6a57d072dcabfa06d297c5cd736fdf12bc669fa85ebed0f11fceb4ddf0ae1	4	1	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901889	10	10	1	-1	2015-06-11 16:34:32.413088	2015-06-11 16:34:32.413088	17179873280
a6fcfa08f10609eea3ce899c206503fe18010dbceccd4695055ba9ada938cf6d	4	2	gU6RrUSUcZpQjTWVsSrNDKvW7exzG25U18mHxE9dFRN3akkmgu	12884901889	10	10	1	-1	2015-06-11 16:34:32.42065	2015-06-11 16:34:32.42065	17179877376
09999bb1ed9b49990146f873d0868a0b7af0493b58f328b82a6341d3257431c8	4	3	gsCpJprcAE3mMhVEtmjzMJgiNf3aoQ7SwUpxSGs7YnwJNLVMo3N	12884901889	10	10	1	-1	2015-06-11 16:34:32.427739	2015-06-11 16:34:32.427739	17179881472
067dd8d6d6e259d51c0b41854bbdd296c91cedb8d2bb83342aa308bbebd4d499	4	4	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901890	10	10	1	-1	2015-06-11 16:34:32.434771	2015-06-11 16:34:32.434771	17179885568
b84da8270097b9d00f8a9a2fc4e4434d9694f4a121df1ac1607dc2f4f0c5da86	4	5	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901891	10	10	1	-1	2015-06-11 16:34:32.44173	2015-06-11 16:34:32.44173	17179889664
19113182d195406cf9737560a746f143c3bd1afdd1472b36eb03fccb3773b36e	4	6	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901892	10	10	1	-1	2015-06-11 16:34:32.449086	2015-06-11 16:34:32.449086	17179893760
0b6d70d4addbb9e587a84e99d218d9f98e88e20a41044313d9ae236747619035	4	7	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901893	10	10	1	-1	2015-06-11 16:34:32.457247	2015-06-11 16:34:32.457247	17179897856
14e864a64fa7bacf5f7c001bc9b1df96930c7dc7ba22218cf80bf3f1e5180fba	4	8	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901894	10	10	1	-1	2015-06-11 16:34:32.464401	2015-06-11 16:34:32.464401	17179901952
07a8ccddee897dfc80720c6888a196b93f9613e37f47eb8dd1d99d8d81347c81	4	9	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901895	10	10	1	-1	2015-06-11 16:34:32.471509	2015-06-11 16:34:32.471509	17179906048
5c605237b717e0e53fbd007641ee6dbdd43c06077cbd36c6f577bc32ac5553ab	4	10	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901896	10	10	1	-1	2015-06-11 16:34:32.478551	2015-06-11 16:34:32.478551	17179910144
a7573afa76f774a7546f3212b4b8caa6ee6a608e9041574add231149152bfcad	5	1	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901889	10	10	1	-1	2015-06-11 16:34:32.495581	2015-06-11 16:34:32.495581	21474840576
202c53787d22fcc39424fc6b4cb803fde8be0ed1e2e38344332a41fe912ed1e6	5	2	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901890	10	10	1	-1	2015-06-11 16:34:32.505714	2015-06-11 16:34:32.505714	21474844672
a325424539a2e13e21ee991139f156ed73ac86c03c1e61cd4a616eb10f207a49	5	3	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901891	10	10	1	-1	2015-06-11 16:34:32.517067	2015-06-11 16:34:32.517067	21474848768
8391035dd353651448b17e21fb6c10e7d394a5b37fc89a3e16eba033acc79a0a	5	4	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901892	10	10	1	-1	2015-06-11 16:34:32.527917	2015-06-11 16:34:32.527917	21474852864
b3c3a3864fc22cda7460ba0088846953fd765216754d7d8f9928bb3fb6b26e65	5	5	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901893	10	10	1	-1	2015-06-11 16:34:32.537078	2015-06-11 16:34:32.537078	21474856960
a070c8f1298dc2bc4781e4a8431ceb428205acd99879aaa07c6cf30051c50c4c	5	6	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901894	10	10	1	-1	2015-06-11 16:34:32.546484	2015-06-11 16:34:32.546484	21474861056
1d2399eb61db32d96ed69965a5f6d1eb436f37896d9ae36ecf1f414e6d06e0b9	5	7	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901895	10	10	1	-1	2015-06-11 16:34:32.555789	2015-06-11 16:34:32.555789	21474865152
1117cb4f032c3dbad210ef536882a4caa51f3bf11922fdff4ec1fcfa3530286c	5	8	gCBGKZDTwK1Ywa7o437AXRogQkqAxB5x1Zzs9P8Ek82fL2TEeb	12884901896	10	10	1	-1	2015-06-11 16:34:32.564164	2015-06-11 16:34:32.564164	21474869248
aaf947893760b8be679cb19f5e19b0fd4201806ce000b851f74fcd0bd5365a52	6	1	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901897	10	10	1	-1	2015-06-11 16:34:32.582141	2015-06-11 16:34:32.582141	25769807872
51d2aa637003115e3d03b7f97538db2a4e24bd6445d9d7895589a44d50a3c2ea	6	2	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901898	10	10	1	-1	2015-06-11 16:34:32.589345	2015-06-11 16:34:32.589345	25769811968
ae62f6f04893132a17bf7265882eb9b2b79db958d976b38e768ff71eeea9bc76	6	3	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901899	10	10	1	-1	2015-06-11 16:34:32.59816	2015-06-11 16:34:32.59816	25769816064
4da0d5b01a494342d7754be504650be66feb6fa87805387701ea245bb0393c0f	6	4	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901900	10	10	1	-1	2015-06-11 16:34:32.605407	2015-06-11 16:34:32.605407	25769820160
856199cd825977224dd744fb4ebb8cd571e406ff5ed4515b03d9885e394f1d51	6	5	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901901	10	10	1	-1	2015-06-11 16:34:32.612474	2015-06-11 16:34:32.612474	25769824256
9fd8b715b26d1596534e13389efa4125e40093e12bc68d47e4f3686fbf492dd7	6	6	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901902	10	10	1	-1	2015-06-11 16:34:32.620442	2015-06-11 16:34:32.620442	25769828352
4298731edea30b9e6b09c6b709cf8020f9e0136cb1656d781e6bfd3bac5e527a	6	7	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901903	10	10	1	-1	2015-06-11 16:34:32.627872	2015-06-11 16:34:32.627872	25769832448
bb013139b5f14065c8294d063a1465b0c7e4ad410b7908d8e8281342281940fd	6	8	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901904	10	10	1	-1	2015-06-11 16:34:32.635511	2015-06-11 16:34:32.635511	25769836544
2837a6d0ab2dd177c41e9efb4a9ca757b1b4eed6de98701f2e6acffbb25d9126	6	9	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901905	10	10	1	-1	2015-06-11 16:34:32.642255	2015-06-11 16:34:32.642255	25769840640
ed5c89d96b5621002100b06f9341321aa9b0ef679ecb10acc834256276ab5e77	6	10	gZikHQwScYTTpkcGmjziS8FTf8UxV5sWvFRj8ap3fbwW79KUtW	12884901906	10	10	1	-1	2015-06-11 16:34:32.648981	2015-06-11 16:34:32.648981	25769844736
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20150501160031
20150310224849
20150313225945
20150313225955
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

