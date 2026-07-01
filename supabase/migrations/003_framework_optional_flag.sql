-- Add optional flag for frameworks like PCI DSS and SOC 2
ALTER TABLE frameworks ADD COLUMN IF NOT EXISTS optional BOOLEAN DEFAULT false;
