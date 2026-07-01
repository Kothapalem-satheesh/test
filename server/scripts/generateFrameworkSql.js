/**
 * Generates supabase/migrations/004_seed_frameworks_data.sql from JSON framework files.
 * Run: node scripts/generateFrameworkSql.js
 */
import { readFileSync, readdirSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const FRAMEWORKS_DIR = join(__dirname, '../data/frameworks');

const args = process.argv.slice(2);
const outArg = args.find((a) => a.startsWith('--out='));
const onlyArg = args.find((a) => a.startsWith('--only='));
const OUT = outArg
  ? join(__dirname, '../../supabase/migrations', outArg.split('=')[1])
  : join(__dirname, '../../supabase/migrations/004_seed_frameworks_data.sql');
const onlyFiles = onlyArg ? onlyArg.split('=')[1].split(',').map((s) => s.trim()) : null;

function esc(str) {
  return (str || '').replace(/'/g, "''");
}

function arrSql(arr) {
  if (!arr?.length) return 'ARRAY[]::TEXT[]';
  return `ARRAY[${arr.map((s) => `'${esc(s)}'`).join(', ')}]`;
}

let files = readdirSync(FRAMEWORKS_DIR).filter((f) => f.endsWith('.json'));
if (onlyFiles?.length) {
  files = files.filter((f) => onlyFiles.includes(f));
}
const lines = [
  '-- Seed compliance frameworks and requirements (embeddings added later via npm run seed)',
  '-- Safe to re-run: uses ON CONFLICT',
  '',
];

for (const file of files) {
  const fw = JSON.parse(readFileSync(join(FRAMEWORKS_DIR, file), 'utf-8'));
  const optional = fw.optional ? 'true' : 'false';
  lines.push(`INSERT INTO frameworks (name, description, version, optional)`);
  lines.push(`VALUES ('${esc(fw.name)}', '${esc(fw.description)}', '${esc(fw.version)}', ${optional})`);
  lines.push(`ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;`);
  lines.push('');

  for (const req of fw.requirements || []) {
    lines.push(`INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)`);
    lines.push(`SELECT f.id, '${esc(req.requirement_code)}', '${esc(req.category)}', '${esc(req.requirement_text)}', ${arrSql(req.keywords)}, '${esc(req.expected_evidence)}', '${esc(req.severity || 'Medium')}', '${esc(req.recommendation_text)}'`);
    lines.push(`FROM frameworks f WHERE f.name = '${esc(fw.name)}'`);
    lines.push(`ON CONFLICT (framework_id, requirement_code) DO UPDATE SET`);
    lines.push(`  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,`);
    lines.push(`  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;`);
    lines.push('');
  }
}

writeFileSync(OUT, lines.join('\n'));
console.log(`Wrote ${OUT} (${lines.length} lines)`);
