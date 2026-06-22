-- ProjectHub — Supabase SQL migration
-- Run this in your Supabase SQL editor

-- ── Tables ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  status text DEFAULT 'activo' CHECK (status IN ('activo', 'pausado', 'archivado')),
  type text CHECK (type IN ('saas', 'afiliados', 'contenido', 'ecommerce', 'otro')),
  url text,
  logo_url text,
  color text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS domains (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE,
  domain text NOT NULL,
  registrar text,
  purchase_date date,
  renewal_date date NOT NULL,
  annual_cost numeric DEFAULT 0,
  auto_renew boolean DEFAULT true,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS tools (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  url text,
  category text CHECK (category IN ('hosting', 'marketing', 'diseño', 'desarrollo', 'ia', 'analytics', 'otro')),
  cost_amount numeric DEFAULT 0,
  cost_period text DEFAULT 'monthly' CHECK (cost_period IN ('monthly', 'annual', 'one_time')),
  renewal_date date,
  logo_url text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS project_tools (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE,
  tool_id uuid REFERENCES tools(id) ON DELETE CASCADE,
  UNIQUE(project_id, tool_id)
);

CREATE TABLE IF NOT EXISTS transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('income', 'expense')),
  category text CHECK (category IN ('publicidad', 'suscripcion', 'afiliados', 'ventas', 'hosting', 'herramientas', 'otro')),
  amount numeric NOT NULL,
  description text,
  date date NOT NULL DEFAULT CURRENT_DATE,
  recurring boolean DEFAULT false,
  recurring_period text CHECK (recurring_period IN ('monthly', 'annual')),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text,
  status text DEFAULT 'pendiente' CHECK (status IN ('pendiente', 'en_progreso', 'completada')),
  priority text DEFAULT 'media' CHECK (priority IN ('alta', 'media', 'baja')),
  due_date date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS calendar_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text,
  type text CHECK (type IN ('contenido', 'dominio', 'lanzamiento', 'reunion', 'otro')),
  start_date timestamptz NOT NULL,
  end_date timestamptz,
  all_day boolean DEFAULT true,
  color text,
  created_at timestamptz DEFAULT now()
);

-- ── Row Level Security ────────────────────────────────────────────────────────
-- Uso personal sin autenticación: policies permisivas

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendar_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow all projects" ON projects FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all domains" ON domains FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all tools" ON tools FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all project_tools" ON project_tools FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all transactions" ON transactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all tasks" ON tasks FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow all calendar_events" ON calendar_events FOR ALL USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS time_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE NOT NULL,
  started_at timestamptz NOT NULL,
  ended_at timestamptz,
  duration_seconds integer,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE time_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "allow all time_entries" ON time_entries FOR ALL USING (true) WITH CHECK (true);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_transactions_project ON transactions(project_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);
CREATE INDEX IF NOT EXISTS idx_domains_renewal ON domains(renewal_date);
CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_calendar_start ON calendar_events(start_date);
CREATE INDEX IF NOT EXISTS idx_time_entries_task ON time_entries(task_id);
