-- SQL para corrigir a duplicidade e/ou problema de nome do índice na tabela "Label"
-- 1. DROP (se existir): Garante que a operação de criação na linha 2 não falhe.
DROP INDEX IF EXISTS "Label_labelId_instanceId_key";

-- 2. CREATE UNIQUE INDEX: Recria o índice exatamente como esperado pela API.
CREATE UNIQUE INDEX "Label_labelId_instanceId_key" ON "Label"("labelId", "instanceId");

-- O comando DELETE executado anteriormente limpou os dados, então a criação do UNIQUE não terá erro de duplicidade de dados.