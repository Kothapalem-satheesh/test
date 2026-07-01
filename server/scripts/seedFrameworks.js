import dotenv from 'dotenv';
import { readFileSync, readdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { createClient } from '@supabase/supabase-js';
import { generateEmbeddings } from '../services/pythonServiceClient.js';

dotenv.config({ path: join(dirname(fileURLToPath(import.meta.url)), '../../.env') });
dotenv.config();

const __dirname = dirname(fileURLToPath(import.meta.url));
const FRAMEWORKS_DIR = join(__dirname, '../data/frameworks');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function seedFrameworks() {
  console.log('Starting framework seed...\n');

  const files = readdirSync(FRAMEWORKS_DIR).filter((f) => f.endsWith('.json'));
  let totalRequirements = 0;

  for (const file of files) {
    const frameworkData = JSON.parse(readFileSync(join(FRAMEWORKS_DIR, file), 'utf-8'));
    console.log(`Processing framework: ${frameworkData.name}`);

    // Upsert framework
    const { data: framework, error: fwError } = await supabase
      .from('frameworks')
      .upsert({
        name: frameworkData.name,
        description: frameworkData.description,
        version: frameworkData.version,
        optional: frameworkData.optional ?? false,
      }, { onConflict: 'name' })
      .select()
      .single();

    if (fwError) {
      console.error(`  Error upserting framework: ${fwError.message}`);
      continue;
    }

    console.log(`  Framework ID: ${framework.id}`);
    const requirements = frameworkData.requirements || [];
    console.log(`  Seeding ${requirements.length} requirements...`);

    // Process in batches of 10 for embedding generation
    const batchSize = 10;
    for (let i = 0; i < requirements.length; i += batchSize) {
      const batch = requirements.slice(i, i + batchSize);
      const texts = batch.map((r) =>
        `${r.requirement_code}: ${r.requirement_text} Keywords: ${(r.keywords || []).join(', ')}`
      );

      let embeddings = [];
      try {
        const result = await generateEmbeddings(texts);
        embeddings = result.embeddings || [];
      } catch (err) {
        console.warn(`  Embedding generation failed for batch ${i}: ${err.message}`);
        console.warn('  Storing requirements without embeddings. Ensure Python service is running.');
      }

      const rows = batch.map((req, idx) => ({
        framework_id: framework.id,
        requirement_code: req.requirement_code,
        category: req.category,
        requirement_text: req.requirement_text,
        keywords: req.keywords || [],
        expected_evidence: req.expected_evidence,
        severity: req.severity || 'Medium',
        recommendation_text: req.recommendation_text,
        embedding: embeddings[idx] || null,
      }));

      const { error: reqError } = await supabase
        .from('requirements')
        .upsert(rows, { onConflict: 'framework_id,requirement_code' });

      if (reqError) {
        console.error(`  Error inserting requirements: ${reqError.message}`);
      } else {
        totalRequirements += batch.length;
        console.log(`  Inserted batch ${Math.floor(i / batchSize) + 1} (${batch.length} requirements)`);
      }
    }
  }

  console.log(`\nSeed complete! Total requirements: ${totalRequirements}`);
}

seedFrameworks().catch((err) => {
  console.error('Seed failed:', err.message);
  process.exit(1);
});
