import { sql } from "drizzle-orm";
import { db } from "./database";
import * as schema from "@shared/schema";
import { log, LogLevel } from "./utils";
import { Role, Department, ClienteStatus, AppointmentStatus, AppointmentType } from "@shared/schema";
import { addWhatsappTables } from "./migrations/add-whatsapp-tables";
import { addIsPrimaryToWhatsapp } from "./migrations/add-is-primary-to-whatsapp";

// Importar todas as migrações que estão em arquivos individuais
import { removeWhatsappColumns } from "./migrations/remove-whatsapp-columns";
import { addBrokerIdToClientes } from "./migrations/add-broker-id-to-clientes";
import { addCpfToClientes } from "./migrations/add-cpf-to-clientes";
import { addAddressToAppointments } from "./migrations/add-address-to-appointments";
import { addProfilePicToClientes } from "./migrations/add-profile-pic-to-clientes";
import { addCascadeDeleteToUsers } from "./migrations/add-cascade-delete-to-users";
import { addClienteNotesTable } from "./migrations/add-cliente-notes-table";
import { addUpdatedAtToVisits } from "./migrations/add-updated-at-to-visits";
import { addVisitDetailFields } from "./migrations/add-visit-detail-fields";
import { addFacebookConfigTable } from "./migrations/add-facebook-config-table";
import { addWhatsappRemoteJid } from "./migrations/add-whatsapp-remote-jid";
import { addSistemaLeadsTable } from "./migrations/add-sistema-leads-table";
import { addSistemaLeadsCascataTable } from "./migrations/add-sistema-leads-cascata-table";
import { addCascadeSLAConfig } from "./migrations/add-cascade-sla-config";

// Defina o tipo Migration aqui mesmo em vez de importar
export type Migration = {
  id: number;
  name: string;
  description: string;
  executeMigration: () => Promise<void | boolean | { success: boolean; message: string }>;
};

// Lista ordenada de todas as migrações disponíveis
const migrationsList: Migration[] = [
  {
    id: 1,
    name: "add_whatsapp_tables",
    description: "Adiciona tabelas para integração com WhatsApp",
    executeMigration: addWhatsappTables
  },
  {
    id: 2,
    name: "add_broker_id_to_clientes",
    description: "Adiciona campo broker_id à tabela clientes",
    executeMigration: addBrokerIdToClientes
  },
  {
    id: 3, 
    name: "add_cpf_to_clientes",
    description: "Adiciona campo CPF à tabela clientes",
    executeMigration: addCpfToClientes
  },
  {
    id: 4,
    name: "add_address_to_appointments",
    description: "Adiciona campo endereço à tabela appointments",
    executeMigration: addAddressToAppointments
  },
  {
    id: 5,
    name: "add_is_primary_to_whatsapp",
    description: "Adiciona campo isPrimary à tabela whatsapp_instances",
    executeMigration: addIsPrimaryToWhatsapp
  },
  {
    id: 6,
    name: "remove_whatsapp_columns",
    description: "Remove colunas desnecessárias da tabela whatsapp_instances",
    executeMigration: removeWhatsappColumns
  },
  {
    id: 7,
    name: "add_profile_pic_to_clientes",
    description: "Adiciona coluna profile_pic_url à tabela clientes",
    executeMigration: addProfilePicToClientes
  },
  {
    id: 8,
    name: "add_cascade_delete_to_users",
    description: "Adiciona exclusão em cascata para registros relacionados a usuários",
    executeMigration: addCascadeDeleteToUsers
  },
  {
    id: 9,
    name: "add_cliente_notes_table",
    description: "Adiciona tabela cliente_notes para anotações de clientes",
    executeMigration: addClienteNotesTable
  },
  {
    id: 10,
    name: "add_updated_at_to_visits",
    description: "Adiciona coluna updated_at à tabela de visitas",
    executeMigration: addUpdatedAtToVisits
  },
  {
    id: 11,
    name: "add_visit_detail_fields",
    description: "Adiciona campos de detalhes à tabela de visitas (temperatura, descrição, próximos passos)",
    executeMigration: addVisitDetailFields
  },
  {
    id: 12,
    name: "add_facebook_config_table",
    description: "Adiciona tabela para configuração de API do Facebook",
    executeMigration: addFacebookConfigTable
  },
  {
    id: 13,
    name: "add_whatsapp_remote_jid",
    description: "Adiciona coluna remote_jid à tabela sistema_whatsapp_instances",
    executeMigration: addWhatsappRemoteJid
  },
  {
    id: 14,
    name: "add_sistema_leads_table",
    description: "Adiciona tabela sistema_leads para gerenciamento de leads",
    executeMigration: addSistemaLeadsTable
  },
  {
    id: 15,
    name: "add_sistema_leads_cascata_table",
    description: "Adiciona tabela sistema_leads_cascata para SLA em cascata",
    executeMigration: addSistemaLeadsCascataTable
  },
  {
    id: 16,
    name: "add_cascade_sla_config",
    description: "Adiciona configurações de SLA em cascata à tabela de automação",
    executeMigration: addCascadeSLAConfig
  }
];

/**
 * Função vazia para manter compatibilidade com código existente
 * Não é mais necessário verificar ou criar a tabela de migrações
 */
async function checkDatabaseConnection(): Promise<void> {
  try {
    // Apenas verificar se podemos executar uma consulta simples
    await db.execute(sql`SELECT 1`);
    log("Conexão com o banco de dados verificada com sucesso.", LogLevel.INFO);
  } catch (error) {
    log(`Erro ao verificar conexão com o banco de dados: ${error}`, LogLevel.ERROR);
    throw error;
  }
}

/**
 * Verifica quais migrações já foram executadas
 */
async function getExecutedMigrations(): Promise<string[]> {
  // Como a tabela migrations foi removida, estamos retornando uma lista fixa
  // de migrações que sabemos que já foram executadas no banco de dados
  const knownMigrations = [
    'add_whatsapp_tables',
    'add_broker_id_to_clientes',
    'add_cpf_to_clientes',
    'add_address_to_appointments',
    'add_is_primary_to_whatsapp',
    'remove_whatsapp_columns',
    'add_profile_pic_to_clientes',
    'add_cascade_delete_to_users',
    'add_cliente_notes_table',
    'add_updated_at_to_visits',
    'add_visit_detail_fields',
    'add_facebook_config_table',
    'add_whatsapp_remote_jid',
    'add_sistema_leads_table',
    'add_sistema_leads_cascata_table',
    'add_cascade_sla_config'
  ];
  
  log(`Usando lista de migrações conhecidas como já executadas: ${knownMigrations.join(', ')}`, LogLevel.INFO);
  return knownMigrations;
}

/**
 * Função vazia para manter compatibilidade com código existente
 * Não registra mais migrações na tabela de banco de dados
 */
async function registerMigration(migration: Migration): Promise<void> {
  log(`Migração ${migration.name} considerada como registrada.`, LogLevel.INFO);
  // Não fazemos mais nada aqui, já que a tabela de migrações foi removida
}

/**
 * Executa todas as migrações pendentes
 */
export async function migrate(): Promise<void> {
  try {
    log("Iniciando processo de migração...", LogLevel.INFO);
    
    // Verificar a conexão com o banco de dados
    await checkDatabaseConnection();
    
    // Obter lista de migrações já executadas
    const executedMigrations = await getExecutedMigrations();
    log(`Migrações já executadas: ${executedMigrations.length}`, LogLevel.INFO);
    
    // Filtrar e executar migrações pendentes
    const pendingMigrations = migrationsList.filter(
      migration => !executedMigrations.includes(migration.name)
    );
    
    if (pendingMigrations.length === 0) {
      log("Nenhuma migração pendente encontrada.", LogLevel.INFO);
      return;
    }
    
    log(`Encontradas ${pendingMigrations.length} migrações pendentes.`, LogLevel.INFO);
    
    // Ordenar migrações por ID
    pendingMigrations.sort((a, b) => a.id - b.id);
    
    // Executar migrações em sequência
    for (const migration of pendingMigrations) {
      try {
        log(`Executando migração: ${migration.name} - ${migration.description}`, LogLevel.INFO);
        
        // Executar migração e lidar com diferentes tipos de retorno
        const result = await migration.executeMigration();
        
        // Verificar o tipo de retorno
        if (typeof result === 'object' && result !== null && 'success' in result) {
          // Para retornos no formato { success: boolean, message: string }
          if (!result.success) {
            throw new Error(result.message);
          }
          log(`Resultado da migração: ${result.message}`, LogLevel.INFO);
        } else if (typeof result === 'boolean' && !result) {
          // Para retornos booleanos falsos
          throw new Error(`A migração ${migration.name} falhou, retornando false`);
        }
        
        await registerMigration(migration);
        log(`Migração ${migration.name} concluída com sucesso.`, LogLevel.INFO);
      } catch (error) {
        log(`Erro ao executar migração ${migration.name}: ${error}`, LogLevel.ERROR);
        throw error;
      }
    }
    
    log("Processo de migração concluído com sucesso.", LogLevel.INFO);
  } catch (error) {
    log(`Erro no processo de migração: ${error}`, LogLevel.ERROR);
    throw error;
  }
}

async function createTables() {
  const createTablesSQL = sql`
    -- Users Table
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      full_name TEXT NOT NULL,
      email TEXT,
      phone TEXT,
      role TEXT NOT NULL,
      department TEXT NOT NULL,
      is_active BOOLEAN DEFAULT true
    );

    -- Clientes Table (anteriormente Leads)
    CREATE TABLE IF NOT EXISTS clientes (
      id SERIAL PRIMARY KEY,
      full_name TEXT NOT NULL,
      email TEXT,
      phone TEXT NOT NULL,
      source TEXT,
      assigned_to INTEGER REFERENCES users(id),
      broker_id INTEGER REFERENCES users(id),
      status TEXT DEFAULT 'Sem Atendimento',
      cpf TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Appointments Table
    CREATE TABLE IF NOT EXISTS appointments (
      id SERIAL PRIMARY KEY,
      cliente_id INTEGER REFERENCES clientes(id),
      user_id INTEGER REFERENCES users(id),
      broker_id INTEGER REFERENCES users(id),
      type TEXT NOT NULL,
      status TEXT NOT NULL,
      notes TEXT,
      scheduled_at TIMESTAMP NOT NULL,
      location TEXT,
      address TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Visits Table
    CREATE TABLE IF NOT EXISTS visits (
      id SERIAL PRIMARY KEY,
      cliente_id INTEGER REFERENCES clientes(id),
      user_id INTEGER REFERENCES users(id),
      property_id TEXT NOT NULL,
      visited_at TIMESTAMP NOT NULL,
      notes TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Sales Table
    CREATE TABLE IF NOT EXISTS sales (
      id SERIAL PRIMARY KEY,
      cliente_id INTEGER REFERENCES clientes(id),
      user_id INTEGER REFERENCES users(id),
      property_id TEXT NOT NULL,
      value DECIMAL(12, 2) NOT NULL,
      sold_at TIMESTAMP NOT NULL,
      notes TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Metrics Table
    CREATE TABLE IF NOT EXISTS metrics (
      id SERIAL PRIMARY KEY,
      user_id INTEGER REFERENCES users(id),
      type TEXT NOT NULL,
      value DECIMAL(12, 2) NOT NULL,
      period TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;

  await db.execute(createTablesSQL);
  log("Tabelas criadas ou já existentes.", LogLevel.INFO);
}

async function seedSampleData() {
  log("Inicializando dados de exemplo...", LogLevel.INFO);
  
  try {
    // Criar usuários
    const users = [
      {
        username: "renato",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Renato Alves",
        email: "renato@fama.com.br",
        phone: "(11) 99999-1111",
        role: Role.MANAGER,
        department: Department.MANAGEMENT,
        isActive: true
      },
      {
        username: "lourenzza",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Lourenzza Carvalho",
        email: "lourenzza@fama.com.br",
        phone: "(11) 99999-2222",
        role: Role.MARKETING,
        department: Department.MARKETING,
        isActive: true
      },
      {
        username: "humberto",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Humberto Santos",
        email: "humberto@fama.com.br",
        phone: "(11) 99999-3333",
        role: Role.BROKER,
        department: Department.SALES,
        isActive: true
      },
      {
        username: "michel",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Michel Silva",
        email: "michel@fama.com.br",
        phone: "(11) 99999-4444",
        role: Role.BROKER,
        department: Department.SALES,
        isActive: true
      },
      {
        username: "jessica",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Jessica Oliveira",
        email: "jessica@fama.com.br",
        phone: "(11) 99999-5555",
        role: Role.CONSULTANT,
        department: Department.SALES,
        isActive: true
      },
      {
        username: "anafabia",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Ana Fabia Rodrigues",
        email: "anafabia@fama.com.br",
        phone: "(11) 99999-6666",
        role: Role.CONSULTANT,
        department: Department.SALES,
        isActive: true
      },
      {
        username: "laura",
        passwordHash: "$2b$10$vQdptqYJsdz9l8Zx5oaj5OGOPUxd0yA5T3pFTEDM.xB9TpFdoqgHO", // "senha123"
        fullName: "Laura Mendes",
        email: "laura@fama.com.br",
        phone: "(11) 99999-7777",
        role: Role.CONSULTANT,
        department: Department.SALES,
        isActive: true
      }
    ];
    
    // Inserir usuários
    for (const user of users) {
      await db.insert(schema.users).values(user);
    }
    log(`${users.length} usuários inseridos`, LogLevel.INFO);
    
    // Obter IDs dos usuários inseridos para referência
    const insertedUsers = await db.query.users.findMany();
    const userMap: Record<string, number> = {};
    
    for (const user of insertedUsers) {
      userMap[user.username] = user.id;
    }
    
    // Criar clientes de exemplo
    const clientes = [
      {
        fullName: "Carlos Alberto",
        email: "carlos@email.com",
        phone: "(11) 98765-4321",
        status: ClienteStatus.SEM_ATENDIMENTO,
        source: "Facebook",
        interest: "Apartamento 3 quartos",
        interestType: "Compra",
        location: "Zona Sul",
        notes: "Procurando imóvel para família",
        assignedTo: userMap["jessica"],
        createdAt: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000), // 15 dias atrás
        updatedAt: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000)
      },
      {
        fullName: "Mariana Silva",
        email: "mariana@email.com",
        phone: "(11) 99876-5432",
        status: ClienteStatus.AGENDAMENTO,
        source: "Instagram",
        interest: "Casa em condomínio",
        interestType: "Compra",
        location: "Zona Oeste",
        notes: "Busca por segurança e áreas de lazer",
        assignedTo: userMap["anafabia"],
        createdAt: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000), // 10 dias atrás
        updatedAt: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000)
      },
      {
        fullName: "Roberto Fernandes",
        email: "roberto@email.com",
        phone: "(11) 97654-3210",
        status: ClienteStatus.VISITA,
        source: "Site",
        interest: "Sala comercial",
        interestType: "Aluguel",
        location: "Centro",
        notes: "Abertura de consultório",
        assignedTo: userMap["laura"],
        createdAt: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000), // 8 dias atrás
        updatedAt: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000)
      },
      {
        fullName: "Juliana Costa",
        email: "juliana@email.com",
        phone: "(11) 96543-2109",
        status: ClienteStatus.EM_ATENDIMENTO,
        source: "Indicação",
        interest: "Cobertura duplex",
        interestType: "Compra",
        location: "Zona Sul",
        notes: "Interesse em vista panorâmica",
        assignedTo: userMap["humberto"],
        createdAt: new Date(Date.now() - 12 * 24 * 60 * 60 * 1000), // 12 dias atrás
        updatedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000)
      },
      {
        fullName: "Pedro Mendes",
        email: "pedro@email.com",
        phone: "(11) 95432-1098",
        status: ClienteStatus.VENDA,
        source: "Google",
        interest: "Apartamento 2 quartos",
        interestType: "Compra",
        location: "Zona Norte",
        notes: "Primeiro imóvel, financiamento",
        assignedTo: userMap["michel"],
        createdAt: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000), // 20 dias atrás
        updatedAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000)
      }
    ];
    
    // Inserir clientes
    for (const cliente of clientes) {
      await db.insert(schema.clientes).values(cliente);
    }
    log(`${clientes.length} clientes inseridos`, LogLevel.INFO);
    
    // Obter IDs dos clientes inseridos
    const insertedClientes = await db.query.clientes.findMany();
    
    // Criar agendamentos de exemplo
    const now = new Date();
    const appointments = [
      {
        clienteId: insertedClientes[1].id, // Mariana Silva
        userId: userMap["anafabia"],
        brokerId: userMap["humberto"], // Corretor designado para a visita
        type: "Consulta",
        status: AppointmentStatus.CONFIRMED,
        notes: "Consulta inicial para entender requisitos",
        scheduledAt: new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000), // 2 dias no futuro
        location: "Escritório central",
        address: "Av. Paulista, 1000 - Bela Vista, São Paulo - SP",
        createdAt: new Date(now.getTime() - 8 * 24 * 60 * 60 * 1000),
        updatedAt: new Date(now.getTime() - 8 * 24 * 60 * 60 * 1000)
      },
      {
        clienteId: insertedClientes[2].id, // Roberto Fernandes
        userId: userMap["laura"],
        brokerId: userMap["michel"], // Corretor designado para a visita
        type: "Visita",
        status: AppointmentStatus.SCHEDULED,
        notes: "Visita à sala comercial no Centro Empresarial",
        scheduledAt: new Date(now.getTime() + 4 * 24 * 60 * 60 * 1000), // 4 dias no futuro
        location: "Centro Empresarial, Sala 504",
        address: "Rua Augusta, 500 - Consolação, São Paulo - SP",
        createdAt: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000),
        updatedAt: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000)
      },
      {
        clienteId: insertedClientes[3].id, // Juliana Costa
        userId: userMap["humberto"],
        brokerId: userMap["humberto"], // O próprio corretor
        type: "Apresentação",
        status: AppointmentStatus.COMPLETED,
        notes: "Apresentação da proposta comercial",
        scheduledAt: new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000), // 2 dias no passado
        location: "Apartamento modelo",
        address: "Av. Brigadeiro Faria Lima, 3000 - Itaim Bibi, São Paulo - SP",
        createdAt: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000),
        updatedAt: new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000)
      }
    ];
    
    // Inserir agendamentos
    for (const appointment of appointments) {
      await db.insert(schema.appointments).values(appointment);
    }
    log(`${appointments.length} agendamentos inseridos`, LogLevel.INFO);
    
    // Criar visitas de exemplo
    const visits = [
      {
        clienteId: insertedClientes[2].id, // Roberto Fernandes
        userId: userMap["laura"],
        propertyId: "SALA-001",
        visitedAt: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000), // 5 dias no passado
        notes: "Cliente gostou do espaço, mas achou o valor alto",
        createdAt: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000)
      },
      {
        clienteId: insertedClientes[3].id, // Juliana Costa
        userId: userMap["humberto"],
        propertyId: "COB-007",
        visitedAt: new Date(now.getTime() - 6 * 24 * 60 * 60 * 1000), // 6 dias no passado
        notes: "Cliente adorou a vista, mas quer negociar o preço",
        createdAt: new Date(now.getTime() - 6 * 24 * 60 * 60 * 1000)
      },
      {
        clienteId: insertedClientes[4].id, // Pedro Mendes
        userId: userMap["michel"],
        propertyId: "APT-042",
        visitedAt: new Date(now.getTime() - 10 * 24 * 60 * 60 * 1000), // 10 dias no passado
        notes: "Cliente muito interessado, fechou negócio na hora",
        createdAt: new Date(now.getTime() - 10 * 24 * 60 * 60 * 1000)
      }
    ];
    
    // Inserir visitas
    for (const visit of visits) {
      await db.insert(schema.visits).values(visit);
    }
    log(`${visits.length} visitas inseridas`, LogLevel.INFO);
    
    // Criar vendas de exemplo
    const sales = [
      {
        clienteId: insertedClientes[4].id, // Pedro Mendes
        userId: userMap["michel"],
        propertyId: "APT-042",
        value: 450000.00,
        soldAt: new Date(now.getTime() - 8 * 24 * 60 * 60 * 1000), // 8 dias no passado
        notes: "Venda à vista com 5% de desconto",
        createdAt: new Date(now.getTime() - 8 * 24 * 60 * 60 * 1000),
        updatedAt: new Date(now.getTime() - 8 * 24 * 60 * 60 * 1000)
      }
    ];
    
    // Inserir vendas
    for (const sale of sales) {
      // Conversão explícita de valores numéricos para string para corrigir erros de tipagem
      const saleToInsert = {
        ...sale,
        value: String(sale.value) // Converter valor para string conforme esperado pelo Drizzle
      };
      await db.insert(schema.sales).values(saleToInsert);
    }
    log(`${sales.length} vendas inseridas`, LogLevel.INFO);
    
    // Criar métricas de exemplo
    const metrics = [
      {
        userId: userMap["humberto"],
        type: "conversao_clientes",
        value: 0.45,
        period: "month",
        createdAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000)
      },
      {
        userId: userMap["michel"],
        type: "conversao_clientes",
        value: 0.38,
        period: "month",
        createdAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000)
      },
      {
        userId: userMap["jessica"],
        type: "agendamentos",
        value: 12,
        period: "month",
        createdAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000)
      },
      {
        userId: userMap["anafabia"],
        type: "agendamentos",
        value: 15,
        period: "month",
        createdAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000)
      },
      {
        userId: userMap["laura"],
        type: "agendamentos",
        value: 10,
        period: "month",
        createdAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000)
      }
    ];
    
    // Inserir métricas
    for (const metric of metrics) {
      // Conversão explícita de valores numéricos para string para corrigir erros de tipagem
      const metricToInsert = {
        ...metric,
        value: String(metric.value) // Converter valor para string conforme esperado pelo Drizzle
      };
      await db.insert(schema.metrics).values(metricToInsert);
    }
    log(`${metrics.length} métricas inseridas`, LogLevel.INFO);
    
    log("Dados de exemplo inseridos com sucesso!", LogLevel.INFO);
  } catch (error) {
    log(`Erro ao inserir dados de exemplo: ${error}`, LogLevel.ERROR);
    throw error;
  }
}