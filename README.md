# Keyless Jacker

O Keyless Jacker e o Keyless Packer são dois novos itens que, quando usados em conjunto, realizam um hack na radiofrequência das chaves de alarme dos veículos.  
Essa funcionalidade permite destravar carros como uma alternativa à lockpick, sem deixar vestígios.

Desenvolvido exclusivamente para bases Creative, como Bewitched e Enchanted.

## Descrição

O Keyless Jacker é um script para FiveM, projetado para permitir aos jogadores destravar veículos de forma discreta, sem deixar rastros, utilizando dois itens: o Keyless Jacker e o Keyless Packer. Quando usados em conjunto, esses itens manipulam a radiofrequência das chaves de alarme dos veículos, proporcionando uma alternativa à tradicional lockpick.

Funcionalidades:
- Destranca veículos sem deixar vestígios.
- Funciona de forma integrada com bases Creative (ex: Bewitched e Enchanted).
- Fácil integração com sistemas de inventário já existentes.
- Oferece uma experiência imersiva e realista para servidores de FiveM.

## Instalação

Passo 1: Adicionar ao seu servidor (Bewitched)

1. Faça o download ou clone este repositório para o seu servidor.
2. Adicione o script à sua pasta de recursos.

Passo 2: Modificar o código do seu Inventory/Server (Enchanted / Native)

O script funciona com a tabela de itens "Use". Caso sua tabela de uso de itens tenha um nome diferente, será necessário fazer ajustes no código.

Ajustando o código (caso necessário)

1. Abra o arquivo principal do Keyless Jacker e localize as linhas 1 e 6. Modifique essas linhas para o nome correto da sua tabela de uso de itens, se necessário.

Ex:
```lua 
Use["keylessjacker"] =  function(source, Passport, Amount, Slot, Full, Item, Split)
ou
Itens["keylessjacker"] =  function(source, Passport, Amount, Slot, Full, Item, Split)
```

2. Alternativamente, remova as linhas 1 a 10 e adicione o código abaixo na sua tabela de uso de itens, para garantir que o script funcione corretamente:

Ex:
```lua
["keylessjacker"] = function(source, Passport, Amount, Slot, Full, Item, Split) --##
    TriggerClientEvent("inventory:Close", source)
    TriggerEvent("Monkey:KeylessJacker", source)
end,

["keylesspacker"] = function(source, Passport, Amount, Slot, Full, Item, Split) --##
    TriggerClientEvent("inventory:Close", source)
    TriggerEvent("Monkey:KeylessPacker", source)
end,
```

## Configuração

1. Após a instalação, você pode configurar os itens Keyless Jacker e Keyless Packer dentro do seu sistema de inventário. 
2. O script irá funcionar sem problemas com servidores que já utilizam bases Creative, como Bewitched ou Enchanted.

## Contribuição

Contribuições são bem-vindas! Se você tem alguma sugestão ou encontrou um bug, sinta-se à vontade para abrir uma issue ou enviar um pull request.
