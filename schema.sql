CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(50) CHECK (rol IN ('Planificador', 'Asesor Juridico', 'Gerente', 'Alcalde', 'Administrador')) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE expedientes (
    id SERIAL PRIMARY KEY,
    codigo_snip VARCHAR(50) UNIQUE NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    presupuesto_estimado NUMERIC(12, 2) NOT NULL,
    ubicacion_georreferenciada VARCHAR(255),
    estado VARCHAR(50) CHECK (estado IN ('Borrador', 'En Evaluacion', 'Pausado_HITL', 'Aprobado', 'Rechazado')) DEFAULT 'En Evaluacion',
    usuario_registro_id INT REFERENCES usuarios(id),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE evaluaciones_agentes (
    id SERIAL PRIMARY KEY,
    expediente_id INT REFERENCES expedientes(id) ON DELETE CASCADE,
    puntaje_economico NUMERIC(5,2),
    puntaje_social NUMERIC(5,2),
    puntaje_ambiental NUMERIC(5,2),
    puntaje_tecnico NUMERIC(5,2),
    puntaje_juridico NUMERIC(5,2),
    puntaje_total_prioridad NUMERIC(5,2),
    resumen_unificado_ia TEXT,
    evaluado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE puntos_control_hitl (
    id SERIAL PRIMARY KEY,
    expediente_id INT REFERENCES expedientes(id),
    motivo_pausa TEXT NOT NULL,
    observaciones_humano TEXT,
    decision VARCHAR(50) CHECK (decision IN ('Aprobado', 'Rechazado', 'Solicitar Correccion')),
    firmado_por INT REFERENCES usuarios(id),
    hash_sha256 VARCHAR(64) UNIQUE,
    fecha_intervencion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auditoria_logs (
    id SERIAL PRIMARY KEY,
    expediente_id INT,
    usuario_id INT,
    accion VARCHAR(100) NOT NULL,
    detalle JSONB NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
