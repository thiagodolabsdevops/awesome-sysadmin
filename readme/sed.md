# Sed

Sed é um editor de fluxo usado para executar transformações básicas de texto em um fluxo de entrada (um arquivo ou entrada de um pipeline).

O sed basicamente faz uma passagem sobre as entradas, sendo consequentemente mais eficiente que editores que permitem edições com script (como o ed).

## Deletar a primeira linha de um arquivo

```bash
sed -i '1d' arquivo
```

## Deletar a última linha de um arquivo

A variável $ indica a última linha do arquivo.

```bash
sed -i '$d' arquivo
```

## Deletar uma linha em específico

Assim como no primeiro exemplo, basta declarar qual é a linha que deseja remover. No exemplo abaixo removeremos a vigésima linha do arquivo.

```bash
sed -i '20d' arquivo
```

## Deletar um range de linhas

Aqui trabalhamos com o modelo de "min,max" para excluir um range inteiro. No exemplo abaixo removeremos da décima à vigésima linha do arquivo.

```bash
sed -i '10,20d' arquivo
```

## Deletar todas as linhas exceto a primeira

```bash
sed -i '1!d' arquivo
```

## Deletar todas as linhas exceto a última

```bash
sed -i '$!d' arquivo
```

## Deletar todas as linhas exceto o range especificado

```bash
sed -i '10,20!d' arquivo
```

## Deletar a primeira e a última linha

```bash
sed -i '1d;$d' arquivo
```

## Deletar linhas vazias ou em branco

```bash
sed -i '/^$/d' arquivo
```

## Deletar linhas que começam com um caracter específico

No exemplo abaixo, todas as linhas que começam com a letra a serão deletadas.

```bash
sed -i '/^a/d' arquivo
```

## Deletar linhas que terminam com um caracter específico

No exemplo abaixo, todas as linhas que terminam com a letra a serão deletadas.

```bash
sed -i '/a$/d' arquivo
```

## Deletar linhas que possuem letras maiúsculas

```bash
sed -i '/^[A-Z]*$/d' arquivo
```

## Deletar linhas que possuem uma palavra em específico

```bash
sed -i '/blablabla/d' arquivo
```
