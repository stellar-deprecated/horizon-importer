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
0	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ
8589938688	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU
8589942784	GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 10000000000}
0	8589938688	1	3	{"amount": 10000000000, "asset_type": "native"}
8589942784	8589942784	0	0	{"starting_balance": 10000000000}
0	8589942784	1	3	{"amount": 10000000000, "asset_type": "native"}
8589938688	12884905984	0	6	{}
8589938688	17179873280	0	6	{}
8589938688	21474840576	0	6	{}
8589938688	25769807872	0	4	{"low_threshold": 0, "med_threshold": 2, "high_threshold": 2}
8589938688	25769807872	1	6	{}
8589938688	30064775168	0	5	{"home_domain": "nullstyle.com"}
8589938688	30064775168	1	6	{}
8589938688	34359742464	0	6	{}
8589938688	38654709760	0	6	{}
8589938688	42949677056	0	6	{}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-08-24 20:29:16.145891	2015-08-24 20:29:16.145891	4294967296
2	62eafce79bc38e2f47546b9778b241bc7760fd466e515fb4ef261d30498469d2	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	2	2	2015-08-24 20:29:14	2015-08-24 20:29:16.17869	2015-08-24 20:29:16.17869	8589934592
3	f5c1d4eaf16168e075d99bb5b40bfed5c481ff52746df0cb19fa1a5fada555c8	62eafce79bc38e2f47546b9778b241bc7760fd466e515fb4ef261d30498469d2	1	1	2015-08-24 20:29:15	2015-08-24 20:29:16.245164	2015-08-24 20:29:16.245164	12884901888
4	8c228ece0ad7614b43b18d72f5a591326538d934608fcbfd939363665e8bf81d	f5c1d4eaf16168e075d99bb5b40bfed5c481ff52746df0cb19fa1a5fada555c8	1	1	2015-08-24 20:29:16	2015-08-24 20:29:16.26403	2015-08-24 20:29:16.26403	17179869184
5	6864f1ce8965b4d449e1c752231990707979a01d26c40e045e5bc619ee0a3d2e	8c228ece0ad7614b43b18d72f5a591326538d934608fcbfd939363665e8bf81d	1	1	2015-08-24 20:29:17	2015-08-24 20:29:16.282428	2015-08-24 20:29:16.282428	21474836480
6	dcf55c8a9183e7055615bdcb039c3468bfd7dc00cb678bee3efc3bbb62852b5d	6864f1ce8965b4d449e1c752231990707979a01d26c40e045e5bc619ee0a3d2e	1	1	2015-08-24 20:29:18	2015-08-24 20:29:16.301513	2015-08-24 20:29:16.301513	25769803776
7	ed48fb9bbc3b3675abdbfc0688b1a7e33537cce75d468c38342f5b82f2cbfe19	dcf55c8a9183e7055615bdcb039c3468bfd7dc00cb678bee3efc3bbb62852b5d	1	1	2015-08-24 20:29:19	2015-08-24 20:29:16.323163	2015-08-24 20:29:16.323163	30064771072
8	9f65e94346af478418fbdbcd6e6e09f7cec26445701e4ded0db0b29c1da6125f	ed48fb9bbc3b3675abdbfc0688b1a7e33537cce75d468c38342f5b82f2cbfe19	1	1	2015-08-24 20:29:20	2015-08-24 20:29:16.344712	2015-08-24 20:29:16.344712	34359738368
9	7214e0fc6e42602b57eb948759909f4ff13c48c6d3eca95b08b9594d940c921e	9f65e94346af478418fbdbcd6e6e09f7cec26445701e4ded0db0b29c1da6125f	1	1	2015-08-24 20:29:21	2015-08-24 20:29:16.363435	2015-08-24 20:29:16.363435	38654705664
10	5190ed2555e6b94499f75a37a9ad75ef30978d355d15b786f2213d84ab6c9680	7214e0fc6e42602b57eb948759909f4ff13c48c6d3eca95b08b9594d940c921e	1	1	2015-08-24 20:29:22	2015-08-24 20:29:16.381753	2015-08-24 20:29:16.381753	42949672960
11	5b78d2d205b2b256f6d40084283c819d83d3fa58790a77a01d87b8109d9a5fdf	5190ed2555e6b94499f75a37a9ad75ef30978d355d15b786f2213d84ab6c9680	0	0	2015-08-24 20:29:23	2015-08-24 20:29:16.40077	2015-08-24 20:29:16.40077	47244640256
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
37	8589938688	0
38	8589938688	8589938688
39	8589942784	0
40	8589942784	8589942784
41	12884905984	8589938688
42	17179873280	8589938688
43	21474840576	8589938688
44	25769807872	8589938688
45	30064775168	8589938688
46	34359742464	8589938688
47	38654709760	8589938688
48	42949677056	8589938688
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 48, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU", "starting_balance": 10000000000}
8589942784	8589942784	0	0	{"funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ", "account": "GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2", "starting_balance": 10000000000}
12884905984	12884905984	0	5	{"inflation_dest": "GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2"}
17179873280	17179873280	0	5	{"set_flags": [1], "set_flags_s": ["auth_required_flag"]}
21474840576	21474840576	0	5	{"master_key_weight": 2}
25769807872	25769807872	0	5	{"low_threshold": 0, "med_threshold": 2, "high_threshold": 2}
30064775168	30064775168	0	5	{"home_domain": "nullstyle.com"}
34359742464	34359742464	0	5	{"signer_key": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "signer_weight": 1}
38654709760	38654709760	0	5	{"clear_flags": [1], "clear_flags_s": ["auth_required_flag"]}
42949677056	42949677056	0	5	{"signer_key": "GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4", "signer_weight": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
37	e8b5ece25598a5cc3ed7ad4eb4a0c3d83b8f207643f503958cebff1e2bcf36cc	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 20:29:16.192984	2015-08-24 20:29:16.192984
38	e8b5ece25598a5cc3ed7ad4eb4a0c3d83b8f207643f503958cebff1e2bcf36cc	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.194351	2015-08-24 20:29:16.194351
39	16daa941a3ea7697601aa52b18ab472fe7aa5d47dcd4eef6c813b3da4a5fe272	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2015-08-24 20:29:16.223439	2015-08-24 20:29:16.223439
40	16daa941a3ea7697601aa52b18ab472fe7aa5d47dcd4eef6c813b3da4a5fe272	GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	2015-08-24 20:29:16.224357	2015-08-24 20:29:16.224357
41	1a373c4fc81ea76295284db8f77be2fbb8f66cf506d471ab25f003090ae00244	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.24939	2015-08-24 20:29:16.24939
42	798a22f61a78bd3df18338881dbeba4ade082bf651951cdabecb41bce4bca7a6	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.268229	2015-08-24 20:29:16.268229
43	1178a3144af427044f19c7e5b9d64d3f05ae92f2734c7ce54b05f979622187ac	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.286769	2015-08-24 20:29:16.286769
44	4454d7b1a46b1784c0104f2154ab065aa7b8f3e134d83ca704131df58b0a9c02	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.305864	2015-08-24 20:29:16.305864
45	bf067d5a30a36d113d358921c1f325bbc93375ca9a02d838c8593f095139e5a8	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.32772	2015-08-24 20:29:16.32772
46	e011466896dec6497cf1562550d4f14e2723eadd5578c520d0d88a52406c6b28	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.349177	2015-08-24 20:29:16.349177
47	4c9b9540b9c2ed594ba84f9a2a8271ae010eb46345e9841cb8304cc70bde12d6	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.367818	2015-08-24 20:29:16.367818
48	bf31e32f1e58e13780869c4f0411f8c72a0dab820c5809ee26a903c51ca8ada9	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	2015-08-24 20:29:16.386363	2015-08-24 20:29:16.386363
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 48, true);


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
e8b5ece25598a5cc3ed7ad4eb4a0c3d83b8f207643f503958cebff1e2bcf36cc	2	1	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	1	10	10	1	-1	2015-08-24 20:29:16.187817	2015-08-24 20:29:16.187817	8589938688
16daa941a3ea7697601aa52b18ab472fe7aa5d47dcd4eef6c813b3da4a5fe272	2	2	GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	2	10	10	1	-1	2015-08-24 20:29:16.221617	2015-08-24 20:29:16.221617	8589942784
1a373c4fc81ea76295284db8f77be2fbb8f66cf506d471ab25f003090ae00244	3	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934593	10	10	1	-1	2015-08-24 20:29:16.247845	2015-08-24 20:29:16.247845	12884905984
798a22f61a78bd3df18338881dbeba4ade082bf651951cdabecb41bce4bca7a6	4	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934594	10	10	1	-1	2015-08-24 20:29:16.266657	2015-08-24 20:29:16.266657	17179873280
1178a3144af427044f19c7e5b9d64d3f05ae92f2734c7ce54b05f979622187ac	5	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934595	10	10	1	-1	2015-08-24 20:29:16.285186	2015-08-24 20:29:16.285186	21474840576
4454d7b1a46b1784c0104f2154ab065aa7b8f3e134d83ca704131df58b0a9c02	6	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934596	10	10	1	-1	2015-08-24 20:29:16.304266	2015-08-24 20:29:16.304266	25769807872
bf067d5a30a36d113d358921c1f325bbc93375ca9a02d838c8593f095139e5a8	7	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934597	10	10	1	-1	2015-08-24 20:29:16.326055	2015-08-24 20:29:16.326055	30064775168
e011466896dec6497cf1562550d4f14e2723eadd5578c520d0d88a52406c6b28	8	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934598	10	10	1	-1	2015-08-24 20:29:16.347495	2015-08-24 20:29:16.347495	34359742464
4c9b9540b9c2ed594ba84f9a2a8271ae010eb46345e9841cb8304cc70bde12d6	9	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934599	10	10	1	-1	2015-08-24 20:29:16.366139	2015-08-24 20:29:16.366139	38654709760
bf31e32f1e58e13780869c4f0411f8c72a0dab820c5809ee26a903c51ca8ada9	10	1	GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	8589934600	10	10	1	-1	2015-08-24 20:29:16.38472	2015-08-24 20:29:16.38472	42949677056
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

