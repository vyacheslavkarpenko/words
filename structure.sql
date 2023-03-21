SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET default_tablespace = '';

--
-- Name: account_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_flags (
    id integer NOT NULL,
    account_id character varying(24),
    flag_id integer,
    enabled boolean,
    visible boolean,
    options public.hstore
);


--
-- Name: account_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_flags_id_seq OWNED BY public.account_flags.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_authentication_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_authentication_methods (
    id integer NOT NULL,
    user_id character varying NOT NULL,
    identifier character varying NOT NULL,
    source character varying NOT NULL
);


--
-- Name: custom_authentication_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_authentication_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_authentication_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_authentication_methods_id_seq OWNED BY public.custom_authentication_methods.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    account_id character varying(24),
    event_type character varying,
    subject_type character varying,
    subject_id character varying(24),
    object_type character varying,
    object_id character varying(24),
    message character varying,
    payload public.hstore,
    created_at timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flags (
    id integer NOT NULL,
    name character varying NOT NULL,
    enabled boolean DEFAULT false,
    visible boolean DEFAULT false,
    options public.hstore DEFAULT ''::public.hstore NOT NULL
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flags_id_seq OWNED BY public.flags.id;


--
-- Name: item_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_views (
    id integer NOT NULL,
    item_id character varying(24),
    account_id character varying(24),
    "time" integer
);


--
-- Name: item_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_views_id_seq OWNED BY public.item_views.id;


--
-- Name: offline_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_migrations (
    id integer NOT NULL,
    name character varying NOT NULL,
    class_name character varying NOT NULL,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    result_file_url text
);


--
-- Name: offline_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offline_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offline_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offline_migrations_id_seq OWNED BY public.offline_migrations.id;


--
-- Name: revision_timeline_position_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revision_timeline_position_seq
    START WITH 3000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revisions (
    id character varying(24) NOT NULL,
    account_id character varying(24),
    creator_guid character varying,
    delta character varying(1),
    ent_type character varying,
    entity_id character varying(24),
    entity_type character varying,
    parent_id character varying(24),
    revision_type character varying,
    timeline_position bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_settings (
    feature character varying NOT NULL,
    active boolean DEFAULT false,
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    public boolean DEFAULT false
);


--
-- Name: user_changed_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_changed_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_flags (
    id integer NOT NULL,
    user_id character varying(24),
    flag_id integer,
    enabled boolean,
    visible boolean,
    options public.hstore
);


--
-- Name: user_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_flags_id_seq OWNED BY public.user_flags.id;


--
-- Name: account_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_flags ALTER COLUMN id SET DEFAULT nextval('public.account_flags_id_seq'::regclass);


--
-- Name: custom_authentication_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_authentication_methods ALTER COLUMN id SET DEFAULT nextval('public.custom_authentication_methods_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags ALTER COLUMN id SET DEFAULT nextval('public.flags_id_seq'::regclass);


--
-- Name: item_views id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_views ALTER COLUMN id SET DEFAULT nextval('public.item_views_id_seq'::regclass);


--
-- Name: offline_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_migrations ALTER COLUMN id SET DEFAULT nextval('public.offline_migrations_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: user_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_flags ALTER COLUMN id SET DEFAULT nextval('public.user_flags_id_seq'::regclass);


--
-- Name: account_flags account_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_flags
    ADD CONSTRAINT account_flags_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: custom_authentication_methods custom_authentication_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_authentication_methods
    ADD CONSTRAINT custom_authentication_methods_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: flags flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: item_views item_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_views
    ADD CONSTRAINT item_views_pkey PRIMARY KEY (id);


--
-- Name: offline_migrations offline_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_migrations
    ADD CONSTRAINT offline_migrations_pkey PRIMARY KEY (id);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (feature);


--
-- Name: user_flags user_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_flags
    ADD CONSTRAINT user_flags_pkey PRIMARY KEY (id);


--
-- Name: index_account_flags_on_account_id_and_flag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_account_flags_on_account_id_and_flag_id ON public.account_flags USING btree (account_id, flag_id);


--
-- Name: index_custom_authentication_methods_on_identifier_and_source; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_custom_authentication_methods_on_identifier_and_source ON public.custom_authentication_methods USING btree (identifier, source);


--
-- Name: index_custom_authentication_methods_on_user_id_and_source; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_custom_authentication_methods_on_user_id_and_source ON public.custom_authentication_methods USING btree (user_id, source);


--
-- Name: index_events_on_account_id_event_type_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_account_id_event_type_created_at ON public.events USING btree (account_id, event_type, created_at);


--
-- Name: index_events_on_subject_id_subject_type_object_id_object_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_subject_id_subject_type_object_id_object_type ON public.events USING btree (subject_id, subject_type, object_id, object_type);


--
-- Name: index_flags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flags_on_name ON public.flags USING btree (name);


--
-- Name: index_item_views_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_views_on_account_id ON public.item_views USING btree (account_id);


--
-- Name: index_item_views_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_views_on_item_id ON public.item_views USING btree (item_id);


--
-- Name: index_revisions_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_deleted_at ON public.revisions USING btree (deleted_at);


--
-- Name: index_revisions_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revisions_on_id ON public.revisions USING btree (id);


--
-- Name: index_revisions_on_timeline_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_timeline_position ON public.revisions USING btree (timeline_position);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_system_settings_on_feature; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_system_settings_on_feature ON public.system_settings USING btree (feature);


--
-- Name: index_user_flags_on_user_id_and_flag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_flags_on_user_id_and_flag_id ON public.user_flags USING btree (user_id, flag_id);


--
-- Name: revisions_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX revisions_index ON public.revisions USING btree (account_id, entity_id, parent_id, creator_guid);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20140909195201'),
('20140922215328'),
('20141006134415'),
('20141017142302'),
('20150605090205'),
('20150608095753'),
('20150618192329'),
('20150618192531'),
('20150803062444'),
('20150804063935'),
('20151103202529'),
('20151201075404'),
('20151224154346'),
('20160105183640'),
('20160222075545'),
('20160315184246'),
('20160503150612'),
('20160503155828'),
('20160616105155'),
('20160630092546'),
('20160630133943'),
('20160712115828'),
('20160724210358'),
('20170404154350'),
('20171201093607'),
('20180216093018'),
('20180320093929'),
('20180618071659'),
('20180802123135'),
('20181008075438'),
('20181114160805'),
('20181119112904'),
('20181217112612'),
('20190206100920'),
('20190325145151'),
('20190612100616'),
('20190616094004'),
('20190621080153'),
('20190814055109'),
('20190820072545'),
('20190925092250'),
('20200416080542'),
('20201111155108'),
('20220801130341');


