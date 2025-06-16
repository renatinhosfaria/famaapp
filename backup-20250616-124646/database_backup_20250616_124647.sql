--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.5

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
-- Name: set_id_construtora(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.set_id_construtora() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Se o tipo de proprietário for Construtora
    IF NEW.tipo_proprietario = 'Construtora' THEN
        -- Busca o id_construtora pelo nome do proprietário
        SELECT c.id_construtora INTO NEW.id_construtora
        FROM imoveis_construtoras c
        WHERE c.nome_construtora = NEW.nome_proprietario;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_id_construtora() OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes_agendamentos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes_agendamentos (
    id integer NOT NULL,
    cliente_id integer,
    user_id integer,
    notes text,
    location text,
    address text,
    broker_id integer,
    type text DEFAULT 'atendimento'::text,
    status text DEFAULT 'agendado'::text,
    title text,
    scheduled_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    assigned_to integer
);


ALTER TABLE public.clientes_agendamentos OWNER TO neondb_owner;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO neondb_owner;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.clientes_agendamentos.id;


--
-- Name: clientes_id_anotacoes; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes_id_anotacoes (
    id integer NOT NULL,
    cliente_id integer,
    user_id integer,
    text text NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.clientes_id_anotacoes OWNER TO neondb_owner;

--
-- Name: cliente_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.cliente_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_notes_id_seq OWNER TO neondb_owner;

--
-- Name: cliente_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.cliente_notes_id_seq OWNED BY public.clientes_id_anotacoes.id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text NOT NULL,
    source text,
    assigned_to integer,
    status text DEFAULT 'Sem Atendimento'::text,
    cpf text,
    broker_id integer,
    haswhatsapp boolean,
    whatsapp_jid text,
    profile_pic_url text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    source_details jsonb,
    preferred_contact text
);


ALTER TABLE public.clientes OWNER TO neondb_owner;

--
-- Name: clientes_vendas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes_vendas (
    id integer NOT NULL,
    cliente_id integer,
    user_id integer,
    value numeric(12,2) NOT NULL,
    notes text,
    updated_at timestamp without time zone,
    sold_at timestamp without time zone,
    created_at timestamp without time zone,
    consultant_id integer,
    broker_id integer,
    cpf text,
    property_type text,
    builder_name text,
    block text,
    unit text,
    payment_method text,
    commission numeric(12,2),
    bonus numeric(12,2),
    total_commission numeric(12,2),
    development_name text,
    assigned_to integer
);


ALTER TABLE public.clientes_vendas OWNER TO neondb_owner;

--
-- Name: COLUMN clientes_vendas.development_name; Type: COMMENT; Schema: public; Owner: neondb_owner
--

COMMENT ON COLUMN public.clientes_vendas.development_name IS 'Nome do empreendimento imobiliário';


--
-- Name: clientes_visitas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes_visitas (
    id integer NOT NULL,
    cliente_id integer,
    user_id integer,
    property_id text NOT NULL,
    notes text,
    visited_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    temperature integer,
    visit_description text,
    next_steps text,
    broker_id integer,
    assigned_to integer
);


ALTER TABLE public.clientes_visitas OWNER TO neondb_owner;

--
-- Name: sistema_facebook_config; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_facebook_config (
    id integer NOT NULL,
    app_id text NOT NULL,
    app_secret text NOT NULL,
    access_token text NOT NULL,
    user_access_token text,
    verification_token text,
    page_id text,
    ad_account_id text,
    webhook_enabled boolean DEFAULT false,
    is_active boolean DEFAULT true,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sistema_facebook_config OWNER TO neondb_owner;

--
-- Name: facebook_config_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.facebook_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facebook_config_id_seq OWNER TO neondb_owner;

--
-- Name: facebook_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.facebook_config_id_seq OWNED BY public.sistema_facebook_config.id;


--
-- Name: imoveis_apartamentos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imoveis_apartamentos (
    id_apartamento integer NOT NULL,
    id_empreendimento integer NOT NULL,
    status_apartamento text,
    area_privativa_apartamento numeric,
    quartos_apartamento integer,
    suites_apartamento integer,
    banheiros_apartamento integer,
    vagas_garagem_apartamento integer,
    tipo_garagem_apartamento text,
    sacada_varanda_apartamento boolean,
    caracteristicas_apartamento text,
    valor_venda_apartamento numeric,
    titulo_descritivo_apartamento text,
    descricao_apartamento text,
    status_publicacao_apartamento text
);


ALTER TABLE public.imoveis_apartamentos OWNER TO neondb_owner;

--
-- Name: imoveis_apartamentos_id_apartamento_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_apartamentos_id_apartamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_apartamentos_id_apartamento_seq OWNER TO neondb_owner;

--
-- Name: imoveis_apartamentos_id_apartamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.imoveis_apartamentos_id_apartamento_seq OWNED BY public.imoveis_apartamentos.id_apartamento;


--
-- Name: imoveis_construtoras; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imoveis_construtoras (
    id_construtora integer NOT NULL,
    nome_construtora text NOT NULL,
    razao_social text,
    cpf_cnpj text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.imoveis_construtoras OWNER TO neondb_owner;

--
-- Name: imoveis_construtoras_id_construtora_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_construtoras_id_construtora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_construtoras_id_construtora_seq OWNER TO neondb_owner;

--
-- Name: imoveis_construtoras_id_construtora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.imoveis_construtoras_id_construtora_seq OWNED BY public.imoveis_construtoras.id_construtora;


--
-- Name: imoveis_construtoras_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_construtoras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_construtoras_id_seq OWNER TO neondb_owner;

--
-- Name: imoveis_contatos_construtora; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imoveis_contatos_construtora (
    id_contato_construtora integer NOT NULL,
    id_construtora integer,
    nome text NOT NULL,
    telefone text NOT NULL,
    email text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.imoveis_contatos_construtora OWNER TO neondb_owner;

--
-- Name: imoveis_contatos_construtora_id_contato_construtora_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_contatos_construtora_id_contato_construtora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_contatos_construtora_id_contato_construtora_seq OWNER TO neondb_owner;

--
-- Name: imoveis_contatos_construtora_id_contato_construtora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.imoveis_contatos_construtora_id_contato_construtora_seq OWNED BY public.imoveis_contatos_construtora.id_contato_construtora;


--
-- Name: imoveis_contatos_construtora_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_contatos_construtora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_contatos_construtora_id_seq OWNER TO neondb_owner;

--
-- Name: imoveis_empreendimentos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imoveis_empreendimentos (
    id_empreendimento integer NOT NULL,
    tipo_proprietario text,
    nome_proprietario text,
    contato_proprietario text,
    telefone_proprietario text,
    tipo_imovel text,
    nome_empreendimento text,
    rua_avenida_empreendimento text,
    numero_empreendimento text,
    complemento_empreendimento text,
    bairro_empreendimento text,
    cidade_empreendimento text,
    estado_empreendimento text,
    cep_empreendimento text,
    bloco_torres_empreendimento text,
    andares_empreendimento text,
    apto_andar_empreendimento text,
    valor_condominio_empreendimento text,
    itens_servicos_empreendimento jsonb,
    itens_lazer_empreendimento jsonb,
    url_foto_capa_empreendimento jsonb,
    url_foto_empreendimento jsonb,
    url_video_empreendimento jsonb,
    data_cadastro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ultima_atualizacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    zona_empreendimento text,
    id_construtora integer,
    prazo_entrega_empreendimento text,
    status text
);


ALTER TABLE public.imoveis_empreendimentos OWNER TO neondb_owner;

--
-- Name: imoveis_empreendimentos_id_empreendimento_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_empreendimentos_id_empreendimento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_empreendimentos_id_empreendimento_seq OWNER TO neondb_owner;

--
-- Name: imoveis_empreendimentos_id_empreendimento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.imoveis_empreendimentos_id_empreendimento_seq OWNED BY public.imoveis_empreendimentos.id_empreendimento;


--
-- Name: imoveis_proprietarios_pf; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imoveis_proprietarios_pf (
    id_proprietario_pf integer NOT NULL,
    nome text NOT NULL,
    telefone text NOT NULL,
    email text,
    cpf text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.imoveis_proprietarios_pf OWNER TO neondb_owner;

--
-- Name: imoveis_proprietarios_pf_id_proprietario_pf_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_proprietarios_pf_id_proprietario_pf_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_proprietarios_pf_id_proprietario_pf_seq OWNER TO neondb_owner;

--
-- Name: imoveis_proprietarios_pf_id_proprietario_pf_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.imoveis_proprietarios_pf_id_proprietario_pf_seq OWNED BY public.imoveis_proprietarios_pf.id_proprietario_pf;


--
-- Name: imoveis_proprietarios_pf_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.imoveis_proprietarios_pf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imoveis_proprietarios_pf_id_seq OWNER TO neondb_owner;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leads_id_seq OWNER TO neondb_owner;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.clientes.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.metrics (
    id integer NOT NULL,
    user_id integer,
    type text NOT NULL,
    value numeric(12,2) NOT NULL,
    period text,
    created_at timestamp without time zone
);


ALTER TABLE public.metrics OWNER TO neondb_owner;

--
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metrics_id_seq OWNER TO neondb_owner;

--
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_id_seq OWNER TO neondb_owner;

--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.clientes_vendas.id;


--
-- Name: sistema_config_automacao_leads; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_config_automacao_leads (
    id integer NOT NULL,
    active boolean DEFAULT true,
    name text NOT NULL,
    distribution_method text DEFAULT 'volume'::text,
    first_contact_sla integer DEFAULT 30,
    warning_percentage integer DEFAULT 75,
    critical_percentage integer DEFAULT 90,
    auto_redistribute boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    rotation_users jsonb DEFAULT '[]'::jsonb,
    by_name boolean DEFAULT true,
    by_phone boolean DEFAULT true,
    by_email boolean DEFAULT true,
    keep_same_consultant boolean DEFAULT true,
    assign_new_consultant boolean DEFAULT false,
    cascade_sla_hours integer DEFAULT 24,
    cascade_user_order jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.sistema_config_automacao_leads OWNER TO neondb_owner;

--
-- Name: sistema_config_automacao_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_config_automacao_leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_config_automacao_leads_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_config_automacao_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_config_automacao_leads_id_seq OWNED BY public.sistema_config_automacao_leads.id;


--
-- Name: sistema_daily_content; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_daily_content (
    id integer NOT NULL,
    image_url text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    active boolean DEFAULT true
);


ALTER TABLE public.sistema_daily_content OWNER TO neondb_owner;

--
-- Name: sistema_daily_content_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_daily_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_daily_content_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_daily_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_daily_content_id_seq OWNED BY public.sistema_daily_content.id;


--
-- Name: sistema_leads; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_leads (
    id integer NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text NOT NULL,
    source text NOT NULL,
    source_details jsonb,
    status text DEFAULT 'Novo Lead'::text,
    assigned_to integer,
    notes text,
    is_recurring boolean DEFAULT false,
    cliente_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tags jsonb DEFAULT '[]'::jsonb,
    last_activity_date timestamp without time zone DEFAULT now(),
    score integer DEFAULT 0,
    interesse text,
    budget text,
    meta_data jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.sistema_leads OWNER TO neondb_owner;

--
-- Name: sistema_leads_cascata; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_leads_cascata (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    lead_id integer,
    user_id integer NOT NULL,
    sequencia integer NOT NULL,
    status text DEFAULT 'Ativo'::text,
    sla_horas integer DEFAULT 24,
    iniciado_em timestamp without time zone DEFAULT now(),
    expira_em timestamp without time zone NOT NULL,
    finalizado_em timestamp without time zone,
    motivo text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sistema_leads_cascata OWNER TO neondb_owner;

--
-- Name: sistema_leads_cascata_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_leads_cascata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_leads_cascata_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_leads_cascata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_leads_cascata_id_seq OWNED BY public.sistema_leads_cascata.id;


--
-- Name: sistema_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_leads_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_leads_id_seq OWNED BY public.sistema_leads.id;


--
-- Name: sistema_metas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_metas (
    id integer NOT NULL,
    user_id integer NOT NULL,
    periodo text DEFAULT 'mensal'::text NOT NULL,
    ano integer NOT NULL,
    mes integer NOT NULL,
    agendamentos integer DEFAULT 0,
    visitas integer DEFAULT 0,
    vendas integer DEFAULT 0,
    conversao_agendamentos integer DEFAULT 0,
    conversao_visitas integer DEFAULT 0,
    conversao_vendas integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sistema_metas OWNER TO neondb_owner;

--
-- Name: sistema_metas_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_metas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_metas_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_metas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_metas_id_seq OWNED BY public.sistema_metas.id;


--
-- Name: sistema_users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_users (
    id integer NOT NULL,
    username text NOT NULL,
    password_hash text NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text,
    role text NOT NULL,
    department text NOT NULL,
    is_active boolean DEFAULT true,
    whatsapp_instance text,
    whatsapp_connected boolean DEFAULT false
);


ALTER TABLE public.sistema_users OWNER TO neondb_owner;

--
-- Name: sistema_users_horarios; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_users_horarios (
    id integer NOT NULL,
    user_id integer,
    dia_semana character varying(3) NOT NULL,
    horario_inicio time without time zone NOT NULL,
    horario_fim time without time zone NOT NULL,
    dia_todo boolean DEFAULT false
);


ALTER TABLE public.sistema_users_horarios OWNER TO neondb_owner;

--
-- Name: sistema_users_horarios_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sistema_users_horarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_users_horarios_id_seq OWNER TO neondb_owner;

--
-- Name: sistema_users_horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sistema_users_horarios_id_seq OWNED BY public.sistema_users_horarios.id;


--
-- Name: sistema_whatsapp_instances; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sistema_whatsapp_instances (
    instancia_id text NOT NULL,
    instance_name text NOT NULL,
    user_id integer NOT NULL,
    instance_status text,
    base64 text,
    updated_at timestamp without time zone,
    last_connection timestamp without time zone,
    created_at timestamp without time zone,
    webhook text,
    remote_jid text
);


ALTER TABLE public.sistema_whatsapp_instances OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.sistema_users.id;


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visits_id_seq OWNER TO neondb_owner;

--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.visits_id_seq OWNED BY public.clientes_visitas.id;


--
-- Name: whatsapp_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.whatsapp_instances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.whatsapp_instances_id_seq OWNER TO neondb_owner;

--
-- Name: whatsapp_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.whatsapp_instances_id_seq OWNED BY public.sistema_whatsapp_instances.instancia_id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: clientes_agendamentos id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes_agendamentos ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: clientes_id_anotacoes id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes_id_anotacoes ALTER COLUMN id SET DEFAULT nextval('public.cliente_notes_id_seq'::regclass);


--
-- Name: clientes_vendas id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes_vendas ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: clientes_visitas id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes_visitas ALTER COLUMN id SET DEFAULT nextval('public.visits_id_seq'::regclass);


--
-- Name: imoveis_apartamentos id_apartamento; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imoveis_apartamentos ALTER COLUMN id_apartamento SET DEFAULT nextval('public.imoveis_apartamentos_id_apartamento_seq'::regclass);


--
-- Name: imoveis_construtoras id_construtora; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imoveis_construtoras ALTER COLUMN id_construtora SET DEFAULT nextval('public.imoveis_construtoras_id_construtora_seq'::regclass);


--
-- Name: imoveis_contatos_construtora id_contato_construtora; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imoveis_contatos_construtora ALTER COLUMN id_contato_construtora SET DEFAULT nextval('public.imoveis_contatos_construtora_id_contato_construtora_seq'::regclass);


--
-- Name: imoveis_empreendimentos id_empreendimento; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imoveis_empreendimentos ALTER COLUMN id_empreendimento SET DEFAULT nextval('public.imoveis_empreendimentos_id_empreendimento_seq'::regclass);


--
-- Name: imoveis_proprietarios_pf id_proprietario_pf; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imoveis_proprietarios_pf ALTER COLUMN id_proprietario_pf SET DEFAULT nextval('public.imoveis_proprietarios_pf_id_proprietario_pf_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: sistema_config_automacao_leads id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_config_automacao_leads ALTER COLUMN id SET DEFAULT nextval('public.sistema_config_automacao_leads_id_seq'::regclass);


--
-- Name: sistema_daily_content id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_daily_content ALTER COLUMN id SET DEFAULT nextval('public.sistema_daily_content_id_seq'::regclass);


--
-- Name: sistema_facebook_config id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_facebook_config ALTER COLUMN id SET DEFAULT nextval('public.facebook_config_id_seq'::regclass);


--
-- Name: sistema_leads id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_leads ALTER COLUMN id SET DEFAULT nextval('public.sistema_leads_id_seq'::regclass);


--
-- Name: sistema_leads_cascata id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_leads_cascata ALTER COLUMN id SET DEFAULT nextval('public.sistema_leads_cascata_id_seq'::regclass);


--
-- Name: sistema_metas id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_metas ALTER COLUMN id SET DEFAULT nextval('public.sistema_metas_id_seq'::regclass);


--
-- Name: sistema_users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: sistema_users_horarios id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sistema_users_horarios ALTER COLUMN id SET DEFAULT nextval('public.sistema_users_horarios_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes (id, full_name, email, phone, source, assigned_to, status, cpf, broker_id, haswhatsapp, whatsapp_jid, profile_pic_url, updated_at, created_at, source_details, preferred_contact) FROM stdin;
8466	eduardo	ana158claudia@gmail.com	(34) 9105-2641	Importado	13	Sem Atendimento	\N	\N	t	553491052641@s.whatsapp.net	\N	2025-06-13 12:42:40.54	2025-04-27 00:00:00	\N	\N
8279	Emily Felipe	emilyfelipe1055@gmail.com	(64) 98138-1650	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8482	Junior Santos	jrsantosgr03@gmail.com	(34) 98417-7760	Importado	23	Sem Atendimento	\N	\N	t	553484177760@s.whatsapp.net	\N	2025-06-13 12:41:14.114	2025-04-28 00:00:00	\N	\N
8280	Junior Batista	silviojr007@hotmail.com	(34) 99241-5048	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8281	Kaua	kv7376096@gmail.com	(34) 99781-3842	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8293	Jose Joaquim	josejoaquimsm@gmail.com	(35) 99184-9011	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8294	Jackson Vitor	jvito2625@gmail.com	(34) 9221-9159	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8295	Denise Nero	denisenero92@gmail.com	(34) 99291-0669	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
6985	Guilherme Gonalves	guilherme-gpt@hotmail.com	(34) 99115-6870	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6986	Karlinha Viana	karliinhaviana2012@gmail.com	(34) 99893-9246	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6987	John Victor	jhon.victor@icloud.com	(34) 98899-5844	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6988	j	marisapereira73768@gmail.com	(34) 3234-0892	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
8266	Michelly Campos Silva	dasilvamichelle030@gmail.com	(32) 99986-1009	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8267	Claudia Beatriz Santos Carrijo	claudiabiacarrijo@gmail.com	(34) 99284-6829	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8268	Marlia Pereira	marilia.mpb@hotmail.com	(38) 99127-7621	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8269	Joo Victor	joaorubia59@gmail.com	(19) 99871-0446	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8270	Matheus Pinheiro	matheusouzapinheiro@gmail.com	(34) 99182-7805	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8271	Ingrid Alberch 	cunhaalbrechingrid@gmail.com	(34) 99797-6266	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8272	selma	selmaapomaia@gmail.com	(34) 99673-3565	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8273	Warllen Silva Cruz	warllen.sc89@gmail.com	(34) 99710-5448	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8274	Iracemalopes Arajo	iracemaaraujo2021@gmail.com	(32) 99841-9332	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8275	Kelly Sousa	kelly.rafael2021@gmail.com	(34) 98411-5989	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8276	Alexandre Gomes	alexandrekoro2010@hotmail.com	(34) 98409-4350	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8277	Denise Arajo dos Santos	denysearaujo000@gmail.com	(75) 98334-3153	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8282	Kennedy	kreis.shop@gmail.com	(34) 98804-9294	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8283	Vania Paes Andrade	vaniaandrad@yahoo.com.br	(34) 9697-3369	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8285	Yara Maia	yaramaia03@gmail.com	(34) 99779-0874	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8286	Cristhian Gomes	cristhiangomes38@gmail.com	(34) 99869-6952	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
8287	Maria Aparecida	cidarosa08@gmail.com	(34) 99289-9257	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
6984	Vinicius	vinitoin2@gmail.com	(34) 99712-1468	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
8288	GABI	gabrielle.sousaferreira123@gmail.com	(34) 99894-6549	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8289	Renata Frana	renatafranacorporativo@gmail.com	(34) 99139-9411	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8290	Andreia Leite de Moraes	aleitedemoraes@yahoo.com.br	(34) 9644-6256	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8291	Mariza Aparecida Lara Lara	marizalara62@gmail.com	(34) 99966-6685	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8292	Maria DA Gloria	gloriavzt@gmail.com	(34) 99171-2783	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8300	Maria Luza	marialuizajr@hotmail.com	(34) 99769-0709	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8301	Silvania Santos	santossilvania184@hotmail.com	(34) 99219-9740	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8302	Isael Bispo	isaelbispoyfh72@icloud.com	(38) 99111-4663	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8303	Gabriela Jlia	gabriela.jdeos@gmail.com	(19) 99932-0968	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8304	Joel Laureano	joellaureanodasilva973@gmail.com	(34) 99798-5267	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-14 00:00:00	2025-04-14 00:00:00	\N	\N
8305	Maycon Pedrosa	maycondfpedrosa@hotmail.com	(34) 98439-4248	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-14 00:00:00	2025-04-14 00:00:00	\N	\N
8307	Mariane gama	gamaluizafreire9@gmail.com	(34) 9841-1388	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-14 00:00:00	2025-04-14 00:00:00	\N	\N
8308	Ileira Ferreira	ileiraferreira2016@gmail.com	(34) 99635-7802	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-14 00:00:00	2025-04-14 00:00:00	\N	\N
8309	Francysca Sousa	frann1537.sousa@gmail.com	(34) 98446-8983	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8310	Mrcia Helena De Sousa	marciahelenasousa39@gmail.com	(34) 99827-4892	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8311	Brbara Dites	aquinodites@bol.com.br	(38) 8865-3596	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8312	Aliene Rosa	alienerosa80@gmail.com	(34) 99646-5517	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8284	Francisco Edilson da Silva	silvaedilson1212@gmail.com	(34) 8446-6170	Importado	22	Agendamento	\N	14	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
6981	Alex	alexalvesaleixo@hotmail.com	(34) 99240-5413	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6983	Brenda Medeiros	brendaamedeiross22@gmail.com	(34) 99242-8522	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6993	Karyne Naves	karynenaves@hotmail.com	(34) 99341-5675	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6994	jorge imoveis	jorgerocha685@yahoo.com.br	(34) 99122-0742	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6995	Victria Peixoto	victoriapeixoto386@gmail.com	(34) 98817-8912	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6996	Lorena Cristina	lorena--cristina@hotmail.com	(34) 99217-7427	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6997	Ricardo Vaz	ricardoovaz321@gmail.com	(91) 99993-0202	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6998	Elaine Cristina Leonel Ferreira	elainecristinafw@gmail.com	(34) 8810-1466	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6999	leticia neres	leticianeres655@gmail.com	(73) 98246-7682	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7000	Cleber Santino	clebersanber@gmail.com	(34) 98834-2935	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7001	Estevan Pithan	estevanpithan@hotmail.com	(34) 99202-6247	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7003	Eliane Vilhena	cerimonialelianevilhena@yahoo.com.br	(34) 99883-7174	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7004	Carin Krampe	carinkrampe@hotmail.com	(19) 98991-9305	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7005	Eliane Ramos	elianeramos2905@gmail.com	(34) 99126-7196	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7006	Emanuela Glenio	manuglenio38@gmail.com	(34) 8403-3897	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7007	Josue Santos	emanuellyluziaferreira@gmail.com	(34) 9687-8044	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7008	Jefferson marques da silva	js4053403@gmail.com	(82) 9919-3068	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7009	Joo Vitor Alves	jv6142460@gmail.com	(34) 99804-9012	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7010	Faby Queiroz Pires	faby.qp@hotmail.com	(19) 98410-3880	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7011	Wallison Barbosa Ferreira	wallisonbarbosa88@gmail.com	(34) 98843-8001	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7012	Kamilly	kamillyraylanda872@gmail.com	(34) 99833-2380	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7013	Renato Fernando	renatofernando96@hotmail.com	(31) 99381-7096	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7014	Pablo Carrijo	pablocarrijo@outlook.com	(34) 99678-7727	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7015	Vitor Santos	vitor.siqueira2009@hotmail.com	(34) 99871-2712	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7016	Rose Passos	rosemeirealvespassos593@gmail.com	(34) 99656-5191	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7017	Consultora Carla Emanuelli	carlamanu_gabi@hotmail.com	(31) 99264-8563	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7019	Tayn  Souza	taynajordany@hotmail.com	(37) 99822-9475	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7020	Gonalves De Campos Campos Gonalves	joaocampositba89@gmail.com	(34) 99769-3669	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7021	Tiago Silva	tiagopci@hotmail.com	(99) 99106-2006	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
6992	Gilberto Lima	gilbertolimafsc@gmail.com	(34) 99796-6674	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7022	Renato Silva	rs.cardoso96@gmail.com	(34) 99998-7943	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7023	Taissa Pereira	pereirataissa612@gmail.com	(34) 9768-6828	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7025	Raphael Souza de Lima	rsl.rapha31@gmail.com	(11) 98375-5122	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7026	Ansia Naves	anesianaves@yahoo.com.br	(34) 99224-5207	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7028	Gean Souza	geansouza0908@gmail.com	(34) 99904-3141	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7030	Kariny	kariny.barbosa@outlook.com	(34) 99280-5204	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7031	Laria Neves	laricaalves012@gmail.com	(38) 99197-4035	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7032	Liara	liarafaria4@icloud.com	(34) 99684-7703	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7033	Larissa Arajo Lopes	larissaaraujolopes31@gmail.com	(34) 9639-8418	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7034	Viviane Pedrosa Vilarinho	vp869236@gmail.com	(34) 9894-5410	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7035	Kaique Costa	kaiquecs02@hotmail.com	(75) 99203-9757	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7036	Karen Marinho	karenmarinhoarq@gmail.com	(34) 99950-4841	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7037	Tiffany Gabrielly	tiffanygabrielly61@gmail.com	(34) 99111-3334	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7038	Glover Matias	glovermatias25@gmail.com	(34) 99660-2960	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7039	Mari Quites	marianemoreiraq@gmail.com	(34) 99763-4421	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7040	Gabriel	econogabriel2002@gmail.com	(34) 99181-7088	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7042	Biel Neves	bielmamute2006@gmail.com	(34) 99109-7108	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7043	Carlos Humberto de Oliveira	carloshumbertooliveira37@gmail.com	(34) 99153-1209	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7044	Saulo Borges	sauloborges830@gmail.com	(96) 99104-0697	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7018	Lidhiane	goncalves_lidiane@yahoo.com.br	(34) 99166-5305	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
6990	e ee	blynypaludo@gmail.com	(34) 99893-5519	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6991	Edi Severino de Sousa	pediseverinosousa@gmail.com	(92) 99279-7992	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7048	Naht	nahtkinsk@gmail.com	(34) 99764-4510	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7050	Maria Eduarda Santos	mmariaeduardasilvasantos818@gmail.com	(34) 9635-8528	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7051	Ester Borges Arajo	esterborgesaraujo14@gmail.com	(34) 99163-0187	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7052	Pedro Pitelli	pedropitelli2014@gmail.com	(16) 99751-1807	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7054	Gusthavo Henrique	gusthavohfs360@gmail.com	(34) 99831-1061	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7055	Thais Arbex	thais.arbex@hotmail.com	(32) 98836-5122	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7047	Emylly Carvalho	emillycosta0001@gmail.com	(34) 99891-2506	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7056	Marcio Aparecido Vieira	marciovieira19101979@gmail.com	(34) 99861-1505	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7057	Maria Fatima Galdino coqueiro	fatinhagaldino@gmail.com	(34) 9170-4289	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7058	Rafael Barbosa	taffa.gamaplay@gmail.com	(34) 9272-5012	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7059	Dione Evair faustino dos reis	monicasantana2024@gmail.com	(34) 8404-1357	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7060	Rosely Saopaulina	roselysaopaulina@hotmail.com	(34) 99147-0665	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7061	Maycon Douglas	maycondouglas03052k@gmail.com	(34) 99888-7353	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7062	Juraci Sebastio Gomes	juracisebastiao56@gmail.com	(34) 9191-4281	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7063	Alex Gondim	alexgondim1@hotmail.com	(34) 99932-7265	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7065	Jessyca Borghes	jessycaborgs@gmail.com	(34) 99275-6805	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7066	Nelio Barbosa	neliosilvabarbosa@gmail.com	(34) 99673-8841	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7067	Lilian Souza	liliandarc05@gmail.com	(62) 98119-2428	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7068	Ray Rodrigues	raissavixx1235@gmail.com	(61) 99137-9144	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7069	Nayana X Danizio	cristinanevesn@yahoo.com.br	(34) 99969-0095	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7070	Andressa Vilela	vilela.andressa@icloud.com	(34) 99193-2026	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7071	Shelton Ribeiro	sheltonribeiro163@gmail.com	(34) 9771-1774	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7072	Talita	talitamacenas50@gmail.com	(55) 34885-2285	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7073	Jad Lavinea	jadlavineaifnmg@gmail.com	(38) 99152-5161	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7074	Luis fernando alves mafra	juliaromontei840@gamil.com	(31) 98423-7323	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7075	Caio Henrique	caiohenriquego137@gmail.com	(62) 99423-5307	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7076	Wellington Ferreira	wfl.leandro@gmail.com	(34) 99873-9438	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7077	Flvia Danielle	flaviadani418@gmail.com	(34) 99777-2914	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7078	matheuzin	matheushenriquemarcelino970@gmail.com	(34) 99630-8345	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7079	Lucas Bonfim	lbonfim@timbrasil.com.br	(34) 9262-5621	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-06 00:00:00	2025-01-06 00:00:00	\N	\N
7080	Yuri Henrique	gbluis2751@gmail.com	(34) 99717-0561	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7081	Anthonyo Kanjja	negrokkanja@hotmail.com	(34) 9111-3086	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7082	R e b e c c a	rebecca.botan22@gmail.com	(35) 99180-3033	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7084	Rebeca Arajo	rebeca123.am50@gmail.com	(34) 9870-6756	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7085	Sheila Silva	sheilaraguari@hotmail.com	(34) 9248-9226	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7086	Wallace da cruz guerra	wdacruz748@gmail.com	(34) 99994-2638	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7087	Nathlia Figueiredo	nathalydifig@hotmail.com	(34) 9891-3990	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
7088	Victria Alves	vic.alvesandrade@gmail.com	(34) 99162-4406	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7089	Thais Diovana	thaisdiovana91@gmail.com	(34) 99884-4191	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7090	Juciara Aguiar	juciaradosreis1964@gmail.com	(34) 9967-4991	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7091	Jean Gonzaga	jeanginzaga@gmail.com	(34) 9769-3206	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7092	Jos Luis Diaz	jlda680401.ltm@gmail.com	(99) 2154-0000	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7093	Mica Gabriela  	mica23.finn@gmail.com	(34) 9163-7026	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7094	Dyonatan paiva	dyonatanpaiva@gmail.com	(34) 99965-1468	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7095	Zuleide Carvalho	zuleidecontadora@gmail.com	(34) 99150-8855	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7096	eo_sousa034 	ianvictor542@icloud.com	(34) 99106-9569	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7097	breno	1234@outlook.com	(34) 9784-2444	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7099	Thiago Vaz	thiagohvmart@gmail.com	(34) 99653-5200	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7100	Renatim Alves	renatim.ras@gmail.com	(34) 9825-0002	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7101	Lucia Maria de Jesus	lumariajandrade@gmail.com	(34) 9807-6183	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7046	Daniel Henrique	danielhenrique9159@gmail.com	(34) 99138-6622	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7053	Camilla Silva	camillanorato13@hotmail.com	(34) 99780-2797	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 23:07:35.479	2025-01-05 00:00:00	\N	\N
7105	Icatu  Uberlndia MG	denilsonsantosmartins81@gmail.com	(34) 99157-3578	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7106	Pierre Humberto	pierrehumbertop@gmail.com	(34) 98813-0851	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7107	Marcia Miranda	marciaalvesmiranda@hotmail.com	(34) 99790-5034	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7108	Geovana Moreschi	geovanamoreschi@gmail.com	(34) 99313-9150	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7109	Leonardo Baumgartner	leonardo.b_99@hotmail.com	(34) 99773-9646	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7110	Nathlia Stephane	nathaliastephane2002@gmail.com	(34) 99106-0843	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7111	Dairon Daniels	dairondaniels6to@gmail.com	(34) 97400-1917	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7112	Marcel Rocha	marcel.inc@hotmail.com	(34) 99972-1414	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7113	Davy Martins	davysllyn00@gmail.com	(34) 98419-5197	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7116	Ana	anajuliateles2021@gmail.com	(34) 99690-3584	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7117	Hugo	cesarhugo2086@gmail.com	(38) 99895-1832	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7104	Sheila Cristina Rosa	sheilaudi@hotmail.com	(34) 3222-8528	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7118	Luana M Souza	luananorett2@gmail.com	(34) 9770-3364	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7119	Caio breno	brenocaiobreno29@gmail.com	(34) 99720-0737	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7120	Daniel Lucas	daniellmaciiel@gmail.com	(34) 99789-2452	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7121	Marcos Fagundes	marcosfagundes7852@gmail.comm	(64) 99336-8664	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7122	Beatriz Marto	beatrizmarto14@gmail.com	(34) 99213-0646	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7123	Rodrigo Rosa Rezende	rodrigorrezende98@gmail.com	(37) 9855-6195	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7124	Iasmyn Aparecida Gonalves Bento	iasmynbento@gmail.com	(34) 99294-4726	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7125	Mirian	carolinamiriam199@gmail.com	(34) 99981-0553	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7126	Wemerson Martins	wemersonsilvard135@icloud.com	(34) 99173-3569	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7127	Maicom	deboraoliveira000@gmail.com	(34) 99992-9609	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	\N	\N
7128	Dhemerson Cardoso	dhemersoncardososilva@gmail.com	(48) 98466-4520	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7129	Joyce Heloisa g neves	as8056107@gmail.com	(34) 9696-7142	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7130	Jos Victtor Carvalho	josevicttor69@gmail.com	(34) 99657-8787	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7132	Rivania Alkimim	rivaalkimim@hotmail.com	(34) 98810-6898	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7133	Lorena Alves	lorenaalvees906@gmail.com	(34) 99685-1744	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7135	Ana Vitria Kenide	anavkenide@gmail.com	(34) 99217-4856	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7136	Ana Luiza Silveira	silveiraanaluizasilveira@gmail.com	(34) 99337-2403	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7137	PERSONAL DBORA	jacintodebora97@gmail.com	(34) 99230-8575	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7138	Sofhia Almeida	silvaannasofhia24051985@gmail.com	(34) 9718-8705	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7139	Anna Laura Martins	armartins127@yahoo.com	(31) 98785-5734	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7140	Andressa Trajano	andressapassostrajano@gmail.com	(34) 9793-3133	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7141	Edmilson Freitas	edmilsonfreitasfreitas@bol.com.br	(32) 98842-0109	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7142	Luiz Cludio	luyzagro@gmail.com	(34) 99249-8515	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7143	Kathleen Machado	kathleenmachado2503@gmail.com	(34) 99266-6133	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7144	Luiz Claudio	luizclaudiopereira1986@gmail.com	(34) 99195-6973	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7145	Arielle Ribeiro	nandoearielle@hotmail.com	(34) 99973-1274	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7146	Beatriz Rocha silva	beatrizsousat203@gmail.com	(98) 98594-2255	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7147	Ayrlla Arantes Guerra	arantesguerraayrlla@gmail.com	(34) 9888-5806	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7148	Andreia Andrade	andreiaandradecv@gmail.com	(34) 99643-8513	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7149	Richard Hanry	hanrysilva670@gmail.com	(34) 9126-1925	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7150	Reginaldo Guimares	reginaldogxjr@gmail.com	(34) 99986-9470	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7151	Johnleno Souuza	johnvectra@hotmail.com.br	(34) 9180-2057	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7152	Carol Arajo	anacarolinaaraujo832@gmail.com	(34) 9866-1494	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7154	Maykon	maykon.sw4@gmail.com	(34) 99155-9354	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7155	Georgia Goulart	georgiadayrel@gmail.com	(34) 99287-8976	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7156	Veridiana Terra	veridianatm@hotmail.com	(34) 99237-5287	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7157	Amanda Ges	amanda-13132009@hotmail.com	(34) 99196-6811	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7103	Aparecida ferreira de lima	aparecida_951@hotmail.com	(34) 9896-6365	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7115	FERNANDA	fernanda_144@famanegociosimobiliarios.com.br	(34) 8446-3375	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 17:25:00.434	2025-01-08 00:00:00	\N	\N
7163	Moiss Henrique	moises.santos1513@gmail.com	(34) 99998-4401	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7161	Marcos Daniel	ferreira1225w@gmail.com	(34) 98403-6107	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-14 13:38:40.277	2025-01-12 00:00:00	\N	\N
7164	Priscila Sclaffani	prifaniferreira@hotmail.com	(34) 99842-8270	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7165	Bruna Cristina	brunacristinaf4@hotmail.com	(34) 99767-7609	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7166	gabriela	baboopbibs@gmail.com	(34) 99154-7349	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7167	Luiz Arthur	luizdomingos.lapd@gmail.com	(34) 99156-6566	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7168	Ana Luisa	annaltm96@gmail.com	(37) 99660-2746	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7169	Ana Beatriz Teixeira de Jesus	alineteixeira.ribeiro29@gmail.com	(34) 99253-6500	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7170	Angela Martins	angelacustodia.003@gmail.com	(34) 99942-6012	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7172	Jos Divino Alves do Nascimento	alvesnascimento2023@outlook.com	(34) 9957-5318	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7173	Gabrielle Fernandes	gabriellesf2005@hotmail.com	(34) 99802-8910	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7162	Ana Karolina Vital	karolinavital28@gmail.com	(34) 99188-8159	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7174	Lany Souza	hs3419323@gmail.com	(31) 99563-5535	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7175	Nayelen Gonalves	nayelenv@gmail.com	(38) 98410-8052	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7176	Jhemylly Vieira	jhemyllymartins15@icloud.com	(62) 99245-4598	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7177	Fabiano Junior	fabianojmelo@hotmail.com	(34) 99706-2349	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7178	Thais Andrade	thaisedu@hotmail.com	(34) 98827-7235	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7180	Joo Pedro Marques	jpfm2504@gmail.com	(34) 9144-1899	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7181	Daiany Rodrigues	daiany_rp@hotmail.com	(34) 99198-4289	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7183	Shaieny Matos	shaienycruz@gmail.com	(91) 99242-6747	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7184	Lucas Eduardo 	lucasmoura2605@gmail.com	(34) 99131-9397	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7185	Gabriel Vitor Santos Silva	gabrielvitorsantossilva587@gmail.com	(34) 9865-9128	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7186	Valber Rodrigues	valbercam13@gmail.com	(34) 99765-1186	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7188	Ellen Gonalves Arajo	ellennathan2023@gmail.com	(34) 9155-7341	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7189	Karina Claudino	kasalles85@gmail.com	(31) 98264-0449	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7190	Maria Julia	mariajulia-sx@hotmail.com	(34) 99217-3556	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7179	Alexsander Jesus	wilkeralex2003@icloud.com	(34) 99878-9713	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7191	Gabriela Morais	gabrielams9@hotmail.com	(34) 99948-8725	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7192	Symone Lima	symonelima@yahoo.com.br	(34) 99190-0615	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7193	Francisco Kenji Fujimoto	fkfujitech@hotmail.com	(93) 40996420175	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7194	MAugusta	mariineves132@gmail.com	(34) 99770-8521	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7195	Susuh Ferreira	suellen_23k@hotmail.com	(34) 9873-8193	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7196	Emanueli Miranda	emanuelieduardam09@gmail.com	(34) 98433-9614	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7159	Layra Lobo	layramyllena@gmail.com	(34) 99135-6822	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7197	Daniel Alencar	dalencar76@gmail.com	(34) 99892-9345	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-14 00:00:00	2025-01-14 00:00:00	\N	\N
7198	Adroaldo Borges Garcia	adroaldo1380@outlook.com	(34) 99856-8631	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7199	taniamg21luciagmailcom	taniamg21lucia@gmail.com	(38) 9886-5815	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7203	Gislaine Mertes	gislaineapvma@hotmail.com	(17) 99215-8894	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7204	Graziela Macedo	grazielamacedo778@gmail.com	(34) 99243-2169	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7205	Helena Oliveira	helenafalves@hotmail.com	(34) 99166-2654	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7206	kellem	kellenhapuque053@gmail.com	(34) 99869-0678	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7207	Pedro Frana	admrealfitness@gmail.com	(34) 99136-0956	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7208	TAMARA	jhulytamara98@gmail.com	(34) 99663-1450	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7209	Lucas Silva	lucasonfroy1208@gmail.com	(34) 99828-7650	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7210	aliceluize	aliceluizecorreareis@gmail.com	(34) 99914-3435	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7211	Lilian Santana Dos Santos	liliandestac@gmail.com	(34) 99149-8377	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7212	kallazzans pretinho	andrecalazans2020@gmail.com	(34) 98414-1942	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7213	Eliane Maria Martins	elianemartins.72@hotmail.com	(64) 99967-2514	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7187	Thyago Rodrigues	rpthyago@gmail.com	(34) 99680-0405	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-14 14:22:43.696	2025-01-14 00:00:00	\N	\N
7171	Ariane Xavier Duarte	ariane.axd@gmail.com	(34) 99183-1595	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 22:53:39.873	2025-01-13 00:00:00	\N	\N
7218	Guilherme Rocha	guilhermerocha40th@gmail.com	(34) 99908-7182	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7219	Eliane Soares	elyanesoares77@gmail.com	(16) 19861-7871	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7220	Tiago Vinicius	tiagovinicius2004@hotmail.com.br	(34) 99145-6259	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7222	Dani	danimedeiros107@gmail.com	(34) 99223-2887	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7216	Thalia	thaliafernandao65163@gmail.com	(34) 99689-5115	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7223	Julia	juliajulinha483@gmail.com	(34) 98825-3253	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7224	Glaucia Miranda	glauciagmiranda@gmail.com	(34) 99120-9778	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7225	Alexsom Rodrigues  veloso	alexsonrodriguesveloso@gmail.com	(34) 99989-6461	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7226	Keila Teixeira	keilateixeiraferraz@gmail.com	(34) 99898-5804	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7227	Joao Nascimento	jbnascimento321@gmail.com	(34) 9961-6699	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7228	ngella	angelamary9632@gmail.com	(34) 99632-4588	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7229	Yuri Almeida	yuri_cruzeirense@hotmail.com	(34) 99966-5832	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7230	Maria Eduarda Brito	mariaedobrito@gmail.com	(34) 99187-7626	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7231	Flavio Incio almeida	flavioinacioalmeida123@gmail.com	(62) 9528-1370	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7232	aysha millene	ayshamillene77@gmail.com	(34) 99163-3502	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7233	Deborah Santana	deborah.chique@gmail.com	(38) 9942-5089	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7234	Andr	dedemachado075@gmail.com	(34) 99931-4911	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7237	Lorena Salvador Melo	lori_sm@hotmail.com	(33) 99122-0028	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7238	Ivan	ivanildosilva2004@gmail.com	(34) 99709-8388	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7239	Claudio henrique	claudiohenriqueps15@icloud.com	(34) 99678-9940	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7240	Michel Freitas	michel_14fc@hotmail.com	(34) 99636-1404	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7241	Heber	binhonaninha10@gmail.com	(34) 99131-5290	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7242	Lucas Borges	lucas.borges.a@gmail.com	(34) 98856-3579	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7243	Milton Souza	adrielealvesdesantana683@gmail.com	(34) 99155-1030	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7244	Naum Aguiar	naum.aguiar.12@gmail.com	(34) 99961-0236	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7245	Mateus Gomess	mateeusgomess@hotmail.com	(34) 9133-4492	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7246	Paulo Silva	paulopensador1@gmail.com	(34) 9879-0013	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7248	Ludmila Hollenbach	hollenbach.lud@gmail.com	(34) 99777-6879	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7249	Ana Vitoria Fernandes	fanavitoria64@gmail.com	(34) 99106-5239	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7250	Charles Silva	charles.alves.da.silva@hotmail.com	(34) 99272-7445	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7251	Ana Clara	anaclarastth@yahoo.com	(34) 99992-6279	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7252	Felipe Palazzo	felipe.palazzorodrigues@gmail.com	(34) 99212-5196	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7254	Gustavo Paiva	gustavobpg15@gmail.com	(34) 99763-8503	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7255	Ana Julia Miranda	anajuliamiranda3010@gmail.com	(34) 99199-5046	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7256	Biaah Santos	anaahleal2119@gmail.com	(34) 99163-0486	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7257	Moises Mamede	moisesmamede@live.com	(34) 99300-0676	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7258	Dinalva Ribeiro	nalva.ribeiro1@hotmail.com	(34) 99178-7602	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7259	Lanaria Livia	98807880ll@gmail.com	(34) 98426-8782	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7260	Maurcio Jnior	mauriciojr652@gmail.com	(34) 9789-9180	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7261	Fabio Giovane	fabiogiovane44@gmail.com	(34) 9111-5526	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7262	wadecy ferreira Loureno	sisi-lourenco@hotmail.com	(34) 9776-4010	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7263	Mecia Arajo	mecia.al@icloud.com	(34) 99209-8644	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7264	Fabiana Sousa Santos	santosgerlaine412@gmail.com	(34) 9131-7789	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7265	Wlyana Souza	wlyanasouza@hotmail.com	(34) 99991-2299	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7266	Geralda Gonalves Medeiros Gonalves	gegegoncalvesm@gmail.com	(34) 9112-6838	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-18 00:00:00	2025-01-18 00:00:00	\N	\N
7267	 sss	keyteodoro71@gmail.com	(34) 99791-2279	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7268	Vitoria Santos	vitoriasantosdacosta4@gmail.com	(34) 99107-1426	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7269	MK	mariakatiasantosdeandrade10@gmail.com	(79) 99813-9844	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7270	Wagylla Snnttos	santoswagila74@gmail.com	(74) 98121-8457	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7383	Diogo Ribeiro	dr8610974@gmail.com	(73) 99956-7350	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7273	Luciano custdio da Silva	lucianocoordenadas@gmail.com	(34) 99107-3433	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 16:41:39.914	2025-01-19 00:00:00	\N	\N
7274	Mara Franco	marapfranco1984@yahoo.com	(47) 92002-3552	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7278	Lucas Vincius	lucavinic2@gmail.com	(79) 99844-3378	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7279	Breno Pedro	brenopedro123@icloud.com	(34) 98824-2421	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7280	Silvio	geycekeli@hotmail.com	(38) 99960-7174	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7281	Beatriz Santos	beatrizssantos20140@gmail.com	(34) 99797-3387	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7282	Marcos Ferreira	marcosferreira1510@yahoo.com.br	(31) 97210-6162	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7283	Walisson Assuno	walissonassuncaopk@gmail.com	(34) 99695-2505	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7284	Thales Silveira	thalesskate2013@hotmail.com	(34) 98402-6977	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7285	Gustavo Soares	gustavoss1902@outlook.com.br	(34) 99684-8821	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7286	Lurdes Carolaine dos Santos Costa	lurdiscarolaine@gmail.com	(31) 99111-1069	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-20 00:00:00	2025-01-20 00:00:00	\N	\N
7287	nelson do carmo faria	valerialimarv@gmail.com	(64) 99341-4662	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7276	Matheus Duraes	matheusduraes98@gmail.com	(38) 99910-9740	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7277	KG Bordados	alguem2019k@gmail.com	(62) 98624-7961	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7288	Maryana Macedo	maryanamacedo29@gmail.com	(34) 99931-7034	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7290	Leo Assis	leotusti@hotmail.com	(73) 99111-2629	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7292	Mell Oliveira	mell.gracinha@hotmail.com	(34) 99224-0041	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7275	Aline Oliveira	alinedeoliveiraoliveira7@gmail.com	(64) 99291-6070	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7293	Cristhian Gabriel	chrisalves0306@gmail.com	(34) 99886-3671	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7294	Fernanda Pacheco	alvesfernandaa@gmail.com	(34) 99774-5634	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7296	Kamily Vitria Rosa Prado	kamilyvitoriaprado550@gmail.com	(34) 99187-7012	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7297	Gabi Tavaress	gabryele.cunha0@gmail.com	(34) 99930-6006	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7299	Vitor Hugo	vitordamit3@gmail.com	(34) 98840-7131	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-22 00:00:00	2025-01-22 00:00:00	\N	\N
7300	Caio Cavalini	cnc200511@gmail.com	(34) 8427-5320	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-22 00:00:00	2025-01-22 00:00:00	\N	\N
7301	Hiago Rabelo	hiagorabelo05@gmail.com	(34) 99635-0501	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-22 00:00:00	2025-01-22 00:00:00	\N	\N
7302	Nicole Almeida	nicoleaasantoss@gmail.com	(34) 98428-0901	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-22 00:00:00	2025-01-22 00:00:00	\N	\N
7304	Daniel Willian	d4nielrever@gmail.com	(34) 99691-0610	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7306	Dani designer	dandaradao@hotmail.com	(35) 99861-2074	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7307	Wendersonramoslima Arajo	wr45450@gmail.com	(34) 99157-0937	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7308	jlia	garotinha_sapekinha_princess@hotmail.com	(34) 98433-8005	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7309	Marcelo Lima	marcelosccp95@gmail.com	(34) 99649-0657	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7310	Lo Silva	lfs.silvasoccer74@gmail.com	(34) 9199-4121	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7311	Edson Borges Silva filho	edson.borgessilva72@gmail.com	(34) 99842-6195	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7312	Bruna Silva	bruna06silvqs@gmail.com	(34) 9312-0408	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7314	Ana Rillary	ana.rillaryy@gmail.com	(34) 98426-3720	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7315	Matheus Coimbra	matheusmartins2014@hotmail.com	(34) 9762-7681	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7316	Eliziene Vasconcelos	eliziene-vasconcelos@hotmail.com	(34) 99230-9106	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7317	Fernanda Eugenia Mesquita	fernandaemesquita88@gmail.com	(38) 9982-2910	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7318	Fernanda Climaco	filipiclimaco@gmail.com	(34) 98441-0032	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7320	Fernanda Maria	fm70760878@gmail.com	(34) 99221-4592	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7321	Vinicius Benetti	viniciuszbenetti@gmail.com	(54) 99712-7608	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7322	Nagilla	nagilanatieli@gmail.com	(34) 99108-6574	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7323	Saymon_Nogueira	uederalcatara@gmail.com	(34) 99972-6731	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7324	Leticia Yokoyama	lehyoko@hotmail.com	(16) 98128-5685	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7325	Dejair Alves Lemes	dejairlemes@hotmail.com	(34) 98825-6588	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7289	Alysson Daniel	alyssondfp@gmail.com	(38) 99234-3700	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 22:54:43.276	2025-01-21 00:00:00	\N	\N
7272	Maria Eduarda	eduarda.santosduarte@outlok.com	(64) 99948-8706	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-14 14:36:06.908	2025-01-19 00:00:00	\N	\N
7329	Nardeli Mota	nardelimota68@gmail.com	(34) 9841-8787	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7330	Luna	lunadamascc@gmail.com	(34) 99762-1538	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7331	Carloman Rosrio Brumes	crbrumesduadim@gmail.com	(34) 99253-1702	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7332	Karina Borges	karinacristinaborges@hotmail.com	(38) 99833-3081	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7333	nick	nicolykellysilvaps@gmail.com	(55) 99338-2715	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7334	Myrella	myrelladiasld@hotmail.com	(34) 99818-9084	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7335	Desenhos da Lilia	liliamariele@gmail.com	(38) 99211-5281	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7336	Josiele Andrade	josieleandrade503@gmail.com	(37) 9840-2541	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7337	Pedrinho	sgtfagundes2018@gmail.com	(34) 98861-0412	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7338	Letys	leticiaguilhermerosa@gmail.com	(34) 99838-4524	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7340	DAVI HELLON TPD	davihellon10@gmail.com	(34) 99862-9044	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7341	Bruno Firmino de Sousa	brunofsousa97@gmail.com	(34) 99905-4484	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7342	Camila Oliveira	milaasantoos1999@gmail.com	(34) 99175-9623	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7343	Shirley Cristina Miguel	shirleymanfrin@gmail.com	(34) 99820-8310	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7344	P r i n c e s a 	jailhe_scn@hotmail.com	(34) 99168-3845	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7345	Scarlet de Arajo	scarlet.araujo@gmail.com	(11) 95425-5526	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7346	Leninha Mathias	edilenemathias123@hotmail.com	(34) 99191-4733	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7347	Aparecida Cida	cida.encarregandauber@gmail.com	(34) 99897-2505	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7348	Vera Bernardes	bernardes.veralucia@hotmail.com	(35) 99911-3719	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7349	Thaabata Rodrigues Ferreira	thaabatart20@gmail.com	(34) 9706-7651	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7350	anderson silva	andersonmds10@outlook.com	(34) 99212-4932	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7352	Cintia Vitria	cintiavitoria5342@gmail.com	(55) 64981188166	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7328	Carlos Zuluaga	carloz110376@gmail.com	(34) 99196-8117	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7353	Gessyca Santos	gessicanunes.apps@gmail.com	(34) 99682-2879	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7354	Raquel Alves	raquel0117@live.com	(34) 99136-7587	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7357	Andreia Carvalho	andreialeonel40@gmail.com	(34) 99229-5440	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7358	Breno Henrique Oliveira Santana	brenolourenconoliveira@gmail.com	(34) 9769-1597	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7359	William Vasconcelos	williamvasconcelos712@gmail.com	(34) 99979-8961	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7360	Divina Garcia	divyninha@hotmail.com	(34) 99633-3279	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7361	Luiz Fernando Ferreira	luizfernando121930@gmail.com	(34) 99111-5097	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7362	Carla Pires	carlapires2018@gmail.com	(34) 9979-3040	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7363	Nelson Sena	nelsonsena1984@gmail.com	(34) 99838-6375	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7364	Luiza Gomes	luizinhaoliver3@gmail.com	(34) 99651-7941	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7365	Ricardo 	ricardo__394@famanegociosimobiliarios.com.br	(34) 99919-1969	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-27 00:00:00	2025-01-27 00:00:00	\N	\N
7366	Vanessa Evangelista	vanessaevans1989@outlook.com	(34) 9105-4559	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7367	Mary S	maria.333slpsousa123@gmail.com	(34) 99720-9399	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7368	Kaio Barbosa	kaiofalcao490@gmail.com	(34) 99131-8722	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7369	Dany Ovidio	danyovidio@gmail.com	(34) 99139-4780	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7370	Marden Martins da Silva	mardenmartins@yahoo.com.br	(34) 99643-4310	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7371	Juh Ferreira	juuhluiza_ferreira@yahoo.com.br	(34) 99259-9404	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7372	Magno Alves	magno@agenciarealiza.com.br	(34) 99678-8205	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-02 00:00:00	2025-02-02 00:00:00	\N	\N
7374	Thaynnara Silva	thaynnarasoouza3@gmail.com	(34) 99875-6968	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-03 00:00:00	2025-02-03 00:00:00	\N	\N
7375	daniel augusto	danielgugu4444@gmail.com	(34) 99872-7827	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-03 00:00:00	2025-02-03 00:00:00	\N	\N
7376	Gisele Alves	giselelove2010@gmail.com	(34) 99964-7194	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-03 00:00:00	2025-02-03 00:00:00	\N	\N
7377	Nathan Henrique	hennathan10@gmail.com	(62) 98156-6302	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-03 00:00:00	2025-02-03 00:00:00	\N	\N
7379	Dani Oliveira	dany_oliveira.59@hotmail.com	(74) 99971-3515	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7381	Vitor Emanoel	vitoremanoel28@outlook.com	(34) 99929-4213	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7382	Jheyfe	jheyfekaylainne@gmail.com	(34) 98430-5979	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7351	Vitor Ribeiro	vitor_ribeiro_cosmo@hotmail.com	(34) 99722-5601	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7405	Valdemar Oliveira Silva Junior	junior.lord.dragon@gmail.com	(34) 9636-2575	Importado	23	Venda	074.240.586-90	14	\N	\N	\N	2025-05-15 13:29:43.34	2025-02-07 00:00:00	\N	\N
7387	Liliane Ezequiel Lucas	lilianefatima36@gmail.com	(34) 99779-9964	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7388	Ana Flvia Carvalho	afcninha@hotmail.com	(34) 99335-4085	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7389	Hellen Cristina	hc1112002@gmail.com	(34) 99689-2313	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7390	Anne Carolina	carolmonte2009@hotmail.com	(34) 99832-6073	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-05 00:00:00	2025-02-05 00:00:00	\N	\N
7391	Ana Luiza Chesca	analuxk@hotmail.com	(16) 99271-6296	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-05 00:00:00	2025-02-05 00:00:00	\N	\N
7392	Carlos Henrique	d061527@gmail.com	(34) 9867-9509	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-05 00:00:00	2025-02-05 00:00:00	\N	\N
7394	Joo Vitor	joaovitordogs@gmail.com	(34) 99872-8727	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-05 00:00:00	2025-02-05 00:00:00	\N	\N
7395	Neto Dias	netinhodias256@gmail.com	(34) 99865-2026	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7386	Maju Muniz	mariajuliamunizcarneiro9@gmail.com	(34) 99990-3727	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7385	Bia	biancavitoriacmacedo@gmail.com	(34) 99663-8373	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7397	bruna menezes	menezesbruna117@gmail.com	(34) 99331-8100	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7398	Julia Rodrigues	juliarodriguespaula16@gmail.com	(34) 99706-8073	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7399	Anderson Martins	cleandroleal3@gmail.com	(66) 99915-2406	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7400	Lorrane Miranda	lorraneclara@bol.com.br	(34) 99251-1265	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7401	Edna Vieira	edinavieira.96@gmail.com	(17) 3335-1485	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7402	Marcos	marcosjrr55@gmail.com	(34) 99641-9545	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7404	Daniel Tavares	tavaresxtdanniels@gmail.com	(34) 98897-2437	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7406	Fernanda Resende	fernanda_nr89@hotmail.com	(34) 99887-2105	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7407	Zakeia Zahir	zakiazahir1222@gmail.com	(34) 9652-3050	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7408	Gabrielly Goulart Silva	gabriellysilva3308@gmail.com	(34) 99634-3624	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7409	Ylrissilva Knowlles	ylrissilvaknowlles@gmail.com	(61) 99146-6385	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7410	Valter Jose	valterjosejaiba02@gmail.com	(34) 9942-0463	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7411	Rayssa de Paula	rayssadepaula02@gmail.com	(34) 8875-4656	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7412	Josias Brito	josias_brito_446@famanegociosimobiliarios.com.br	(17) 99789-1606	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7413	Milton Alexandre Dantas	paeseciaadm@gmail.com	(34) 99794-8598	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7416	Marceliinho Junior	marceeloo2000@gmail.com	(34) 9799-1483	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7417	Lari Muniz	lari.elma@hotmail.com	(34) 99897-7024	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7419	ngela Maria Pereira Dos Santos	flor71972@hotmail.com	(33) 99981-8273	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7420	Larissa	larissinhajunqueira@hotmail.com	(34) 99100-8825	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7421	Jose Goncalves Gomes Gomes	zedaserva7132@gmail.com	(66) 98119-8150	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7422	Juliana	julianavzp34@gmail.com	(38) 98848-3891	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7423	Ana Jlia	moraisanajulia2019@gmail.com	(34) 98440-5512	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7424	Ana Paula dos Santos	anastteves.2019@gmail.com	(34) 8808-3470	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7425	Eshilley Stealth	danyeleshilley@gmail.com	(34) 98440-0846	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7426	Debora Feitosa	deborazaquicristine1802@gmail.com	(34) 99245-2812	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7427	Conceiao Barbosa Souza	mundialtintasconceicao@hotmail.com	(34) 9177-2455	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-08 00:00:00	2025-02-08 00:00:00	\N	\N
7428	Ueidson Alves	ueidsonvzp@hotmail.com	(38) 9746-2981	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7429	KenNedy Santos Icm	w.kennedy_93@hotmail.com	(38) 98807-2578	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7430	Jacirene Barrocas	jacybarrocas51@gmail.com	(34) 98432-2000	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7432	Sarah Balado	sarinha_decoracao@hotmail.com	(34) 99650-5910	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7433	Graciane Silva Cunha	gracianycunha519@gmail.com	(34) 99212-5148	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7434	Olmpio	ocupacional2@hotmail.com	(34) 99925-3374	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7436	Glaucia Vieira Vieira	glaucia.c.v@hotmail.com	(34) 99165-9255	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7437	Wanderson Oliveira	wandersonvisiontec@hotmail.com	(64) 99228-5561	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7438	Luis Miguel Felicio	luisfelicio11@gmail.com	(31) 98916-5441	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7439	Igor Teixeira	ih.teixeira@yahoo.com.br	(34) 99694-9379	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7393	tais	tatahw46@gmail.com	(31) 99534-0332	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 16:43:07.521	2025-02-05 00:00:00	\N	\N
7414	Max Osorio	max_animes@hotmail.com	(34) 9163-7884	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 16:36:04.33	2025-02-07 00:00:00	\N	\N
7442	Henrick	delatorrehenrick@icloud.com	(34) 98408-6902	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7443	Jean Wilson	jeanwilsonwenceslau288@gmail.com	(34) 9683-5553	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7446	Rosiel Araujo	piscar.47encontrao@icloud.com	(94) 99280-6003	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7447	Vitor Hugo Lima Santos Lima	vitorhugolimasantoslima8@gmail.com	(34) 99884-0676	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7494	Samira	samira_528@famanegociosimobiliarios.com.br	(34) 8876-6056	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:44:53.817	2025-02-11 00:00:00	\N	\N
7448	Juan Estevanim	juanestevanimch4@gmail.com	(34) 98432-7646	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7449	Jhonatan	jhonatan_jfr@live.com	(34) 99651-6448	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7450	Gracielle Meneses	graciellemeneses@gmail.com	(34) 99141-2696	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7451	Ana	analuizaferreira859@gmail.com	(34) 99209-0378	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7452	Marcia Fernandes	fernandesmarcia332@gmail.com	(34) 98805-4459	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7453	Ra Rodrigues	railopsr@gmail.com	(33) 99957-9119	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7454	Carlos Eduardo MartMartins	geneciasgaldino@gmail.com	(34) 9968-1582	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7455	Ana Paula Sousa	anapaulasousa203540@gmail.com	(38) 9132-0861	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7456	Everton Eduardo	avertoneduardom@gmail.com	(38) 9957-4135	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7458	Felipe Diniz	valterfeliphede@gmail.com	(31) 97597-1292	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7459	Anthony Ribeiro	joaoribeiro.3142@gmail.com	(54) 99712-5321	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7460	Carmelio Pires	carmelio@outlook.com	(64) 99985-7564	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7461	Mirian	ferreirabrantmirian@gmail.com.br	(34) 99911-1678	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7462	liliane silva	lilikadasilvacustodio433@gmail.com	(27) 99731-2551	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7463	Flavia Ribeiro	flaviaa7905@gmail.com	(34) 98405-4507	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7464	Sandra Maria da Silva	sandramaria65.11@gmail.com	(34) 9696-8500	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7465	Hugo Talles Justo Galvo	hugox10tatallesxjujusto@gmail.com	(34) 99676-8260	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7466	Lo Lima	wiltonsofhiamiguel2@gmail.com	(19) 99797-2736	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7467	Meyrielle Couto Borges	meyriellecouto@gmail.com	(38) 98405-5556	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7468	Sara Cristina	cristinasara088@gmail.com	(67) 99697-3140	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7470	Erick Vini	erickvini2511@gmail.com	(44) 98812-2341	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7471	manu	maanu.rodrigues06@gmail.com	(34) 99777-1789	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7441	Cssio Diniz Figueiredo	cassimfigueiredo@gmail.com	(34) 99645-5073	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7472	nsncyleles daRocha	nancyleles2@gmail.com	(41) 9841-3404	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7473	Monielly Silva Alves	moniellyalves1@gmail.com	(64) 99668-8542	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7475	Flauciglene moreno Gonalo	glenny-goncalo@hotmail.com.br	(34) 8858-1581	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7476	Fabiana Karoline	fabiana-karoline@hotmail.com	(34) 99244-0390	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7477	Higor	higor.hds@hotmail.com	(34) 98419-5164	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7478	Marcos Elias	marquimana10@gmail.com	(34) 99117-6200	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7479	Lucas Silveira borges	lucassilveirab06@gmail.com	(34) 9895-0608	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7480	Gisele borges	gb337178@gmail.com	(34) 99897-9714	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7481	Aparecida Helena Cidinha	aparecidaelenaferreiraferreira@gmail.com	(64) 9215-8585	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7482	Rapha Amorim	raffasouza58@gmail.com	(35) 99981-1842	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7483	Simone Batista Mello	simonemello.walter@gmail.com	(67) 9174-8008	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7484	Geovana Silva	geovanags2397209@gmail.com	(34) 99668-4850	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7485	Avanhia Francisca	avanhiafrancisca54668@gmail.com	(34) 99290-7088	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7486	JAMILA SOUSA	sousajamila490@gmail.com	(74) 9908-9457	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7487	Hemilly Patrcia	hemysena@gmail.com	(34) 99107-7276	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7488	Samuel Henrique	samuelhenrique588@gmail.com	(16) 99120-9468	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7489	Ismaria Nascimento	ismarianascimento9@gmail.com	(34) 99646-6434	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7490	Yasmin Borges	yasminfatimaborges@gmail.com	(34) 99772-4927	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7491	Jacqueline Ferreira da Silva	jacquelineferreirasilva01@hotmail.com	(37) 99814-6280	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7492	Munique Cardoso	muniquinhac@gmail.com	(34) 99172-3818	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-11 00:00:00	2025-02-11 00:00:00	\N	\N
7469	Karine Menezes	karinemenezes72@gmail.com	(34) 99106-1144	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7493	Mrcia Carvalho Pacheco	mercia_patos@hotmail.com	(34) 9908-6694	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:43:08.496	2025-02-11 00:00:00	\N	\N
7445	Daniel Daher Leite	daherleite@hotmail.com	(34) 9194-8054	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 14:50:03.383	2025-02-09 00:00:00	\N	\N
7497	Isaque Fernandes	isaquefernandinho123@gmail.com	(34) 99779-4810	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7498	Liliane de Melo Freitas	lilianedemelofreitas@gmail.com	(34) 9172-1465	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7499	Emily Schuwrstemberg	emilyschuwrstemberg@gmail.com	(42) 99128-6553	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7500	Day Pereira	gcristine359@gmail.com	(34) 99729-7297	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7501	Mariane Barros	mariane__barros@hotmail.com	(34) 99763-4170	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7502	Osvaldir Junior	osvaldirjunior1212@gmail.com	(34) 99167-5899	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7504	Cleide Souza	gomessouzacleidinhapereira@gmail.com	(38) 9270-3622	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7505	Maxwel Santos	maxwel.santos.162018@gmail.com	(31) 98478-3869	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7506	Liete Figueiredo	lilicamineirica@hotmail.com	(21) 99779-1969	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7507	Claudio Luiz	babetzke277@hotmail.com	(48) 99195-8447	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7508	Jhon Mller Cardoso	jhonmuller@yahoo.com.br	(34) 98856-5563	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7509	arthur de souza 	melo61749@gmail.com	(34) 99891-6187	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7510	Emanuel Sobrinho	aguiamasterone@gmail.com	(34) 9880-6884	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7512	Tayss_reis	taysreiz23@gmail.com	(34) 99818-3978	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7513	Tamires Erisvan	tamirescorrea016@gmail.com	(99) 98521-4435	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7514	Thales Silva Castro	thalesoliveira96781996@gmail.com	(34) 99279-4231	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7516	Janaina	uaijanaina@gmail.com	(34) 99644-8287	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7517	Priscila Rocha	charles-rsilva@hotmail.com	(34) 8858-5543	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7496	Adriano Renhe Pessoa	adriano.renhe@gmail.com	(34) 99944-3671	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7518	Gustavo almeida 	gustavoanalsilva@gmail.com	(38) 98804-9097	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7519	ana Maria Sarmento	sarmentoa482@gmail.com	(51) 99439-1495	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7520	Jose Domingos Alves Dos Santos	domingostaxi1956@gmail.com	(27) 99955-2725	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7521	Amanda	amandagarciapxd@gmail.com	(34) 99963-7831	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7511	Geraldo Alves santos junior	impactotelas@gmail.com	(34) 9698-9556	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7522	Kethllyn Clara	kethllynclara@gmail.com	(64) 99663-2926	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7524	Vitoria Evangelista	vitoriaevangelista237@gmail.com	(35) 99116-6929	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7525	Lucas Henrique	lucahenrique345679@gmail.com	(34) 98877-9818	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7526	Mario Donizete Donizete	mdmateriaiselocacao@gmail.com	(94) 9191-8899	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7527	Ana julia	anaj10448@gmail.com	(34) 99685-0578	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7528	Bianca Silva	biancamartins0626@gmail.com	(85) 98971-6340	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7529	Thales Miguel	miguelth28@hotmail.com	(34) 99904-7192	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7530	Leidiane Almeida Martins Ferreira	alfazemas.1401@gmail.com	(64) 99600-5320	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7531	Alessandro Sacramento	sacramentoslessandro12@gmail.com	(32) 99832-8059	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7533	Simone Cione	simonejfamiga@gmail.com	(32) 98858-3570	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7534	Amanda Espndola	espindolaamanda02@gmail.com	(48) 99175-9328	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7535	Gabriel	gabriel2021faria@gmail.com	(34) 99879-7043	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7536	Brbara Naves Lemes	barbarete1983@gmail.com	(34) 98439-6249	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7537	Eberval Silva Azevedo	eberval_silvaazevedo@hotmail.com	(27) 99513-7824	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7538	Vinicius Tefilo	viniciusteofilo26@gmail.com	(34) 9235-7669	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7539	Rafael Marques	rapha.marques16@hotmail.com	(34) 99708-1519	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7540	Paulla Laureano	paullapramos@yahoo.com.br	(38) 9990-7027	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7541	Eneide Justino	eneidemariajustinojustino@gmail.com	(18) 49635-9884	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7542	Poliane Tavares	polianetavares12345@gmail.com	(64) 9227-4302	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7543	Lorena Guimares	pereiralorena@hotmail.com	(34) 99962-8822	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-15 00:00:00	2025-02-15 00:00:00	\N	\N
7545	Robert Alan	robbison.junir725@gmail.com	(34) 99694-8118	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7547	Flvia Medeiros	flaviamedeiros97@gmail.com	(34) 99176-2881	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7544	Lucas Rodrigues	lucasfrodriguesvzp@gmail.com	(34) 99791-1676	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:41:28.752	2025-02-16 00:00:00	\N	\N
7548	Grazy Tibrcio	tiburciogracielle@gmail.com	(66) 99937-7449	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7549	Thiago J Santos	jsethia03@gmail.com	(79) 99155-3291	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7550	Robert Alan	thiagoemmanuelly00@gmail.com	(34) 99892-9754	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7515	Rene Moura	ramoura56@gmail.com	(34) 98408-3930	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7582	Ethyerryson Cunha Santos	santosmorriraeliene@gmail.com	(34) 99638-1304	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7583	Hiully Rodrigues	hiullyprodrigues@gmail.com	(34) 9145-4705	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7584	Alex Duarte	alexkadal@hotmail.com	(34) 9129-0703	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7586	Jose Roberto Lopes Silva	joserobertolopessilva7@gmail.com	(34) 9947-8393	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7587	Jos Carlos Bomfim Bomfim	zecarlosbomfim04@gmail.com	(34) 9304-7581	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7588	Leandro Antnio Da Silva	marieleoliveira432@gmail.com	(34) 99950-9622	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7589	Alzira de Campos Silva	alziracampos.s@outlook.pt	(34) 8427-2251	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7590	Eduardo Koyama	edu12jnnk54770@outlook.com	(34) 99992-2519	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7592	Ana Rita Silva	arsilva430@gmail.com	(34) 9200-3202	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7551	Patricia Mendes	pattykange15@gmail.com	(65) 99803-0647	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7593	Maria	marya82@hotmail.com	(34) 99138-8863	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7594	Efraim	eli-zena-santos@hotmail.com	(34) 9767-8814	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7596	Vilmara Medeiros	leoedeborah123@hotmail.com	(34) 99337-3861	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7552	Joao Victor	lluizaanjos29@gmail.com	(34) 8824-5670	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7597	Joo Pedro Fraissat Ramos	joaopedrofraissat@gmail.com	(34) 99120-4778	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7598	Sandro Jesus Silva	sandrojesus574@gmail.com	(34) 99283-1612	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7599	Danilo Pereira Rodrigues	olinda992128@gmail.com	(34) 99721-8408	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7600	z4mung4_blackk	pedrowevertonsantosreis15@gmail.com	(34) 99661-3596	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7601	Samuel Lucas	samuelllucas2004@gmail.com	(38) 99228-2588	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7602	Rmulo Souza	romulocarvalhodesouza21@gmail.com	(94) 98437-4586	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7603	Marcelo de Andrade	marceloandradejr@yahoo.com.br	(34) 99699-6936	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7604	Eduardo Portes	eduardogoncalvesyt@gmail.com	(34) 99182-4602	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7606	Jurandir Dias	jurandirdfilho@uol.com.br	(34) 98812-9862	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7591	valtemes ferreira Gomes	valtemesferreiragomes@gmail.com	(64) 98406-5260	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7553	Hellen Nunes	hellemgomes88006@gmail.com	(34) 99735-2709	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7554	Kamila Ribeiro	ribeiro_kamila_borba@hotmail.com	(34) 99636-3727	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7555	Juliano	deusejuliano@gmail.com	(34) 99711-9649	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7556	Rayane Benks	rayanebenks574@gmail.com	(34) 99275-6867	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7557	diogo	diogomarcal46@gmail.com	(34) 98824-0436	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7558	Duarte Marques  Advogado	duartebatistamarquesneto@gmail.com	(34) 99796-3627	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7559	Gabriel Da Silva Matias Roque	gabrielvr0911@gmail.com	(24) 98165-0621	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7560	Daniel Dias	danielprof201@outlook.com	(34) 99141-0254	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7561	felipe dias	felipecostadias26@gmail.com	(91) 98603-6716	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7562	Maelly Paiva	maellyxpaiva@gmail.com	(34) 99924-2449	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7563	Luziana Santos	luzianassilva2020@gmail.com	(34) 99930-9698	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7564	Milena Corteze	milena20bneto@icloud.com	(34) 99991-7587	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
7565	Mariana Amorim	marianaamorims@hotmail.com	(34) 99875-0008	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-17 00:00:00	2025-02-17 00:00:00	\N	\N
7566	Samir Nogueira de Figueiredo	rimasnf@yahoo.com.br	(34) 9675-4775	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-17 00:00:00	2025-02-17 00:00:00	\N	\N
7567	Stefani Ventura	svo1995@hotmail.com	(34) 99938-3481	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-17 00:00:00	2025-02-17 00:00:00	\N	\N
7568	Henrique Dias	henriquediasmachado17@gmail.com	(34) 8834-8614	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-17 00:00:00	2025-02-17 00:00:00	\N	\N
7569	Moises Silva	xuxamcs@yahoo.com.br	(34) 9667-6374	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-17 00:00:00	2025-02-17 00:00:00	\N	\N
7572	Edilene Mathias Rocha	edilenecorretora2@gmail.com	(34) 99764-9908	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7573	Lari Barbosa	enfalarissa.barbosa@hotmail.com	(34) 98899-8679	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7574	Tnia Cristina Machado Borges	taniacristina91@hotmail.com	(34) 98824-5404	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7575	Rosy Santos	leninhalpga2014@gmail.com	(34) 99186-0607	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7576	Thiago Martins	martinsthiagofla@gmail.com	(34) 99636-2095	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7577	Maria Martins	mariamariagah@gmail.com	(34) 99315-1569	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7578	Jose Humberto Nunes Nunes	josehumbertohmv38@gmail.com	(34) 99865-0104	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-19 00:00:00	2025-02-19 00:00:00	\N	\N
7579	John Galdames	jfgg316395@gmail.com	(34) 9811-7374	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7581	Carlos	andradebio@hotmail.com	(34) 99724-9413	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
8699	Lorrayne Martins	lorraynemartinsmatis@gmail.com	(34) 98834-9875	Facebook Ads	22	Sem Atendimento	\N	\N	t	553488349875@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491838446_24021489460770872_8840810014727563612_n.jpg?ccb=11-4&oh=01_Q5Aa1gGX1PPurVE1Z7pP_vgACrGniA6cAsiyouX0ml9UNJPnFQ&oe=68334AFA&_nc_sid=5e03e0&_nc_cat=104	2025-06-13 12:21:31.416	2025-05-15 18:25:46.597	\N	\N
7652	Michele Marlene dos dantis	mihgael21@gmail.com	(34) 99136-6008	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
8645	Anna Clara	asclaraleal@gmail.com	(34) 99777-4484	Importado	22	Sem Atendimento	\N	\N	t	553497774484@s.whatsapp.net	\N	2025-06-13 12:26:26.194	2025-05-12 00:00:00	\N	\N
7609	Kel_villar	hewellynketherin@outlook.com	(82) 99689-9592	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7610	Antnio Borges de Freitas	tunicofreitas@yahoo.com.br	(34) 9968-7462	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7611	Daniel	barbosa.danyel@hotmail.com	(71) 98630-3778	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-23 00:00:00	2025-02-23 00:00:00	\N	\N
7612	Gabrielle	thayronlima606@gmail.com	(63) 99964-4280	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-25 00:00:00	2025-02-25 00:00:00	\N	\N
7613	Liara	liarafaria4@icloud.com	(34) 99684-7703	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7615	Alison Sena	alisommsena@gmail.com	(91) 99943-1769	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7616	Ana Carolina	anacarolina_olis@hotmail.com	(34) 99199-2022	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7617	Quesia Souza	quesia.souusa@gmail.comq	(34) 99863-0963	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7618	Rafael Cruz	jonathan.raf96@gmail.com	(34) 99110-1848	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7619	Alessandro Ferreira	alessandroferreira_23@hotmail.com	(34) 9970-7188	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7620	Lus Fernando	fernando.bezerra11@hotmail.com	(34) 98417-4874	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7621	Roberto Liberato	roberto.liberato@hotmail.com	(34) 98407-2404	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7622	Fran Oliveira	oliveiramf198930@gmail.com	(34) 99162-7101	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7623	Diogo Morais	diogomoraispqs@gmail.com	(34) 99134-9744	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7624	Paloma Rodrigues	paullonagatinha@gmail.com	(34) 99143-8625	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7625	Kauhanny Vitria	kauhannyvitoria18@gmail.com	(34) 99647-9501	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7627	Diully Botelho	diuly.lorr@gmail.com	(34) 99238-8135	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7608	Geovanna Silva	silvageovanna1711@gmail.com	(34) 99966-3289	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7629	Bruno Blancato	bblancato@gmail.com	(34) 98878-9187	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7630	Bruna Mell	brunamellmendesrocha@gmail.com	(34) 99878-6901	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7631	Marie Asuaje	azuaje956@gmail.com	(34) 99738-3154	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7633	Junior Faleiro	ajfaleiro@hotmail.com	(32) 98701-9376	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7628	Leonardo ferreira	leonardoferreira8642@gmail.com	(16) 99996-9145	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7634	Jonatas Mariano Andrade	jonatasmariano492@gmail.com	(34) 99153-2999	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7635	Wilton Amaral DIas	wiltonadias@gmail.com	(34) 9194-5608	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7638	Emerson silva	e9917@icloud.com	(34) 99860-4214	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7639	Delcimar Ferreira dos Santos	delcimarlol@gmail.com	(34) 9868-5512	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7637	Carolaine Silva	carolaine_3d@hotmail.com	(16) 98830-8396	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7640	Millene Moura	millenesilvaalvesdemoura@gmail.com	(34) 9679-1624	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7641	Leandro Fernandes	frleandro641@gmail.com	(34) 99318-4166	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7642	Alessandra Picciguelli	picciguelli_11@hotmail.com	(34) 99152-0511	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7643	Eduardo Augusto Muniz	eduardoamcar@icloud.com	(34) 99777-2841	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7644	Edison Miguel Rodrigues	edisonmiguelrodriguesdeassunca@gmail.com	(34) 9111-9139	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7645	Daniel Vicente	danielvicente421@gmail.com	(82) 9805-0747	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7646	Helena Malaquias	malaquiaslhs@hotmail.com	(34) 99181-6621	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7647	Flvio Tiago	flaviotiagoir@outlook.com	(34) 99129-1411	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7649	Ana Paula Paulinha	anaziliott4@gmail.com	(13) 99763-8374	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7650	Kilderyh Cavalcante	kemellycavalcante25@gmail.com	(92) 99301-6595	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7626	Cris Lima	raianepira@hotmail.com	(38) 9815-6300	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
8296	Viviane Neves de Castro	vivianeneves741@gmail.com	(34) 99131-9288	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8297	Barbara Pricinoti	barbara.pricinoti@hotmail.com	(34) 99771-0502	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8299	Eduarda Nascimento	en926078@gmail.com	(34) 99341-6006	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8306	Adna Dantas	adna.dantas93@gmail.com	(84) 98834-5897	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-14 00:00:00	2025-04-14 00:00:00	\N	\N
7657	Laih Menezes	laicarmo15@gmail.com	(34) 98447-0800	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7658	Lauane	lauanelalazita@hotmail.com	(34) 99898-3833	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7659	Munique Alves	munivicalves@gmail.com	(34) 99689-2413	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7660	Thamiris	thamirismyrdosreis@gmail.com	(34) 99113-3283	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7662	maria arlete sartori	arlaetearlete799@gmail.com	(47) 99718-1327	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7669	Las Estevo Moraes de Oliveira	mzsacfhytjgi@hebmails.com	(15) 99680-7009	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7670	Valquiria Fatima	valquiriadefatimasouza0@gmail.com	(38) 99953-9651	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7671	Sarah Farias	sarahfariassilva9@gmail.com	(34) 99174-3017	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7672	Raquel Antonieta Rodrigues	raquelantonietarodriguesantoni@gmail.com	(34) 98721-1761	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7673	Julia	julianobrepereira42@gmail.com	(34) 99960-7814	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7674	Eduardo 46	eduardoelias2517@gmail.com	(34) 99132-6091	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7675	Jocasta Cristiane	jocristianeassis@gmail.com	(34) 99762-3729	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7676	Emyy_Lilila	mariaemiliafs2015@gmail.com	(34) 99651-3790	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7677	Mnica Pessoa Barcelos	monicapessoabarcelos@gmail.com	(99) 9104-7595	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7678	Gabrielh367	gabrieldasilvasousa439@gmail.com	(34) 99168-4526	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7679	Ernesto Silva	nestim13@gmail.com	(34) 99134-0520	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7680	Elizamara Loureiro Martins	elizamara.martins3012@gmail.com	(92) 99413-2557	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7681	Israel Damasceno	israel.barbosa2401@icloud.com	(35) 99748-4665	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7682	Erick Alcntara	erickalcantara35@gmail.com	(34) 9881-5574	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7683	Cleber Martins Silva	clebermartinssilva40@gmail.com	(34) 99324-5977	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7684	 Juliano  Ubersystem 	juliano.carneiro@ubersystem.com.br	(34) 99867-7227	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7685	Doug Caval	dougcaval.reis@gmail.com	(34) 99836-0023	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7688	Thales Henrique	th937290@gmail.com	(34) 99924-6543	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7689	Tiago Faleiros	tiagofaleirosilva@gmail.com	(34) 99243-2016	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7690	Juliana Almeida	julianasantana6@hotmail.com	(61) 98205-0105	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7691	Pedro	pedropaulobritom@gmail.com	(34) 99683-5757	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7692	Ozaira Lago	annamellaggo2@gmail.com	(64) 99675-6499	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7693	Ruan Garcia	ruan.pedro414@gmail.com	(34) 99891-7530	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7694	Fernandes7e7	elianafreiitas03@gmail.com	(38) 99812-0142	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7653	Gustavo Lopes	luislopes052005@gmail.com	(34) 99107-0529	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7654	Joo Paulo Araujo	araujojoaopaulo566@gmail.com	(34) 99867-9476	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7655	Ana Beatriz Fabiano de Souza	anasouzabeatriz2002@gmail.com	(34) 99710-3413	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7663	nay	eg5697752@gmail.com	(97) 98102-6847	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
8674	Ilda Rezende	ildarezende@bol.com.br	(34) 99895-1058	Facebook Ads	23	Sem Atendimento	\N	\N	t	553498951058@s.whatsapp.net	\N	2025-06-13 12:23:47.051	2025-05-14 22:14:47.822	\N	\N
8638	Geova Lacerda	jeovaimoveis2@gmail.com	(64) 98123-0439	Importado	23	Sem Atendimento	\N	\N	t	556481230439@s.whatsapp.net	\N	2025-06-13 12:27:04.795	2025-05-12 00:00:00	\N	\N
8629	Mateus cardoso	novomateusfinance@gmail.com	(34) 99185-7698	Importado	23	Sem Atendimento	\N	\N	t	553491857698@s.whatsapp.net	\N	2025-06-13 12:27:53.935	2025-05-11 00:00:00	\N	\N
8543	Maryaah Oliveira	oliveiraferreiramariapaula94@gmail.com	(34) 9898-7354	Importado	23	Sem Atendimento	\N	\N	t	553498987354@s.whatsapp.net	\N	2025-06-13 12:35:42.612	2025-05-05 00:00:00	\N	\N
7667	Renan	renanvribeiro@hotmail.com	(34) 99284-0626	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
8468	Junior Figueiredo	armantefigueiredo@hotmail.com	(34) 99122-5499	Importado	23	Sem Atendimento	\N	\N	t	553491225499@s.whatsapp.net	\N	2025-06-13 12:42:29.813	2025-04-27 00:00:00	\N	\N
8525	Saulo Oliver	saulotiago2011@hotmail.com	(34) 99659-8816	Importado	23	Sem Atendimento	\N	\N	t	553496598816@s.whatsapp.net	\N	2025-06-13 12:37:21.309	2025-05-04 00:00:00	\N	\N
7699	Romilda Martins Arruda	romildamarruda@gmail.com	(34) 98833-2009	Importado	22	Visita	\N	14	\N	\N	\N	2025-05-14 15:37:25.045	2025-03-08 00:00:00	\N	\N
8446	Matheus Ribeiro	teteusrib@hotmail.com	(34) 99678-3042	Importado	23	Sem Atendimento	\N	\N	t	553496783042@s.whatsapp.net	\N	2025-06-13 12:44:29.617	2025-04-24 00:00:00	\N	\N
8427	Pedro Paulo Nacarato	pedropaulo@segimob.com	(11) 99780-5864	Importado	23	Sem Atendimento	\N	\N	t	5511997805864@s.whatsapp.net	\N	2025-06-13 12:46:13.541	2025-04-23 00:00:00	\N	\N
8509	Ingride Lima	ingridlimaa012@gmail.com	(98) 98501-6630	Importado	23	Sem Atendimento	\N	\N	t	559885016630@s.whatsapp.net	\N	2025-06-13 12:38:47.848	2025-05-01 00:00:00	\N	\N
7695	Maria Amparo	ma3706671@gmail.com	(34) 99834-0417	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7696	Eliete Abadia	elieteabadia22@gmail.com	(34) 99249-4780	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
8399	Igor Rodriguess	igorroh04@gmail.com	(38) 98434-9102	Importado	23	Sem Atendimento	\N	\N	t	553884349102@s.whatsapp.net	\N	2025-06-13 12:48:46.064	2025-04-22 00:00:00	\N	\N
7697	Claudionor Almeida  Design  Motion	claudionor.alm@outlook.com	(34) 99667-0534	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7698	Pedro Alves	pedroalveskiz97@gmail.com	(34) 99936-8093	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7700	Elessandra	elessandrafernandes154@hotmail.com	(34) 99839-9810	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7666	Joo Gabriel	joaogabrielteles65@gmail.com	(34) 99927-2352	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7701	Lavinia Morais	laviniabarbosademorais1703@gmail.com	(34) 99194-9151	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7702	giloliveira33	gilvanalves103@gmail.com	(34) 99723-4428	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7732	rika Nunes	erikanunes301@gmail.com	(34) 9253-1438	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7733	Mariana Barbosa	marianabarbosinha123@hotmail.com	(64) 98418-1559	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7734	Carlos Silva	carlossilva190259@gmail.com	(13) 99107-7529	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7738	Priscilla Nascimento	npriscila525@gmail.com	(34) 99334-8182	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7739	Madu	madusouzaaraujo574@gmail.com	(34) 99699-3723	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7723	Flavio Belisario da Silva	santanafunilaria95@gmail.com	(34) 9692-5915	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7740	Paulo reis	pauloreisoffc@gmail.com	(34) 99663-4736	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7736	Tatiana Maria Campos	tatianabianchini2011@hotmail.com	(34) 99106-4140	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7742	Maria Clara	mariiasilvadesign@gmail.com	(34) 99207-5669	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7743	tais Cipriano	oliveiratais118@gmail.com	(64) 99270-0678	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7744	Wallace Martins De Souza	wallace.martins.souza@gmail.com	(34) 99975-3084	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7745	Kelly Araujo	hakellysaraujo@gmail.com	(34) 99831-0706	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7746	Adriana Silvaah	adrianalucas.2025@gmail.com	(64) 99305-6535	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7747	Raquel	raquel_781@famanegociosimobiliarios.com.br	(62) 9823-3512	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7748	Romilda Martins	romilda_martins_782@famanegociosimobiliarios.com.br	(34) 9883-3200	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7754	Anderson	anderson.arm765@gmail.com	(27) 99907-1075	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7755	Rayssa	oliveirarayssa217@gmail.com	(34) 99666-4969	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7757	Genilda Silva	genildademeneses@hotmail.com	(64) 9944-4454	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7759	Whenderson 	whendersonribeiro515@gmail.com	(34) 99158-2206	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7760	Joo Carlos Mello	jcmello0@gmail.com	(14) 98126-8513	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7762	Leticia	leticia_796@famanegociosimobiliarios.com.br	(91) 9819-8651	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7758	Laura Arduini	lauraarduiniroriz@gmail.com	(34) 99636-7639	Importado	22	Visita	\N	14	\N	\N	\N	2025-05-14 15:25:22.883	2025-03-11 00:00:00	\N	\N
7763	Paula Beatriz	paula_beatriz_797@famanegociosimobiliarios.com.br	(34) 9842-0304	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7765	Antonia Aparecida	antoniavidaloko1533@gmail.com	(34) 99794-7364	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7766	Liryanne Munis	liryanneaparecida@gmail.com	(34) 99964-6144	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7767	yasmin3	yasminlinda89393@gmail.com	(34) 99241-5232	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7768	Gabriela Luiza	gabrielaluiza1233@gmail.com	(34) 99220-1894	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7769	Hb Lele HELENICE BOESCHENSTEIN	hbtauanda@yahoo.com.br	(34) 3234-5797	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7770	Maria De Lourdes Marcelina Teixeira	mmarcelinateixeira52@gmail.com	(34) 99235-1725	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7771	Anne Kaeley Amaral Barbosa	kaeleyanne3@gmail.com	(34) 9994-9550	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7772	Roberto Lopes de Sousa	rorobertojunior2229@gmail.com	(34) 3224-5156	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7773	Gabriella Luisa	gabriellaluisa41@gmail.com	(34) 99170-2631	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7774	Simone Oliveira	simone_edymais@hotmail.com	(69) 99973-3738	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7775	Samuel Cordeiro	samuelcordeirosantoss15@gmail.com	(34) 99734-7194	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7782	Geovanna Gonalves	geovannageogoncalves12@gmail.com	(34) 9843-1293	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7783	Mari	mariellymedeiros1@gmail.com	(34) 99863-1212	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7784	Estacionamento Renato Estela	renatoantoniomartins26@gmail.com	(35) 98866-0072	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7785	Emilly	emillypereirasantos26@gmail.com	(38) 99725-6665	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7786	Daniel Domenes	danieldomenes3@gmail.com	(13) 98862-5755	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7787	Gabriel de Oliveira	gabriel75oliveira@gmail.com	(34) 99232-0902	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7788	Gabriele	gabriele_822@famanegociosimobiliarios.com.br	(34) 9915-6599	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7789	Submerged Girl	rosana-medeiros1975@hotmail.com	(34) 99141-1252	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7791	Matheus Cassimiro	matheusscassimiro@gmail.com	(34) 99321-4992	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7776	Luana Ferreira Cassimiro	luannaaa@live.com	(69) 99277-9012	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7792	Daniel Tavares	tavaresxtdanniels@gmail.com	(34) 98897-2437	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7793	Jos Divino Jr	ijuninh@gmail.com	(34) 99872-8366	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7795	Carlos Pinheiro	casouzapj@gmail.com	(92) 98145-0252	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7796	Dailson silveira Alves	dailson201169@hotmail.com	(34) 99267-4515	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7797	Sheylla Cristina	sheyllacristinaae@gmail.com	(34) 99923-1076	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7798	Reinaldo Adelinodesouza	reinaldoadelino2023@gmail.com	(16) 98180-3148	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7799	arthurferreiradesouza	arthurferreiradesouza1@gmail.com	(34) 99186-0217	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7800	Kaik Souza	deusj9910@gmail.com	(38) 99879-3643	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7801	Walysson Mendes	walysson_mendes@hotmail.com	(34) 99139-5171	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7802	Kaio Macedo	kaiomacedo80@gmail.com	(34) 99810-7122	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7804	Cristiane Rochael	cristiane_rochael_838@famanegociosimobiliarios.com.br	(34) 9930-3476	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7777	ana vitoria nascimento freitas	anavitnf@gmail.com	(34) 99775-8989	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7805	Thayn Santos	nathanpatricio982@gmail.com	(34) 99109-1541	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7806	Aparecida Mariashiva	msilva56626@gmail.com	(32) 99938-7350	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7807	Marco Antonio Lima Meireles	meirelesmarco22@gmail.com	(31) 9504-0235	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7809	Kelly Melo	kellygaby2929@icloud.com	(34) 99335-6627	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7803	Cristiane Rochael	crisrochael@outlook.com	(34) 99303-4761	Importado	22	Agendamento	\N	14	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7810	samuel borges	gontijosamuel20@gmail.com	(34) 99941-1022	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7811	Fabio Mendes dos Santos	fabios8antosmendes66@gmail.com	(34) 9670-8144	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7812	Fernando Dos Santos	fernandomonteiro1215@gmail.com	(38) 9848-2869	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7814	Trumpet Rafael Souza	rafaelsouzatrumpet@gmail.com	(32) 98802-9884	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7815	Carlos Henrique Alves de brito	carlosbrito0767@gmail.com	(34) 9792-1653	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7816	Gledson Ferreira	gledsonnnt@gmail.com	(34) 99877-5952	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7817	Elizabeth Rodrigues Rodrigues	elizabethrodrigues060580@gmail.com	(34) 99838-1596	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7818	Simone Alves	simone__alves@hotmail.com	(34) 99997-0201	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7819	Priscilla Rafaela	rafaelapriscilla02@gmail.com	(34) 99860-0363	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7820	Fabio Mendes dos Santos	fabios8antosmendes66@gmail.com	(34) 9670-8144	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7821	Josu Lucas	josuemoreiralucas@gmail.com	(34) 98879-0072	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7823	Pedro Henrique Maia	pedrohbmaia@gmail.com	(34) 99718-9469	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7778	????????????	vieiray917@gmail.com	(34) 99859-7572	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7824	Leonardo Ferreira	leonardo.ff0512@icloud.com	(34) 99273-5412	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7825	Amadeu Mendes	amadeumendes59@gmail.com	(34) 99917-0676	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7826	Ray Rodrigues	rayllanebryenna@gmail.com	(34) 99652-4216	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7827	Edinho Ramos	moveis_edi@hotmail.com	(34) 8802-3979	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7829	Poliana Araujo	polly777@hotmail.com	(34) 99631-9929	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7781	Simone Oliveira	simone_edymais@hotmail.com	(69) 99973-3738	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7830	Trumpet Rafael Souza	rafaelsouzatrumpet@gmail.com	(32) 98802-9884	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7790	Cadu Santos	carloseduardosantos209@gmail.com	(34) 99699-4578	Importado	13	Venda	086.947.596-75	17	\N	\N	\N	2025-05-15 16:31:15.994	2025-03-13 00:00:00	\N	\N
7808	Maria Tereza Vilela	desertpratas@gmail.com	(34) 99740-6168	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 15:07:08.577	2025-03-14 00:00:00	\N	\N
7703	Jackson Araujo	jacksonaraujo2099@gmail.com	(34) 99165-2058	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7704	Alzira de Campos Silva	alziracampos.s@outlook.pt	(34) 8427-2251	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7705	Eduarda Alves	duda_gabil@hotmail.com	(34) 99173-3566	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7750	Mary S	maria.333slpsousa123@gmail.com	(34) 99720-9399	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7751	An Dr	spanfer@gmail.com	(34) 99981-2526	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7749	Tiago	tiago_783@famanegociosimobiliarios.com.br	(34) 9870-2334	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:38:38.363	2025-03-10 00:00:00	\N	\N
7752	Sergio Neto	serginetoapp07@gmail.com	(34) 99137-3065	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7942	Duda Prado	dudaprado14@gmail.com	(38) 99853-3871	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7737	Leticia	ls3708820@gmail.com	(91) 98198-6512	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7842	 n	vj2902851@gmail.com	(81) 98745-0342	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7859	Evandro Nascimento	e@gmail.com	(34) 99964-4723	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7860	Luanna Rodrigues	luannakellen06@hotmail.com	(34) 98430-4278	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7833	LUSMARA BATISTA SILVA BERNARDES	bernardesandre1969@gmail.com	(34) 99185-0270	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7834	Mila Morena	milaandresilva12345@gmail.com	(34) 99802-9793	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7835	Selma Maria de Souza	selmamariarodarte@hotmail.com	(99) 8917-2622	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7836	???????????????? ????	mariellypassos80@gmail.com	(34) 99897-0502	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7838	Ana Clara Incio Leite	anaclaraileite@gmail.com	(34) 99861-9544	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7832	Walber Ribeiro Sousa	walberwalberribeirosousa@gmail.com	(34) 99885-4762	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7839	Ricardo	assisricardoleandro@gmail.com	(34) 98429-5776	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7840	Leonardo	leo92335401@gmail.com	(67) 99233-5401	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7841	Lucivaldo Silva	lucivaldosilva0702@gmail.com	(34) 99888-3424	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7844	Zez Maria	maria.teofilo0657@gmail.com	(11) 95045-5074	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7845	Paty Santos	patriciasguimaraess@gmail.com	(64) 98445-8327	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7846	Jssica Rezende	jessicarezende258@gmail.com	(34) 99119-4574	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7847	Jania Aparecida Silva Chagas	jania.agatha2018@gmail.com	(64) 9801-2003	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7850	Ligia Aquino	ligia11aquino@gmail.com	(77) 99851-2968	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7851	Mayara Deodato	m.d.estacio@uni9.edu.br	(11) 95403-5472	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7853	Alex Julian Singer	alex_julian2005@hotmail.com	(34) 99645-6927	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7854	Jlia	juliamenorzinha007@gmail.com	(34) 9155-5224	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7855	ARTHUR ARAJO	arthuraraujogon13@gmail.com	(38) 99205-7976	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7856	Thaynara Aparecida	thaynaraaparecida2013@hotmail.com	(34) 99240-7047	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7857	Weslhysson Gleydson Raimundo fernandes	kendrioalef@gmail.com	(93) 99126-5703	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7858	Laura Alcantara	lauramalcantara@hotmail.com	(34) 99257-5747	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7852	Marliin Sousa	iphonemarlon0@gmail.com	(34) 99631-2294	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7869	Thaynara Aparecida	thaynaraaparecida2013@hotmail.com	(34) 99240-7047	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7870	Weslhysson Gleydson Raimundo fernandes	kendrioalef@gmail.com	(93) 99126-5703	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7871	Evandro Nascimento	e@gmail.com	(34) 99964-4723	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7872	Luiz Marcos	luizlt15@hotmail.com	(34) 9678-5267	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7873	Sandy	sandy-pereira2011@hotmail.com	(77) 99924-4734	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7874	ISADORA	imperio.isadora@gmail.com	(34) 99764-4240	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7875	Eduardo Ferreira	edufsilva2002galo@gmail.com	(34) 99642-0694	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7876	Ana Jlia	anajulia17tatin@gmail.com	(34) 99964-3019	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7877	Jonatas Pereira	jonataspereirap055@gmail.com	(34) 99113-4276	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7878	joseilson Nunes de Arajo	nunesjoseilson7@gmail.com	(34) 99862-4865	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7880	Elaine Borges Pires	elaineborges_03@hotmail.com	(34) 9630-8224	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7881	Jlia	juliamenorzinha007@gmail.com	(34) 9155-5224	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7884	Ncolas Carvalho	nickecarvalho09@gmail.com	(34) 99216-0324	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7885	Maria Klara Bononi	maria.kbononi@gmail.com	(34) 9861-8822	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7886	ISADORA	imperio.isadora@gmail.com	(34) 99764-4240	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7849	Leticia Nunes	leticianunes3708@gmail.com	(34) 9121-8388	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 15:23:47.747	2025-03-17 00:00:00	\N	\N
7883	José  Neto	joseanisio720@gmail.com	(34) 99993-3562	Importado	22	Visita	\N	14	\N	\N	\N	2025-05-14 15:18:54.889	2025-03-17 00:00:00	\N	\N
7706	Aline Santos	alinefguto@hotmail.com	(34) 99208-1794	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7707	Lenir Souza	lenirdesouza@hotmail.com	(34) 99282-2267	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7708	Renato Santos	renatoeugenio2@outlook.com	(34) 99774-1370	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7837	Dra Thamyres Andrade	thamyresborges06@gmail.com	(34) 98876-0958	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7901	Dai Santos	ds217carvalho94@gmail.com	(34) 99806-6845	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7908	Rubens da Silva Belmiro	rubensbelmiro@gmail.com	(34) 9640-5922	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7909	filho	vitinhomiller@hotmail.com	(47) 99158-1805	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7911	Douglas reis	douglasbisporeissilva@gmail.com	(31) 98581-2728	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7934	Lu Cacau	lu_cacau_968@famanegociosimobiliarios.com.br	(34) 9988-8048	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7935	Fernanda domiciano barbosa	fernandinha.domicianobarbosa@gmail.com	(34) 98425-5238	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7936	Diego Miranda	diegomirandadossantos15@gmail.com	(34) 99696-7434	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7937	Larissa Rodrigues	larirodrigues4815@gmail.com	(31) 97155-6431	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7938	Isabela Dutra	isabella.dutrac@gmail.com	(31) 98850-4708	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7939	Jason 	jasonkaro@hotmail.com	(34) 99167-4329	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7940	Daniela Leao Rodrigues	danielalrodrigues63@gmail.com	(34) 99645-2308	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7941	Thayna Alves	thaynaavom@gmail.com	(31) 98818-0783	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7904	Nilton Neto	niltonindi@gmail.com	(34) 99116-4221	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7943	Gessica Amaral	gessikacaroline12@gmail.com	(34) 99992-6226	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7889	bruna	brunaraphaelaemachado@gmail.com	(38) 99832-2076	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7890	Kyohane Maria do Rosrio	kyohane100@gmail.com	(34) 9118-4492	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7891	Felipe Rodrigues Mendes Dos Santos	feliperodriguesmendesdossantos@gmail.com	(34) 99886-9011	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7892	Dai Santos	ds217carvalho94@gmail.com	(34) 99806-6845	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7893	Alexandre Caetano	xandaopinturasereformas@gmail.com	(34) 9166-0340	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7894	Wellington Sobrinho	wellingtonudi@hotmail.com	(34) 98402-7521	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7895	Matheus Brilhante	brilhantematheus73@gmail.com	(34) 99137-9760	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7896	Romy Carla	romycarlavieira@gmail.com	(34) 99671-6006	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7897	soares	laisrafaely17@gmail.com	(34) 99130-3656	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7898	carol lisboa	eu.carolls0@gmail.com	(34) 99337-4163	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7899	Lais Margarida do Nascimento	lais17692009@gmail.com	(55) 6480-1831	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7900	Alexsandro de Souza Nunes	sandro.nunis001@gmail.com	(34) 9681-7686	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7888	Emily Karolayne	carolayneemily765@gmail.com	(34) 99243-5766	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7912	Ellen Karla Silva Batista	ellensilva.md@gmail.com	(34) 9888-3394	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7913	Lypi Assis	felypegheord155@gmail.com	(34) 99142-0349	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7914	ty_willian	js7526735@gmail.com	(34) 98827-1436	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7915	ana julia	cavalcanteanajulia63@gmail.com	(34) 99893-2385	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7916	Everson	eversongustavonunes1@gmail.com	(34) 99981-0088	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7917	Creusa Dias Pereira de Oliveira	creusadias2011@hotmail.com	(33) 98826-1999	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7918	Jheymes Braga	jheyminhobraga@gmail.com	(34) 99715-3165	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7919	Wender Fernandes	wender.inter@bol.com.br	(34) 9660-2994	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7920	Guilherme Henrique	guilhermehenrique1908dss@gmail.com	(34) 99672-2090	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7921	Giovana Castro	giovanamartinscastro323@gmail.com	(34) 98891-8791	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7922	Diogo Pinheiro Junio	diogojunio358@gmail.com	(31) 99113-6268	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7923	Estefanie Aparecida	estefanie07almeida@gmail.com	(31) 99505-4218	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7924	Rayane Isabella	rayaneisa1803@gmail.com	(37) 99873-5413	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7925	Sophya Rodrigues Arajo	astrogildo.marques.ar@gmail.com	(34) 99697-6859	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7928	Vinicius Duque	biaduque28@gmail.com	(37) 99957-9697	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7929	Beatriz Gonalves	beatrizlimagoncalves@gmail.com	(31) 99542-1092	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7931	Ronylson Almeida	ronymarcosantos@gmail.com	(37) 99669-1038	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7932	Ronaldo Lopes	rvlopes10@yahoo.com.br	(31) 99842-5185	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7933	Jeferson Carlos	jcgameplay939@gmail.com	(34) 99227-8757	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7710	Graziele SanttoOs	grazielesoliveira99175@gmail.com	(79) 99641-6638	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7711	Kevin Soares Silva	callinksuperdigital@gmail.com	(34) 99201-3812	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7712	Matheus Paulo	matheuzinho.bonitao@gmail.com	(34) 98434-5158	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7713	Ana Jlia Neves	anajulianeves2019@gmail.com	(34) 99671-0973	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7714	Maria Das Dores Santos da Silva	santosmaria90601@gmail.com	(11) 93343-1654	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7966	Aline Simim	alinebh32@hotmail.com	(31) 99333-5337	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7967	Ronandir	ronandir@yahoo.com.br	(37) 98832-3202	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7971	Daguia Pereira	daguiapereirarodrigues@gmail.com	(31) 98912-3681	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7972	Matheus Luan	luizcarlosassissantos@gmail.com	(34) 98837-2004	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7973	Elisangela Baracui	lisabaracui@gmail.com	(34) 98889-9448	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8581	eduardo	canaleduxff@gmail.com	(99) 98527-4499	Importado	13	Sem Atendimento	\N	\N	t	559985274499@s.whatsapp.net	\N	2025-06-13 12:32:15.658	2025-05-08 00:00:00	\N	\N
7983	Josenoe Pereira	josenoepereira8@gmail.com	(34) 99647-1752	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7984	R2 GAS	r2gas.venda@gmail.com	(34) 99159-2124	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7985	Lorena Souza	lorenaslf@hotmail.com	(38) 99166-0183	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7987	Lusa Guilhermina Targino	targinogui@gmail.com	(34) 99722-1669	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7988	Rosanna Euqueres	rosanna21euqueres@gmail.com	(64) 99342-5579	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7989	Maria Luiza Arajo	marialuiza2005araujo@icloud.com	(34) 99260-8165	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7990	Thell Henrique	nathanael123@hotmail.com.br	(34) 99774-7391	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7991	Luiz Gustavo	luiizgusta1305@gmail.com	(34) 98853-9959	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7992	Jssica Souza	jessicasouzaa003@gmail.com	(34) 9799-6044	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7993	Peas infantil	geovanaanagi@gmail.com	(37) 98802-9050	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7994	Kdu	kdu_1028@famanegociosimobiliarios.com.br	(31) 9993-8906	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7995	Warley	warley.mottaoliveira@gmail.com	(31) 99640-8401	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
7996	Joab Amaral	joabamaral901@gmail.com	(37) 99993-9244	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
7997	Lays	layscristina2021@gmail.com	(34) 99127-2161	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
7998	Ceidy Cunnha	ceydegoncalves69@gmail.com	(34) 99690-8464	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
7944	Guilherme Colares	colaresguilherme@gmail.com	(34) 99728-2903	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7945	Larissa Vitria	lv5430114@gmail.com	(31) 97209-7350	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7947	Larissa Rodrigues	larirodrigues4815@gmail.com	(31) 97155-6431	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7948	Sabrina Duarte	sabrinaduarte9410@gmail.com	(34) 99960-0418	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7949	Duda Prado	dudaprado14@gmail.com	(38) 99853-3871	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7950	Lavinia F Martins	laviniafm03@gmail.com	(34) 99944-3904	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7951	Wallisson Oliveira	wallisson1938@hotmail.com	(73) 9854-8111	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7952	Ashley Barbosa	ashley.28.guedes@gmail.com	(38) 99750-2079	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7953	Ronan Santos	sronan103@gmail.com	(34) 99115-9887	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7954	rica Martins	ericap.martins18@gmail.com	(34) 98422-1176	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7955	Larissa Rodrigues	larirodrigues4815@gmail.com	(31) 97155-6431	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7956	Joaneci Pereira	joanecipereiradossantos@gmail.com	(34) 99897-1017	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7957	loryqueiroz	lorenafaifferdc109@hotmail.com	(34) 99693-1567	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7958	Gabriel Silva	gabrielvieiradasilva2021@outlook.com	(38) 99998-7862	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7959	Lavinia F Martins	laviniafm03@gmail.com	(34) 99944-3904	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7960	gyan	gyancipri13@gmail.com	(31) 99727-5233	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7961	Juliana Santos	julianaapmorais86@gmail.com	(34) 98425-0363	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
7962	Kailane Gomes	kailanegomes0312@gmail.com	(99) 9219-2727	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7963	R2 GAS	r2gas.venda@gmail.com	(34) 99159-2124	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7964	Lorena Souza	lorenaslf@hotmail.com	(38) 99166-0183	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7979	Beatriz Xavier 	beatrizx604@gmail.com	(34) 99645-3220	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7982	Felipe Costa	filinpincirco@hotmail.com	(31) 99243-4958	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7986	Ana Flvia	anaanjospx07@icloud.com	(38) 99105-3802	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 16:03:19.49	2025-03-21 00:00:00	\N	\N
7715	Kezia X Iran Vicent	oliveirakezia74503@gmail.com	(34) 99838-4514	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7968	Luis Fernando	nando-fut@hotmail.com	(34) 98442-6533	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8002	Cristiani Campos	cristianicampos@hotmail.com	(34) 99230-9223	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8003	Devai Martins	devai.martinssouza@gmail.com	(31) 9940-9361	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8004	Natosilva Silva	silvaraimundononatodasilva88@gmail.com	(16) 98807-1823	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8005	Daniel Souza	danielsouzaah00987@gmail.com	(64) 99999-3562	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8006	renan	renanpivetecx@gmail.com	(31) 98978-1928	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8007	Isadora Ribeiro	isadoraeranyer@gmail.com	(34) 8440-8322	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8008	Fabricio Ribeiro	fabricioribeiro1541@gmail.com	(34) 9965-1283	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8009	Kailer Santos	kailersantos131@gmail.com	(34) 99193-7030	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8010	Henrique leite	henriqueleite22@icloud.com	(34) 98400-5181	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8001	Juliene Almeida	julielua@gmail.com	(34) 99126-5237	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8032	Amanda Maria	amandamaria.pereira1718@gmail.com	(34) 99998-6724	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8033	Nathalia Alves	nathaliapatricia8586@gmail.com	(37) 98838-0160	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8034	Daniela Lopes	daniela981150143@gmail.com	(31) 98115-0143	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8035	italo Lima Barbosa	italo34993353658@gmail.com	(34) 99335-3658	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8036	Micaela Brito	micaelabrito699@gmail.com	(31) 98464-7429	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8037	Belchor Garcia	belchorgarcia@gmail.com	(34) 99667-3686	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8038	Demetrios Carlos	demetrioscarlos1@gmail.com	(37) 99952-8245	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8012	Higor Sousa	higoralbinodesousa@gmail.com	(37) 98852-8387	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8013	Yasmim Soares	yasmimsoarersilva07@gmail.com	(38) 98417-6575	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8014	FLOR DE ALECRIM  VAZANTE MG	vick_rbd10@hotmail.com	(34) 99797-2599	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8015	Camila Fernandes	camilaffs19@hotmail.com	(37) 99974-0498	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8016	kduzada	ce7453129@gmail.com	(34) 99762-2350	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-24 00:00:00	2025-03-24 00:00:00	\N	\N
8017	 ss	dani.jetlee@hotmail.com	(61) 98119-9979	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-24 00:00:00	2025-03-24 00:00:00	\N	\N
8018	Victor	victor_1052@famanegociosimobiliarios.com.br	(81) 9874-5034	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-24 00:00:00	2025-03-24 00:00:00	\N	\N
8019	�gata	_gata_1053@famanegociosimobiliarios.com.br	(11) 9451-8088	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-25 00:00:00	2025-03-25 00:00:00	\N	\N
8021	Julia Parice	juliaparice@gmail.com	(11) 95868-0910	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8022	Vitania Alves	vitania111@hotmail.com	(34) 99144-6220	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8023	Valnirene Lima	valnirenesilva@gmail.com	(34) 99776-8310	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8024	Dayla Waltrick	daylawaltrick7@gmail.com	(41) 99898-4979	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8025	Nathalia Alves	nathaliapatricia8586@gmail.com	(37) 98838-0160	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8026	Nayara Baro	nana_nascimento2012@hotmail.com	(34) 99774-4448	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8027	MAGNA MAGALHES  CLIOS  CURSOS BH	magmagalhaes91@gmail.com	(31) 99214-9490	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8028	Joao Quirino	jquirino863@gmail.com	(37) 98840-2794	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8029	Rick Frana	rickffoliveira@gmail.com	(31) 99685-3191	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8030	lara	larahitta16@gmail.com	(31) 98622-9006	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8041	Cristhyan	goncalvescristhyan6@gmail.comg	(34) 99169-4567	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8042	Ana Maria Monteiro de Carvalho	anagabrielamonteiro712@gmail.com	(34) 99970-1866	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8043	Aline Ferreira	aline.ferreira.rpg@gmail.com	(34) 99968-1335	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8044	Jailma Gomes	veronnnyka.jn@gmail.com	(65) 99274-3586	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8045	Veraneide Ferreira	weranneyde@hotmail.com	(64) 99228-1630	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8047	DENNER D C	dennerddc.15@gmail.com	(31) 98959-8323	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8048	Lucas Pavoliine	lucaspavoliine@hotmail.com	(31) 99227-5736	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8049	Washington Camargo Alves	lu.wca@hotmail.com	(34) 99843-2946	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8050	Italo Rodrigues Oliveira	italorodrigues.adm@hotmail.com	(11) 95385-2558	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8051	Vn Silva	viniciusviana173@gmail.com	(31) 98268-8896	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8052	lara	larahitta16@gmail.com	(31) 98622-9006	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8053	Amanda Maria	amandamaria.pereira1718@gmail.com	(34) 99998-6724	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8054	Dayla Waltrick	daylawaltrick7@gmail.com	(41) 99898-4979	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8055	Daniela Lopes	daniela981150143@gmail.com	(31) 98115-0143	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8020	SIMONE / JU FILHA DA SIMONE	simone___ju_filha_da_simone_1054@famanegociosimobiliarios.com.br	(34) 9954-3022	Importado	13	Agendamento	\N	17	\N	\N	\N	2025-03-27 00:00:00	2025-03-27 00:00:00	\N	\N
7717	Anna Martins	annacassiamartins2005@gmail.com	(34) 99876-2005	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7716	Camilla Pinatti	camillapinatti@yahoo.com.br	(34) 99686-8997	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:33:08.423	2025-03-09 00:00:00	\N	\N
8039	Reginaldo Soares	reginaldo.santtos2012@gmail.com	(31) 99139-8125	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8040	HENRIQUE	henrickenem17@gmail.com	(31) 98435-5638	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8062	Daih Moreira	daielemmoreira@gmail.com	(31) 98610-9536	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8063	Leticya MMAT	leticyamacedot@hotmail.com	(31) 99126-8266	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8064	Myria Garcez	myriapdx@gmail.com	(34) 99814-9225	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8065	Denilson Bernardino	mrdenilsonbernardino@gmail.com	(31) 98769-4021	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8066	Flvio Bleme	flavio.bleme@hotmail.com	(31) 99634-4253	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8067	Rosangela Nunes da Silva	franciscomestre@hotmail.com	(71) 98679-0347	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8068	Ludmila Lemos	ludlemos1@hotmail.com	(34) 99802-5177	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8069	Juliana Rodrigues	jurodrigues3107@gmail.com	(34) 99726-5566	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8070	Totty	tottywiniciusvb@gmail.com	(38) 98835-0041	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8071	Jarbas Silva	jarbassilva2022@gmail.com	(31) 98510-8242	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8093	Suellem Gomes	suellemgomes13@gmail.com	(37) 98837-3123	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8095	Mariinha Oliveira	mariajs157@gmail.com	(16) 99399-1556	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8096	Ricardo Henrique	ricardorhs@yahoo.com.br	(31) 98786-6087	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8097	Otavio Vieiira	vieiirarodrigues@gmail.com	(34) 99168-5917	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8098	Vanessa Salazar	vanessassalazar@hotmail.com	(34) 99167-6157	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8059	Andr Castro	andrepaulodecastro@gmail.com	(31) 99768-8180	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8060	Mateus Emanuell	mateusemanuel820@gmail.com	(37) 99832-4621	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8061	Leandro de Carvalho	leandro.rcarvalho@hotmail.com	(31) 98533-6557	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8072	T Nunes	elizetenunesmatos@gmail.com	(77) 98876-6828	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8073	Brbara Stephane	barbaraenycolle@hotmail.com	(31) 98442-1730	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8075	Rodrigo Passos	passosjhs@yahoo.com.br	(31) 9333-0769	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8103	Wagner Souza	2013wls2013@gmail.com	(34) 99916-9098	Importado	13	Agendamento	\N	17	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8076	Josimara Macedo Ramos de Freitas	josimaraseguranca09@gmail.com	(38) 9747-2223	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8077	Carivaldo Neto	carivaldo_neto@hotmail.com	(34) 99228-0039	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8078	Hanna	iahanagabriele01@gmail.com	(34) 98414-5536	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8080	Israel Macedo	israel.marcela.lover@hotmail.com	(27) 99709-9103	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8081	Ligia Ditlef	ditlefl@yahoo.com.br	(31) 98732-8998	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8082	Ariane Oliveira	agrobeloni.ariane@hotmail.com	(34) 98803-0865	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8083	Adriel Eduardo	adriel.damasceno@fatec.sp	(16) 98190-4963	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8084	Jirleia _ Engenheira Civil	jirleia@hotmail.com	(31) 98532-9596	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8085	Igor Gabriel	igorgabriel.1@outlook.com	(67) 99857-1448	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8086	Glaucio Daniel	gla.cio@hotmail.com	(27) 99892-9746	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8088	Especialista em Emagrecimento e Hipertrofia	thiagosilvaxxt00712@hotmail.com	(34) 99318-3383	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8087	Vicentina Maria	vicentinamaria@yahoo.com.br	(34) 99663-5993	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8089	Junior Moreira	moreirajrudia@hotmail.com	(34) 99120-3363	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-31 00:00:00	2025-03-31 00:00:00	\N	\N
8090	Johnny Junior	johnny96301273@gmail.com	(34) 99775-3416	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-31 00:00:00	2025-03-31 00:00:00	\N	\N
8091	Valdemir Savazi	savazivaldemur@gmail.com	(34) 99997-4453	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8092	tabitha	tabithadias06@gmail.com	(32) 98487-6491	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8104	Fernndo Souzah	chemiambiental@gmail.com	(34) 99177-8036	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8057	Andressa Lara	dressa_l18@hotmail.com	(34) 99926-6807	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8105	Geovanna	geo_couto@hotmail.com	(34) 99294-8719	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-15 18:01:57.923	2025-04-03 00:00:00	\N	\N
8106	Maria Dalva Dantas	mariadalvadantas@hotmail.com	(34) 99977-0895	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8107	Tayse Bessa	tayse_bessa@hotmail.com	(34) 99180-7802	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8108	Wanderson Pinicorte	wandersongomespinicorte@gmail.com	(19) 99861-8402	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8109	Eduardo braga	ed949467@gmail.com	(38) 98834-1659	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8110	Fabricia Lopes	fabricial216@gmail.com	(31) 99360-1412	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8111	Karolainny Feitoza	karolainnys@gmail.com	(64) 99215-9135	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
7718	Marlene	gsilvamarlene@yahoo.com.br	(34) 99120-7511	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
8695	Marcus Vinicius	\N	(34) 99639-2222	Importado	23	Venda	094.013.276-10	14	t	553496392222@s.whatsapp.net	\N	2025-06-13 12:21:52.942	2025-04-09 00:00:00	\N	\N
8694	Lucas André	\N	(34) 99164-3656	Importado	23	Agendamento	\N	14	t	553491643656@s.whatsapp.net	\N	2025-06-13 12:21:58.331	2025-04-16 00:00:00	\N	\N
8099	Fausto Campos Carvalho	fausto.campos20@gmail.com	(34) 99896-4978	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8100	Robson Soares	robsonblack001@gmail.com	(35) 99953-1808	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8157	Caline Mariano 	calinemariano513@gmail.com	(34) 98427-7935	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8158	Simone Freitas Cruvinel	simonebrayanbrendakaua@gmail.com	(34) 99269-9193	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8159	Renata Marques	thhatymarx@gmail.com	(34) 99132-4726	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8693	Pedro Paulo	\N	(34) 99313-9755	Importado	23	Visita	\N	14	t	553493139755@s.whatsapp.net	\N	2025-06-13 12:22:03.796	2025-03-19 00:00:00	\N	\N
8160	Patricia Coelho	patycoelhods@yahoo.com.br	(34) 99659-9494	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8161	Duda Gonalves	me094149@gmail.com	(34) 99668-5023	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8162	Wilson Passos	wilson742016@gmail.com	(34) 9127-1126	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8165	Brenno Bandeira Rocha	brenno.b.rocha@gmail.com	(63) 98451-5800	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8166	Dani Martins	danimarlupi@gmail.com	(34) 98808-0415	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8167	Laura Moreira	laurasthefany221006@gmail.com	(34) 93505-2351	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8113	Ronei Peterson	ronyprs2010@hotmail.com	(34) 99159-8639	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8190	Edvania Gabriela	gabrielaedvania48@gmail.com	(38) 99133-8073	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8191	Rosejose AmaralSilva	rosya2017@hotmail.com	(34) 99244-3470	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8192	Genilson Gonzaga Santos	genilsonsantos487@gmail.com	(31) 9888384781	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8193	Joo Pedro Vieira Rodrigues	joaopedro3018@hotmail.com	(34) 99697-6171	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8194	Igila Medeiros	igilamsm@gmail.com	(34) 99274-8806	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8197	Carlos Jose	carlosjoserx9999@gmail.com	(34) 99861-2656	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8115	ana claudia	anaclaudiamartins521@gmail.com	(34) 99912-0486	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8117	Talia Silva	thaliaoliveira90@gmail.com	(31) 97143-4981	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8118	Leandro Gontijo	leandrogontijo191083@gmail.com	(37) 99903-2872	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8119	Bruna medrado souza	brunasouza25769@gmail.com	(37) 99662-4014	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8120	Prii Reis	pri.dosreis.1988@gmail.com	(35) 99804-7816	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8121	Ane Caroline	anecarol1989@gmail.com	(31) 98504-9702	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8122	Giceli De Lurdes Carniel	gicarniel@hotmail.com	(45) 99936-1668	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8123	Danilo Santos	dam.griz@yahoo.com.br	(38) 99152-6005	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8124	Cesar Adriani Goncalves	cesarag1966@yahoo.com	(41) 9984-7890	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8125	Leandro Fonseca Moraes	leandromoraesuberlandia@gmail.com	(34) 9939-1438	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8137	Lucas SantosS	santoslima.slucas@gmail.com	(34) 99925-6236	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8138	Carlos	b0carlosjr0d.ch@gmail.com	(34) 99999-7631	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8139	Marcia Melo	marciavdlmelo@gmail.com	(34) 99836-0221	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8140	Anniela Mamede	annielamamede@gmail.com	(34) 99168-6081	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8141	Lenize Santos da Silva	lenizasantos411@gmail.com	(91) 98166-4840	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8142	Larissa Mundim	laramundim@hotmail.com	(34) 98429-8036	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8143	Larissa Rabelo	larissarabelo012@gmail.com	(34) 99178-6943	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8144	MARCIELI UBERLNDIA MG	marcieliizidorioo@gmail.com	(34) 98410-1271	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8145	Mileide Ferreira	mylly.ferreira@hotmail.com	(34) 9215-8092	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8146	Vanderlei Mendes	vanderleismendes@gmail.com	(34) 99778-5004	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8147	Edilma	edilmac923@gmail.com	(34) 98445-9283	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8148	Raquel Carvalho	raquelazevedo20.c@gmail.com	(34) 99202-4669	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8149	Istefany Alves	istefanymitologia@gmail.com	(34) 98811-2231	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8150	Jssica Ins	jessica.ines333@gmail.com	(34) 98424-8897	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8151	Matheus Cassiano	mateuspwjacksom@hotmail.com	(34) 99150-2473	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8153	Sibely Campos	sibelyc196@gmail.com	(34) 99254-0465	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8154	Eduardo Boaventura Consultor de Automotivos	e.boaventura@yahoo.com.br	(34) 98807-9515	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8155	Anny Gabriele	annyg713@gmail.com	(38) 99157-7329	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8156	Lays Cardoso	layss_cardoso@hotmail.com	(33) 99119-3635	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8380	Lorenzzo Rodrigues	lo@b.mhhh	(34) 98435-2983	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8696	Gustavo Ferreira	\N	(34) 9148-6001	Importado	23	Venda	525.847.928-50	14	t	553491486001@s.whatsapp.net	\N	2025-06-13 12:21:47.565	2025-01-07 00:00:00	\N	\N
7719	Arno Junior	arnosj13@hotmail.com	(34) 99686-6786	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
8198	Anny Costa	anny-e@live.com	(16) 99277-4981	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8199	victor	ruanvictormello23@gmail.com	(34) 99196-6016	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8200	Karina Teixeira	karinateixeiralopesadv@gmail.com	(34) 98417-2980	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8196	Wellerson Oliveira	weoliveiraa@hotmail.com	(34) 99780-7795	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8222	Brenda Galvo	brendaferreira557@gmail.com	(34) 99769-8813	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8223	Rafael Dias da Cruz	rmtbfael@gmail.com	(34) 99919-9533	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8186	Mikaele Morais	mikaelemorais45@gmail.com	(88) 8821-7038	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8227	Lulu	cimaravic66@gmail.com	(33) 99900-0533	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8228	Cntia Igino	cintiacastro.silvaaa@gmail.com	(61) 99505-2032	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8229	Wesley Freitas	wesleyf_df@hotmail.com	(34) 98403-2083	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8230	Mery Feitoza	feitozamery3@gmail.com	(34) 99186-9536	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8231	Maria Rozeli	rozelimaria08@gmail.com	(34) 99311-7665	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8181	Alder	alder.ms@hotmail.com	(34) 99137-2848	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8183	Amanda Rodrigues	amandarcosta9@gmail.com	(11) 96328-4135	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8184	Carlos Eduardo	carlosduferreiragm@gmail.com	(34) 99710-2538	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8185	Stefanny Arajo	stefanny.16araujo@gmail.com	(34) 99778-6877	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8187	Johnny Marques	johnnymsgouveia@gmail.com	(34) 99862-0410	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8169	Elienai C Rosa	elienaichr@gmail.com	(34) 98403-5304	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8188	Guto Correia Alves	augustoedson2018@gmail.com	(34) 99641-1523	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8189	Ana Paula Guimares	guimaraesanapaula98@gmail.com	(34) 99945-7975	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8170	Rejane Ferreira	rejaninha.ferreira@hotmail.com	(34) 99318-7207	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8202	Dias Cludio	claudioedudias@gmail.com	(34) 99116-4488	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8203	Snia	soninhamariac@hotmail.com	(34) 9681-4306	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8204	Elda Andrade	andradeelda257@gmail.com	(34) 9864-7530	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8205	Maria Celia Santos Steola	mcelinha2@hotmail.com	(98) 98114-4978	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8206	Doris Alves	dorisalves1603@hotmail.com	(34) 9685-1603	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8207	Geislayne Souza	geislaynnesilva@gmail.com	(34) 99725-9102	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8208	Michelli Cristina	smichellicristina11@gmail.com	(34) 9146-1262	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8209	Tiago Santana	tiagotjsk8@hotmail.com	(34) 9291-8947	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8210	Marianna	eumarianna02@gmail.com	(77) 99990-2657	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8211	celma	celmamartins@yahoo.com.br	(38) 99953-1056	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8212	Jeferson Cardoso	jjefersoncardosoribeiro@gmail.com	(33) 99709-0975	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8213	Gaby	gaoliveira336@gmail.com	(34) 99826-1561	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8214	Hseyin Rahmi Karaca	karacahuseyinrahmi185@gmail.com	(49) 17641751565	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8215	Jullya Alves	jullya7oliveira@gmail.com	(34) 98843-2306	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8216	Aline Ferreira	alineufu81@gmail.com	(34) 99272-2520	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8217	Maria Aparecida	mariapele515@gmail.com	(34) 99869-6978	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8218	Gabriela Oliveira	novinhaantenada@gmail.com	(21) 98692-6992	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8219	Danilo Alves	negodandas05@gmail.com	(34) 99900-1054	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8220	Laura Marques	lauragna15@gmail.com	(34) 99779-1080	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8221	alana Arajo santos	alanaaraujosantos5@gmail.com	(73) 99843-0670	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8171	Pedrin 	elpedrohenriquegomes@gmail.com	(34) 98440-8640	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8173	Amanda Andrade	amanda-andradee7@hotmail.com	(34) 99987-8778	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-06 00:00:00	2025-04-06 00:00:00	\N	\N
8174	AjRodrigues	acisiorodrigues@hotmail.com	(34) 99339-7178	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-06 00:00:00	2025-04-06 00:00:00	\N	\N
8172	Wislem Matheus cunha Gouveia	wislenmatheuscunha@gmail.com	(34) 9229-5294	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 14:18:26.881	2025-04-06 00:00:00	\N	\N
8175	Cau Mondini	c.auemondini@hotmail.com	(34) 9655-3593	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-06 00:00:00	2025-04-06 00:00:00	\N	\N
8176	Joao Pedro	jp548278@gmail.com	(34) 99716-7837	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-06 00:00:00	2025-04-06 00:00:00	\N	\N
8177	gabriela	gabi.firmino07@gmail.com	(64) 99269-5035	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-06 00:00:00	2025-04-06 00:00:00	\N	\N
8178	Gabriel Santos	gsds323667@gmail.com	(34) 98415-6657	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8179	Anuor Abraho	minhacasaemuberlandia@gmail.com	(34) 9687-8777	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8180	Simoni Cavichioli	simonigui@hotmail.com	(34) 99274-0735	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
7720	Lenir Souza	lenirdesouza@hotmail.com	(34) 99282-2267	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7686	Matheus Valdir	mcontacell@gmail.com	(34) 9762-3883	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 15:34:29.311	2025-03-08 00:00:00	\N	\N
8253	Christian Samuel	chrisamu280@gmail.com	(38) 98863-8687	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8254	Juciley Domingues	jucileyperola22@hotmail.com	(34) 98817-5590	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8255	Dudinha	melnunes.dudadudaduda@gmail.com	(34) 99771-8271	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8256	Miriane Coelho	mirianecoelho4@gmail.com	(34) 99777-1521	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8257	Denise Santos Catharina	sdenise701@yahoo.com	(21) 96837-5745	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8258	Gabriela Cunha	gabriela.ms0901@gmail.com	(34) 99866-1015	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8259	Pamela Rodrigues	pamelaemanuelly21@gmail.com	(34) 99671-8357	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8260	Melquisedec Cardoso	melqui1606@gmail.com	(86) 99487-1970	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8261	Ligia Mendes	ligiamaria18@outlook.com	(38) 98435-3807	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8225	Leila Menezes	leilamenezes091@hotmail.com	(34) 99994-1009	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8262	Gustavo Silva	gustavosilva171120@outlook.com	(34) 99885-9315	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-15 16:50:41.698	2025-04-11 00:00:00	\N	\N
8334	Celso Paulo	celsomaciel296@gmail.com	(35) 8892-1640	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8335	Huryel Souto	huuh950@gmail.com	(33) 99936-3493	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8336	Gabriela Mello	josesilva690m@gmail.com	(37) 99934-1703	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8233	Mislene Romano	mi.sp.romano@hotmail.com	(17) 99117-5958	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8234	Wilmar Antonio Gonalves da silva	wilmargoncalves@hotmail.com	(34) 9179-4590	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8235	Graziela taynara Silva	grazielatainara11@gmail.com	(34) 9334-0143	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8236	Luiz Henrique	lh561116@gmail.com	(31) 98114-4881	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8237	Coracy Hipolito	coracao_hipolito@hotmail.com	(34) 9777-5389	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8238	Ariele Sandy	sanmartins231705@gmail.com	(34) 99143-3923	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8239	Maria Dias	amaria.dsd@gmail.com	(34) 99962-4445	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8240	Wesley	henriquewesley9483@gmail.com	(38) 99947-5729	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8241	Thassa	thaissaviviany049@gmail.com	(73) 9983-2356	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8242	Ervita NAkagawa	ervitamp@hotmail.com	(34) 99195-1658	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8243	Kelly Carreiro	kellycarreiro09@icloud.com	(34) 99777-7460	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8244	JB Afiacao	juliocesarguimaraesedani@gmail.com	(34) 9690-4887	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8245	Talita Victria	talitavic@hotmail.com	(34) 99716-4473	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8246	Arthur Uchoa	arthursouz67@gmail.com	(91) 9939-8868	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8248	Bueno_	henriqqsilvaa7@gmail.com	(34) 99186-9110	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8249	Jorge pereira	jorgepereira2020s@gmail.com	(34) 99645-2085	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8250	Rozeli Costa	rozelicosta417@gmail.com	(34) 99678-7385	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8251	Vincius Batista	amarelobatistta@gmail.com	(34) 99680-4175	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8252	Michelly B S Macdo	michellybeatriz96@gmail.com	(38) 99196-1904	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8263	Joo Victor	socialbyalice@gmail.com	(11) 98892-8870	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8264	Juvenal Ferreira de Souza	souza.j.v@hotmail.com	(34) 9137-5490	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8265	carlos 	carlosaguiar444@gmail.com	(34) 9696-9617	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-11 00:00:00	2025-04-11 00:00:00	\N	\N
8314	Luiz Jnior	do.ni.z@hotmail.com	(34) 99201-8579	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8315	Ilma Snia de melo	ilma_sonia@hotmail.com	(64) 99207-5920	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8316	Heloi Emanuel	heloiemanoel@hotmail.com	(34) 9644-1500	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8317	Thiago Henrick	thiagobraga12@icloud.com	(34) 99638-2050	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8318	Linda Vitoria	heloudemelo123@gmail.com	(34) 99145-0782	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8319	Diego Duarte Carvalho Duarte	diegodld697@gmail.com	(34) 9230-3345	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8320	Sindomar Barbosa	sindomaradry@gmail.com	(34) 99163-4463	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8321	Felipe Flvio	felipeflavio21@hotmail.com	(34) 99197-3274	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8322	Neila Fernandes Justino	neilafernandesjustino@hotmail.com	(34) 99867-0717	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8323	Marilene Adriana Araujo Gonalves	marileneaag@hotmail.com	(33) 98868-4303	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8324	Neide Xavier dos Santos	neidex77@gmail.com	(62) 98170-2479	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8325	Roselly Macedo	roselly86@yahoo.com.br	(34) 99693-0186	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8326	Ingrid Lopes	santanaingrid904@gmail.com	(73) 98109-7548	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8327	Juliana Gonalves	julianagp100@hotmail.com	(34) 98424-8585	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
7724	Carolina Carol	ana632carozinha@gmail.com	(34) 99799-0382	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
8333	Bell Lima	bellclaramanu60@gnail.com	(34) 99650-3479	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8337	iovanna Souza	gabrielygiovanna6@gmail.com	(64) 99322-5517	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8338	Amanda Sousa	amandamvs01@gmail.com	(62) 99112-5075	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8339	julia mendes	juliamend3s14yt@gmail.com	(37) 99865-3243	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8340	Mrcia	marcia30vitoria@gmail.com	(34) 99279-1743	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8341	Guimares	elizeu.guedes@icloud.com	(73) 99821-9780	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8343	Hebert kauan	kauanhebert134@gmail.com	(34) 99122-6910	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8344	Larissa Caldas	larissasouzacaldas03@gmail.com	(34) 98415-4056	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8345	Eligiany Ponciano	silvaeligiany@gmail.com	(34) 99794-3233	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8346	Maria Das Graas Picelli De Azevedo	lia.joao20@hotmail.com	(14) 99902-4853	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8347	Yasmin Hallidey Gomes	hallideyy@gmail.com	(34) 99664-8224	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-17 00:00:00	2025-04-17 00:00:00	\N	\N
8349	Vitor Marques	vitinho0.gyn@gmail.com	(34) 99891-1091	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-20 00:00:00	2025-04-20 00:00:00	\N	\N
8361	Mrcia	marcia.nascimento23071975@gmail.com	(34) 98818-7416	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8363	Maria Eduarda Rodrigues	maryaedwarda18@gmail.com	(64) 99996-1526	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8365	steilon silva	silvasteilon@gmail.com	(34) 98818-7656	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8366	Maria Socorro Mota	mariamota69@hotmail.com	(11) 97226-9415	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8367	Jeferson Martins	jefersonmartins9512@gmail.com	(34) 99725-6221	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8368	Renan Portela Melo	renanportelameki@gmail.com	(34) 99909-4654	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8369	Maria Regina Ferreira Monteiro	mariareginaferreiraf946@gmail.com	(34) 9844-0665	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8348	Gabriel Alexandre	gabri00br@gmail.com	(34) 98892-1920	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-04-17 00:00:00	2025-04-17 00:00:00	\N	\N
8390	Jhessyka Cunha	jhessyka_silvas2@hotmail.com	(34) 99280-1791	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8352	Nathalia B  Silva	nathbiah.ss@gmail.com	(34) 99686-7081	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8353	John Martins	panificadora2015jlmcmei@gmail.com	(34) 99990-9942	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8354	Rosiane Maria Da Silva	rosianemariasilva2019@gmail.com	(34) 9171-5327	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8329	thiago	th033thigas15@gmail.com	(34) 99118-4498	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8330	Yasmin Souza	yayasouzaudi110@gmail.com	(34) 99164-4638	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8331	Jhonata Carlos	jhonatacarlos98@gmail.com	(34) 98858-3626	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8332	Erick Enrick Soares Santos	ericksoares0610@gmail.com	(34) 99138-9765	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8328	Maira Masuda	masuda.maira@gmail.com	(34) 99977-4250	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8350	Denys Marques	dmarques.analista@gmail.com	(34) 99927-2933	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-20 00:00:00	2025-04-20 00:00:00	\N	\N
8355	Joao Luiz Machado	j8o8a5o3l4u4i7z5@gmail.com	(34) 99905-8384	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8372	Pedro Matos	peu.castro.matos@hotmail.com	(34) 99638-5045	Importado	22	Visita	\N	14	\N	\N	\N	2025-05-14 14:28:40.797	2025-04-21 00:00:00	\N	\N
8356	Jessica	teste25@teste.com.br	(64) 9227-7529	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8357	Vera Lucia da Silva Faria	teste2025@teste.com.br	(34) 99966-3189	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8358	Bruna Bruninha	brunynhah89@gmail.com	(34) 99907-4285	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8359	Ciara Pereira	js6461121@gmail.com	(73) 98885-7873	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8360	Jucineide Medeiros	jucineidemeideros@gmail.com	(34) 9696-9766	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8370	Lcio Jos da Silva	luciolagas@hotmail.com	(34) 9323-2331	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8371	VH Mveis Planejados	vh240331@gmail.com	(34) 99709-0295	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8373	Sandra Regis	sandra6reginna@hotmail.com	(34) 99764-9285	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8374	Leandro Santos	leandrosantos63@hotmail.com	(34) 99800-3360	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8375	Ricardo Faria	teste2016@teste.com.br	(34) 99978-5828	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8376	Neusa Pereira de Souza	neusapereira2004@gmail.com	(34) 99663-5480	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8377	Fransergio Menezes	fransergiomenezes@hotmail.com	(34) 98829-5101	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8351	Maria Eduarda	ddiixxduda@gmail.com	(34) 99170-9401	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 14:44:53.196	2025-04-21 00:00:00	\N	\N
8378	Carla Mendonca	carlamendonca01@hotmail.com	(34) 99966-4543	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8379	?????????????????	claudineimartins312@gmail.com	(34) 99716-5092	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8381	Mirlei Rosa	mirleiaparecidaroa@gmail.com	(34) 9213-2648	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8382	Henrique Martins	martinshenrique2312@gmail.com	(34) 99217-7788	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8383	Thalles	thalleswhite1@gmail.com	(34) 98403-4070	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8440	Anelita Marqus	anelitapalves@gmail.com	(34) 99991-3089	Importado	13	Sem Atendimento	\N	\N	t	553499913089@s.whatsapp.net	\N	2025-06-13 12:45:02.252	2025-04-24 00:00:00	\N	\N
8439	Jaqueline Silva	lookzinhos2.0@gmail.com	(34) 99971-3972	Importado	13	Sem Atendimento	\N	\N	t	553499713972@s.whatsapp.net	\N	2025-06-13 12:45:07.838	2025-04-24 00:00:00	\N	\N
8438	Tauanne Barros Oliveira	tauanne@hotmail.com	(34) 99877-2005	Importado	22	Sem Atendimento	\N	\N	t	553498772005@s.whatsapp.net	\N	2025-06-13 12:45:13.232	2025-04-23 00:00:00	\N	\N
8437	Olimpio Garcia	olimpiogar@hotmail.com	(34) 98853-8924	Importado	22	Sem Atendimento	\N	\N	t	553488538924@s.whatsapp.net	\N	2025-06-13 12:45:18.637	2025-04-23 00:00:00	\N	\N
8436	Ricardo Fernandes	ricardo_mendes27@hotmail.com	(34) 99773-0112	Importado	22	Sem Atendimento	\N	\N	t	553497730112@s.whatsapp.net	\N	2025-06-13 12:45:24.019	2025-04-23 00:00:00	\N	\N
8435	Jhonatan santos	jhonatanvinicius839@gmail.com	(34) 99164-8199	Importado	22	Sem Atendimento	\N	\N	t	553491648199@s.whatsapp.net	\N	2025-06-13 12:45:29.436	2025-04-23 00:00:00	\N	\N
8434	Daniel	danielhenriquemotalopes@gmail.com	(34) 99236-4970	Importado	22	Sem Atendimento	\N	\N	t	553492364970@s.whatsapp.net	\N	2025-06-13 12:45:34.934	2025-04-23 00:00:00	\N	\N
8433	Ellen Oliveira Silva	oliveiraellen095@gmail.com	(34) 99666-0568	Importado	22	Sem Atendimento	\N	\N	t	553496660568@s.whatsapp.net	\N	2025-06-13 12:45:40.3	2025-04-23 00:00:00	\N	\N
8431	Josival Gomes	josivalgomescena123@gmail.com	(34) 9255-9252	Importado	22	Sem Atendimento	\N	\N	t	553492559252@s.whatsapp.net	\N	2025-06-13 12:45:51.147	2025-04-23 00:00:00	\N	\N
8430	Letcia Lorrane dos Santos	leticialorraned@gmail.com	(64) 9999-5210	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:45:57.139	2025-04-23 00:00:00	\N	\N
8429	giselly ferreira de souza	gisellyferreiradesouzaf89@gmail.com	(34) 99907-3516	Importado	22	Sem Atendimento	\N	\N	t	553499073516@s.whatsapp.net	\N	2025-06-13 12:46:02.693	2025-04-23 00:00:00	\N	\N
8421	Jonatas Alves	jonatasalvessantos9@gmail.com	(34) 99835-9975	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:46:46.397	2025-04-23 00:00:00	\N	\N
8420	Lucia Helena	helenalu455@gmail.com	(31) 97258-3251	Importado	13	Sem Atendimento	\N	\N	t	553172583251@s.whatsapp.net	\N	2025-06-13 12:46:52.314	2025-04-23 00:00:00	\N	\N
8419	Juliane Silva	juliane1607ng@gmail.com	(34) 98443-8657	Importado	13	Sem Atendimento	\N	\N	t	553484438657@s.whatsapp.net	\N	2025-06-13 12:46:57.748	2025-04-23 00:00:00	\N	\N
8418	POLLYANA DUART	pollyanakduarte@gmail.com	(37) 99831-4129	Importado	13	Sem Atendimento	\N	\N	t	553798314129@s.whatsapp.net	\N	2025-06-13 12:47:03.251	2025-04-23 00:00:00	\N	\N
8417	Flavia Mara Gonalves	flaviabg@hotmail.com	(31) 98837-3048	Importado	13	Sem Atendimento	\N	\N	t	553188373048@s.whatsapp.net	\N	2025-06-13 12:47:08.767	2025-04-23 00:00:00	\N	\N
8416	Gabriela Carvalho	gabriela.o.carvalho53@gmail.com	(34) 99261-5916	Importado	13	Sem Atendimento	\N	\N	t	553492615916@s.whatsapp.net	\N	2025-06-13 12:47:14.19	2025-04-23 00:00:00	\N	\N
8414	Gabrielly	ferrazgaby25@gmail.com	(34) 99866-1245	Importado	13	Sem Atendimento	\N	\N	t	553498661245@s.whatsapp.net	\N	2025-06-13 12:47:25.12	2025-04-23 00:00:00	\N	\N
8413	kah_022	rodrigueshonoratom108@gmail.com	(34) 99124-2237	Importado	13	Sem Atendimento	\N	\N	t	553491242237@s.whatsapp.net	\N	2025-06-13 12:47:30.498	2025-04-23 00:00:00	\N	\N
8412	Ftima Maria De Jesus Silva	fatimamariadejesus1952@gmail.com	(34) 9771-7806	Importado	13	Sem Atendimento	\N	\N	t	553497717806@s.whatsapp.net	\N	2025-06-13 12:47:35.885	2025-04-23 00:00:00	\N	\N
8411	Gabriel prb	gabrielprb8@gmail.com	(34) 99135-5774	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:47:41.301	2025-04-23 00:00:00	\N	\N
8410	Felipe Dias	felipe_dias_1444@famanegociosimobiliarios.com.br	(64) 9931-9492	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:47:46.666	2025-04-22 00:00:00	\N	\N
8409	Erick Adriano	erickadrino5@gmail.com	(34) 99646-2461	Importado	22	Sem Atendimento	\N	\N	t	553496462461@s.whatsapp.net	\N	2025-06-13 12:47:52.035	2025-04-22 00:00:00	\N	\N
8408	Maria Vitria	vitoriaferreiram15@gmail.com	(34) 99903-1389	Importado	22	Sem Atendimento	\N	\N	t	553499031389@s.whatsapp.net	\N	2025-06-13 12:47:57.453	2025-04-22 00:00:00	\N	\N
8406	Rafael dos reis santos	rafaeldosreis1981@gmail.com	(34) 99127-4664	Importado	22	Sem Atendimento	\N	\N	t	553491274664@s.whatsapp.net	\N	2025-06-13 12:48:08.292	2025-04-22 00:00:00	\N	\N
8405	Neusa Inacio	gneusa@hotmail.co.uk	(34) 99638-5289	Importado	22	Sem Atendimento	\N	\N	t	553496385289@s.whatsapp.net	\N	2025-06-13 12:48:13.692	2025-04-22 00:00:00	\N	\N
8404	Filipe Oliveira Andrade	filipeaugusto@gmail.com	(34) 98443-8558	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:48:19.026	2025-04-22 00:00:00	\N	\N
8403	Soninha Maral	soninha_7mar@hotmail.com	(34) 98842-4677	Importado	22	Sem Atendimento	\N	\N	t	553488424677@s.whatsapp.net	\N	2025-06-13 12:48:24.52	2025-04-22 00:00:00	\N	\N
8402	Diana Soares dos santos	dianasoaresdossantos70@gmail.com	(34) 9133-8028	Importado	22	Sem Atendimento	\N	\N	t	553491338028@s.whatsapp.net	\N	2025-06-13 12:48:29.933	2025-04-22 00:00:00	\N	\N
7725	Geovanna Silva	silvageovanna1711@gmail.com	(34) 99966-3289	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7726	Everton Veloso De Oliveira	velosoeverton852@gmail.com	(34) 8892-1298	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
8391	Edriane Amorim	amorinedriane@gmail.com	(24) 99997-6892	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8393	Bruna	bcostagarcia1@gmail.com	(11) 98918-3573	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8394	Stephany Dias Costa	stephanydcosta98@gmail.com	(11) 93389-3682	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8389	bila thereza	mariliatrza@gmail.com	(34) 99631-4183	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8401	Cleia Vieira	cleiavimartins@gmail.com	(34) 9125-3889	Importado	22	Sem Atendimento	\N	\N	t	553491253889@s.whatsapp.net	\N	2025-06-13 12:48:35.311	2025-04-22 00:00:00	\N	\N
8400	Leila Nunes Oliveira	leilanunesoliveira@yahoo.com.br	(34) 9992-0697	Importado	22	Sem Atendimento	\N	\N	t	553499920697@s.whatsapp.net	\N	2025-06-13 12:48:40.724	2025-04-22 00:00:00	\N	\N
8392	Marcos Junior	marcosaurelio0990@gmail.com	(34) 99799-3773	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8483	Liliane Regina	reginaliliane82@gmail.com	(34) 99690-1174	Importado	23	Sem Atendimento	\N	\N	t	553496901174@s.whatsapp.net	\N	2025-06-13 12:41:08.637	2025-04-28 00:00:00	\N	\N
8481	LUSMARA BATISTA SILVA BERNARDES	wf2303804@gmail.com	(34) 99875-4201	Importado	23	Sem Atendimento	\N	\N	t	553498754201@s.whatsapp.net	\N	2025-06-13 12:41:19.535	2025-04-28 00:00:00	\N	\N
8549	Francisca De Assis Morais	franciscamorais1154@gmail.com	(34) 8429-2160	Importado	23	Sem Atendimento	\N	\N	t	553484292160@s.whatsapp.net	\N	2025-06-13 12:35:09.854	2025-05-05 00:00:00	\N	\N
8386	Lorrane Miranda	lorraneclara@bol.com.br	(34) 99251-1265	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8387	Ray__034	raydeyest@gmail.com	(34) 99683-9537	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8388	Rocicley Araujo de Souza	rocicleyarajo@gmail.com	(62) 98243-1946	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8465	Maxwel Mb	maxwelm746@gmail.com	(34) 99896-9645	Importado	13	Sem Atendimento	\N	\N	t	553498969645@s.whatsapp.net	\N	2025-06-13 12:42:45.952	2025-04-27 00:00:00	\N	\N
8464	Expert em Penteados e Noivas  Curso Vip Profissional	otalita@yahoo.com.br	(34) 99293-3162	Importado	13	Sem Atendimento	\N	\N	t	553492933162@s.whatsapp.net	\N	2025-06-13 12:42:51.54	2025-04-27 00:00:00	\N	\N
8463	Hian Roberto	hianroberto36@hotmail.com	(34) 99165-1162	Importado	13	Sem Atendimento	\N	\N	t	553491651162@s.whatsapp.net	\N	2025-06-13 12:42:56.925	2025-04-27 00:00:00	\N	\N
8461	Laizza Maria Peres	laizzabaglaizza33@gmail.com	(34) 9862-9966	Importado	13	Sem Atendimento	\N	\N	t	553498629966@s.whatsapp.net	\N	2025-06-13 12:43:08.013	2025-04-26 00:00:00	\N	\N
8460	Samy Rodrigues	samuelrodrigues0706@gmail.com	(34) 99213-2428	Importado	22	Sem Atendimento	\N	\N	t	553492132428@s.whatsapp.net	\N	2025-06-13 12:43:13.464	2025-04-25 00:00:00	\N	\N
8459	Vincius F Soares	vinicius_faria_soares@hotmail.com	(34) 99283-2010	Importado	22	Sem Atendimento	\N	\N	t	553492832010@s.whatsapp.net	\N	2025-06-13 12:43:18.96	2025-04-25 00:00:00	\N	\N
8458	Luiza Helena	genys80@yahoo.com	(34) 9638-7480	Importado	22	Sem Atendimento	\N	\N	t	553496387480@s.whatsapp.net	\N	2025-06-13 12:43:24.349	2025-04-25 00:00:00	\N	\N
8454	Luana Martins	luanamartinsmedeiros5@gmail.com	(34) 99875-0650	Importado	13	Sem Atendimento	\N	\N	t	553498750650@s.whatsapp.net	\N	2025-06-13 12:43:45.929	2025-04-25 00:00:00	\N	\N
8453	Kamilly Cristina Squesario	anamariade484@gmail.com	(16) 99995-6895	Importado	13	Sem Atendimento	\N	\N	t	5516999956895@s.whatsapp.net	\N	2025-06-13 12:43:51.5	2025-04-25 00:00:00	\N	\N
8452	Geovana vieira	geovana_vieira_1486@famanegociosimobiliarios.com.br	(34) 9693-0387	Importado	13	Visita	\N	14	t	553496930387@s.whatsapp.net	\N	2025-06-13 12:43:56.956	2025-04-24 00:00:00	\N	\N
8443	Melissa Helena	helenamelyssa3@gmail.com	(34) 99110-1280	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:44:45.82	2025-04-24 00:00:00	\N	\N
8448	Maria Angelica de Santana	angelicaleobraga@gmail.com	(34) 9342-7777	Importado	22	Sem Atendimento	\N	\N	t	553493427777@s.whatsapp.net	\N	2025-06-13 12:44:18.769	2025-04-24 00:00:00	\N	\N
8449	Luana Liberato	luuribeiro01@hotmail.com	(64) 99279-6017	Importado	22	Sem Atendimento	\N	\N	t	556492796017@s.whatsapp.net	\N	2025-06-13 12:44:13.371	2025-04-24 00:00:00	\N	\N
8450	Josyane Limma	josyanelimma25@gmail.com	(34) 9859-2691	Importado	22	Sem Atendimento	\N	\N	t	553498592691@s.whatsapp.net	\N	2025-06-13 12:44:07.891	2025-04-24 00:00:00	\N	\N
8451	Ana Lucia Pereira Dos Santos	luciasantos0927@gmail.com	(34) 9966-3982	Importado	22	Sem Atendimento	\N	\N	t	553499663982@s.whatsapp.net	\N	2025-06-13 12:44:02.415	2025-04-24 00:00:00	\N	\N
8442	Lucy	cangaceirop12@gmail.com	(34) 98413-5814	Importado	13	Visita	\N	14	t	553484135814@s.whatsapp.net	\N	2025-06-13 12:44:51.312	2025-04-24 00:00:00	\N	\N
8441	Jhennifer Florinda Machado	jhenniferflorinda104@gmail.com	(34) 99866-6569	Importado	13	Agendamento	\N	17	t	553498666569@s.whatsapp.net	\N	2025-06-13 12:44:56.789	2025-04-24 00:00:00	\N	\N
7727	Marcela Sales	marcelladanielly@hotmail.com	(34) 98809-2202	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7728	Mauro Marks	marquesgren.mais@gmail.com	(34) 99966-5153	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7729	Luiza Mariana	xaviernascimentoluiza3@gmail.com	(34) 98422-7341	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7730	Edson Matias	iioo96934@gmail.com	(34) 9635-1194	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7731	Nubia Beleli	nbeleli@gmail.com	(34) 99769-8014	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
8495	Claudio Viola	crvcartruckbrasil@gmail.com	(34) 99156-9755	Importado	22	Sem Atendimento	\N	\N	t	553491569755@s.whatsapp.net	\N	2025-06-13 12:40:03.759	2025-04-29 00:00:00	\N	\N
8493	Malu Gomes	luoliver40@hotmail.com	(34) 99648-5299	Importado	13	Sem Atendimento	\N	\N	t	553496485299@s.whatsapp.net	\N	2025-06-13 12:40:14.624	2025-04-29 00:00:00	\N	\N
8492	Geraldo Herystarley Veloso Cruz	herystarley@yahoo.com.br	(38) 99979-1738	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:40:20.15	2025-04-29 00:00:00	\N	\N
8491	Fran Gomes	francislainy.fran.gomes@outlook.com	(34) 99904-3403	Importado	22	Sem Atendimento	\N	\N	t	553499043403@s.whatsapp.net	\N	2025-06-13 12:40:25.557	2025-04-28 00:00:00	\N	\N
8489	Gui	guibarcelosfilho@outlook.com	(34) 99735-0764	Importado	22	Sem Atendimento	\N	\N	t	553497350764@s.whatsapp.net	\N	2025-06-13 12:40:36.326	2025-04-28 00:00:00	\N	\N
8488	Vera Pinheiro	verapinheiroo@gmail.com	(34) 9897-1510	Importado	22	Sem Atendimento	\N	\N	t	553498971510@s.whatsapp.net	\N	2025-06-13 12:40:41.706	2025-04-28 00:00:00	\N	\N
8487	Ione Monteiro dos Santos	ionemonteiro2009@gmail.com	(38) 9815-2326	Importado	22	Sem Atendimento	\N	\N	t	553898152326@s.whatsapp.net	\N	2025-06-13 12:40:47.068	2025-04-28 00:00:00	\N	\N
8486	Fabi Gomes	fabianacg32@gmail.com	(34) 99653-9138	Importado	22	Sem Atendimento	\N	\N	t	553496539138@s.whatsapp.net	\N	2025-06-13 12:40:52.459	2025-04-28 00:00:00	\N	\N
8520	Thais Vitria	vitoriathais704@gmail.com	(34) 99636-8918	Importado	13	Sem Atendimento	\N	\N	t	553496368918@s.whatsapp.net	\N	2025-06-13 12:37:48.395	2025-05-04 00:00:00	\N	\N
8485	Lu Ornelas	luziornelas.lo@gmail.com	(34) 99683-2901	Importado	22	Sem Atendimento	\N	\N	t	553496832901@s.whatsapp.net	\N	2025-06-13 12:40:57.84	2025-04-28 00:00:00	\N	\N
8484	Elianne Paranagu	oliverparanagua@gmail.com	(64) 99259-9753	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:41:03.233	2025-04-28 00:00:00	\N	\N
8479	Alexandre Sousa	vitormakauly1533@icloud.com	(34) 99887-0946	Importado	13	Sem Atendimento	\N	\N	t	553498870946@s.whatsapp.net	\N	2025-06-13 12:41:30.356	2025-04-28 00:00:00	\N	\N
8478	Claudio MAJ	claudiojunior@unipam.edu.br	(34) 99214-8156	Importado	13	Sem Atendimento	\N	\N	t	553492148156@s.whatsapp.net	\N	2025-06-13 12:41:35.731	2025-04-28 00:00:00	\N	\N
8519	leonardo	leonardo.g.barbosa784@gmail.com	(38) 99987-6736	Importado	13	Sem Atendimento	\N	\N	t	553899876736@s.whatsapp.net	\N	2025-06-13 12:37:53.838	2025-05-04 00:00:00	\N	\N
8518	Maria	mariaeduarda.r.domingues@gmail.com	(34) 99775-9394	Importado	13	Sem Atendimento	\N	\N	t	553497759394@s.whatsapp.net	\N	2025-06-13 12:37:59.218	2025-05-04 00:00:00	\N	\N
8477	Marisa Sousa Cunha	msousacunha2016@bol.com.br	(34) 8444-5113	Importado	13	Agendamento	\N	14	t	553484445113@s.whatsapp.net	\N	2025-06-13 12:41:41.135	2025-04-28 00:00:00	\N	\N
8476	Sionara Amorim	sionaraamorim65@gmail.com	(99) 8891-4814	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:41:46.707	2025-04-28 00:00:00	\N	\N
8475	Kawa Lucas	kawa91399@gmail.com	(34) 99185-3710	Importado	13	Sem Atendimento	\N	\N	t	553491853710@s.whatsapp.net	\N	2025-06-13 12:41:52.053	2025-04-28 00:00:00	\N	\N
8474	Claudinha Cristhina	claudiacristina20@hotmail.com	(73) 98129-4088	Importado	22	Sem Atendimento	\N	\N	t	557381294088@s.whatsapp.net	\N	2025-06-13 12:41:57.468	2025-04-27 00:00:00	\N	\N
8473	Guilherme Henrique	gh8929346@gmail.com	(64) 99662-9961	Importado	22	Sem Atendimento	\N	\N	t	556496629961@s.whatsapp.net	\N	2025-06-13 12:42:02.909	2025-04-27 00:00:00	\N	\N
8471	Eva Aparecida Rabelo	rabeloeva32@gmail.com	(34) 9142-4439	Importado	22	Sem Atendimento	\N	\N	t	553491424439@s.whatsapp.net	\N	2025-06-13 12:42:13.624	2025-04-27 00:00:00	\N	\N
8517	Andr Arajo	andrearaujo668@gmail.com	(32) 99820-4203	Importado	13	Sem Atendimento	\N	\N	t	553298204203@s.whatsapp.net	\N	2025-06-13 12:38:04.571	2025-05-04 00:00:00	\N	\N
7861	Luis Gustavo	guguhorossso@gmail.com	(34) 99649-1862	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8516	Maria Felipe	mariafelipe1951@gmail.com	(34) 99148-3211	Importado	13	Sem Atendimento	\N	\N	t	553491483211@s.whatsapp.net	\N	2025-06-13 12:38:09.907	2025-05-04 00:00:00	\N	\N
7862	Cleyton silva  Juliao	cleytondd918@gmail.com	(34) 9634-2688	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8515	Glicelda Machado	gliceldasoaresdesouza@gmail.com	(33) 8803-7940	Importado	22	Sem Atendimento	\N	\N	t	553388037940@s.whatsapp.net	\N	2025-06-13 12:38:15.359	2025-05-01 00:00:00	\N	\N
7863	Hebertt Moraes	weberttms@gmail.com	(34) 99105-2901	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8507	Ozias Rodrigues costa	ozeiasrodrigues2090@gmail.com	(34) 9317-1973	Importado	13	Sem Atendimento	\N	\N	t	553493171973@s.whatsapp.net	\N	2025-06-13 12:38:58.684	2025-05-01 00:00:00	\N	\N
8514	Leticia Ribeiro	leehmaria09@gmail.com	(34) 9125-5221	Importado	22	Sem Atendimento	\N	\N	t	553491255221@s.whatsapp.net	\N	2025-06-13 12:38:20.742	2025-05-01 00:00:00	\N	\N
8513	Gabriel	gabrielsilvawppw8@gmail.com	(38) 99722-7876	Importado	22	Sem Atendimento	\N	\N	t	553897227876@s.whatsapp.net	\N	2025-06-13 12:38:26.195	2025-05-01 00:00:00	\N	\N
8508	Lucia Assuncao	lucia.assuncao@hotmail.com	(64) 99999-1077	Importado	13	Sem Atendimento	\N	\N	t	556499991077@s.whatsapp.net	\N	2025-06-13 12:38:53.221	2025-05-01 00:00:00	\N	\N
8548	Simone Braga	simonebragasigma@gmail.com	(24) 98151-5937	Importado	23	Sem Atendimento	\N	\N	t	5524981515937@s.whatsapp.net	\N	2025-06-13 12:35:15.367	2025-05-05 00:00:00	\N	\N
8546	Joo Martins	joaomartinsaraujo18@gmail.com	(34) 99162-0852	Importado	23	Sem Atendimento	\N	\N	t	553491620852@s.whatsapp.net	\N	2025-06-13 12:35:26.333	2025-05-05 00:00:00	\N	\N
8545	Wesley Oliveira	faiscask8@msn.com	(34) 98814-4871	Importado	23	Sem Atendimento	\N	\N	t	553488144871@s.whatsapp.net	\N	2025-06-13 12:35:31.711	2025-05-05 00:00:00	\N	\N
8506	Keylla Guimares	keilarocha21-@hotmail.com	(61) 9849-3989	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:39:04.041	2025-05-01 00:00:00	\N	\N
8505	Guilherme ngelo	guilhermeangelo580@gmail.com	(34) 9862-2615	Importado	22	Sem Atendimento	\N	\N	t	553498622615@s.whatsapp.net	\N	2025-06-13 12:39:09.498	2025-04-30 00:00:00	\N	\N
8504	Raimundo Silva Sousa	raimundosilvasouza15@gmail.com	(22) 97404-0704	Importado	22	Sem Atendimento	\N	\N	t	5522974040704@s.whatsapp.net	\N	2025-06-13 12:39:14.852	2025-04-30 00:00:00	\N	\N
8503	Lanne Silva	lanynha-24@hotmail.com	(34) 99205-4470	Importado	22	Sem Atendimento	\N	\N	t	553492054470@s.whatsapp.net	\N	2025-06-13 12:39:20.232	2025-04-30 00:00:00	\N	\N
8499	Agatha Moreira	agatha.julymoreira@gmail.com	(34) 99812-2723	Importado	13	Sem Atendimento	\N	\N	t	553498122723@s.whatsapp.net	\N	2025-06-13 12:39:41.963	2025-04-30 00:00:00	\N	\N
8498	India Silva	indianaraaparecida52@gmail.com	(31) 98999-0953	Importado	13	Sem Atendimento	\N	\N	t	553189990953@s.whatsapp.net	\N	2025-06-13 12:39:47.378	2025-04-30 00:00:00	\N	\N
8496	Snia	soninha.m.c@hotmail.com	(34) 99681-4306	Importado	13	Sem Atendimento	\N	\N	t	553496814306@s.whatsapp.net	\N	2025-06-13 12:39:58.114	2025-04-30 00:00:00	\N	\N
7864	Julia Marcia	juliamarciaf1@hotmail.com	(34) 9123-9202	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7866	Alessandra Pereira	lessandra.p.silva@hotmail.com	(34) 99681-4767	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8544	Joo Pedro	joaopedroavellar81@gmail.com	(34) 98416-8311	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:35:37.18	2025-05-05 00:00:00	\N	\N
8542	Daltim Santos	edwardesjr28@gmail.com	(35) 1913903449	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:35:48.034	2025-05-05 00:00:00	\N	\N
8526	Paulo Brito	paulobritoweerr@gmail.com	(34) 9295-4071	Importado	23	Sem Atendimento	\N	\N	t	553492954071@s.whatsapp.net	\N	2025-06-13 12:37:15.934	2025-05-04 00:00:00	\N	\N
8524	Geraldo Maia	geraldomaia159@gmail.com	(34) 9665-0931	Importado	23	Sem Atendimento	\N	\N	t	553496650931@s.whatsapp.net	\N	2025-06-13 12:37:26.694	2025-05-04 00:00:00	\N	\N
8579	Devanice Aparecida Marques Candido	devaniceap15@gmail.com	(34) 99666-2515	Importado	22	Sem Atendimento	\N	\N	t	553496662515@s.whatsapp.net	\N	2025-06-13 12:32:26.387	2025-05-07 00:00:00	\N	\N
8578	Marcos Antonio Borges	m.antonio.borges@bol.com.br	(34) 99973-9456	Importado	22	Sem Atendimento	\N	\N	t	553499739456@s.whatsapp.net	\N	2025-06-13 12:32:31.762	2025-05-07 00:00:00	\N	\N
8575	Marcio Aparecido da Silva	marcioap1010@gmail.com	(34) 99246-3687	Importado	13	Sem Atendimento	\N	\N	t	553492463687@s.whatsapp.net	\N	2025-06-13 12:32:47.898	2025-05-07 00:00:00	\N	\N
8574	lopes	nicollymlpaula@gmail.com	(34) 99868-4145	Importado	13	Sem Atendimento	\N	\N	t	553498684145@s.whatsapp.net	\N	2025-06-13 12:32:53.265	2025-05-07 00:00:00	\N	\N
8573	Ana Yelle	anayelle.motasouza@icloud.com	(34) 99272-7862	Importado	13	Sem Atendimento	\N	\N	t	553492727862@s.whatsapp.net	\N	2025-06-13 12:32:58.702	2025-05-07 00:00:00	\N	\N
8530	Hosana Costa	hosanacfcosta@gmail.com	(34) 99282-3677	Importado	22	Visita	\N	14	t	553492823677@s.whatsapp.net	\N	2025-06-13 12:36:54.039	2025-05-04 00:00:00	\N	\N
8572	Pamella Melo	pamellamsfm@gmail.com	(34) 98407-2728	Importado	22	Sem Atendimento	\N	\N	t	553484072728@s.whatsapp.net	\N	2025-06-13 12:33:04.073	2025-05-06 00:00:00	\N	\N
8529	vitria	vc8254467@gmail.com	(34) 98878-3596	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:36:59.394	2025-05-04 00:00:00	\N	\N
8532	Samuel Oliveira	so6099079@gmail.com	(34) 99978-9863	Importado	13	Sem Atendimento	\N	\N	t	553499789863@s.whatsapp.net	\N	2025-06-13 12:36:43.247	2025-05-05 00:00:00	\N	\N
8531	Aline Claudia Machado	alinecostamachado1@gmail.com	(34) 99275-4520	Importado	22	Sem Atendimento	\N	\N	t	553492754520@s.whatsapp.net	\N	2025-06-13 12:36:48.67	2025-05-04 00:00:00	\N	\N
8534	Leandro Batista	leandro.pereira87@hotmail.com	(34) 9707-2112	Importado	13	Sem Atendimento	\N	\N	t	553497072112@s.whatsapp.net	\N	2025-06-13 12:36:31.74	2025-05-05 00:00:00	\N	\N
8533	Cristina Sousa	cris.udi@hotmail.com	(34) 99114-3011	Importado	13	Sem Atendimento	\N	\N	t	553491143011@s.whatsapp.net	\N	2025-06-13 12:36:37.587	2025-05-05 00:00:00	\N	\N
8536	Douglas Resende	dodo.cross@hotmail.com	(34) 99912-0891	Importado	13	Sem Atendimento	\N	\N	t	553499120891@s.whatsapp.net	\N	2025-06-13 12:36:20.908	2025-05-05 00:00:00	\N	\N
8535	Joo  Batista	joaobatista199800@gmail.com	(34) 99183-8013	Importado	13	Sem Atendimento	\N	\N	t	553491838013@s.whatsapp.net	\N	2025-06-13 12:36:26.269	2025-05-05 00:00:00	\N	\N
8528	Esthefane Caroline LS	esthefanecaroline2014@gmail.com	(34) 99898-6104	Importado	22	Sem Atendimento	\N	\N	t	553498986104@s.whatsapp.net	\N	2025-06-13 12:37:04.825	2025-05-04 00:00:00	\N	\N
8539	Diego Fernandes	diegoaxb@gmail.com	(34) 99261-3145	Importado	13	Sem Atendimento	\N	\N	t	553492613145@s.whatsapp.net	\N	2025-06-13 12:36:04.464	2025-05-05 00:00:00	\N	\N
8538	Jos Augusto	jose3898@live.com	(34) 99688-5806	Importado	13	Sem Atendimento	\N	\N	t	553496885806@s.whatsapp.net	\N	2025-06-13 12:36:09.909	2025-05-05 00:00:00	\N	\N
8571	Daniele Campos	danielecampossilva@hotmail.com	(34) 99694-8504	Importado	22	Sem Atendimento	\N	\N	t	553496948504@s.whatsapp.net	\N	2025-06-13 12:33:09.461	2025-05-06 00:00:00	\N	\N
8570	Rodrigo Ferreira	ferosilva001@gmail.com	(34) 9684-3232	Importado	22	Sem Atendimento	\N	\N	t	553496843232@s.whatsapp.net	\N	2025-06-13 12:33:14.822	2025-05-06 00:00:00	\N	\N
8569	Lucimar Brando	lujhonyamor@gmail.com	(34) 98412-5126	Importado	22	Sem Atendimento	\N	\N	t	553484125126@s.whatsapp.net	\N	2025-06-13 12:33:20.245	2025-05-06 00:00:00	\N	\N
8568	Marcos Renato	marcosrenato94@yahoo.com.br	(34) 99186-9186	Importado	22	Sem Atendimento	\N	\N	t	553491869186@s.whatsapp.net	\N	2025-06-13 12:33:25.617	2025-05-06 00:00:00	\N	\N
8567	Danyele Vilela	danyelevilela@gmail.com	(34) 99307-7993	Importado	22	Sem Atendimento	\N	\N	t	553493077993@s.whatsapp.net	\N	2025-06-13 12:33:31.045	2025-05-06 00:00:00	\N	\N
8562	Vilma Assis	vilmafa@hotmail.com	(34) 99175-5603	Importado	13	Sem Atendimento	\N	\N	t	553491755603@s.whatsapp.net	\N	2025-06-13 12:33:58.334	2025-05-06 00:00:00	\N	\N
8537	Wendell alves	luanlucassantos23@gmail.com	(34) 98849-2131	Importado	13	Sem Atendimento	\N	\N	t	553488492131@s.whatsapp.net	\N	2025-06-13 12:36:15.391	2025-05-05 00:00:00	\N	\N
8551	Laura Pedrosa	laurapedrosa153@gmail.com	(34) 99195-2539	Importado	22	Sem Atendimento	\N	\N	t	553491952539@s.whatsapp.net	\N	2025-06-13 12:34:58.279	2025-05-05 00:00:00	\N	\N
8550	Nelton Henrique	neltonherinque5@gmail.com	(34) 9240-9565	Importado	22	Sem Atendimento	\N	\N	t	553492409565@s.whatsapp.net	\N	2025-06-13 12:35:04.445	2025-05-05 00:00:00	\N	\N
8541	Sonia Regina	soniaraguiar@gmail.com	(34) 99778-4100	Importado	13	Sem Atendimento	\N	\N	t	553497784100@s.whatsapp.net	\N	2025-06-13 12:35:53.642	2025-05-05 00:00:00	\N	\N
8540	Karolina Freitas	wkarolina.antunes2@gmail.com	(34) 99191-3688	Importado	13	Sem Atendimento	\N	\N	t	553491913688@s.whatsapp.net	\N	2025-06-13 12:35:59.043	2025-05-05 00:00:00	\N	\N
8555	Cristiane Lopes	cris.lopes2040@gmail.com	(34) 99241-6256	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:34:36.474	2025-05-05 00:00:00	\N	\N
8554	Nandinho Rodrigues	f.s.081991325793@gmail.com	(34) 98436-8286	Importado	22	Sem Atendimento	\N	\N	t	553484368286@s.whatsapp.net	\N	2025-06-13 12:34:42.079	2025-05-05 00:00:00	\N	\N
8553	Lucilene Faria	lucileneelias19@gmail.com	(34) 99142-5309	Importado	22	Sem Atendimento	\N	\N	t	553491425309@s.whatsapp.net	\N	2025-06-13 12:34:47.472	2025-05-05 00:00:00	\N	\N
8552	Luana	luanafernandesluanete@gmail.com	(34) 99639-8643	Importado	22	Sem Atendimento	\N	\N	t	553496398643@s.whatsapp.net	\N	2025-06-13 12:34:52.896	2025-05-05 00:00:00	\N	\N
8560	Paulo Silva	paiolpaulo@hotmail.com	(34) 99124-1063	Importado	13	Sem Atendimento	\N	\N	t	553491241063@s.whatsapp.net	\N	2025-06-13 12:34:09.254	2025-05-06 00:00:00	\N	\N
8559	Gustavo	gustavo_1593@famanegociosimobiliarios.com.br	(34) 9789-5411	Importado	13	Visita	\N	14	t	553497895411@s.whatsapp.net	\N	2025-06-13 12:34:14.724	2025-05-05 00:00:00	\N	\N
8561	Mauro Pereira	mauroalvespereira54@gmail.com	(34) 9295-4455	Importado	13	Sem Atendimento	\N	\N	t	553492954455@s.whatsapp.net	\N	2025-06-13 12:34:03.714	2025-05-06 00:00:00	\N	\N
8558	Henrique Neves	henriquesantosneves42@gmail.com	(79) 99879-7290	Importado	22	Sem Atendimento	\N	\N	t	557998797290@s.whatsapp.net	\N	2025-06-13 12:34:20.152	2025-05-05 00:00:00	\N	\N
8557	Cleide Freitas	freitascleide967@gmail.com	(34) 99666-3596	Importado	22	Sem Atendimento	\N	\N	t	553496663596@s.whatsapp.net	\N	2025-06-13 12:34:25.668	2025-05-05 00:00:00	\N	\N
8556	Luiz Ricardo	l.rick.lrab@gmail.com	(62) 99339-3482	Importado	22	Sem Atendimento	\N	\N	t	556293393482@s.whatsapp.net	\N	2025-06-13 12:34:31.087	2025-05-05 00:00:00	\N	\N
7867	Alex Julian Singer	alex_julian2005@hotmail.com	(34) 99645-6927	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8523	Priscila Souza Ramos	prijesus04@gmail.com	(31) 99252-6486	Importado	23	Sem Atendimento	\N	\N	t	553192526486@s.whatsapp.net	\N	2025-06-13 12:37:32.095	2025-05-04 00:00:00	\N	\N
8522	Alexandre Siqueira Silva	alexandregordosilva10@gmail.com	(34) 99180-0550	Importado	23	Sem Atendimento	\N	\N	t	553491800550@s.whatsapp.net	\N	2025-06-13 12:37:37.507	2025-05-04 00:00:00	\N	\N
8521	RAFAEL SOUZA	rafaelsouzass1609@gmail.com	(34) 98414-8072	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:37:42.98	2025-05-04 00:00:00	\N	\N
8512	Vladimir Luiz	vladimirluiz55@gmail.com	(34) 99660-4442	Importado	23	Sem Atendimento	\N	\N	t	553496604442@s.whatsapp.net	\N	2025-06-13 12:38:31.637	2025-05-01 00:00:00	\N	\N
8502	Carlin	carlosdkrt@gmail.com	(34) 9111-7475	Importado	23	Sem Atendimento	\N	\N	t	553491117475@s.whatsapp.net	\N	2025-06-13 12:39:25.645	2025-04-30 00:00:00	\N	\N
8501	Eli Freitas	eli299630@gmail.com	(34) 99790-5828	Importado	23	Sem Atendimento	\N	\N	t	553497905828@s.whatsapp.net	\N	2025-06-13 12:39:31.125	2025-04-30 00:00:00	\N	\N
8634	johnnantan	johnnatasilva405@gmail.com	(38) 99930-4214	Importado	22	Sem Atendimento	\N	\N	t	553899304214@s.whatsapp.net	\N	2025-06-13 12:27:26.59	2025-05-11 00:00:00	\N	\N
8500	olaides Junior	graci.silva86@yahoo.com	(34) 9641-9052	Importado	23	Sem Atendimento	\N	\N	t	553496419052@s.whatsapp.net	\N	2025-06-13 12:39:36.487	2025-04-30 00:00:00	\N	\N
8480	Cinthia Queiroz	cinthiaqueirozjd@hotmail.com	(34) 9923-6520	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:41:24.972	2025-04-28 00:00:00	\N	\N
8470	Lidiany Martins	lidianyaraujo.2@hotmail.com	(34) 99878-0499	Importado	23	Sem Atendimento	\N	\N	t	553498780499@s.whatsapp.net	\N	2025-06-13 12:42:19.082	2025-04-27 00:00:00	\N	\N
8469	Vaal Ferreira	guuhsoares245@gmail.com	(38) 99740-9930	Importado	23	Sem Atendimento	\N	\N	t	553897409930@s.whatsapp.net	\N	2025-06-13 12:42:24.445	2025-04-27 00:00:00	\N	\N
8633	Isabela Sthefany	isabelas921@gmail.com	(34) 99888-8904	Importado	22	Sem Atendimento	\N	\N	t	553498888904@s.whatsapp.net	\N	2025-06-13 12:27:31.966	2025-05-11 00:00:00	\N	\N
8632	Harryson Arruda	harrysonrn@hotmail.com	(34) 9129-7535	Importado	22	Sem Atendimento	\N	\N	t	553491297535@s.whatsapp.net	\N	2025-06-13 12:27:37.401	2025-05-11 00:00:00	\N	\N
8584	Jean Carlos Jcsm	vendas.j1@hotmail.com	(34) 9662-6158	Importado	13	Sem Atendimento	\N	\N	t	553496626158@s.whatsapp.net	\N	2025-06-13 12:31:59.374	2025-05-08 00:00:00	\N	\N
8631	Anglica Guimares	angelguimaraes59@gmail.com	(34) 99633-3242	Importado	22	Sem Atendimento	\N	\N	t	553496333242@s.whatsapp.net	\N	2025-06-13 12:27:43.029	2025-05-11 00:00:00	\N	\N
8627	Wedson Lucio da Silva	wedsonluciodasilva@gmail.com	(99) 9684-8929	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:28:04.672	2025-05-11 00:00:00	\N	\N
8626	Pablo Vitor	pablovitorrocha017@gmail.com	(77) 99874-6768	Importado	13	Sem Atendimento	\N	\N	t	557798746768@s.whatsapp.net	\N	2025-06-13 12:28:10.215	2025-05-11 00:00:00	\N	\N
8625	Maria Ana Rodrigues de Matos	mariamatos2806@gmail.com	(69) 9940-7745	Importado	13	Sem Atendimento	\N	\N	t	556999407745@s.whatsapp.net	\N	2025-06-13 12:28:15.639	2025-05-11 00:00:00	\N	\N
8624	Anne Carolina	carolmonte2009@hotmail.com	(34) 99832-6073	Importado	22	Sem Atendimento	\N	\N	t	553498326073@s.whatsapp.net	\N	2025-06-13 12:28:21.174	2025-05-10 00:00:00	\N	\N
8623	Manoel Batista	emanuelbatistaebail@gmail.com	(34) 99651-6146	Importado	22	Sem Atendimento	\N	\N	t	553496516146@s.whatsapp.net	\N	2025-06-13 12:28:27.284	2025-05-10 00:00:00	\N	\N
8622	Netaly Oliveira	netalyb.nascimento@gmail.com	(34) 99309-0535	Importado	22	Sem Atendimento	\N	\N	t	553493090535@s.whatsapp.net	\N	2025-06-13 12:28:32.801	2025-05-10 00:00:00	\N	\N
8583	Nick Silva	nicolysilva12536@gmail.com	(11) 97261-5886	Importado	13	Sem Atendimento	\N	\N	t	5511972615886@s.whatsapp.net	\N	2025-06-13 12:32:04.745	2025-05-08 00:00:00	\N	\N
8601	Richard Maciel Frana	injetronicsystem@hotmail.com	(34) 99116-3635	Importado	13	Sem Atendimento	\N	\N	t	553491163635@s.whatsapp.net	\N	2025-06-13 12:30:26.764	2025-05-09 00:00:00	\N	\N
8600	Thiago Garcia	t.garcialive@gmail.com	(35) 99105-6268	Importado	22	Sem Atendimento	\N	\N	t	553591056268@s.whatsapp.net	\N	2025-06-13 12:30:32.359	2025-05-08 00:00:00	\N	\N
8599	Danilo Alves	danilooooo123@hotmail.com	(64) 99626-7767	Importado	22	Sem Atendimento	\N	\N	t	556496267767@s.whatsapp.net	\N	2025-06-13 12:30:37.753	2025-05-08 00:00:00	\N	\N
8598	Marcio Garcia	bladegarcia@hotmail.com	(34) 98811-6993	Importado	22	Sem Atendimento	\N	\N	t	553488116993@s.whatsapp.net	\N	2025-06-13 12:30:43.203	2025-05-08 00:00:00	\N	\N
8618	Livia Alves Cantarin	livia.cantarin@gmail.com	(34) 98811-5827	Importado	13	Sem Atendimento	\N	\N	t	553488115827@s.whatsapp.net	\N	2025-06-13 12:28:54.785	2025-05-10 00:00:00	\N	\N
8617	Maurcio Jose	mauricioavivamento123@gmail.com	(31) 99868-1612	Importado	13	Sem Atendimento	\N	\N	t	553198681612@s.whatsapp.net	\N	2025-06-13 12:29:00.162	2025-05-10 00:00:00	\N	\N
8616	William Cesar Silva	willcesar@yahoo.com.br	(34) 8805-0545	Importado	22	Sem Atendimento	\N	\N	t	553488050545@s.whatsapp.net	\N	2025-06-13 12:29:05.611	2025-05-09 00:00:00	\N	\N
8615	Thiago Melo	tsmelo.13@gmail.com	(34) 99156-8233	Importado	22	Sem Atendimento	\N	\N	t	553491568233@s.whatsapp.net	\N	2025-06-13 12:29:10.998	2025-05-09 00:00:00	\N	\N
8597	Brenda Leite	brendaleite16032004@gmail.com	(34) 99122-6970	Importado	22	Sem Atendimento	\N	\N	t	553491226970@s.whatsapp.net	\N	2025-06-13 12:30:48.694	2025-05-08 00:00:00	\N	\N
8596	Cleonice Gil Aguilar	aguilar.cleonice@yahoo.com	(35) 1930530110	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:30:54.072	2025-05-08 00:00:00	\N	\N
8595	Wellen Rezende	wellenrezende@gmail.com	(31) 98752-8585	Importado	22	Sem Atendimento	\N	\N	t	553187528585@s.whatsapp.net	\N	2025-06-13 12:30:59.436	2025-05-08 00:00:00	\N	\N
8586	Otvio	otaviodoj7@gmail.com	(31) 99550-4645	Importado	13	Sem Atendimento	\N	\N	t	553195504645@s.whatsapp.net	\N	2025-06-13 12:31:48.324	2025-05-08 00:00:00	\N	\N
8585	oficial_lucianojunior	lucianom2nobre@gmail.com	(34) 98856-2332	Importado	13	Agendamento	\N	14	t	553488562332@s.whatsapp.net	\N	2025-06-13 12:31:53.975	2025-05-08 00:00:00	\N	\N
8614	Eldimaria Dias Cabral Malaquias	eldimariadiascabral852@gmail.com	(34) 99306-2968	Importado	22	Sem Atendimento	\N	\N	t	553493062968@s.whatsapp.net	\N	2025-06-13 12:29:16.364	2025-05-09 00:00:00	\N	\N
8613	Jos SantosdaCunha	josesantos03597@gmail.com	(13) 4984477716	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:29:21.783	2025-05-09 00:00:00	\N	\N
8611	Nadir Bianquine Arantes	nabianarantes@gmail.com	(34) 99215-7310	Importado	22	Sem Atendimento	\N	\N	t	553492157310@s.whatsapp.net	\N	2025-06-13 12:29:32.605	2025-05-09 00:00:00	\N	\N
8610	Claudiene Alves	claudyene@gmail.com	(34) 99862-3465	Importado	22	Sem Atendimento	\N	\N	t	553498623465@s.whatsapp.net	\N	2025-06-13 12:29:38.017	2025-05-09 00:00:00	\N	\N
8605	Lorena Guimares	pereiralorena@hotmail.com	(34) 99962-8822	Importado	13	Sem Atendimento	\N	\N	t	553499628822@s.whatsapp.net	\N	2025-06-13 12:30:05.089	2025-05-09 00:00:00	\N	\N
8604	Diego Arantes	diegohas75@gmail.com	(34) 99123-9977	Importado	13	Sem Atendimento	\N	\N	t	553491239977@s.whatsapp.net	\N	2025-06-13 12:30:10.468	2025-05-09 00:00:00	\N	\N
8603	Talles Henrique Personal	talleshenriquecontato@gmail.con	(34) 99145-7599	Importado	13	Sem Atendimento	\N	\N	t	553491457599@s.whatsapp.net	\N	2025-06-13 12:30:15.904	2025-05-09 00:00:00	\N	\N
8602	Amanda Yasmim	amanday607@gmail.com	(37) 99903-9766	Importado	13	Sem Atendimento	\N	\N	t	553799039766@s.whatsapp.net	\N	2025-06-13 12:30:21.273	2025-05-09 00:00:00	\N	\N
7868	Jlia	juliamenorzinha007@gmail.com	(34) 9155-5224	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8671	FERNANDA (Importação Manual)	fernanda_importacao_manual_1747222432332@famanegociosimobiliarios.com.br	(34) 84463-3758	Importado 	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:24:03.285	2025-01-08 00:00:00	\N	\N
8670	Bruno Augusto Jose Silva Bispo	bruno_augusto_jose_silva_bispo_1747222318538@famanegociosimobiliarios.com.br	(34) 9915-4379	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:24:08.72	2025-01-31 00:00:00	\N	\N
8669	Silvimar Oliveira Porto Oliveira	Oliveiraporto0@hotmail.com	(34) 9996-1601	Importado	23	Sem Atendimento	\N	\N	t	553499961601@s.whatsapp.net	\N	2025-06-13 12:24:14.195	2025-02-02 00:00:00	\N	\N
8668	Renata  maria de Carvalho	renatavalho@gmail.com	(64) 99252-5656	Importado	23	Sem Atendimento	\N	\N	t	556492525656@s.whatsapp.net	\N	2025-06-13 12:24:19.65	2025-02-02 00:00:00	\N	\N
8642	Lisandra ester silvestre araujo 	lana.210407@gmail.com	(34) 99803-9298	Importado	22	Sem Atendimento	\N	\N	t	553498039298@s.whatsapp.net	\N	2025-06-13 12:26:42.826	2025-05-12 00:00:00	\N	\N
8643	Leidiane Marcela	marcosfranca22@hotmail.com	(34) 3505-0325	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:26:37.329	2025-05-12 00:00:00	\N	\N
8644	Eduardo Alves	eduardo6509e@gmail.com	(61) 8302-0830	Importado	22	Sem Atendimento	\N	\N	t	556183020830@s.whatsapp.net	\N	2025-06-13 12:26:31.623	2025-05-12 00:00:00	\N	\N
8646	Ana	anavitoriaspaceklopes@gmail.com	(34) 99225-2811	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:26:20.774	2025-05-12 00:00:00	\N	\N
8647	Ellen Christina	ellencas172@gmail.com	(34) 99154-3281	Importado	22	Sem Atendimento	\N	\N	t	553491543281@s.whatsapp.net	\N	2025-06-13 12:26:15.398	2025-05-12 00:00:00	\N	\N
8648	Caua Leyva Ca	caualeyva09@gmail.com	(34) 9961-9631	Importado	22	Sem Atendimento	\N	\N	t	553499619631@s.whatsapp.net	\N	2025-06-13 12:26:09.949	2025-05-12 00:00:00	\N	\N
8649	Fillipe Suzigan	fillipealvessuzigam@hotmail.com	(34) 99151-5891	Importado	22	Sem Atendimento	\N	\N	t	553491515891@s.whatsapp.net	\N	2025-06-13 12:26:03.669	2025-05-12 00:00:00	\N	\N
8667	Gabriel Camargos	gabriel.camargos@outlook.com	(38) 99890-2429	Importado	23	Sem Atendimento	\N	\N	t	553898902429@s.whatsapp.net	\N	2025-06-13 12:24:25.095	2025-02-02 00:00:00	\N	\N
8666	Eduarda Nogueira	comercial.huntersagency@gmail.com	(34) 98805-0570	Importado	23	Sem Atendimento	\N	\N	t	553488050570@s.whatsapp.net	\N	2025-06-13 12:24:30.605	2025-01-28 00:00:00	\N	\N
8664	Natiih Siilva	nathaliakarolaine14@gmail.com	(34) 99142-2727	Importado	23	Sem Atendimento	\N	\N	t	553491422727@s.whatsapp.net	\N	2025-06-13 12:24:41.618	2025-01-06 00:00:00	\N	\N
8650	Juliana Rodrigues	rodrigueaj16@gmail.com	(34) 99197-5168	Importado	22	Sem Atendimento	\N	\N	t	553491975168@s.whatsapp.net	\N	2025-06-13 12:25:58.072	2025-05-12 00:00:00	\N	\N
8654	Amanda Silva	amandactsilva22@gmail.com	(34) 9968-2806	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:25:36.338	2025-05-13 00:00:00	\N	\N
8655	Daniel Silva	ds6030105@gmail.com	(84) 99199-5044	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:25:30.702	2025-05-13 00:00:00	\N	\N
8656	Delvia Lopes	delvialopess@outlook.com	(35) 8834-5702	Importado	22	Sem Atendimento	\N	\N	t	553588345702@s.whatsapp.net	\N	2025-06-13 12:25:25.339	2025-05-13 00:00:00	\N	\N
7083	Giovanna Matos	ggiomatos1@hotmail.com	(34) 99202-7572	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	\N	\N
8657	Duda	duda_1691@famanegociosimobiliarios.com.br	(34) 9685-6961	Importado	13	Visita	\N	17	t	553496856961@s.whatsapp.net	\N	2025-06-13 12:25:19.769	2025-05-13 00:00:00	\N	\N
8658	Tiago Ramalho	tiagoobreirouniversal@gmail.com	(61) 99664-9292	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:25:14.119	2025-01-05 00:00:00	\N	\N
8659	Celeida Oliveira	celeidavieiraoliveira@gmail.com	(34) 9159-1458	Importado	23	Sem Atendimento	\N	\N	t	553491591458@s.whatsapp.net	\N	2025-06-13 12:25:08.716	2025-01-05 00:00:00	\N	\N
8660	Ludmila Sousa	lud.sousa2017@outlook.com	(34) 99682-7814	Importado	23	Sem Atendimento	\N	\N	t	553496827814@s.whatsapp.net	\N	2025-06-13 12:25:03.247	2025-01-05 00:00:00	\N	\N
8661	Juliana Valerio	wjksalves@gmail.com	(34) 99878-9223	Importado	23	Sem Atendimento	\N	\N	t	553498789223@s.whatsapp.net	\N	2025-06-13 12:24:57.822	2025-01-06 00:00:00	\N	\N
8663	Nayra Rafaela	nayrarafaela69@gmail.com	(34) 99942-5623	Importado	23	Sem Atendimento	\N	\N	t	553499425623@s.whatsapp.net	\N	2025-06-13 12:24:47.005	2025-01-06 00:00:00	\N	\N
6980	Vanilson Amaral	vanilson.dias1094@gmail.com	(34) 99939-5995	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7114	Simone	simone_143@famanegociosimobiliarios.com.br	(34) 9183-1484	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-14 14:20:17.216	2025-01-08 00:00:00	\N	\N
6982	William Ferreira	william-luz@hotmail.com	(34) 9900-7195	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
6989	Marina Rodrigues	marinarno76@gmail.com	(34) 99293-4518	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7002	Lucirene Urzedo de Paula	lu.urzedo@hotmail.com	(34) 9956-0242	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-03 00:00:00	2025-01-03 00:00:00	\N	\N
7024	Jessica Rodrigues	jessicarodriguesolegario12122@gmail.com	(34) 98899-6715	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7045	Mosair Santos	katia-mosair@hotmail.com	(34) 99918-5068	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7049	Ingrid Palumino	julianamoradinha24@gmail.com	(34) 99884-3862	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7064	Marcus Vinicius	marcusmendes1999@hotmail.com	(35) 9745-9996	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
7102	Neria Carolina	neriacarolinaduarte@hotmail.com	(34) 99893-3358	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-08 00:00:00	2025-01-08 00:00:00	\N	\N
7134	Amanda Rodrigues	amandarodriguesal17@gmail.com	(34) 99682-6475	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7153	Marco Tulio Amaral	marcotuliozeiro@hotmail.com	(34) 99690-5961	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-11 00:00:00	2025-01-11 00:00:00	\N	\N
7158	Victor	victor03limeira@gmail.com	(34) 99653-7264	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7160	Rubens Rodrigues Machado	rubensleiliane@gmail.com	(34) 98827-1081	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-12 00:00:00	2025-01-12 00:00:00	\N	\N
7182	Jardel Oliveira	jardeloliverr21@gmail.com	(34) 98401-6857	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-13 00:00:00	2025-01-13 00:00:00	\N	\N
7200	Samuel da Silva	1998silvasamu@gmail.com	(34) 9859-6135	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7214	Marineide Pereira	pereiramarineide12@gmail.com	(88) 98106-0799	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7217	Eduardo Anjos Fernandes	eduardoanjosfernandes@gmail.com	(34) 99777-2312	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7235	Tayssa Helena Eleoterio da Silva	helenatayssa03@gmail.com	(34) 9143-5112	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7902	Wellington Sobrinho	wellingtonudi@hotmail.com	(34) 98402-7521	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7903	Romy Carla	romycarlavieira@gmail.com	(34) 99671-6006	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7905	Tatiele Mrcia	tatielemarcia_@hotmail.com	(34) 9156-8663	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7906	Marcos Eduardo 	marcoseduardo.silva071@gmail.com	(38) 99960-6664	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7907	Marcia Casangelo	casangelomarcia03@gmail.com	(17) 98103-5139	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7580	Heytor Hugo	heytor20000@gmail.com	(34) 99715-6052	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7585	Fernanda Soares	soares.damasceno.fernanda@gmail.com	(32) 98844-5157	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7605	Elionai Rodrigues	elionai-rodrigues@hotmail.com	(34) 98825-9298	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7607	Tassia Paulino	tassiapaulino@outlook.com	(34) 98810-8195	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-21 00:00:00	2025-02-21 00:00:00	\N	\N
7614	Amanda Santos	amandasantoss1@hotmail.com	(34) 98803-2164	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7632	Janaina Marques	janainamarques.adm@gmail.com	(34) 92000-1284	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-05 00:00:00	2025-03-05 00:00:00	\N	\N
7648	Nilce Tiburtino	nilcetiburtino2018@gmail.com	(84) 9617-0849	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7780	Jessica Alves	jessicaasouza623@gmail.com	(34) 99203-6834	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7794	Richard Valentim	richardvalentim@bol.com.br	(34) 9766-3053	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-13 00:00:00	2025-03-13 00:00:00	\N	\N
7813	Simone Oliveira	simone_oliveira_847@famanegociosimobiliarios.com.br	(69) 99976-8872	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7831	Ana Karolina Credi Dio	karolcredidio@gmail.com	(34) 9252-1063	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7843	Leandro Rodrigues	leandrorodrigues097846@gmail.com	(34) 99833-3083	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-15 00:00:00	2025-03-15 00:00:00	\N	\N
7882	Weslhysson Gleydson Raimundo fernandes	kendrioalef@gmail.com	(93) 99126-5703	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7887	Jos� Neto	jos__neto_921@famanegociosimobiliarios.com.br	(34) 9999-3356	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7253	Maria Pertile	juliapertile@hotmail.com	(34) 99678-7981	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7271	Maria Isabella	mariaisabellafernandesdeolivei@gmail.com	(34) 99829-6272	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-19 00:00:00	2025-01-19 00:00:00	\N	\N
7291	Samyra Oliveira	samyrao619@gmail.com	(34) 98405-4489	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-21 00:00:00	2025-01-21 00:00:00	\N	\N
7305	camilla	camillarodriguesborges@gmail.com	(64) 99235-8054	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-24 00:00:00	2025-01-24 00:00:00	\N	\N
7326	marcos roberto mazzeo	marcos.mazzeoricosoqnao@gmail.com	(19) 98767-4738	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7339	Jlia Honorato	juliagonshonorato45@gmail.com	(34) 99977-4295	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7355	Erick Luiz	erickluizoliveira2006@gmail.com	(34) 99212-8572	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-01-26 00:00:00	2025-01-26 00:00:00	\N	\N
7380	Maria Fernanda	mariafernandamf1225@outlook.com	(34) 99202-7054	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7384	Gabriella Rezende	gabriella.rezende.udia@gmail.com	(34) 99710-0890	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-04 00:00:00	2025-02-04 00:00:00	\N	\N
7327	Luiz Otvio Ferreira	luiz.otavio.077685@gmail.com	(34) 99708-6690	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-01-25 00:00:00	2025-01-25 00:00:00	\N	\N
7974	R2 GAS	r2gas.venda@gmail.com	(34) 99159-2124	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7975	Lorena Souza	lorenaslf@hotmail.com	(38) 99166-0183	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7976	Ana Flvia	anaanjospx07@icloud.com	(38) 99105-3802	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7981	Jssica Souza	jessicasouzaa003@gmail.com	(34) 9799-6044	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
7999	Sebastio Severino Flix	tiaozinhonaturaup@gmail.com	(34) 98833-7833	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8000	Carolina Silva	casilva14@yahoo.com.br	(31) 99745-7220	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8011	Joo Silva	joaovicentesilva650@gmail.com	(16) 99261-0651	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-23 00:00:00	2025-03-23 00:00:00	\N	\N
8046	Juliana Pereira Fernandes	juliana.pfernandes@gmail.com	(31) 99420-6889	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8056	Wesley Souza	wesley_csouza@outlook.com	(31) 98233-7011	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8079	Marcos Martins	marcossilvaa85553635@gmail.com	(31) 98555-3635	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-29 00:00:00	2025-03-29 00:00:00	\N	\N
8182	Vinicius Silva	costa1998silva@outlook.com	(34) 99922-9232	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
8247	maria ines da silva oliveira	mariainesoliveira976@gmail.com	(34) 9217-1356	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-10 00:00:00	2025-04-10 00:00:00	\N	\N
8224	Rosimeire Rodrigues	rosimeireleite2008@hotmail.com	(34) 99643-4192	Importado	22	Agendamento	\N	14	\N	\N	\N	2025-04-08 00:00:00	2025-04-08 00:00:00	\N	\N
8058	Kaue	kaue_1092@famanegociosimobiliarios.com.br	(34) 9265-9370	Importado	13	Visita	\N	14	\N	\N	\N	2025-05-14 14:52:47.258	2025-03-28 00:00:00	\N	\N
8201	Camila Nara	camila_nara_1235@famanegociosimobiliarios.com.br	(34) 8447-8250	Importado	23	Venda	626.471.793-28	14	\N	\N	\N	2025-05-15 13:15:24.321	2025-04-07 00:00:00	\N	\N
8490	Giovanna Freitas	giovannafreitas09@hotmail.com	(64) 99662-6255	Importado	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:40:30.927	2025-04-28 00:00:00	\N	\N
8472	Carmilene Milk	carmileneleite@gmail.com	(34) 9640-6192	Importado	22	Sem Atendimento	\N	\N	t	553496406192@s.whatsapp.net	\N	2025-06-13 12:42:08.292	2025-04-27 00:00:00	\N	\N
8432	Reina Josefina Rodrigues Lopez	reinajosefinarodrigueslopez@gmail.com	(34) 99828-3771	Importado	22	Sem Atendimento	\N	\N	t	553498283771@s.whatsapp.net	\N	2025-06-13 12:45:45.731	2025-04-23 00:00:00	\N	\N
8415	Adriana Braga	adrianabraga664@gmail.com	(34) 99800-4257	Importado	13	Sem Atendimento	\N	\N	t	553498004257@s.whatsapp.net	\N	2025-06-13 12:47:19.605	2025-04-23 00:00:00	\N	\N
8101	Marcos Ryan	ryanpaiva130@icloud.com	(31) 98249-7320	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8462	Alex Junio Amorim Souza	souzaalexx33@gmail.com	(34) 99864-4507	Importado	23	Sem Atendimento	\N	\N	t	553498644507@s.whatsapp.net	\N	2025-06-13 12:43:02.612	2025-04-26 00:00:00	\N	\N
8457	fabifpratagmailcom	neil.prata@hotmail.com	(34) 98885-3469	Importado	23	Sem Atendimento	\N	\N	t	553488853469@s.whatsapp.net	\N	2025-06-13 12:43:29.735	2025-04-25 00:00:00	\N	\N
8456	Maria Luiza Marcelino	marcelinoluizamaria@gmail.com	(34) 99650-4405	Importado	23	Sem Atendimento	\N	\N	t	553496504405@s.whatsapp.net	\N	2025-06-13 12:43:35.083	2025-04-25 00:00:00	\N	\N
8455	Kauane Kelly	kauane.kauane.ass@gmail.com	(34) 99103-9892	Importado	23	Sem Atendimento	\N	\N	t	553491039892@s.whatsapp.net	\N	2025-06-13 12:43:40.56	2025-04-25 00:00:00	\N	\N
8447	maria	izidiamaria04@hotmail.com	(34) 98854-7118	Importado	23	Sem Atendimento	\N	\N	t	553488547118@s.whatsapp.net	\N	2025-06-13 12:44:24.151	2025-04-24 00:00:00	\N	\N
8445	Stefany Godoi	stefany.gdeoliveira@gmail.com	(34) 99631-7628	Importado	23	Sem Atendimento	\N	\N	t	553496317628@s.whatsapp.net	\N	2025-06-13 12:44:35.045	2025-04-24 00:00:00	\N	\N
8444	Danielle Ferreira	danieleferreirapinto2205@gmail.com	(37) 99946-5041	Importado	23	Sem Atendimento	\N	\N	t	553799465041@s.whatsapp.net	\N	2025-06-13 12:44:40.447	2025-04-24 00:00:00	\N	\N
8428	Matheus Basilio	matheus_basilio@outlook.com	(34) 99771-0007	Importado	23	Sem Atendimento	\N	\N	t	553497710007@s.whatsapp.net	\N	2025-06-13 12:46:08.069	2025-04-23 00:00:00	\N	\N
8662	DECORAES EM GERAL  BUFFET INFANTIL	crisdecore@hotmail.com	(34) 9767-2473	Importado	23	Sem Atendimento	\N	\N	t	553497672473@s.whatsapp.net	\N	2025-06-13 12:24:52.427	2025-01-06 00:00:00	\N	\N
8426	Carlos Eduardo	srcarlosoeduardo@gmail.com	(34) 98406-4519	Importado	23	Sem Atendimento	\N	\N	t	553484064519@s.whatsapp.net	\N	2025-06-13 12:46:18.927	2025-04-23 00:00:00	\N	\N
8425	Ilenice Eliel	elieleilenice@hotmail.com	(38) 99165-5934	Importado	23	Sem Atendimento	\N	\N	t	553891655934@s.whatsapp.net	\N	2025-06-13 12:46:24.283	2025-04-23 00:00:00	\N	\N
8424	Taynara Crispim	tatacrispim28@gmail.com	(34) 99237-9159	Importado	23	Sem Atendimento	\N	\N	t	553492379159@s.whatsapp.net	\N	2025-06-13 12:46:29.821	2025-04-23 00:00:00	\N	\N
7503	Rayssa Fernanda	rayssafernanda171112@gmail.com	(34) 99117-4880	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7523	Suzane Mendes	suzane_mendes01@hotmail.com	(34) 99633-4083	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-13 00:00:00	2025-02-13 00:00:00	\N	\N
7546	Maico Zatt	maicozatt@hotmail.com	(64) 9202-3436	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-16 00:00:00	2025-02-16 00:00:00	\N	\N
8612	Tatielle Aparecida	tatiellesilva100@gmail.com	(34) 99763-4774	Importado	22	Sem Atendimento	\N	\N	t	553497634774@s.whatsapp.net	\N	2025-06-13 12:29:27.178	2025-05-09 00:00:00	\N	\N
8582	Mirelle Mirian	mirellemirian25@gmail.com	(34) 99796-7346	Importado	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:32:10.208	2025-05-08 00:00:00	\N	\N
8580	Laisa Silva	laisadias321@hotmail.com	(34) 9651-4746	Importado	13	Sem Atendimento	\N	\N	t	553496514746@s.whatsapp.net	\N	2025-06-13 12:32:21.012	2025-05-08 00:00:00	\N	\N
8527	Suzana Moura	suzanasdm2010@hotmail.com	(34) 99674-9240	Importado	22	Sem Atendimento	\N	\N	t	553496749240@s.whatsapp.net	\N	2025-06-13 12:37:10.543	2025-05-04 00:00:00	\N	\N
7756	Ricardo Rodrigues de Arajo	ricardo.rodriguesmg@yahoo.com.br	(34) 99170-7189	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7779	Andressa Borges	andressa_boliveira@hotmail.com	(34) 99811-2506	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-12 00:00:00	2025-03-12 00:00:00	\N	\N
7927	Jenifer Carneiro	jeniferferreira77@hotmail.com	(31) 98909-8814	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
8112	Dermival Batista	dermivalbp@hotmail.com	(38) 98847-2219	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8152	Gilliard Antonio	antoniogilliard91@gmail.com	(34) 99710-1160	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8168	Valdirene Lisboa	valdirenelisboa@yahoo.com.br	(35) 99942-1711	Importado	22	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8313	Priscila Carita Santos	priscilacaritasantos3508@gmail.com	(34) 9135-0985	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-15 00:00:00	2025-04-15 00:00:00	\N	\N
8384	Jenifer Naomi Albuquerque	naomi_jenifer@live.com	(34) 99155-7493	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
8385	Cleonice Silva	cleocabelosemegahair13@gmail.com	(37) 9948-4617	Importado	13	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-22 00:00:00	2025-04-22 00:00:00	\N	\N
7396	Francisco Junior	francisco_junior_430@famanegociosimobiliarios.com.br	(34) 99698-5691	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7418	Alan Carlos Tinoco	alantinoco10@yahoo.com.br	(34) 9948-1002	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7435	Eduardo  Atleta Hbrido	eduardomoch22@gmail.ckm	(34) 99940-6516	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7440	Rayssa Pires	rayssaedma123@gmail.com	(34) 99684-5174	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7457	Gabriela Ribeiro Braga	gabriea819@gmail.com	(34) 99912-1048	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7474	Luis felipe arantes ferraz felipe	luisfelipea3301@gmail.com	(55) 34996-4750	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-10 00:00:00	2025-02-10 00:00:00	\N	\N
7495	Diego Gomes Rodrigues	diego.gomes09.rodrigues@gmail.com	(34) 99772-8830	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	\N	\N
7027	Samuel Santos Castro	samumuitotop@gmail.com	(34) 98841-0876	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
7029	Natali Ferreira	ferreiranatali95@gmail.com	(71) 98427-6111	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-01-04 00:00:00	2025-01-04 00:00:00	\N	\N
8074	danilo santos hipolito	danilovictorhipolito@gmail.com	(34) 99884-5739	Importado	22	Venda	090.244.996-66	14	\N	\N	\N	2025-05-15 13:23:16.855	2025-03-29 00:00:00	\N	\N
8407	Felipe Dias	felipedias51@hotmail.com	(64) 99319-4920	Importado	22	Agendamento	\N	14	t	556493194920@s.whatsapp.net	\N	2025-06-13 12:48:02.908	2025-04-22 00:00:00	\N	\N
8665	Samara Oliveira	Samara_p.oliveira@hotmail.com	(34) 99193-3160	Importado	23	Visita	\N	14	t	553491933160@s.whatsapp.net	\N	2025-06-13 12:24:36.237	2025-01-06 00:00:00	\N	\N
8102	valquiria arrieiro	valquiriaarrieiro@gmail.com	(38) 9819-7470	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8423	Adriana Esteves	sem100comentarios@hotmail.com	(34) 98879-6946	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:46:35.151	2025-04-23 00:00:00	\N	\N
8422	Yara Ramos	yara.maria72@hotmail.com	(34) 99918-1992	Importado	23	Sem Atendimento	\N	\N	t	553499181992@s.whatsapp.net	\N	2025-06-13 12:46:40.599	2025-04-23 00:00:00	\N	\N
8398	984186826	anacosta1582@gmail.com	(34) 9651-0966	Importado	23	Sem Atendimento	\N	\N	t	553496510966@s.whatsapp.net	\N	2025-06-13 12:48:51.434	2025-04-22 00:00:00	\N	\N
8396	Munique	muniqueloren252@gmail.com	(62) 99329-7655	Importado	23	Sem Atendimento	\N	\N	t	556293297655@s.whatsapp.net	\N	2025-06-13 12:49:02.255	2025-04-22 00:00:00	\N	\N
8395	Rhaniel Jonathan	rhanieljonatam98@gmail.com	(34) 99295-5049	Importado	23	Sem Atendimento	\N	\N	t	553492955049@s.whatsapp.net	\N	2025-06-13 12:49:07.754	2025-04-22 00:00:00	\N	\N
8591	Sidney Fernandes	sidneyfsneto@hotmail.com	(64) 99606-9277	Importado	23	Sem Atendimento	\N	\N	t	556496069277@s.whatsapp.net	\N	2025-06-13 12:31:21.3	2025-05-08 00:00:00	\N	\N
8590	Gaspar Francisco de Sousa	gasparsousa931@gmail.com	(34) 9657-5983	Importado	23	Sem Atendimento	\N	\N	t	553496575983@s.whatsapp.net	\N	2025-06-13 12:31:26.654	2025-05-08 00:00:00	\N	\N
8589	Higor Oliveira	higorcm011100@gmail.com	(38) 99739-6702	Importado	23	Sem Atendimento	\N	\N	t	553897396702@s.whatsapp.net	\N	2025-06-13 12:31:32.033	2025-05-08 00:00:00	\N	\N
8588	Alexsandro	alexdomingos1103@gmail.com	(32) 99865-1408	Importado	23	Sem Atendimento	\N	\N	t	553298651408@s.whatsapp.net	\N	2025-06-13 12:31:37.431	2025-05-08 00:00:00	\N	\N
8497	Suzana Moura	suzanamoura2003@yahoo.com.br	(34) 9674-9240	Importado	13	Agendamento	\N	14	t	553496749240@s.whatsapp.net	\N	2025-06-13 12:39:52.74	2025-04-30 00:00:00	\N	\N
8587	Ana Paula Nunes	anapaulaborges800@gmail.com	(34) 99221-9641	Importado	23	Sem Atendimento	\N	\N	t	553492219641@s.whatsapp.net	\N	2025-06-13 12:31:42.902	2025-05-08 00:00:00	\N	\N
8577	Amanda Ferreira	amanda.afa89@gmail.com	(34) 99818-6015	Importado	23	Sem Atendimento	\N	\N	t	553498186015@s.whatsapp.net	\N	2025-06-13 12:32:37.123	2025-05-07 00:00:00	\N	\N
7444	Claudio Vitorino Raes Sal Mineral Casquinha de Soja Briqfeno	claudiovitorinoasp@yahoo.com.br	(34) 99699-9474	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7098	Carlos Solrac	carloseduardo.a.s@hotmail.com	(34) 99808-0898	Importado	23	Venda	074.240.586-90	14	\N	\N	\N	2025-05-15 13:33:06.343	2025-01-08 00:00:00	\N	\N
7378	Thawane Carolina	thawanecarolina44@gmail.com	(34) 98424-8237	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 17:21:51.79	2025-02-03 00:00:00	\N	\N
7131	Silvani Costa	silvanic57@gmail.com	(34) 99635-1620	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-01-10 00:00:00	2025-01-10 00:00:00	\N	\N
7201	Alice Pena	alicepena050@gmail.com	(34) 99770-3250	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7202	Jaciara Francisca	oliveirajaciara670@gmail.com	(34) 98403-0777	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7221	Paulo Cesar	rafaelgomesrafaelgomesmota@gmail.com	(34) 98428-1969	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7236	Francilene Sousa Araujo	francilenesa73@gmail.com	(34) 9199-5815	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-01-16 00:00:00	2025-01-16 00:00:00	\N	\N
7247	Denuze Teodora	denuzeteodoradasilvaoliveira@gmail.com	(34) 99676-3469	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-17 00:00:00	2025-01-17 00:00:00	\N	\N
7828	Igor Ranuzzi	rogi_ranuzzi@hotmail.com	(34) 99212-1932	Importado	22	Venda	091.288.516-50	17	\N	\N	\N	2025-05-15 16:28:33.837	2025-03-14 00:00:00	\N	\N
7313	Josiane Abbadia	josi_pessoa@hotmail.com	(64) 98424-9720	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 22:48:27.861	2025-01-24 00:00:00	\N	\N
7656	Sarah Farias	sarahfariassilva9@gmail.com	(34) 99174-3017	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 15:31:34.505	2025-03-07 00:00:00	\N	\N
7319	Libna Monique	libnamonique16@gmail.com	(34) 99188-2519	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 22:51:17.973	2025-01-24 00:00:00	\N	\N
7295	Gabrielle Stephanie	gabistephanie73@gmail.com	(38) 99833-6601	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-15 15:06:08.681	2025-01-21 00:00:00	\N	\N
7298	Daniel	daniel_327@famanegociosimobiliarios.com.br	(34) 9839-3571	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-14 18:37:46.429	2025-01-21 00:00:00	\N	\N
7403	Henrique Martins Rodrigues	henriquemartim@gmail.com	(34) 99111-7133	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-06 00:00:00	2025-02-06 00:00:00	\N	\N
7431	edula maria penha	edulapenhap@bol.com.br	(34) 99225-1321	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-02-09 00:00:00	2025-02-09 00:00:00	\N	\N
7532	Ana Clara	anaclararochasilvagarcia@gmail.com	(34) 99640-1417	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-14 00:00:00	2025-02-14 00:00:00	\N	\N
7595	Arthur Martins santos	arthurbrendhs4@gmail.com	(34) 8426-5821	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-02-20 00:00:00	2025-02-20 00:00:00	\N	\N
7636	Leandro Fernandes	frleandro641@gmail.com	(34) 99318-4166	Importado	13	Agendamento	\N	17	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7753	Gabrielle Salustino Lahass	gabriellelahass.03@gmail.com	(34) 99156-5992	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 15:36:34.661	2025-03-11 00:00:00	\N	\N
7741	Paula Beatriz	paulabeatrizn@gmail.com	(34) 98420-3041	Importado	22	Agendamento	\N	14	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7764	Adriano Roberto Viana Costa	adrianocosta.hnd@gmail.com	(34) 9923-6508	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 15:38:42.533	2025-03-12 00:00:00	\N	\N
7848	Maysa	maysa_882@famanegociosimobiliarios.com.br	(34) 8439-9270	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 15:41:18.927	2025-03-15 00:00:00	\N	\N
7969	Kelly M	kelly-mayte@hotmail.com	(34) 99222-5083	Importado	13	Visita	\N	17	\N	\N	\N	2025-05-15 15:54:16.407	2025-03-21 00:00:00	\N	\N
7879	Lu Cacau	lucacau13@icloud.com	(34) 99888-0481	Importado	22	Agendamento	\N	17	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
7303	Bruno Augusto JS	vanessa.cristina007@icloud.com	(34) 99154-3790	Importado	23	Venda	703.208.956-96	17	\N	\N	\N	2025-05-15 16:18:29.813	2025-01-24 00:00:00	\N	\N
7930	Danilo Freitas	danilinho_freitas33@hotmail.com	(34) 99294-0524	Importado	22	Venda	138.951.556-75	17	\N	\N	\N	2025-05-15 16:36:27.955	2025-03-19 00:00:00	\N	\N
7970	Lorrayne Mundim	lorraynemendonca337@gmail.com	(34) 99737-9171	Importado	13	Agendamento	\N	14	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8195	Rodrigo Freitas Cruz	rodrigo_freitas_cruz@hotmail.com	(34) 9871-3892	Importado	22	Agendamento	\N	14	\N	\N	\N	2025-04-07 00:00:00	2025-04-07 00:00:00	\N	\N
7215	Aline Santos	alinnesantoslopes123@gmail.com	(34) 99822-2696	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-15 00:00:00	2025-01-15 00:00:00	\N	\N
7356	João Lazaro Souza de Araujo	joao.araujo.ufu@gmail.com	(34) 99992-4459	Importado	23	Venda	136.117.236-30	14	\N	\N	\N	2025-05-15 13:25:17.18	2025-01-26 00:00:00	\N	\N
7373	Geovanna Dias Chendi	geovannadias2323@icloud.com	(34) 9679-2758	Importado	23	Visita	\N	14	\N	\N	\N	2025-05-14 16:34:31.681	2025-02-03 00:00:00	\N	\N
7041	Gaspar Gonalves	gaspargoncalvesdesouza22@gmail.com	(34) 99900-8603	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-01-05 00:00:00	2025-01-05 00:00:00	\N	\N
8164	Paula Mello	mellop346@gmail.com	(34) 98406-1533	Importado	13	Agendamento	\N	14	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
7980	Kdu	cadu.2112.reis@gmail.com	(31) 99938-9067	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8680	Thalia Barcelos	thaliabarcelos1020@gmail.com	(34) 99771-2127	Facebook Ads	13	Sem Atendimento	\N	\N	t	553497712127@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491866366_1764499527836142_7765875524410805725_n.jpg?ccb=11-4&oh=01_Q5Aa1gF7KWI90NmWy4hCKYiKGw_NuF2wzST-dZ_GzXurgRVVDA&oe=6832EDA0&_nc_sid=5e03e0&_nc_cat=108	2025-06-13 12:23:14.188	2025-05-15 12:06:04.983	\N	\N
8672	Dhandara Cristina	cristinadhandara28@gmail.com	(34) 99148-3648	Facebook Ads	13	Sem Atendimento	\N	\N	t	553491483648@s.whatsapp.net	\N	2025-06-13 12:23:57.834	2025-05-14 17:37:58.33	\N	\N
8126	Edu	edujaime313@gmail.com	(34) 99251-1789	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8692	Emilly	emillycarvalholacerda45@gmail.com	(34) 99886-4472	Facebook Ads	13	Sem Atendimento	\N	\N	t	553498864472@s.whatsapp.net	\N	2025-06-13 12:22:09.297	2025-05-15 16:10:56.005	\N	\N
8127	Lucas Silva	lucassilva152831@gmail.com	(34) 9722-0398	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8675	Florence Morais	morais_fc@hotmail.com	(34) 99239-2829	Facebook Ads	13	Sem Atendimento	\N	\N	t	553492392829@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/394159661_670455335218488_3817244411440998529_n.jpg?ccb=11-4&oh=01_Q5Aa1gHn_9eQeYh8vbuSRl6W16h7JgHjl36P9a_or9Qi6EjrIA&oe=68321704&_nc_sid=5e03e0&_nc_cat=107	2025-06-13 12:23:41.452	2025-05-14 22:23:28.362	\N	\N
8673	Eduarda Santos	Dudabsanntos@gmail.com	(34) 99722-4795	Facebook Ads	22	Sem Atendimento	\N	\N	t	553497224795@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491869440_1854537181999041_5836486986351812421_n.jpg?ccb=11-4&oh=01_Q5Aa1gHb_WDq7G5_HMFMe0cjxHKawP3afWVkPHzQS6rG61dxtw&oe=683209B6&_nc_sid=5e03e0&_nc_cat=107	2025-06-13 12:23:52.453	2025-05-14 18:11:26.796	\N	\N
8128	Marlon Santos Gomes	marlonjenifer@hotmail.com	(34) 98876-5843	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8691	Thiago Pimentel	chevettinho.henrique009@gmail.com	(34) 8412-4428	Facebook Ads	22	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:22:14.665	2025-05-15 16:09:09.834	\N	\N
8129	Ricardo Ramos	richardpereira1979@gmail.com	(34) 99672-7198	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8685	Rodrigo Ricardo	rodrigoricardosilva@hotmail.com	(34) 99255-7746	Facebook Ads	22	Sem Atendimento	\N	\N	t	553492557746@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/473399442_1615668995981172_8729426549167106128_n.jpg?ccb=11-4&oh=01_Q5Aa1gG6d1F6PhG7RRFZLQ8b_muUpJ-kNV5HOMfnBe95nI_3uQ&oe=6833104A&_nc_sid=5e03e0&_nc_cat=103	2025-06-13 12:22:47.197	2025-05-15 13:41:57.182	\N	\N
8130	Fernando Lima Carvalho	fernandolimacarvalho2019@gmail.com	(34) 99977-3916	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8133	Barbie Morena  Santos	edinnunis@hotmail.com	(34) 98404-1700	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8134	Nycole Souza	nycole.s.t@hotmail.com	(34) 99191-2058	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8689	Duda Lemes	maryaeduardalemes@gmail.com	(34) 99663-3834	Facebook Ads	13	Sem Atendimento	\N	\N	t	553496633834@s.whatsapp.net	\N	2025-06-13 12:22:25.551	2025-05-15 15:31:00.562	\N	\N
8688	Jean Mitidiero	jeanmitidiero@gmail.com	(34) 99106-7095	Facebook Ads	22	Sem Atendimento	\N	\N	t	553491067095@s.whatsapp.net	\N	2025-06-13 12:22:31.017	2025-05-15 15:18:19.157	\N	\N
8679	Marcia Christina	mxistina@hotmail.com	(34) 99641-8714	Facebook Ads	22	Sem Atendimento	\N	\N	t	553496418714@s.whatsapp.net	\N	2025-06-13 12:23:19.538	2025-05-15 12:02:53.251	\N	\N
8677	Paty Santos	patriciasguimaraess@gmail.com	(64) 9859-8487	Facebook Ads	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:23:30.641	2025-05-15 11:51:35.998	\N	\N
8135	Mateus de jesus dos Santos	mateussts882@gmail.com	(37) 99973-1183	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8686	𝒦𝒾𝓂𝒷𝑒𝓇𝓁𝓎 𝓈𝒾𝓁𝓋𝒶	kimberlyketlyn64@gmail.com	(31) 97222-3990	Facebook Ads	13	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:22:41.809	2025-05-15 14:13:59.872	\N	\N
8683	Carla Ribeiro	cr2707851@gmail.com	(34) 99815-8894	Facebook Ads	13	Sem Atendimento	\N	\N	t	553498158894@s.whatsapp.net	\N	2025-06-13 12:22:57.911	2025-05-15 12:42:17.689	\N	\N
8682	Cris Correia	crislgus@icloud.com	(34) 99882-2378	Facebook Ads	22	Sem Atendimento	\N	\N	t	553498822378@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491840364_586711424463333_1801363680932900249_n.jpg?ccb=11-4&oh=01_Q5Aa1gEOkNIn-4tFeOF-i9kSgXnuxPCwWD1VYJ4yHS1-t7hMjw&oe=6833065D&_nc_sid=5e03e0&_nc_cat=100	2025-06-13 12:23:03.341	2025-05-15 12:27:19.934	\N	\N
8136	Maria Luiza	marialuizaaugustodasilva7@gmail.com	(34) 99672-5326	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8676	Maria Clara Nogueira	mariaclara52@hotmail.com	(34) 99277-3685	Facebook Ads	22	Sem Atendimento	\N	\N	t	553492773685@s.whatsapp.net	\N	2025-06-13 12:23:36.075	2025-05-15 11:33:23.161	\N	\N
7571	Jofre Neto	jofre_neto_605@famanegociosimobiliarios.com.br	(34) 9874-6813	Importado	23	Venda	016.653.926-06	14	\N	\N	\N	2025-05-15 16:22:36.15	2025-02-18 00:00:00	\N	\N
8163	Carol Frana	anninhaa11@yahoo.com.br	(34) 98845-0802	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-05 00:00:00	2025-04-05 00:00:00	\N	\N
8697	Lucas Gondim	\N	(34) 8440-6785	Importado	23	Venda	115.043.056-71	14	t	553484406785@s.whatsapp.net	\N	2025-06-13 12:21:42.185	2025-01-07 00:00:00	\N	\N
8494	Francielle Silva	silvafrancielle278@gmail.com	(34) 99827-9172	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:40:09.155	2025-04-29 00:00:00	\N	\N
8606	Grazi Santos	grazimeacessorios@gmail.com	(64) 99245-4418	Importado	23	Sem Atendimento	\N	\N	t	556492454418@s.whatsapp.net	\N	2025-06-13 12:29:59.683	2025-05-09 00:00:00	\N	\N
8712	Thiago Pimentel	chevettinho.henrique009@gmail.com	(34) 98811-0681	Facebook Ads	13	Sem Atendimento	\N	\N	t	553488110681@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491875223_1345546436717005_7309071897401338754_n.jpg?ccb=11-4&oh=01_Q5Aa1gHAQwJH9GeHD5cSWaK2wXOQpUsLUWAeLZrBq0JxeX0gvA&oe=6834449F&_nc_sid=5e03e0&_nc_cat=108	2025-06-13 12:20:20.64	2025-05-16 14:14:49.147	\N	\N
8711	Linda Kennya Nogueira	linda_kenia@hotmail.com	(34) 99898-2654	Facebook Ads	22	Sem Atendimento	\N	\N	t	553498982654@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/483646159_1001298734726768_1944504831999760352_n.jpg?ccb=11-4&oh=01_Q5Aa1gFDlP_Jv5XUYLgYlDPapqnU2S4O5ZEpnqdgmIn4YVguCQ&oe=68344140&_nc_sid=5e03e0&_nc_cat=106	2025-06-13 12:20:25.989	2025-05-16 13:54:56.289	\N	\N
8702	Edvelma mendes	edvelmamendes123@gmail.com	(31) 98349-6059	Facebook Ads	22	Sem Atendimento	\N	\N	t	553183496059@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491843838_666755209675823_4509574472865920930_n.jpg?ccb=11-4&oh=01_Q5Aa1gECShuuswm2ofSehrhTrl2ZyM_7Rr-U-gOBfewboRNT3Q&oe=683345FB&_nc_sid=5e03e0&_nc_cat=107	2025-06-13 12:21:15.062	2025-05-15 18:53:37.985	\N	\N
8621	Shirley Aparecida	shirleyaparecidalaurindo@gmail.com	(34) 99961-1873	Importado	23	Sem Atendimento	\N	\N	t	553499611873@s.whatsapp.net	\N	2025-06-13 12:28:38.37	2025-05-10 00:00:00	\N	\N
8700	Waldeir	waldwoss@gmail.com	(31) 98103-5541	Facebook Ads	13	Sem Atendimento	\N	\N	t	553181035541@s.whatsapp.net	\N	2025-06-13 12:21:26.031	2025-05-15 18:27:54.752	\N	\N
8710	wc acabamentos	warley199512@gmail.com	(34) 99125-5112	Facebook Ads	13	Sem Atendimento	\N	\N	t	553491255112@s.whatsapp.net	\N	2025-06-13 12:20:31.323	2025-05-16 13:49:27.915	\N	\N
8708	Rafaela Biazi	rafaelabiazi2004@gmail.com	(17) 99622-2013	Facebook Ads	13	Sem Atendimento	\N	\N	t	5517996222013@s.whatsapp.net	\N	2025-06-13 12:20:42.241	2025-05-16 13:29:22.221	\N	\N
8620	Jeferson Rodrigues	1984.jefersonn@gmail.com	(34) 9105-5430	Importado	23	Sem Atendimento	\N	\N	t	553491055430@s.whatsapp.net	\N	2025-06-13 12:28:43.914	2025-05-10 00:00:00	\N	\N
8619	Brenda Silva	brendaa0020@gmail.com	(34) 99685-6817	Importado	23	Sem Atendimento	\N	\N	t	553496856817@s.whatsapp.net	\N	2025-06-13 12:28:49.384	2025-05-10 00:00:00	\N	\N
8705	David Santos	david.junior.10@hotmail.com	(34) 99272-4040	Facebook Ads	13	Sem Atendimento	\N	\N	t	553492724040@s.whatsapp.net	\N	2025-06-13 12:20:58.818	2025-05-16 11:55:05.392	\N	\N
8609	Wemerson Lcio	wemerson2803@hotmail.com	(34) 99987-4284	Importado	23	Sem Atendimento	\N	\N	t	553499874284@s.whatsapp.net	\N	2025-06-13 12:29:43.448	2025-05-09 00:00:00	\N	\N
8703	Victor Hugo	rosangela2andre@gmail.com	(34) 93505-2966	Facebook Ads	13	Sem Atendimento	\N	\N	t	5534935052966@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491872248_1531383474912953_3366787380481856783_n.jpg?ccb=11-4&oh=01_Q5Aa1gHicu7zUz8pvCsSkY7lcod1kxDawLNZlxsAqlsphQoX_A&oe=683353B3&_nc_sid=5e03e0&_nc_cat=100	2025-06-13 12:21:09.609	2025-05-15 19:17:40.588	\N	\N
8608	Dayane Dittrich	dayanedittrich2016@gmail.com	(34) 99132-6224	Importado	23	Sem Atendimento	\N	\N	t	553491326224@s.whatsapp.net	\N	2025-06-13 12:29:48.914	2025-05-09 00:00:00	\N	\N
8717	Laura dos Santos	laura15112008s@gmail.com	(34) 99120-0528	Facebook Ads	22	Sem Atendimento	\N	\N	t	553491200528@s.whatsapp.net	\N	2025-06-13 12:19:53.687	2025-05-16 17:49:24.02	\N	\N
8715	_amanda_rodrigues_borges_	mundodosgames1214@gmail.com	(34) 99256-5671	Facebook Ads	13	Sem Atendimento	\N	\N	t	553492565671@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/473408290_916044694034732_8280519908726058239_n.jpg?ccb=11-4&oh=01_Q5Aa1gFtsgcM8OiA7ieI-OT7f87n38PkE9WFmZ4YO3_O9ZX5tQ&oe=68347A5E&_nc_sid=5e03e0&_nc_cat=108	2025-06-13 12:20:04.413	2025-05-16 17:28:56.438	\N	\N
8607	Marli Vieira	marlicvieira66@hotmail.com	(34) 99976-1881	Importado	23	Sem Atendimento	\N	\N	t	553499761881@s.whatsapp.net	\N	2025-06-13 12:29:54.334	2025-05-09 00:00:00	\N	\N
8714	Geovanna	geovannabianchini12@gmail.com	(34) 99637-6648	Facebook Ads	22	Sem Atendimento	\N	\N	t	553496376648@s.whatsapp.net	\N	2025-06-13 12:20:09.792	2025-05-16 17:28:52.716	\N	\N
8593	Gabrielly	gabriellysilvie684@gmail.com	(34) 99644-6825	Importado	23	Sem Atendimento	\N	\N	t	553496446825@s.whatsapp.net	\N	2025-06-13 12:31:10.356	2025-05-08 00:00:00	\N	\N
8592	Lucy Silva	lucyloyra446@gmail.com	(34) 99960-8015	Importado	23	Sem Atendimento	\N	\N	t	553499608015@s.whatsapp.net	\N	2025-06-13 12:31:15.724	2025-05-08 00:00:00	\N	\N
8467	Jackson Shreiner	jackson.shreiner93@gmail.com	(34) 99994-6645	Importado	23	Sem Atendimento	\N	\N	t	553499946645@s.whatsapp.net	\N	2025-06-13 12:42:35.188	2025-04-27 00:00:00	\N	\N
8114	Ananias Medeiros	ananiasg12@bol.com.br	(34) 99996-7232	Importado	23	Agendamento	\N	23	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8576	Ana Vitoria borges	anavitoria.brotas@hotmail.com	(34) 99708-7433	Importado	23	Sem Atendimento	\N	\N	t	553497087433@s.whatsapp.net	\N	2025-06-13 12:32:42.529	2025-05-07 00:00:00	\N	\N
8566	CAIO ANDR	caioandreandre713@gmail.com	(34) 69168-9957	Importado	23	Sem Atendimento	\N	\N	t	553491689957@s.whatsapp.net	\N	2025-06-13 12:33:36.563	2025-05-06 00:00:00	\N	\N
8564	Raimundo Oliveira Santos	raimundo63os@gmail.com	(34) 99181-3614	Importado	23	Sem Atendimento	\N	\N	t	553491813614@s.whatsapp.net	\N	2025-06-13 12:33:47.382	2025-05-06 00:00:00	\N	\N
8563	Lorena Chrissy	lorena.arantesdutra@gmail.com	(34) 99896-7113	Importado	23	Sem Atendimento	\N	\N	t	553498967113@s.whatsapp.net	\N	2025-06-13 12:33:52.792	2025-05-06 00:00:00	\N	\N
7664	vitria	diasvivi24@gmail.com	(87) 98116-5608	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7665	Nubia Oliveira	lyannnubia@gmail.com	(99) 98226-7203	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7668	Sandra Calaa Garcia	sandracgarcia@gmail.com	(34) 98809-5110	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7687	Jos Carlos Andrade Fona	fona.fmce@imbel.gov.br	(21) 99987-5867	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-08 00:00:00	2025-03-08 00:00:00	\N	\N
7865	Dbora Miranda	deboraddmiranda@gmail.com	(34) 99816-7285	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-17 00:00:00	2025-03-17 00:00:00	\N	\N
8031	Tiago A Oliveira	tiassisoliveira@gmail.com	(31) 98823-5117	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-28 00:00:00	2025-03-28 00:00:00	\N	\N
8232	Evelyn Bianca	eb123691@gmail.com	(34) 98424-6932	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
8278	Leonel Jose Tavares	leoneljosetavares@yahoo.com.br	(34) 99169-3702	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	\N	\N
7709	Gleysson Freitas	gleyssin1986@hotmail.com	(34) 99162-4699	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7721	mimi	emillyeman@gmail.com	(34) 99131-8431	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7722	Renato Santos	uuu@gmail.com	(34) 9774-1370	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-09 00:00:00	2025-03-09 00:00:00	\N	\N
7735	Pedro Henrique	pedro.hen.10@hotmail.com.br	(34) 99669-8074	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-10 00:00:00	2025-03-10 00:00:00	\N	\N
7910	Maria Luiza Rodrigues	marialuizaalvesrodrigues14@gmail.com	(34) 99294-4165	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-18 00:00:00	2025-03-18 00:00:00	\N	\N
7965	Ana Flvia	anaanjospx07@icloud.com	(38) 99105-3802	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8094	Yasmim Priscila	yasmimpriscila421@gmail.con	(31) 8745-2270	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-01 00:00:00	2025-04-01 00:00:00	\N	\N
8132	Joabe Alves de Souza	diac.joabealves28@gmail.com	(94) 99145-5905	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-04 00:00:00	2025-04-04 00:00:00	\N	\N
8342	Claudinei da Silva	claudineisilva481@gmail.com	(34) 99875-9579	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	\N	\N
8397	Wenderson Beleli	wender.beleli@hotmail.com	(34) 99965-6821	Importado	23	Sem Atendimento	\N	\N	t	553499656821@s.whatsapp.net	\N	2025-06-13 12:48:56.842	2025-04-22 00:00:00	\N	\N
8298	Anderson Berdnaski	ander_israel@hotmail.com	(34) 99164-2385	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-13 00:00:00	2025-04-13 00:00:00	\N	\N
8362	Gabrielle Caroline	gabriellecaroline123@hotmail.com	(34) 99989-3893	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8226	Carmen Vicente dos Santos 	carmenvicentesantos@gmaill.com	(34) 99654-6101	Importado	23	Sem Atendimento	\N	\N	\N	\N	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	\N	\N
7415	Deborah Deh	oliviarosadesouza67@gmail.com	(34) 99655-7299	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-02-07 00:00:00	2025-02-07 00:00:00	\N	\N
7651	Henrique Bruutus	rikys_5@hotmail.com	(34) 99169-6604	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-03-06 00:00:00	2025-03-06 00:00:00	\N	\N
7661	Raquel Menestrino	raquel.menestrino@gmail.com	(62) 98233-5122	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-07 00:00:00	2025-03-07 00:00:00	\N	\N
7761	Anna Julia	anna_julia_795@famanegociosimobiliarios.com.br	(34) 9914-4153	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-11 00:00:00	2025-03-11 00:00:00	\N	\N
7822	Poliana Araujo	polly777@hotmail.com	(34) 99631-9929	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-14 00:00:00	2025-03-14 00:00:00	\N	\N
7977	Andressa Alana	andressaalana2@outlook.com	(61) 98402-3408	Importado	23	Venda	047.235.051-05	17	\N	\N	\N	2025-05-15 16:34:00.773	2025-03-21 00:00:00	\N	\N
7926	Vitria Gabriela	vitoriagms1@live.com	(34) 99174-1573	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	\N	\N
7946	GATA	agatacaylane23@gmail.com	(11) 94518-0882	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-20 00:00:00	2025-03-20 00:00:00	\N	\N
8131	Cau Mondini	mondinicaue@gmail.com	(34) 99655-3593	Importado	23	Visita	\N	17	\N	\N	\N	2025-05-15 16:43:07.966	2025-04-04 00:00:00	\N	\N
7978	Rodrigo Oliveira	rodrigoosantos869@gmail.com	(34) 99966-2751	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-03-21 00:00:00	2025-03-21 00:00:00	\N	\N
8116	Andressa	dessamendes05@gmail.com	(34) 99228-3901	Importado	23	Agendamento	\N	14	\N	\N	\N	2025-04-03 00:00:00	2025-04-03 00:00:00	\N	\N
8364	Galdino Brito	dedef2014@gmail.com	(34) 99240-6498	Importado	23	Agendamento	\N	17	\N	\N	\N	2025-04-21 00:00:00	2025-04-21 00:00:00	\N	\N
8653	Kamilly Vitoria	kv189058@gmail.com	(34) 99240-9128	Importado	23	Sem Atendimento	\N	\N	t	553492409128@s.whatsapp.net	\N	2025-06-13 12:25:41.875	2025-05-13 00:00:00	\N	\N
8652	Maria Eduarda Almeida	mariaeduarda2015@yahoo.com	(38) 99166-7645	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:25:47.227	2025-05-13 00:00:00	\N	\N
8651	Carol_Squarcino	carolynasquarcino@gmail.com	(34) 99811-4974	Importado	23	Sem Atendimento	\N	\N	t	553498114974@s.whatsapp.net	\N	2025-06-13 12:25:52.669	2025-05-13 00:00:00	\N	\N
8641	Nilton Carlos Fidelis da silva	niltinpalmeirense@gmail.com	(34) 9865-8829	Importado	23	Sem Atendimento	\N	\N	t	553498658829@s.whatsapp.net	\N	2025-06-13 12:26:48.223	2025-05-12 00:00:00	\N	\N
8640	Natlia Rodovalho	prmarianatalia23@hotmail.com	(34) 99878-0293	Importado	23	Sem Atendimento	\N	\N	t	553498780293@s.whatsapp.net	\N	2025-06-13 12:26:53.727	2025-05-12 00:00:00	\N	\N
8639	Lideia Pereira	marialideia@hotmail.com	(31) 98616-2332	Importado	23	Sem Atendimento	\N	\N	t	553186162332@s.whatsapp.net	\N	2025-06-13 12:26:59.334	2025-05-12 00:00:00	\N	\N
8637	Reinaldo Machado	cristoreinaldo@hotmail.com	(34) 9695-1000	Importado	23	Visita	\N	17	t	553496951000@s.whatsapp.net	\N	2025-06-13 12:27:10.254	2025-05-12 00:00:00	\N	\N
8636	Amanda Serrao	serraoa06@gmail.com	(17) 99223-8582	Importado	23	Sem Atendimento	\N	\N	t	5517992238582@s.whatsapp.net	\N	2025-06-13 12:27:15.679	2025-05-12 00:00:00	\N	\N
8635	Maykon Sanso Firmino Santos Gonalves	maykonsansao25@gmail.com	(34) 99164-6676	Importado	23	Sem Atendimento	\N	\N	f	\N	\N	2025-06-13 12:27:21.151	2025-05-12 00:00:00	\N	\N
8630	Juliana Afonso	juafonso2009@hotmail.com	(34) 9926-3866	Importado	23	Sem Atendimento	\N	\N	t	553499263866@s.whatsapp.net	\N	2025-06-13 12:27:48.4	2025-05-11 00:00:00	\N	\N
8628	Rony Sampaio	ronysampaiorv@gmail.com	(64) 99345-3556	Importado	23	Sem Atendimento	\N	\N	t	556493453556@s.whatsapp.net	\N	2025-06-13 12:27:59.281	2025-05-11 00:00:00	\N	\N
8594	Rodolfo Fernandes Duarte	rodolfo.feeh@gmail.com	(34) 9993-2390	Importado	23	Sem Atendimento	\N	\N	t	553499932390@s.whatsapp.net	\N	2025-06-13 12:31:04.925	2025-05-08 00:00:00	\N	\N
8565	Jeniffer Rodrigues	rodriguesjeniffer179@gmail.com	(35) 98478-2507	Importado	23	Sem Atendimento	\N	\N	t	553584782507@s.whatsapp.net	\N	2025-06-13 12:33:41.899	2025-05-06 00:00:00	\N	\N
8547	Tain Azevedo Fagundes	tainaazfagundes@hotmail.com	(34) 99652-1026	Importado	23	Sem Atendimento	\N	\N	t	553496521026@s.whatsapp.net	\N	2025-06-13 12:35:20.884	2025-05-05 00:00:00	\N	\N
8511	Robson Silva	robsonwesley502@gmail.com	(34) 99200-6311	Importado	23	Sem Atendimento	\N	\N	t	553492006311@s.whatsapp.net	\N	2025-06-13 12:38:37.085	2025-05-01 00:00:00	\N	\N
8510	vitin rs	buenovanessa220@gmail.com	(41) 99847-6592	Importado	23	Agendamento	\N	14	t	554198476592@s.whatsapp.net	\N	2025-06-13 12:38:42.484	2025-05-01 00:00:00	\N	\N
8701	poliana Silva	ps0894894@gmail.com	(34) 99855-8852	Facebook Ads	23	Sem Atendimento	\N	\N	t	553498558852@s.whatsapp.net	\N	2025-06-13 12:21:20.566	2025-05-15 18:31:28.662	\N	\N
8698	.	lemoscthamara@gmail.com	(34) 99809-2966	Facebook Ads	23	Sem Atendimento	\N	\N	t	553498092966@s.whatsapp.net	\N	2025-06-13 12:21:36.802	2025-05-15 17:20:36.511	\N	\N
8690	timtim	Uelitonmoura1234@gmail.com	(34) 99900-8835	Facebook Ads	23	Sem Atendimento	\N	\N	t	553499008835@s.whatsapp.net	\N	2025-06-13 12:22:20.097	2025-05-15 15:32:41.543	\N	\N
8687	Paulo Cesar Ricardo da Silva	paulocesarricardo1@gmail.com	(34) 9900-4417	Facebook Ads	23	Sem Atendimento	\N	\N	t	553499004417@s.whatsapp.net	\N	2025-06-13 12:22:36.418	2025-05-15 14:17:01.143	\N	\N
8684	Clelia Magela	cleliamagela@yahoo.com.br	(34) 99961-9714	Facebook Ads	23	Sem Atendimento	\N	\N	t	553499619714@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/222474207_252023113787393_7530758746161302212_n.jpg?ccb=11-4&oh=01_Q5Aa1gEflNw-5DabQkTIrVrDmD7v8_Gx5nG3GK6_Jny4VeYb5g&oe=6833009B&_nc_sid=5e03e0&_nc_cat=105	2025-06-13 12:22:52.56	2025-05-15 13:38:09.205	\N	\N
8681	David Jhony	gl951698@gmail.com	(34) 99694-3698	Facebook Ads	23	Sem Atendimento	\N	\N	t	553496943698@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/484084181_655887820637315_7304254147915347917_n.jpg?ccb=11-4&oh=01_Q5Aa1gGC8Myy_UnhzouhZEjMo9apb4W01XF7NRuuCbDDNftXCA&oe=6832E23C&_nc_sid=5e03e0&_nc_cat=102	2025-06-13 12:23:08.773	2025-05-15 12:16:56.521	\N	\N
8716	Michael W Rodrigues	wellingtonmahindra@hotmail.com	(34) 98408-3409	Facebook Ads	23	Sem Atendimento	\N	\N	t	553484083409@s.whatsapp.net	\N	2025-06-13 12:19:59.069	2025-05-16 17:36:28.791	\N	\N
8713	Jerusa Andrade	jerusaandrade029@gmail.com	(34) 9171-7981	Facebook Ads	23	Sem Atendimento	\N	\N	t	553491717981@s.whatsapp.net	\N	2025-06-13 12:20:15.166	2025-05-16 15:07:12.753	\N	\N
8709	Luana Rodrigues	luasouza1995@hotmail.com	(34) 99260-5312	Facebook Ads	23	Sem Atendimento	\N	\N	t	553492605312@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491843236_1060034159375346_4628424868710381939_n.jpg?ccb=11-4&oh=01_Q5Aa1gFx1x3UHI4su28D0-1g4u-l8VgSSasmtMc0RzUX7ApAkw&oe=68344D45&_nc_sid=5e03e0&_nc_cat=102	2025-06-13 12:20:36.724	2025-05-16 13:46:46.192	\N	\N
8707	iran	iran22584@gmail.com	(34) 99762-1649	Facebook Ads	23	Sem Atendimento	\N	\N	t	553497621649@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/328636775_1579936619152207_3747235895625799652_n.jpg?ccb=11-4&oh=01_Q5Aa1gGI2hmX9gSTUp-4vpgRcPzch_hlcvdOn0Xh3CKYjd7xdQ&oe=68344830&_nc_sid=5e03e0&_nc_cat=102	2025-06-13 12:20:47.864	2025-05-16 12:20:19.63	\N	\N
8706	Ana Luiza	bobbybrowncnmillie@gmail.com	(34) 98824-5670	Facebook Ads	23	Sem Atendimento	\N	\N	t	553488245670@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/491870671_1162398159260209_1180968031060425143_n.jpg?ccb=11-4&oh=01_Q5Aa1gGNlAkt3UAN5xLvDMKptc3Ei1Czq-3q0TM66DU64hsihQ&oe=68343427&_nc_sid=5e03e0&_nc_cat=105	2025-06-13 12:20:53.21	2025-05-16 11:58:33.132	\N	\N
8704	𝑱𝒖𝒍𝒊𝒂 𝑫𝒊𝒂𝒔	Juliadiassvieira@gmail.com	(38) 99830-6172	Facebook Ads	23	Sem Atendimento	\N	\N	t	553898306172@s.whatsapp.net	https://pps.whatsapp.net/v/t61.24694-24/455263836_9065828303494325_4248724205107101072_n.jpg?ccb=11-4&oh=01_Q5Aa1gGFAeFHisXRT6x-HYh4SvkgvWQnD0vXDlXJ-IqAwRouWQ&oe=6833621E&_nc_sid=5e03e0&_nc_cat=104	2025-06-13 12:21:04.175	2025-05-15 20:11:27.613	\N	\N
8678	𝕬𝖒𝖆𝖓𝖉𝖆 𝖘𝖆𝖓𝖙𝖔𝖘	amandasantosmartinsmorenaflor@gmail.com	(34) 99136-6087	Facebook Ads	23	Sem Atendimento	\N	\N	t	553491366087@s.whatsapp.net	\N	2025-06-13 12:23:24.983	2025-05-15 11:53:54.279	\N	\N
\.


--
-- Data for Name: clientes_agendamentos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes_agendamentos (id, cliente_id, user_id, notes, location, address, broker_id, type, status, title, scheduled_at, updated_at, created_at, assigned_to) FROM stdin;
247	8501	13	\N	\N	\N	23	Visita	Agendado	\N	2025-04-12 00:00:00	2025-04-12 00:00:00	2025-04-12 00:00:00	13
134	7661	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-28 16:00:00	2025-03-10 00:00:00	2025-03-10 00:00:00	23
154	7686	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-10 12:30:00	2025-03-10 00:00:00	2025-03-10 00:00:00	23
132	7737	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-13 09:00:00	2025-03-11 00:00:00	2025-03-11 00:00:00	23
155	7749	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-10 19:30:00	2025-03-10 00:00:00	2025-03-10 00:00:00	23
153	7761	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-15 09:00:00	2025-03-11 00:00:00	2025-03-11 00:00:00	23
126	7842	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-25 16:00:00	2025-03-24 00:00:00	2025-03-24 00:00:00	23
125	7946	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-29 15:00:00	2025-03-25 00:00:00	2025-03-25 00:00:00	23
127	7980	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-21 10:30:00	2025-03-21 00:00:00	2025-03-21 00:00:00	23
180	8114	23	\N	\N	\N	23	Visita	Agendado	\N	2025-04-14 09:00:00	2025-04-08 00:00:00	2025-04-08 00:00:00	23
182	8116	23	\N	\N	\N	14	Visita	Agendado	\N	2025-04-04 09:00:00	2025-04-04 00:00:00	2025-04-04 00:00:00	23
143	8131	23	\N	\N	\N	17	Visita	Agendado	\N	2025-04-12 09:00:00	2025-04-11 00:00:00	2025-04-11 00:00:00	23
144	8186	23	\N	\N	\N	17	Visita	Agendado	\N	2025-04-15 09:00:00	2025-04-09 00:00:00	2025-04-09 00:00:00	23
174	8262	23	\N	\N	\N	17	Visita	Agendado	\N	2025-04-25 11:00:00	2025-04-25 00:00:00	2025-04-25 00:00:00	23
177	8348	23	\N	\N	\N	17	Visita	Agendado	\N	2025-04-24 15:00:00	2025-04-23 00:00:00	2025-04-23 00:00:00	23
173	8364	23	\N	\N	\N	17	Visita	Agendado	\N	2025-05-03 09:00:00	2025-04-28 00:00:00	2025-04-28 00:00:00	23
169	8392	23	\N	\N	\N	14	Visita	Agendado	\N	2025-05-09 14:00:00	2025-05-08 00:00:00	2025-05-08 00:00:00	23
172	8510	23	\N	\N	\N	14	Visita	Agendado	\N	2025-05-02 14:00:00	2025-05-01 00:00:00	2025-05-01 00:00:00	23
243	8637	23	\N	\N	\N	17	Visita	Agendado	\N	2025-05-14 00:00:00	2025-05-14 00:00:00	2025-04-17 00:00:00	23
209	7027	23	\N	\N	\N	23	Visita	Agendado	\N	2025-02-01 11:00:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
210	7221	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-05 13:30:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
211	7393	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-07 17:30:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
212	7532	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-18 15:30:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
213	7403	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-14 09:00:00	2025-02-13 00:00:00	2025-02-13 00:00:00	23
214	7431	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-11 10:30:00	2025-02-11 00:00:00	2025-02-11 00:00:00	23
215	7378	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-04 18:30:00	2025-02-04 00:00:00	2025-02-04 00:00:00	23
216	7273	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-07 16:00:00	2025-02-03 00:00:00	2025-02-03 00:00:00	23
217	7327	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-01 10:00:00	2025-01-30 00:00:00	2025-01-30 00:00:00	23
218	7351	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-01 10:00:00	2025-01-27 00:00:00	2025-01-27 00:00:00	23
219	7319	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-25 11:00:00	2025-01-24 00:00:00	2025-01-24 00:00:00	23
220	7313	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-26 10:00:00	2025-01-24 00:00:00	2025-01-24 00:00:00	23
221	7295	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-25 10:00:00	2025-01-23 00:00:00	2025-01-23 00:00:00	23
222	7247	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-23 18:00:00	2025-01-22 00:00:00	2025-01-22 00:00:00	23
223	7289	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-22 11:30:00	2025-01-21 00:00:00	2025-01-21 00:00:00	23
224	7272	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-21 16:00:00	2025-01-20 00:00:00	2025-01-20 00:00:00	23
225	7201	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-08 09:30:00	2025-01-16 00:00:00	2025-01-16 00:00:00	23
226	8665	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-16 19:00:00	2025-01-16 00:00:00	2025-01-16 00:00:00	23
227	7202	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-17 15:00:00	2025-01-16 00:00:00	2025-01-16 00:00:00	23
228	7187	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-15 16:30:00	2025-01-15 00:00:00	2025-01-15 00:00:00	23
229	7215	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-16 14:30:00	2025-01-15 00:00:00	2025-01-15 00:00:00	23
230	7131	23	\N	\N	\N	23	Visita	Agendado	\N	2025-01-19 10:00:00	2025-01-14 00:00:00	2025-01-14 00:00:00	23
231	7179	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-17 18:30:00	2025-01-14 00:00:00	2025-01-14 00:00:00	23
233	7171	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-25 10:00:00	2025-01-14 00:00:00	2025-01-14 00:00:00	23
234	7161	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-13 19:00:00	2025-01-13 00:00:00	2025-01-13 00:00:00	23
235	7083	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-14 19:00:00	2025-01-10 00:00:00	2025-01-10 00:00:00	23
236	7041	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-13 11:00:00	2025-01-09 00:00:00	2025-01-09 00:00:00	23
237	7098	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-17 19:00:00	2025-01-09 00:00:00	2025-01-09 00:00:00	23
238	7018	23	\N	\N	\N	23	Visita	Agendado	\N	2025-01-13 13:30:00	2025-01-08 00:00:00	2025-01-08 00:00:00	23
239	7053	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-09 19:00:00	2025-01-08 00:00:00	2025-01-08 00:00:00	23
240	7029	23	\N	\N	\N	23	Visita	Agendado	\N	2025-01-11 09:00:00	2025-01-08 00:00:00	2025-01-08 00:00:00	23
244	8693	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-19 00:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	23
245	8694	23	\N	\N	\N	14	Visita	Agendado	\N	2025-04-16 00:00:00	2025-04-16 00:00:00	2025-04-16 00:00:00	23
246	8695	23	\N	\N	\N	14	Visita	Agendado	\N	2025-04-09 00:00:00	2025-04-09 00:00:00	2025-04-09 00:00:00	23
186	7415	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-29 09:00:00	2025-03-25 00:00:00	2025-03-25 00:00:00	23
185	7651	23	\N	\N	\N	17	Visita	Agendado	\N	2025-03-26 14:00:00	2025-03-25 00:00:00	2025-03-25 00:00:00	23
198	7822	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-18 17:00:00	2025-03-14 00:00:00	2025-03-14 00:00:00	23
193	7837	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-22 13:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	23
196	7904	23	\N	\N	\N	17	Visita	Agendado	\N	2025-03-22 14:00:00	2025-03-18 00:00:00	2025-03-18 00:00:00	23
194	7926	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-22 10:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	23
191	7977	23	\N	\N	\N	17	Visita	Agendado	\N	2025-03-28 11:00:00	2025-03-21 00:00:00	2025-03-21 00:00:00	23
190	7978	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-22 11:00:00	2025-03-21 00:00:00	2025-03-21 00:00:00	23
183	8113	23	\N	\N	\N	14	Visita	Agendado	\N	2025-04-26 09:00:00	2025-04-04 00:00:00	2025-04-04 00:00:00	23
248	8696	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-09 00:00:00	2025-01-09 00:00:00	2025-01-09 00:00:00	23
249	8697	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-07 00:00:00	2025-01-07 00:00:00	2025-01-07 00:00:00	23
250	8105	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-17 00:00:00	2025-04-17 00:00:00	2025-04-17 00:00:00	13
123	8407	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-23 13:00:00	2025-04-22 00:00:00	2025-04-22 00:00:00	22
124	8224	22	\N	\N	\N	14	Visita	Agendado	\N	2025-04-17 10:00:00	2025-04-11 00:00:00	2025-04-11 00:00:00	22
128	7879	22	\N	\N	\N	17	Visita	Agendado	\N	2025-03-26 09:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	22
129	7883	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-18 18:00:00	2025-03-17 00:00:00	2025-03-17 00:00:00	22
130	7803	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-13 18:00:00	2025-03-13 00:00:00	2025-03-13 00:00:00	22
131	7753	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-13 16:30:00	2025-03-12 00:00:00	2025-03-12 00:00:00	13
133	7741	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-14 15:00:00	2025-03-11 00:00:00	2025-03-11 00:00:00	22
135	7699	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-10 15:30:00	2025-03-10 00:00:00	2025-03-10 00:00:00	22
136	7303	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-30 18:00:00	2025-01-31 00:00:00	2025-01-31 00:00:00	23
137	8559	13	\N	\N	\N	14	Visita	Agendado	\N	2025-05-05 19:30:00	2025-05-05 00:00:00	2025-05-05 00:00:00	13
138	8497	13	\N	\N	\N	14	Visita	Agendado	\N	2025-05-10 10:00:00	2025-05-05 00:00:00	2025-05-05 00:00:00	13
139	8477	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-29 15:00:00	2025-04-28 00:00:00	2025-04-28 00:00:00	13
140	8452	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-24 16:00:00	2025-04-24 00:00:00	2025-04-24 00:00:00	13
141	8284	22	\N	\N	\N	14	Visita	Agendado	\N	2025-04-22 16:00:00	2025-04-14 00:00:00	2025-04-14 00:00:00	22
142	8172	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-19 10:00:00	2025-04-11 00:00:00	2025-04-11 00:00:00	13
145	8195	22	\N	\N	\N	14	Visita	Agendado	\N	2025-04-09 18:00:00	2025-04-08 00:00:00	2025-04-08 00:00:00	22
146	8201	23	\N	\N	\N	14	Visita	Agendado	\N	2025-04-08 17:00:00	2025-04-07 00:00:00	2025-04-07 00:00:00	23
147	8058	13	\N	\N	\N	14	Visita	Agendado	\N	2025-03-29 13:25:00	2025-03-28 00:00:00	2025-03-28 00:00:00	13
148	8020	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-31 10:00:00	2025-03-27 00:00:00	2025-03-27 00:00:00	13
149	7445	13	\N	\N	\N	14	Visita	Agendado	\N	2025-03-31 11:00:00	2025-03-26 00:00:00	2025-03-26 00:00:00	13
150	7849	13	\N	\N	\N	14	Visita	Agendado	\N	2025-03-19 18:30:00	2025-03-18 00:00:00	2025-03-18 00:00:00	13
151	7848	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-17 14:30:00	2025-03-15 00:00:00	2025-03-15 00:00:00	13
152	7764	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-15 10:00:00	2025-03-14 00:00:00	2025-03-14 00:00:00	13
156	7626	23	\N	\N	\N	23	Visita	Agendado	\N	2025-03-07 14:00:00	2025-03-06 00:00:00	2025-03-06 00:00:00	23
157	7595	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-21 15:00:00	2025-02-20 00:00:00	2025-02-20 00:00:00	23
158	7571	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-18 18:30:00	2025-02-18 00:00:00	2025-02-18 00:00:00	23
160	7414	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-09 11:30:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
161	7373	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-14 17:20:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
162	7493	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-16 09:00:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
163	7494	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-15 09:00:00	2025-02-11 00:00:00	2025-02-11 00:00:00	23
164	7298	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-23 10:00:00	2025-01-21 00:00:00	2025-01-21 00:00:00	23
165	7236	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-17 08:30:00	2025-01-16 00:00:00	2025-01-16 00:00:00	23
166	7114	23	\N	\N	\N	17	Visita	Agendado	\N	2025-01-08 19:00:00	2025-01-08 00:00:00	2025-01-08 00:00:00	23
167	7115	23	\N	\N	\N	14	Visita	Agendado	\N	2025-01-08 18:30:00	2025-01-08 00:00:00	2025-01-08 00:00:00	23
168	8585	13	\N	\N	\N	14	Visita	Agendado	\N	2025-05-19 13:30:00	2025-05-08 00:00:00	2025-05-08 00:00:00	13
170	8442	13	\N	\N	\N	14	Visita	Agendado	\N	2025-05-05 15:00:00	2025-05-05 00:00:00	2025-05-05 00:00:00	13
171	8530	22	\N	\N	\N	14	Visita	Agendado	\N	2025-05-12 09:00:00	2025-05-05 00:00:00	2025-05-05 00:00:00	22
175	8351	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-22 17:00:00	2025-04-24 00:00:00	2025-04-24 00:00:00	13
176	8441	13	\N	\N	\N	17	Visita	Agendado	\N	2025-04-25 18:00:00	2025-04-24 00:00:00	2025-04-24 00:00:00	13
178	8372	22	\N	\N	\N	14	Visita	Agendado	\N	2025-04-25 13:00:00	2025-04-23 00:00:00	2025-04-23 00:00:00	22
179	8074	22	\N	\N	\N	14	Visita	Agendado	\N	2025-04-12 09:00:00	2025-04-09 00:00:00	2025-04-09 00:00:00	22
181	8164	13	\N	\N	\N	14	Visita	Agendado	\N	2025-04-18 14:00:00	2025-04-07 00:00:00	2025-04-07 00:00:00	13
184	8103	13	\N	\N	\N	17	Visita	Agendado	\N	2025-04-05 11:00:00	2025-04-04 00:00:00	2025-04-04 00:00:00	13
187	7970	13	\N	\N	\N	14	Visita	Agendado	\N	2025-03-27 11:30:00	2025-03-24 00:00:00	2025-03-24 00:00:00	13
188	7986	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-24 14:00:00	2025-03-24 00:00:00	2025-03-24 00:00:00	13
189	7969	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-24 18:00:00	2025-03-21 00:00:00	2025-03-21 00:00:00	13
192	7930	22	\N	\N	\N	17	Visita	Agendado	\N	2025-03-22 09:00:00	2025-03-20 00:00:00	2025-03-20 00:00:00	22
195	7808	13	\N	\N	\N	14	Visita	Agendado	\N	2025-03-20 11:00:00	2025-03-18 00:00:00	2025-03-18 00:00:00	13
197	7828	22	\N	\N	\N	17	Visita	Agendado	\N	2025-03-18 15:00:00	2025-03-17 00:00:00	2025-03-17 00:00:00	22
199	7790	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-18 10:00:00	2025-03-14 00:00:00	2025-03-14 00:00:00	13
200	7758	22	\N	\N	\N	14	Visita	Agendado	\N	2025-03-15 10:00:00	2025-03-12 00:00:00	2025-03-12 00:00:00	22
201	7636	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-12 16:30:00	2025-03-12 00:00:00	2025-03-12 00:00:00	13
202	7656	13	\N	\N	\N	17	Visita	Agendado	\N	2025-03-10 19:00:00	2025-03-12 00:00:00	2025-03-12 00:00:00	13
204	7515	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-26 14:00:00	2025-02-25 00:00:00	2025-02-25 00:00:00	23
205	7591	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-21 18:30:00	2025-02-21 00:00:00	2025-02-21 00:00:00	23
206	7544	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-17 18:30:00	2025-02-18 00:00:00	2025-02-18 00:00:00	23
207	7469	23	\N	\N	\N	17	Visita	Agendado	\N	2025-02-20 13:00:00	2025-02-18 00:00:00	2025-02-18 00:00:00	23
208	7356	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-08 09:00:00	2025-02-17 00:00:00	2025-02-17 00:00:00	23
242	8657	13	\N	\N	\N	17	Visita	Agendado	\N	2025-05-13 00:00:00	2025-05-13 00:00:00	2025-05-13 00:00:00	13
241	7405	23	\N	\N	\N	14	Visita	Agendado	\N	2025-02-12 00:00:00	2025-02-12 00:00:00	2025-02-12 00:00:00	23
203	7716	23	\N	\N	\N	14	Visita	Agendado	\N	2025-03-12 14:00:00	2025-03-10 00:00:00	2025-03-10 00:00:00	23
\.


--
-- Data for Name: clientes_id_anotacoes; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes_id_anotacoes (id, cliente_id, user_id, text, updated_at, created_at) FROM stdin;
\.


--
-- Data for Name: clientes_vendas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes_vendas (id, cliente_id, user_id, value, notes, updated_at, sold_at, created_at, consultant_id, broker_id, cpf, property_type, builder_name, block, unit, payment_method, commission, bonus, total_commission, development_name, assigned_to) FROM stdin;
11	7405	1	262900.00		2025-02-28 00:00:00	2025-02-28 00:00:00	2025-02-28 00:00:00	23	14	074.240.586-90	Apto	Opção	Bloco 1	1102	Financiamento Bancário	10516.00	\N	10516.00	Recanto Verde	23
18	7930	1	223000.00	Pagar a primeira parcela do sinal, no valor de R$ 1.500,00.	2025-04-20 00:00:00	2025-04-20 00:00:00	2025-04-20 00:00:00	22	17	138.951.556-75	Apto	vivamus	2	102	Financiamento Bancário	8920.00	\N	8920.00	jade	22
19	8697	1	245900.00	Ficamos responsaveis por pagar o sinal de R$ 2.000,00 e ele nao pagar parcela em boleto em 4x R$ 500, sendo feito o pagamento total no dia 20/01 pra Opção.	2025-01-07 00:00:00	2025-01-07 00:00:00	2025-01-07 00:00:00	23	14	115.043.056-71	Apto	OPÇÃO	1	207	Financiamento Bancário	9836.00	\N	9836.00	RECANTO VERDE II	23
20	8696	1	258000.00		2025-01-07 00:00:00	2025-01-07 00:00:00	2025-01-07 00:00:00	23	14	525.847.928-50	Apto	Urbani	2	203	Financiamento Bancário	10320.00	\N	10320.00	Bella Vitta	23
21	8695	1	300000.00		2025-04-09 00:00:00	2025-04-09 00:00:00	2025-04-09 00:00:00	23	14	094.013.276-10	Apto	OPÇÃO	2	508	Financiamento Bancário	15000.00	\N	15000.00	SHOPPING SUL	23
9	8074	1	245000.00		2025-04-23 00:00:00	2025-04-23 00:00:00	2025-04-23 00:00:00	22	14	090.244.996-66	Apto	Rummo	Bloco A	1003	Financiamento Bancário	9800.00	\N	9800.00	Bris	22
10	7356	1	254436.00		2025-03-31 00:00:00	2025-03-31 00:00:00	2025-03-31 00:00:00	23	14	136.117.236-30	Apto	Hlts	Bloco 4	407	Financiamento Bancário	10177.44	3000.00	13177.44	Union Landscape	23
12	7098	1	264790.00		2025-02-28 00:00:00	2025-02-28 00:00:00	2025-02-28 00:00:00	23	14	074.240.586-90	Apto	Hlts	Bloco 3	001	Financiamento Bancário	10591.60	3000.00	13591.60	Union Landscape	23
13	7303	1	225369.00		2025-01-30 00:00:00	2025-01-30 00:00:00	2025-01-30 00:00:00	23	17	703.208.956-96	Apto	TRUST	1	502	Financiamento Bancário	9014.76	\N	9014.76	HORIZON	23
14	7571	1	263900.00		2025-02-28 00:00:00	2025-02-28 00:00:00	2025-02-28 00:00:00	23	14	016.653.926-06	Apto	OPÇÃO	3	1006	Financiamento Bancário	10556.00	\N	10556.00	RECANTO VERDE II	23
15	7828	1	210500.00		2025-03-20 00:00:00	2025-03-20 00:00:00	2025-03-20 00:00:00	22	17	091.288.516-50	Apto	Realiza	2	408	Financiamento Bancário	8138.74	\N	8138.74	prime clube	22
16	7790	1	263900.00	Vamos precisar pagar as duas primeiras mensais pro cliente, começando a partir de 10/05 no valor de R$ 428,11.	2025-03-29 00:00:00	2025-03-29 00:00:00	2025-03-29 00:00:00	13	17	086.947.596-75	Apto	OPÇÃO	3	808	Financiamento Bancário	10556.00	\N	10556.00	RECANTO VERDE II	13
17	7977	1	259900.00		2025-03-29 00:00:00	2025-03-29 00:00:00	2025-03-29 00:00:00	1	17	047.235.051-05	Apto	OPÇÃO	3	408	Financiamento Bancário	10394.56	\N	10394.56	RECANTO VERDE II	23
\.


--
-- Data for Name: clientes_visitas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes_visitas (id, cliente_id, user_id, property_id, notes, visited_at, created_at, updated_at, temperature, visit_description, next_steps, broker_id, assigned_to) FROM stdin;
37	7171	1	visita-1747263218024	Temperatura: Morno\n\nResultado: renda mais baixa, estava atrasada na visita, condições baixas igual a da simulação.\n\n\nPróximos passos: renda mais baixa, estava atrasada na visita, condições baixas igual a da simulação.\n	2025-01-25 10:00:00	2025-01-25 00:00:00	2025-01-25 00:00:00	3	renda mais baixa, estava atrasada na visita, condições baixas igual a da simulação.\n	renda mais baixa, estava atrasada na visita, condições baixas igual a da simulação.\n	14	23
46	7571	1	visita-1747322724844	Temperatura: Muito Quente\n\nResultado: Cliente vai fechar Novo Mundo.\n\nPróximos passos: Cliente vai fechar Novo Mundo.	2025-02-20 18:30:00	2025-02-20 00:00:00	2025-02-20 00:00:00	5	Cliente vai fechar Novo Mundo.	Cliente vai fechar Novo Mundo.	14	23
3	7161	1	visita-1747229916682	Temperatura: Quente\n\nResultado: Marcos gostou do empreendimento, disse que ja vai mandar a documentação pra aprovar, opção ficou caro pra ele e vou mostrar alguns outros.\n\nPróximos passos: .Marcos gostou do empreendimento, disse que ja vai mandar a documentação pra aprovar, opção ficou caro pra ele e vou mostrar alguns outros.	2025-01-13 19:00:00	2025-01-13 00:00:00	2025-01-13 00:00:00	4	Marcos gostou do empreendimento, disse que ja vai mandar a documentação pra aprovar, opção ficou caro pra ele e vou mostrar alguns outros.	.Marcos gostou do empreendimento, disse que ja vai mandar a documentação pra aprovar, opção ficou caro pra ele e vou mostrar alguns outros.	17	23
4	8442	1	visita-1747231614672	Temperatura: Frio\n\nResultado: Cliente é maquiadora, tem uma renda média de 3 mil, paga um aluguel de 800 reais.Precisava de uma apartamento já próximo da entrega com parcela de no máximo 1100, tem preferência pelo Planalto e região\n\n\nPróximos passos: Cliente é maquiadora, tem uma renda média de 3 mil, paga um aluguel de 800 reais.Precisava de uma apartamento já próximo da entrega com parcela de no máximo 1100, tem preferência pelo Planalto e região\n	2025-05-05 19:30:00	2025-05-05 00:00:00	2025-05-05 00:00:00	2	Cliente é maquiadora, tem uma renda média de 3 mil, paga um aluguel de 800 reais.Precisava de uma apartamento já próximo da entrega com parcela de no máximo 1100, tem preferência pelo Planalto e região\n	Cliente é maquiadora, tem uma renda média de 3 mil, paga um aluguel de 800 reais.Precisava de uma apartamento já próximo da entrega com parcela de no máximo 1100, tem preferência pelo Planalto e região\n	14	13
5	8559	1	visita-1747232101471	Temperatura: Morno\n\nResultado: Noiva trabalha na Realiza, já conhece basicamente todas as plantas de Uberlândia. Ela comprou o Grand Prime e agora ele quer comprar um outro, quer o mais pronto possível, se interessou muito no Solar do vale, mas precisa vender o carro.Quer ver outros empreendimentos também\n\n\nPróximos passos: Noiva trabalha na Realiza, já conhece basicamente todas as plantas de Uberlândia. Ela comprou o Grand Prime e agora ele quer comprar um outro, quer o mais pronto possível, se interessou muito no Solar do vale, mas precisa vender o carro.Quer ver outros empreendimentos também\n	2025-05-05 20:30:00	2025-05-05 00:00:00	2025-05-05 00:00:00	3	Noiva trabalha na Realiza, já conhece basicamente todas as plantas de Uberlândia. Ela comprou o Grand Prime e agora ele quer comprar um outro, quer o mais pronto possível, se interessou muito no Solar do vale, mas precisa vender o carro.Quer ver outros empreendimentos também\n	Noiva trabalha na Realiza, já conhece basicamente todas as plantas de Uberlândia. Ela comprou o Grand Prime e agora ele quer comprar um outro, quer o mais pronto possível, se interessou muito no Solar do vale, mas precisa vender o carro.Quer ver outros empreendimentos também\n	14	13
63	8697	1	visita-1747330888691	Temperatura: Muito Quente\n\nResultado: cliente vai comprar novo mundo\n\nPróximos passos: cliente vai comprar novo mundo	2025-01-07 19:00:00	2025-01-07 00:00:00	2025-01-07 00:00:00	5	cliente vai comprar novo mundo	cliente vai comprar novo mundo	14	23
64	8696	1	visita-1747331202274	Temperatura: Muito Quente\n\nResultado: vai comprar bella vitta\n\nPróximos passos: vai comprar bella vitta	2025-01-07 19:00:00	2025-01-07 00:00:00	2025-01-07 00:00:00	5	vai comprar bella vitta	vai comprar bella vitta	14	23
6	8172	1	visita-1747232305042	Temperatura: Quente\n\nResultado: Cliente enrolou 3 semanas pra visitar, chamei pra ir no decorado ai aceitou a visita.Uber, esposa caixa, vão comprar juntos, mas querem comprar somente no nome dele, tem um filho.Quer um imóvel o mais pronto possível\n\n\nPróximos passos: Cliente enrolou 3 semanas pra visitar, chamei pra ir no decorado ai aceitou a visita.Uber, esposa caixa, vão comprar juntos, mas querem comprar somente no nome dele, tem um filho.Quer um imóvel o mais pronto possível\n	2025-04-29 10:15:00	2025-04-29 00:00:00	2025-04-29 00:00:00	4	Cliente enrolou 3 semanas pra visitar, chamei pra ir no decorado ai aceitou a visita.Uber, esposa caixa, vão comprar juntos, mas querem comprar somente no nome dele, tem um filho.Quer um imóvel o mais pronto possível\n	Cliente enrolou 3 semanas pra visitar, chamei pra ir no decorado ai aceitou a visita.Uber, esposa caixa, vão comprar juntos, mas querem comprar somente no nome dele, tem um filho.Quer um imóvel o mais pronto possível\n	14	13
7	7114	1	visita-1747232418179	Temperatura: Quente\n\nResultado: Cliente Simone, gostou muito do projeto do Jardim Patrícia, mas achou interessante o do Novo Mundo, vai investir.Os valores ficaram muito bons, já me mandou documentação, porém ela saiu do serviço dela, deu baixa na carteira no mês 12, vou ver com ela oq aconteceu ainda\n\nPróximos passos: Cliente Simone, gostou muito do projeto do Jardim Patrícia, mas achou interessante o do Novo Mundo, vai investir.Os valores ficaram muito bons, já me mandou documentação, porém ela saiu do serviço dela, deu baixa na carteira no mês 12, vou ver com ela oq aconteceu ainda	2025-01-08 19:00:00	2025-01-08 00:00:00	2025-01-08 00:00:00	4	Cliente Simone, gostou muito do projeto do Jardim Patrícia, mas achou interessante o do Novo Mundo, vai investir.Os valores ficaram muito bons, já me mandou documentação, porém ela saiu do serviço dela, deu baixa na carteira no mês 12, vou ver com ela oq aconteceu ainda	Cliente Simone, gostou muito do projeto do Jardim Patrícia, mas achou interessante o do Novo Mundo, vai investir.Os valores ficaram muito bons, já me mandou documentação, porém ela saiu do serviço dela, deu baixa na carteira no mês 12, vou ver com ela oq aconteceu ainda	17	23
8	7187	1	visita-1747232564984	Temperatura: Morno\n\nResultado: gostou bastante da opção, mas sozinho ele nao consegue, namorada vai tentar regularizar a pendencia dela pra comprarem juntos, vou tentar aprovar o credito\n\nPróximos passos: gostou bastante da opção, mas sozinho ele nao consegue, namorada vai tentar regularizar a pendencia dela pra comprarem juntos, vou tentar aprovar o credito	2025-01-16 16:30:00	2025-01-16 00:00:00	2025-01-16 00:00:00	3	gostou bastante da opção, mas sozinho ele nao consegue, namorada vai tentar regularizar a pendencia dela pra comprarem juntos, vou tentar aprovar o credito	gostou bastante da opção, mas sozinho ele nao consegue, namorada vai tentar regularizar a pendencia dela pra comprarem juntos, vou tentar aprovar o credito	17	23
9	8372	1	visita-1747232918906	Temperatura: Morno\n\nResultado: Foi com os pais, conheceu o decorado da Opção e da HLTS, pelos fechamentos se interessou mais no Recanto II e no Place + Bosque.Perguntou sobre outros empreendimentos em outros bairros, falei sobre o Figueira, mas ele não deu um retorno ainda.Vai precisar esperar o novo holerite, pra vir com o reajuste salarial\n\n\nPróximos passos: Foi com os pais, conheceu o decorado da Opção e da HLTS, pelos fechamentos se interessou mais no Recanto II e no Place + Bosque.Perguntou sobre outros empreendimentos em outros bairros, falei sobre o Figueira, mas ele não deu um retorno ainda.Vai precisar esperar o novo holerite, pra vir com o reajuste salarial\n	2025-04-25 13:00:00	2025-04-25 00:00:00	2025-04-25 00:00:00	3	Foi com os pais, conheceu o decorado da Opção e da HLTS, pelos fechamentos se interessou mais no Recanto II e no Place + Bosque.Perguntou sobre outros empreendimentos em outros bairros, falei sobre o Figueira, mas ele não deu um retorno ainda.Vai precisar esperar o novo holerite, pra vir com o reajuste salarial\n	Foi com os pais, conheceu o decorado da Opção e da HLTS, pelos fechamentos se interessou mais no Recanto II e no Place + Bosque.Perguntou sobre outros empreendimentos em outros bairros, falei sobre o Figueira, mas ele não deu um retorno ainda.Vai precisar esperar o novo holerite, pra vir com o reajuste salarial\n	14	22
10	8452	1	visita-1747233289467	Temperatura: Morno\n\nResultado: Clientes estão morando em Uberlândia a apenas 2 meses, estão pagando quase 2 mil de aluguel, queriam algo o mais pronto possível, ela gostou do Jardim Patricia III e do Novo Holanda, chamei pra conhecerem os decorados mas o namorado não está em Uberlândia\n\n\nPróximos passos: Clientes estão morando em Uberlândia a apenas 2 meses, estão pagando quase 2 mil de aluguel, queriam algo o mais pronto possível, ela gostou do Jardim Patricia III e do Novo Holanda, chamei pra conhecerem os decorados mas o namorado não está em Uberlândia\n	2025-04-24 16:00:00	2025-04-24 00:00:00	2025-04-24 00:00:00	3	Clientes estão morando em Uberlândia a apenas 2 meses, estão pagando quase 2 mil de aluguel, queriam algo o mais pronto possível, ela gostou do Jardim Patricia III e do Novo Holanda, chamei pra conhecerem os decorados mas o namorado não está em Uberlândia\n	Clientes estão morando em Uberlândia a apenas 2 meses, estão pagando quase 2 mil de aluguel, queriam algo o mais pronto possível, ela gostou do Jardim Patricia III e do Novo Holanda, chamei pra conhecerem os decorados mas o namorado não está em Uberlândia\n	14	13
11	7272	1	visita-1747233368233	Temperatura: Muito Quente\n\nResultado: gostou muito do apartamento da opção, eles tem renda suficiente pra comprar o apartamento, vao ate o local da obra ver o apartamento, se gostar, vão manda a documentação e caminhar pra venda,\n\nPróximos passos: gostou muito do apartamento da opção, eles tem renda suficiente pra comprar o apartamento, vao ate o local da obra ver o apartamento, se gostar, vão manda a documentação e caminhar pra venda,	2025-01-21 16:00:00	2025-01-21 00:00:00	2025-01-21 00:00:00	5	gostou muito do apartamento da opção, eles tem renda suficiente pra comprar o apartamento, vao ate o local da obra ver o apartamento, se gostar, vão manda a documentação e caminhar pra venda,	gostou muito do apartamento da opção, eles tem renda suficiente pra comprar o apartamento, vao ate o local da obra ver o apartamento, se gostar, vão manda a documentação e caminhar pra venda,	17	23
12	8351	1	visita-1747233891147	Temperatura: Morno\n\nResultado: Cliente não estava muito animada, mas a parcela da TRUST ela disse que fica bom pra eles.Marcou de visitar a construtora sexta as 17:30\n\n\nPróximos passos: Cliente não estava muito animada, mas a parcela da TRUST ela disse que fica bom pra eles.Marcou de visitar a construtora sexta as 17:30\n	2025-04-22 17:00:00	2025-04-22 00:00:00	2025-04-22 00:00:00	3	Cliente não estava muito animada, mas a parcela da TRUST ela disse que fica bom pra eles.Marcou de visitar a construtora sexta as 17:30\n	Cliente não estava muito animada, mas a parcela da TRUST ela disse que fica bom pra eles.Marcou de visitar a construtora sexta as 17:30\n	14	13
13	8074	1	visita-1747233994368	Temperatura: Quente\n\nResultado: Visita na Fama, fomos na Rummo, adorou o decorado, já escolheu unidade e valor de sinal.Quer fechar o quanto antes\n\n\nPróximos passos: Visita na Fama, fomos na Rummo, adorou o decorado, já escolheu unidade e valor de sinal.Quer fechar o quanto antes\n	2025-04-12 09:00:00	2025-04-12 00:00:00	2025-04-12 00:00:00	4	Visita na Fama, fomos na Rummo, adorou o decorado, já escolheu unidade e valor de sinal.Quer fechar o quanto antes\n	Visita na Fama, fomos na Rummo, adorou o decorado, já escolheu unidade e valor de sinal.Quer fechar o quanto antes\n	14	22
14	7445	1	visita-1747234201426	Temperatura: Morno\n\nResultado: É casado no papel, mas ela não tem renda formal.Hoje moram em Araguari e pagam aluguel de 750 reaisÉ servidor publico com renda de 6 milQuerem algo perto do trabalho deles, na zona leste e o mais pronto possívelEnviei fechamento pelo whatsapp\n\n\nPróximos passos: É casado no papel, mas ela não tem renda formal.Hoje moram em Araguari e pagam aluguel de 750 reaisÉ servidor publico com renda de 6 milQuerem algo perto do trabalho deles, na zona leste e o mais pronto possívelEnviei fechamento pelo whatsapp\n	2025-04-01 09:00:00	2025-04-01 00:00:00	2025-04-01 00:00:00	3	É casado no papel, mas ela não tem renda formal.Hoje moram em Araguari e pagam aluguel de 750 reaisÉ servidor publico com renda de 6 milQuerem algo perto do trabalho deles, na zona leste e o mais pronto possívelEnviei fechamento pelo whatsapp\n	É casado no papel, mas ela não tem renda formal.Hoje moram em Araguari e pagam aluguel de 750 reaisÉ servidor publico com renda de 6 milQuerem algo perto do trabalho deles, na zona leste e o mais pronto possívelEnviei fechamento pelo whatsapp\n	14	13
15	8058	1	visita-1747234365558	Temperatura: Morno\n\nResultado: Cliente vai comprar com a namorada. Estão noivando e querem algo pro quanto antes.Moram no Morumbi, gostou muito do Recanto Verde II.Vão enviar documentação\n\n\nPróximos passos: Cliente vai comprar com a namorada. Estão noivando e querem algo pro quanto antes.Moram no Morumbi, gostou muito do Recanto Verde II.Vão enviar documentação\n	2025-03-29 09:00:00	2025-03-29 00:00:00	2025-03-29 00:00:00	3	Cliente vai comprar com a namorada. Estão noivando e querem algo pro quanto antes.Moram no Morumbi, gostou muito do Recanto Verde II.Vão enviar documentação\n	Cliente vai comprar com a namorada. Estão noivando e querem algo pro quanto antes.Moram no Morumbi, gostou muito do Recanto Verde II.Vão enviar documentação\n	14	13
16	7808	1	visita-1747235226641	Temperatura: Quente\n\nResultado: Cliente vai comprar com o esposo, tem a possibilidade de colocar o irmão como dependente.Ou colocar o marido (agiota) para comprar junto.Renda dela chega em mais ou menos 2 mil, e a dele gira em torno de 4 mil\n\n\nPróximos passos: Cliente vai comprar com o esposo, tem a possibilidade de colocar o irmão como dependente.Ou colocar o marido (agiota) para comprar junto.Renda dela chega em mais ou menos 2 mil, e a dele gira em torno de 4 mil\n	2025-03-20 11:00:00	2025-03-20 00:00:00	2025-03-20 00:00:00	4	Cliente vai comprar com o esposo, tem a possibilidade de colocar o irmão como dependente.Ou colocar o marido (agiota) para comprar junto.Renda dela chega em mais ou menos 2 mil, e a dele gira em torno de 4 mil\n	Cliente vai comprar com o esposo, tem a possibilidade de colocar o irmão como dependente.Ou colocar o marido (agiota) para comprar junto.Renda dela chega em mais ou menos 2 mil, e a dele gira em torno de 4 mil\n	14	13
17	7883	1	visita-1747235934468	Temperatura: Morno\n\nResultado: Cliente morava em Ituiutaba, está morando com a mãe a 2 semanas.Está em um emprego novo ainda não tem holerite.Cara bem simples, queria algo mais pronto, aceitou sobre as parcelas e falou que seria possível conseguir a entrada com o pai.\n\n\nPróximos passos: Cliente morava em Ituiutaba, está morando com a mãe a 2 semanas.Está em um emprego novo ainda não tem holerite.Cara bem simples, queria algo mais pronto, aceitou sobre as parcelas e falou que seria possível conseguir a entrada com o pai.\n	2025-03-20 15:00:00	2025-03-20 00:00:00	2025-03-20 00:00:00	3	Cliente morava em Ituiutaba, está morando com a mãe a 2 semanas.Está em um emprego novo ainda não tem holerite.Cara bem simples, queria algo mais pronto, aceitou sobre as parcelas e falou que seria possível conseguir a entrada com o pai.\n	Cliente morava em Ituiutaba, está morando com a mãe a 2 semanas.Está em um emprego novo ainda não tem holerite.Cara bem simples, queria algo mais pronto, aceitou sobre as parcelas e falou que seria possível conseguir a entrada com o pai.\n	14	22
18	7849	1	visita-1747236227283	Temperatura: Morno\n\nResultado: Cliente vai comprar junto com o esposo, queriam algo mais pronto da entrega pra sair do aluguel, já tem 2 filhos, renda de 3400 conjunta.Diz ter 3 anos, mas fazendo as contas ainda não tem.\n\n\nPróximos passos: Cliente vai comprar junto com o esposo, queriam algo mais pronto da entrega pra sair do aluguel, já tem 2 filhos, renda de 3400 conjunta.Diz ter 3 anos, mas fazendo as contas ainda não tem.\n	2025-03-19 19:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	3	Cliente vai comprar junto com o esposo, queriam algo mais pronto da entrega pra sair do aluguel, já tem 2 filhos, renda de 3400 conjunta.Diz ter 3 anos, mas fazendo as contas ainda não tem.\n	Cliente vai comprar junto com o esposo, queriam algo mais pronto da entrega pra sair do aluguel, já tem 2 filhos, renda de 3400 conjunta.Diz ter 3 anos, mas fazendo as contas ainda não tem.\n	14	13
19	7758	1	visita-1747236322435	Temperatura: Morno\n\nResultado: Cliente já possui imóvel no nome, mas os pais não tem.Renda da cliente de 2500, e dos pais algo em torno de 14 milAdorou o Select, mas ficou muito caro, o Recanto Verde ela acha que os pais não iriam gostar.Vai mandar tudo para os pais e ver as possibilidades\n\n\nPróximos passos: Cliente já possui imóvel no nome, mas os pais não tem.Renda da cliente de 2500, e dos pais algo em torno de 14 milAdorou o Select, mas ficou muito caro, o Recanto Verde ela acha que os pais não iriam gostar.Vai mandar tudo para os pais e ver as possibilidades\n	2025-03-15 09:00:00	2025-03-15 00:00:00	2025-03-15 00:00:00	3	Cliente já possui imóvel no nome, mas os pais não tem.Renda da cliente de 2500, e dos pais algo em torno de 14 milAdorou o Select, mas ficou muito caro, o Recanto Verde ela acha que os pais não iriam gostar.Vai mandar tudo para os pais e ver as possibilidades\n	Cliente já possui imóvel no nome, mas os pais não tem.Renda da cliente de 2500, e dos pais algo em torno de 14 milAdorou o Select, mas ficou muito caro, o Recanto Verde ela acha que os pais não iriam gostar.Vai mandar tudo para os pais e ver as possibilidades\n	14	22
27	7373	1	visita-1747240470992	Temperatura: Frio\n\nResultado: Cliente ainda está vendo oportunidades, teria uns 5 mil hoje, mas conseguiria conversar com a mãe pra conseguir um pouco mais.Gostou muito do Oasis, mas quer conhecer o Prime Clube, pois o sinal encaixaria pra ela\n\n\nPróximos passos: Cliente ainda está vendo oportunidades, teria uns 5 mil hoje, mas conseguiria conversar com a mãe pra conseguir um pouco mais.Gostou muito do Oasis, mas quer conhecer o Prime Clube, pois o sinal encaixaria pra ela\n	2025-02-14 10:00:00	2025-02-14 00:00:00	2025-02-14 00:00:00	2	Cliente ainda está vendo oportunidades, teria uns 5 mil hoje, mas conseguiria conversar com a mãe pra conseguir um pouco mais.Gostou muito do Oasis, mas quer conhecer o Prime Clube, pois o sinal encaixaria pra ela\n	Cliente ainda está vendo oportunidades, teria uns 5 mil hoje, mas conseguiria conversar com a mãe pra conseguir um pouco mais.Gostou muito do Oasis, mas quer conhecer o Prime Clube, pois o sinal encaixaria pra ela\n	14	23
36	7319	1	visita-1747263076176	Temperatura: Morno\n\nResultado: Já tem imóvel, quer vender, inventario do marido avançado, necessitando de um tempo para vender\n\n\nPróximos passos: Já tem imóvel, quer vender, inventario do marido avançado, necessitando de um tempo para vender\n	2025-01-25 09:00:00	2025-01-25 00:00:00	2025-01-25 00:00:00	3	Já tem imóvel, quer vender, inventario do marido avançado, necessitando de um tempo para vender\n	Já tem imóvel, quer vender, inventario do marido avançado, necessitando de um tempo para vender\n	14	23
22	7699	1	visita-1747237044572	Temperatura: Morno\n\nResultado: Quer vender uma casa em Araguari, é empresária e recebe uma pensão de 9300, tem 66 anos, gostou muito do decorado da HLTS\n\n\nPróximos passos: Quer vender uma casa em Araguari, é empresária e recebe uma pensão de 9300, tem 66 anos, gostou muito do decorado da HLTS\n	2025-03-10 10:00:00	2025-03-10 00:00:00	2025-03-10 00:00:00	3	Quer vender uma casa em Araguari, é empresária e recebe uma pensão de 9300, tem 66 anos, gostou muito do decorado da HLTS\n	Quer vender uma casa em Araguari, é empresária e recebe uma pensão de 9300, tem 66 anos, gostou muito do decorado da HLTS\n	14	22
24	7544	1	visita-1747237288241	Temperatura: Morno\n\nResultado: Está com o nome sujo, mas o namorado está ok.Mas só na renda do namorado não daria, pedi documentação pra sabermos quanto liberaria\n\n\nPróximos passos: Está com o nome sujo, mas o namorado está ok.Mas só na renda do namorado não daria, pedi documentação pra sabermos quanto liberaria\n	2025-02-17 10:00:00	2025-02-17 00:00:00	2025-02-17 00:00:00	3	Está com o nome sujo, mas o namorado está ok.Mas só na renda do namorado não daria, pedi documentação pra sabermos quanto liberaria\n	Está com o nome sujo, mas o namorado está ok.Mas só na renda do namorado não daria, pedi documentação pra sabermos quanto liberaria\n	14	23
25	7493	1	visita-1747237387922	Temperatura: Frio\n\nResultado: O filho não foi.Já moram na região, vão ajudar o filho com a entrada, hoje tem 20 mil, mas teriam um carro pra vender que vale uns 30.Queria que fosse na SAC, tive que explicar sobre a PRICE e ainda assim estão bem resistentes com a price.\n\n\nPróximos passos: O filho não foi.Já moram na região, vão ajudar o filho com a entrada, hoje tem 20 mil, mas teriam um carro pra vender que vale uns 30.Queria que fosse na SAC, tive que explicar sobre a PRICE e ainda assim estão bem resistentes com a price.\n	2025-02-16 09:00:00	2025-02-16 00:00:00	2025-02-16 00:00:00	2	O filho não foi.Já moram na região, vão ajudar o filho com a entrada, hoje tem 20 mil, mas teriam um carro pra vender que vale uns 30.Queria que fosse na SAC, tive que explicar sobre a PRICE e ainda assim estão bem resistentes com a price.\n	O filho não foi.Já moram na região, vão ajudar o filho com a entrada, hoje tem 20 mil, mas teriam um carro pra vender que vale uns 30.Queria que fosse na SAC, tive que explicar sobre a PRICE e ainda assim estão bem resistentes com a price.\n	14	23
26	7494	1	visita-1747237493334	Temperatura: Quente\n\nResultado: Cliente vai comprar com o noivo.Querem algo próximo de onde já moram atualmente (Jd Patricia)Tem 25 mil de entrada A renda conjunta deles é em torno de 3700\n\n\nPróximos passos: Cliente vai comprar com o noivo.Querem algo próximo de onde já moram atualmente (Jd Patricia)Tem 25 mil de entrada A renda conjunta deles é em torno de 3700\n	2025-02-15 13:00:00	2025-02-15 00:00:00	2025-02-15 00:00:00	4	Cliente vai comprar com o noivo.Querem algo próximo de onde já moram atualmente (Jd Patricia)Tem 25 mil de entrada A renda conjunta deles é em torno de 3700\n	Cliente vai comprar com o noivo.Querem algo próximo de onde já moram atualmente (Jd Patricia)Tem 25 mil de entrada A renda conjunta deles é em torno de 3700\n	14	23
47	7656	1	visita-1747323094667	Temperatura: Quente\n\nResultado: Cliente gostou bastante do apartamento do Novo Mundo, mandou a documentação pra fazer a declaração de imposto de renda.\n\nPróximos passos: Cliente gostou bastante do apartamento do Novo Mundo, mandou a documentação pra fazer a declaração de imposto de renda.	2025-03-10 19:00:00	2025-03-10 00:00:00	2025-03-10 00:00:00	4	Cliente gostou bastante do apartamento do Novo Mundo, mandou a documentação pra fazer a declaração de imposto de renda.	Cliente gostou bastante do apartamento do Novo Mundo, mandou a documentação pra fazer a declaração de imposto de renda.	17	13
28	7414	1	visita-1747240563651	Temperatura: Morno\n\nResultado: Cliente foi bastante sincero que não conseguiria assumir as parcelas da Opção, mesmo no Recanto 2.Fiz o fechamento no Place + Bosque, já disse que ficaria melhor e a esposa já falou que por ela esse encaixaria perfeito, marcou a visita pra verem o decorado na quinta\n\n\nPróximos passos: Cliente foi bastante sincero que não conseguiria assumir as parcelas da Opção, mesmo no Recanto 2.Fiz o fechamento no Place + Bosque, já disse que ficaria melhor e a esposa já falou que por ela esse encaixaria perfeito, marcou a visita pra verem o decorado na quinta\n	2025-02-09 09:00:00	2025-02-09 00:00:00	2025-02-09 00:00:00	3	Cliente foi bastante sincero que não conseguiria assumir as parcelas da Opção, mesmo no Recanto 2.Fiz o fechamento no Place + Bosque, já disse que ficaria melhor e a esposa já falou que por ela esse encaixaria perfeito, marcou a visita pra verem o decorado na quinta\n	Cliente foi bastante sincero que não conseguiria assumir as parcelas da Opção, mesmo no Recanto 2.Fiz o fechamento no Place + Bosque, já disse que ficaria melhor e a esposa já falou que por ela esse encaixaria perfeito, marcou a visita pra verem o decorado na quinta\n	14	23
29	7356	1	visita-1747240728808	Temperatura: Quente\n\nResultado: Cliente gostou do empreendimento, mas queria algo perto de onde mora, Zona Sul, já tinha ido até na obra da HLTS, e é apaixonado no Landscape, agendou uma nova visita sabado que vem na HLTS pra mãe conseguir ver também\n\n\nPróximos passos: Cliente gostou do empreendimento, mas queria algo perto de onde mora, Zona Sul, já tinha ido até na obra da HLTS, e é apaixonado no Landscape, agendou uma nova visita sabado que vem na HLTS pra mãe conseguir ver também\n	2025-02-08 10:00:00	2025-02-08 00:00:00	2025-02-08 00:00:00	4	Cliente gostou do empreendimento, mas queria algo perto de onde mora, Zona Sul, já tinha ido até na obra da HLTS, e é apaixonado no Landscape, agendou uma nova visita sabado que vem na HLTS pra mãe conseguir ver também\n	Cliente gostou do empreendimento, mas queria algo perto de onde mora, Zona Sul, já tinha ido até na obra da HLTS, e é apaixonado no Landscape, agendou uma nova visita sabado que vem na HLTS pra mãe conseguir ver também\n	14	23
30	7273	1	visita-1747240899217	Temperatura: Frio\n\nResultado: O filho que acabou de se formar em medicina quer comprar, mas como está sem tempo os pais que estão olhando.Entrou no emprego fazem 2 semanas, mas é PJ.Nunca declarou e os pais que movimentavam a conta, mas da conta deles pra do filho\n\n\nPróximos passos: O filho que acabou de se formar em medicina quer comprar, mas como está sem tempo os pais que estão olhando.Entrou no emprego fazem 2 semanas, mas é PJ.Nunca declarou e os pais que movimentavam a conta, mas da conta deles pra do filho\n	2025-02-07 14:00:00	2025-02-07 00:00:00	2025-02-07 00:00:00	2	O filho que acabou de se formar em medicina quer comprar, mas como está sem tempo os pais que estão olhando.Entrou no emprego fazem 2 semanas, mas é PJ.Nunca declarou e os pais que movimentavam a conta, mas da conta deles pra do filho\n	O filho que acabou de se formar em medicina quer comprar, mas como está sem tempo os pais que estão olhando.Entrou no emprego fazem 2 semanas, mas é PJ.Nunca declarou e os pais que movimentavam a conta, mas da conta deles pra do filho\n	14	23
31	7393	1	visita-1747240986804	Temperatura: Morno\n\nResultado: Cliente vai precisar esperar o Imposto de Renda, gostou do Jade e do Novo Mundo.Chegou a conhecer o decorado da Opção, está pra voltar pra Uberlândia pra ver o da Vivamus.Tem uma renda em torno de 5 mil\n\n\nPróximos passos: Cliente vai precisar esperar o Imposto de Renda, gostou do Jade e do Novo Mundo.Chegou a conhecer o decorado da Opção, está pra voltar pra Uberlândia pra ver o da Vivamus.Tem uma renda em torno de 5 mil\n	2025-02-07 12:00:00	2025-02-07 00:00:00	2025-02-07 00:00:00	3	Cliente vai precisar esperar o Imposto de Renda, gostou do Jade e do Novo Mundo.Chegou a conhecer o decorado da Opção, está pra voltar pra Uberlândia pra ver o da Vivamus.Tem uma renda em torno de 5 mil\n	Cliente vai precisar esperar o Imposto de Renda, gostou do Jade e do Novo Mundo.Chegou a conhecer o decorado da Opção, está pra voltar pra Uberlândia pra ver o da Vivamus.Tem uma renda em torno de 5 mil\n	14	23
32	7378	1	visita-1747243310243	Temperatura: Quente\n\nResultado: cliente muito bom, somente no nome dela ficaria ruim, ganha apenas 2mil, juntando com o namorado com renda de 3100, para o empreendimento Novo Mundo ficaria melhor, pediu documentação, foi apenas ela na visita, gostou de tudo, e dos valores.\n\n\nPróximos passos: cliente muito bom, somente no nome dela ficaria ruim, ganha apenas 2mil, juntando com o namorado com renda de 3100, para o empreendimento Novo Mundo ficaria melhor, pediu documentação, foi apenas ela na visita, gostou de tudo, e dos valores.\n	2025-02-04 14:00:00	2025-02-04 00:00:00	2025-02-04 00:00:00	4	cliente muito bom, somente no nome dela ficaria ruim, ganha apenas 2mil, juntando com o namorado com renda de 3100, para o empreendimento Novo Mundo ficaria melhor, pediu documentação, foi apenas ela na visita, gostou de tudo, e dos valores.\n	cliente muito bom, somente no nome dela ficaria ruim, ganha apenas 2mil, juntando com o namorado com renda de 3100, para o empreendimento Novo Mundo ficaria melhor, pediu documentação, foi apenas ela na visita, gostou de tudo, e dos valores.\n	14	23
56	7930	1	visita-1747325244389	Temperatura: Muito Quente\n\nResultado: Danilo gostou do apartamento da opção mas não cabe no bolso,  está olhando algumas opções, pedi a documentação.\n\nPróximos passos: Danilo gostou do apartamento da opção mas não cabe no bolso,  está olhando algumas opções, pedi a documentação.	2025-03-29 16:00:00	2025-03-29 00:00:00	2025-03-29 00:00:00	5	Danilo gostou do apartamento da opção mas não cabe no bolso,  está olhando algumas opções, pedi a documentação.	Danilo gostou do apartamento da opção mas não cabe no bolso,  está olhando algumas opções, pedi a documentação.	17	22
33	7115	1	visita-1747243499117	Temperatura: Morno\n\nResultado: Clientes super tranquilas, gente boa, unico problema é que estão pagando aluguel e buscam por algo mais em conta, fez simulação tanto no recanto verde 1 quanto no 2, o 2 ficaria melhor por causa da evolução, gostaram bastante\n\n\nPróximos passos: Clientes super tranquilas, gente boa, unico problema é que estão pagando aluguel e buscam por algo mais em conta, fez simulação tanto no recanto verde 1 quanto no 2, o 2 ficaria melhor por causa da evolução, gostaram bastante\n	2025-01-28 14:00:00	2025-01-28 00:00:00	2025-01-28 00:00:00	3	Clientes super tranquilas, gente boa, unico problema é que estão pagando aluguel e buscam por algo mais em conta, fez simulação tanto no recanto verde 1 quanto no 2, o 2 ficaria melhor por causa da evolução, gostaram bastante\n	Clientes super tranquilas, gente boa, unico problema é que estão pagando aluguel e buscam por algo mais em conta, fez simulação tanto no recanto verde 1 quanto no 2, o 2 ficaria melhor por causa da evolução, gostaram bastante\n	14	23
34	7298	1	visita-1747247868004	Temperatura: Frio\n\nResultado: gostou bastante da opção, ele ja tem um imovel no nome e quer comprar no da namorada, porem ela ganha 2500, achou o valor um pouco alto e disse que esta procurando agora as oportunidades\n\nPróximos passos: gostou bastante da opção, ele ja tem um imovel no nome e quer comprar no da namorada, porem ela ganha 2500, achou o valor um pouco alto e disse que esta procurando agora as oportunidades	2025-01-23 10:00:00	2025-01-23 00:00:00	2025-01-23 00:00:00	2	gostou bastante da opção, ele ja tem um imovel no nome e quer comprar no da namorada, porem ela ganha 2500, achou o valor um pouco alto e disse que esta procurando agora as oportunidades	gostou bastante da opção, ele ja tem um imovel no nome e quer comprar no da namorada, porem ela ganha 2500, achou o valor um pouco alto e disse que esta procurando agora as oportunidades	17	23
35	7313	1	visita-1747262906029	Temperatura: Quente\n\nResultado: Vai comprar com o namorado, a renda deles não é das melhores, juntando as duas dá 3363,76Mas os pais tem a possibilidade de ajudar com a entrada entre 50 e 60 milJá olharam alguns usados mas começaram a ver na planta agora\n\n\nPróximos passos: Vai comprar com o namorado, a renda deles não é das melhores, juntando as duas dá 3363,76Mas os pais tem a possibilidade de ajudar com a entrada entre 50 e 60 milJá olharam alguns usados mas começaram a ver na planta agora\n	2025-01-26 10:00:00	2025-01-26 00:00:00	2025-01-26 00:00:00	4	Vai comprar com o namorado, a renda deles não é das melhores, juntando as duas dá 3363,76Mas os pais tem a possibilidade de ajudar com a entrada entre 50 e 60 milJá olharam alguns usados mas começaram a ver na planta agora\n	Vai comprar com o namorado, a renda deles não é das melhores, juntando as duas dá 3363,76Mas os pais tem a possibilidade de ajudar com a entrada entre 50 e 60 milJá olharam alguns usados mas começaram a ver na planta agora\n	14	23
38	7289	1	visita-1747263281473	Temperatura: Quente\n\nResultado: Cliente possui 25 mil de entrada, conheceu HLTS e também quer ver sobre o imóvel da MOR, possui excelente renda de 3500.\n\n\nPróximos passos: Cliente possui 25 mil de entrada, conheceu HLTS e também quer ver sobre o imóvel da MOR, possui excelente renda de 3500.\n	2025-01-22 14:00:00	2025-01-22 00:00:00	2025-01-22 00:00:00	4	Cliente possui 25 mil de entrada, conheceu HLTS e também quer ver sobre o imóvel da MOR, possui excelente renda de 3500.\n	Cliente possui 25 mil de entrada, conheceu HLTS e também quer ver sobre o imóvel da MOR, possui excelente renda de 3500.\n	14	23
39	7098	1	visita-1747263402044	Temperatura: Quente\n\nResultado: renda 5000, engenheiro, vai comprar rozinho, gostou muito da opção e hlts\n\n\nPróximos passos: renda 5000, engenheiro, vai comprar rozinho, gostou muito da opção e hlts\n	2025-01-22 10:00:00	2025-01-22 00:00:00	2025-01-22 00:00:00	4	renda 5000, engenheiro, vai comprar rozinho, gostou muito da opção e hlts\n	renda 5000, engenheiro, vai comprar rozinho, gostou muito da opção e hlts\n	14	23
40	8665	1	visita-1747263539015	Temperatura: Muito Frio\n\nResultado: estagiaria, compor renda com mae que tem imovel e é casada, nao consegue comprar\n\n\nPróximos passos: estagiaria, compor renda com mae que tem imovel e é casada, nao consegue comprar\n	2025-01-16 19:00:00	2025-01-16 00:00:00	2025-01-16 00:00:00	1	estagiaria, compor renda com mae que tem imovel e é casada, nao consegue comprar\n	estagiaria, compor renda com mae que tem imovel e é casada, nao consegue comprar\n	14	23
41	7053	1	visita-1747264053588	Temperatura: Morno\n\nResultado: noivo com restrição no nome, noivo querendo ver casa, sem entrada, renda de 5.000, conversa em andamento\n\n\nPróximos passos: noivo com restrição no nome, noivo querendo ver casa, sem entrada, renda de 5.000, conversa em andamento\n	2025-01-15 18:00:00	2025-01-15 00:00:00	2025-01-15 00:00:00	3	noivo com restrição no nome, noivo querendo ver casa, sem entrada, renda de 5.000, conversa em andamento\n	noivo com restrição no nome, noivo querendo ver casa, sem entrada, renda de 5.000, conversa em andamento\n	14	23
42	8201	1	visita-1747314659647	Temperatura: Quente\n\nResultado: Cliente bem interessada, foi com o namorado e com o sogro\n\nPróximos passos: Cliente bem interessada, foi com o namorado e com o sogro	2025-04-07 18:00:00	2025-04-07 00:00:00	2025-04-07 00:00:00	4	Cliente bem interessada, foi com o namorado e com o sogro	Cliente bem interessada, foi com o namorado e com o sogro	14	23
54	7986	1	visita-1747324999597	Temperatura: Quente\n\nResultado: Cliente tem 19 anos anos e tem uma filha de um ano, recem separada e busca algo pra ela morar, ela possui uma renda mais baixa e deseja algo pronto.. tentando encaixar em algo\n\nPróximos passos: Cliente tem 19 anos anos e tem uma filha de um ano, recem separada e busca algo pra ela morar, ela possui uma renda mais baixa e deseja algo pronto.. tentando encaixar em algo	2025-03-24 13:00:00	2025-03-24 00:00:00	2025-03-24 00:00:00	4	Cliente tem 19 anos anos e tem uma filha de um ano, recem separada e busca algo pra ela morar, ela possui uma renda mais baixa e deseja algo pronto.. tentando encaixar em algo	Cliente tem 19 anos anos e tem uma filha de um ano, recem separada e busca algo pra ela morar, ela possui uma renda mais baixa e deseja algo pronto.. tentando encaixar em algo	17	13
44	7295	1	visita-1747321568819	Temperatura: Muito Quente\n\nResultado: cliente queria imovel usado, mas gostou muito da proposta do da opção no novo mundo, tem 30 mil disponivel de entrada e ja esta aprovada, reuniao marcada novamente para passar os valores.\n\nPróximos passos: cliente queria imovel usado, mas gostou muito da proposta do da opção no novo mundo, tem 30 mil disponivel de entrada e ja esta aprovada, reuniao marcada novamente para passar os valores.	2025-01-25 10:00:00	2025-01-25 00:00:00	2025-01-25 00:00:00	5	cliente queria imovel usado, mas gostou muito da proposta do da opção no novo mundo, tem 30 mil disponivel de entrada e ja esta aprovada, reuniao marcada novamente para passar os valores.	cliente queria imovel usado, mas gostou muito da proposta do da opção no novo mundo, tem 30 mil disponivel de entrada e ja esta aprovada, reuniao marcada novamente para passar os valores.	17	23
45	7303	1	visita-1747322541824	Temperatura: Muito Quente\n\nResultado: Cliente entrou alegando que fechou na Vivamus, mas nao gostou do preço e quer fechar Horizon\n\nPróximos passos: Cliente entrou alegando que fechou na Vivamus, mas nao gostou do preço e quer fechar Horizon	2025-01-30 18:00:00	2025-01-30 00:00:00	2025-01-30 00:00:00	5	Cliente entrou alegando que fechou na Vivamus, mas nao gostou do preço e quer fechar Horizon	Cliente entrou alegando que fechou na Vivamus, mas nao gostou do preço e quer fechar Horizon	17	23
43	7405	1	visita-1747315668484	Temperatura: Quente\n\nResultado: Cliente muito interessado no Novo Mundo, trabalha perto.\nFoi com a namorada\n\nPróximos passos: Cliente muito interessado no Novo Mundo, trabalha perto.\nFoi com a namorada	2025-02-04 15:00:00	2025-02-04 00:00:00	2025-02-04 00:00:00	4	Cliente muito interessado no Novo Mundo, trabalha perto.\nFoi com a namorada	Cliente muito interessado no Novo Mundo, trabalha perto.\nFoi com a namorada	14	23
48	7753	1	visita-1747323394761	Temperatura: Frio\n\nResultado: Cliente gostou do apartamento da opção mas não tem condição... chamei pra fazer a aprovação e estou aguardando, pra ver oq encaixa melhor pra ela.\n\nPróximos passos: Cliente gostou do apartamento da opção mas não tem condição... chamei pra fazer a aprovação e estou aguardando, pra ver oq encaixa melhor pra ela.	2025-03-13 16:30:00	2025-03-13 00:00:00	2025-03-13 00:00:00	2	Cliente gostou do apartamento da opção mas não tem condição... chamei pra fazer a aprovação e estou aguardando, pra ver oq encaixa melhor pra ela.	Cliente gostou do apartamento da opção mas não tem condição... chamei pra fazer a aprovação e estou aguardando, pra ver oq encaixa melhor pra ela.	17	13
49	7764	1	visita-1747323522695	Temperatura: Muito Frio\n\nResultado: Visita complicada, pois os pais estão olhando pra filha e pro genro, e nenhum deles foi, não sabem exatamente a renda de ambos e estão começando olhar agora... queriam uma parcela de no maximo R$ 900, juntando entrada e financiamento.. não tem sinal.\n\nPróximos passos: Visita complicada, pois os pais estão olhando pra filha e pro genro, e nenhum deles foi, não sabem exatamente a renda de ambos e estão começando olhar agora... queriam uma parcela de no maximo R$ 900, juntando entrada e financiamento.. não tem sinal.	2025-03-15 10:00:00	2025-03-15 00:00:00	2025-03-15 00:00:00	1	Visita complicada, pois os pais estão olhando pra filha e pro genro, e nenhum deles foi, não sabem exatamente a renda de ambos e estão começando olhar agora... queriam uma parcela de no maximo R$ 900, juntando entrada e financiamento.. não tem sinal.	Visita complicada, pois os pais estão olhando pra filha e pro genro, e nenhum deles foi, não sabem exatamente a renda de ambos e estão começando olhar agora... queriam uma parcela de no maximo R$ 900, juntando entrada e financiamento.. não tem sinal.	17	13
50	7848	1	visita-1747323679049	Temperatura: Morno\n\nResultado: Cliente gostou muito do apartamento da Opção, mas quer visitar com o namorado ainda... chamei pra aprovar até lá\n\nPróximos passos: Cliente gostou muito do apartamento da Opção, mas quer visitar com o namorado ainda... chamei pra aprovar até lá	2025-03-17 14:30:00	2025-03-17 00:00:00	2025-03-17 00:00:00	3	Cliente gostou muito do apartamento da Opção, mas quer visitar com o namorado ainda... chamei pra aprovar até lá	Cliente gostou muito do apartamento da Opção, mas quer visitar com o namorado ainda... chamei pra aprovar até lá	17	13
51	7828	1	visita-1747323783563	Temperatura: Muito Quente\n\nResultado: Cliente igor gostou muito da opção mas nao tem condições, apresentei o Prime Club e gostou\n\nPróximos passos: Cliente igor gostou muito da opção mas nao tem condições, apresentei o Prime Club e gostou	2025-03-18 15:00:00	2025-03-18 00:00:00	2025-03-18 00:00:00	5	Cliente igor gostou muito da opção mas nao tem condições, apresentei o Prime Club e gostou	Cliente igor gostou muito da opção mas nao tem condições, apresentei o Prime Club e gostou	17	22
52	7790	1	visita-1747323911021	Temperatura: Morno\n\nResultado: fiz video chamada com o ciente, gostou bastante, mas falou q esta com outra corretora tmb, estou tentando ter preferencia e fazer a aprovação\n\nPróximos passos: fiz video chamada com o ciente, gostou bastante, mas falou q esta com outra corretora tmb, estou tentando ter preferencia e fazer a aprovação	2025-03-18 10:00:00	2025-03-18 00:00:00	2025-03-18 00:00:00	3	fiz video chamada com o ciente, gostou bastante, mas falou q esta com outra corretora tmb, estou tentando ter preferencia e fazer a aprovação	fiz video chamada com o ciente, gostou bastante, mas falou q esta com outra corretora tmb, estou tentando ter preferencia e fazer a aprovação	17	13
53	7969	1	visita-1747324456773	Temperatura: Muito Quente\n\nResultado: Cliente Kelly, amou a opção, mas nao cabe no bolso, apresentei o Place + Bosque e ela apaixonou, falou que a irma e a amiga comprou la, parcela ficou muito barata, chamei ela pra aprovar e topou.\n\nPróximos passos: Cliente Kelly, amou a opção, mas nao cabe no bolso, apresentei o Place + Bosque e ela apaixonou, falou que a irma e a amiga comprou la, parcela ficou muito barata, chamei ela pra aprovar e topou.	2025-03-24 15:00:00	2025-03-24 00:00:00	2025-03-24 00:00:00	5	Cliente Kelly, amou a opção, mas nao cabe no bolso, apresentei o Place + Bosque e ela apaixonou, falou que a irma e a amiga comprou la, parcela ficou muito barata, chamei ela pra aprovar e topou.	Cliente Kelly, amou a opção, mas nao cabe no bolso, apresentei o Place + Bosque e ela apaixonou, falou que a irma e a amiga comprou la, parcela ficou muito barata, chamei ela pra aprovar e topou.	17	13
57	8530	1	visita-1747327370446	Temperatura: Quente\n\nResultado: Cliente acabou de entrar em um emprego CLT.\nVai comprar no nome dele e a mãe vai ajudar, parecer ter um bom dinheiro guardado, mas quer usar o menor valor possível.\nVisitou Opção e Mor\n\nPróximos passos: Levar a mãe pra visitar e ir mostrando possibilidades até o holerite dela sair	2025-05-12 09:00:00	2025-05-12 00:00:00	2025-05-12 00:00:00	4	Cliente acabou de entrar em um emprego CLT.\nVai comprar no nome dele e a mãe vai ajudar, parecer ter um bom dinheiro guardado, mas quer usar o menor valor possível.\nVisitou Opção e Mor	Levar a mãe pra visitar e ir mostrando possibilidades até o holerite dela sair	14	22
60	8657	1	visita-1747329363172	Temperatura: Quente\n\nResultado: Cliente quer algo já mais pronto possível pois o proprietário está pedindo o imóvel de volta.\nTem uma renda de quase 6 mil por mês junto com o marido, mas no holerite apenas 3200.\n\nPróximos passos: Já estou com parte da documentação para aprovação	2025-05-13 20:00:00	2025-05-13 00:00:00	2025-05-13 00:00:00	4	Cliente quer algo já mais pronto possível pois o proprietário está pedindo o imóvel de volta.\nTem uma renda de quase 6 mil por mês junto com o marido, mas no holerite apenas 3200.	Já estou com parte da documentação para aprovação	17	13
55	7977	1	visita-1747325132465	Temperatura: Muito Quente\n\nResultado: Cliente gostou muito do Novo Mundo e ja passou documentação.\n\nPróximos passos: Cliente gostou muito do Novo Mundo e ja passou documentação.	2025-03-28 10:00:00	2025-03-28 00:00:00	2025-03-28 00:00:00	5	Cliente gostou muito do Novo Mundo e ja passou documentação.	Cliente gostou muito do Novo Mundo e ja passou documentação.	17	23
62	8693	1	visita-1747330651772	Temperatura: Morno\n\nResultado: Cliente gostou muito do Recanto Verde II e vai comprar.\n\nPróximos passos: Cliente gostou muito do Recanto Verde II e vai comprar.	2025-03-19 19:00:00	2025-03-19 00:00:00	2025-03-19 00:00:00	3	Cliente gostou muito do Recanto Verde II e vai comprar.	Cliente gostou muito do Recanto Verde II e vai comprar.	14	23
65	8695	1	visita-1747331510642	Temperatura: Muito Quente\n\nResultado: cliente vai comprar um apartamento usado, Shopping Sul\n\nPróximos passos: cliente vai comprar um apartamento usado, Shopping Sul	2025-04-09 09:00:00	2025-04-09 00:00:00	2025-04-09 00:00:00	5	cliente vai comprar um apartamento usado, Shopping Sul	cliente vai comprar um apartamento usado, Shopping Sul	14	23
66	8105	1	visita-1747332118114	Temperatura: Quente\n\nResultado: CLIENTE VISITOU VARIOS DECORADOS E FICOU DE MANDAR A DOCUMENTAÇÃO PRA APROVAR\n\nPróximos passos: CLIENTE VISITOU VARIOS DECORADOS E FICOU DE MANDAR A DOCUMENTAÇÃO PRA APROVAR	2025-05-17 14:00:00	2025-05-17 00:00:00	2025-05-17 00:00:00	4	CLIENTE VISITOU VARIOS DECORADOS E FICOU DE MANDAR A DOCUMENTAÇÃO PRA APROVAR	CLIENTE VISITOU VARIOS DECORADOS E FICOU DE MANDAR A DOCUMENTAÇÃO PRA APROVAR	14	13
59	8262	1	visita-1747327841854	Temperatura: Morno\n\nResultado: cliente esta procurando algo pra pagar, nao tem muita exigencia\n\n\nPróximos passos: cliente esta procurando algo pra pagar, nao tem muita exigencia\n	2025-04-25 10:00:00	2025-04-25 00:00:00	2025-04-25 00:00:00	3	cliente esta procurando algo pra pagar, nao tem muita exigencia\n	cliente esta procurando algo pra pagar, nao tem muita exigencia\n	17	23
61	8637	1	visita-1747329842799	Temperatura: Muito Frio\n\nResultado: Cliente mega exigente não gosta de planta integrada, queria um apartamento com mais divisórias.\nQueria uma metragem maior, perguntou tudo que eu tinha, queria 2 vagas.\nMas não tem dinheiro pra entrada e está com divida no nome ainda\n\nPróximos passos: Ele vai ver se consegue financiamento em algum outro banco	2025-05-14 15:00:00	2025-05-14 00:00:00	2025-05-14 00:00:00	1	Cliente mega exigente não gosta de planta integrada, queria um apartamento com mais divisórias.\nQueria uma metragem maior, perguntou tudo que eu tinha, queria 2 vagas.\nMas não tem dinheiro pra entrada e está com divida no nome ainda	Ele vai ver se consegue financiamento em algum outro banco	17	23
20	7716	1	visita-1747236788183	Temperatura: Morno\n\nResultado: Cliente é marceneiro tem uma renda de + ou - 5 mil, que algo na região leste.Adorou o decorado, mas está falando com vários corretores, não chegou a visitar, mas abe todos os preços e metragens.No momento não tem entrada, mas tem perspectiva de receber valores.\n\n\nPróximos passos: Cliente é marceneiro tem uma renda de + ou - 5 mil, que algo na região leste.Adorou o decorado, mas está falando com vários corretores, não chegou a visitar, mas abe todos os preços e metragens.No momento não tem entrada, mas tem perspectiva de receber valores.\n	2025-03-12 14:00:00	2025-03-12 00:00:00	2025-03-12 00:00:00	3	Cliente é marceneiro tem uma renda de + ou - 5 mil, que algo na região leste.Adorou o decorado, mas está falando com vários corretores, não chegou a visitar, mas abe todos os preços e metragens.No momento não tem entrada, mas tem perspectiva de receber valores.\n	Cliente é marceneiro tem uma renda de + ou - 5 mil, que algo na região leste.Adorou o decorado, mas está falando com vários corretores, não chegou a visitar, mas abe todos os preços e metragens.No momento não tem entrada, mas tem perspectiva de receber valores.\n	14	23
21	7686	1	visita-1747236859755	Temperatura: Quente\n\nResultado: Cliente motoboy, limpou o nome recentemente, tem 7 mil de renda, precisa declarar o I.R, esposa com o nome ainda sujo e quer um imóvel o mais pronto possível\n\n\nPróximos passos: Cliente motoboy, limpou o nome recentemente, tem 7 mil de renda, precisa declarar o I.R, esposa com o nome ainda sujo e quer um imóvel o mais pronto possível\n	2025-05-10 09:00:00	2025-05-10 00:00:00	2025-05-10 00:00:00	4	Cliente motoboy, limpou o nome recentemente, tem 7 mil de renda, precisa declarar o I.R, esposa com o nome ainda sujo e quer um imóvel o mais pronto possível\n	Cliente motoboy, limpou o nome recentemente, tem 7 mil de renda, precisa declarar o I.R, esposa com o nome ainda sujo e quer um imóvel o mais pronto possível\n	14	23
23	7749	1	visita-1747237117904	Temperatura: Morno\n\nResultado: Está comprando pra ex mulher, renda de 3500, não tem muitas exigências, só não quer uma planta muito pequena.Gostou do decorado, mas precisa conversar com a ex pra ver o que seria melhor, e ainda estão casados, porém o nome dela está com restrição\n\n\nPróximos passos: Está comprando pra ex mulher, renda de 3500, não tem muitas exigências, só não quer uma planta muito pequena.Gostou do decorado, mas precisa conversar com a ex pra ver o que seria melhor, e ainda estão casados, porém o nome dela está com restrição\n	2025-03-10 09:00:00	2025-03-10 00:00:00	2025-03-10 00:00:00	3	Está comprando pra ex mulher, renda de 3500, não tem muitas exigências, só não quer uma planta muito pequena.Gostou do decorado, mas precisa conversar com a ex pra ver o que seria melhor, e ainda estão casados, porém o nome dela está com restrição\n	Está comprando pra ex mulher, renda de 3500, não tem muitas exigências, só não quer uma planta muito pequena.Gostou do decorado, mas precisa conversar com a ex pra ver o que seria melhor, e ainda estão casados, porém o nome dela está com restrição\n	14	23
58	8131	1	visita-1747327386088	Temperatura: Morno\n\nResultado: Cliente estava corrido, desmostrou interesse e chamei pra aprovação\n\n\nPróximos passos: Cliente estava corrido, desmostrou interesse e chamei pra aprovação\n	2025-04-12 10:00:00	2025-04-12 00:00:00	2025-04-12 00:00:00	3	Cliente estava corrido, desmostrou interesse e chamei pra aprovação\n	Cliente estava corrido, desmostrou interesse e chamei pra aprovação\n	17	23
\.


--
-- Data for Name: imoveis_apartamentos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.imoveis_apartamentos (id_apartamento, id_empreendimento, status_apartamento, area_privativa_apartamento, quartos_apartamento, suites_apartamento, banheiros_apartamento, vagas_garagem_apartamento, tipo_garagem_apartamento, sacada_varanda_apartamento, caracteristicas_apartamento, valor_venda_apartamento, titulo_descritivo_apartamento, descricao_apartamento, status_publicacao_apartamento) FROM stdin;
8	20	Em construção	52	2	1	2	1	Descoberta	t		250000	Apto de 52m² no Bairro Novo Mundo	Apto com suíte, sacada